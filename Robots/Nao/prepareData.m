function taxelStruct=prepareData(robot, datasetName, chain1, chain2, DH)
% PREPAREDATA returns 'taxelStruct' with Nao dataset informations
%   INPUT - robot - instance of @robot class
%         - datasetName - string with name of the dataset
%         - chain1, chain2 - strings with the names of the chains
%         - DH - structure with 'groups' as fields
%   OUTPUT - taxelStruct - structure with fields for each taxel

% Load taxels in local frames
firstLocal = importdata(strcat('Dataset/Points/',chain1,'.txt'),' ',4);
chain1Original=firstLocal.data;
firstLocal = importdata(strcat('Dataset/Points/',chain2,'.txt'),' ',4);
chain2Original=firstLocal.data;

% Load given dataset
datasetLocal=load(strcat('Dataset/Datasets/',datasetName,'.mat'));
% Split string with word 'Arm' to get just side ...right for
% rightArm, '' for Torso
name1=strsplit(chain1,'Arm');
name1=name1{1};
name2=strsplit(chain2,'Arm');
name2=name2{1};

% Prepare instances of each frame to speed-up the computation
chain1Joints=[];
chain2Joints=[];
for triangleId=1:32
    %Find frame from string, e.g. rightTriangle15
    joint=robot.findJoint([name1,'Triangle',int2str(triangleId-1)]);
    %Save it joint was found
    if ~isempty(joint)
        joint=joint{1};
        chain1Joints=[chain1Joints;joint];
    %Else save 'nan'...in case the triangle is not equipped on the robot
    %it is non really 'nan' as matlab define the array as array of joints
    %and when 'nan' is inserted, he insert empty 'joint'
    else
        chain1Joints=[chain1Joints;nan];
    end
    %The same for second chain
    joint=robot.findJoint([name2,'Triangle',int2str(triangleId-1)]);
    if ~isempty(joint)
        joint=joint{1};
        chain2Joints=[chain2Joints;joint];
    else
        chain2Joints=[chain2Joints;nan];
    end
end

% variables init
dataset.(chain1).newTaxels={}; % 1xN cell array of arrays with points (1x3 points, pointId)
dataset.(chain2).newTaxels={}; 
dataset.(chain1).cops={}; % 1xN cell array of arrays with cops (1x3 points)
dataset.(chain2).cops={};
dataset.(chain1).cop={}; % 1xN cell array of points with selected cop (1x3 point)
dataset.(chain2).cop={};
dataset.angles=[]; % Nx1 structure of joint angles (field names are names of the groups)
dataset.mins=[]; % Nx1 array of double distances between selected cops
dataset.difs=[]; % Nx3 array of double distances in each coordinate
dataset.(chain1).newTaxelsNA={}; %1xN cell array of non-activated points (1x3 point)
dataset.(chain2).newTaxelsNA={};

fprintf('%s\n',datasetName);
for i=1:size(datasetLocal.(chain1),1)
    % Just print of process
    if rem(i,100)==0
        fprintf('Completed %d out of %d\n',i,size(datasetLocal.(chain1),1))
    end
    % Assing right angles to the groups
    ang=datasetLocal.(chain1)(i).angles;
    angles.rightArm=[0,ang.RShoulderPitch, ang.RShoulderRoll, ang.RElbowYaw,...
        ang.RElbowRoll, ang.RWristYaw];
    angles.leftArm=[0,ang.LShoulderPitch, ang.LShoulderRoll, ang.LElbowYaw,...
        ang.LElbowRoll, ang.LWristYaw];
    angles.head=[0,ang.HeadYaw, ang.HeadPitch];
    angles.rightArmSkin=[0,0,0];
    angles.leftArmSkin=[0,0,0];
    angles.torsoSkin=[0,0,0];
    angles.headSkin=[0,0,0];
    angles.torso=[0];
    dataset.angles=[dataset.angles;angles];
    
    % Init variables - 384 taxels
    chain1Points=zeros(384,3);
    chain2Points=zeros(384,3);
    
    for triangleId=1:32
        % Get joint
        joint=chain1Joints(triangleId);
        % If parent is not empty == not 'nan'
        if ~isempty(joint.parent)
            % compute RT matrix
            gr = joint.group;
            idx = [];
            id=1;
            j2=joint;
            while isobject(j2) 
                while strcmp(j2.group,gr) && ~strcmp(j2.type,types.base) % save indexes into DH table for all joints of the group
                   idx(id)=j2.DHindex;
                   id=id+1;
                   j2=j2.parent;
                end
                DHindexes.(joint.name).(gr) = idx(end:-1:1);
                parents.(gr) = j2; % joint.group differs from gr
                gr = j2.group;
                idx = j2.DHindex; 
                id=2;
                j2=j2.parent; 
            end
            mat=getTF(DH,joint,[],angles, robot.structure.H0,DHindexes.(joint.name),parents);
            % transform all points for given frame
            points=mat*[chain1Original((triangleId-1)*12+1:triangleId*12,1:3),ones(12,1)]';%.*1000
            % assign 1:3 component of the vectors
            chain1Points((triangleId-1)*12+1:triangleId*12,1:3)=points(1:3,:)';
        end
        joint=chain2Joints(triangleId);
        if ~isempty(joint.parent)
            gr = joint.group;
            idx = [];
            id=1;
            j2=joint;
            while isobject(j2) 
                while strcmp(j2.group,gr) && ~strcmp(j2.type,types.base) % save indexes into DH table for all joints of the group
                   idx(id)=j2.DHindex;
                   id=id+1;
                   j2=j2.parent;
                end
                DHindexes.(joint.name).(gr) = idx(end:-1:1);
                parents.(gr) = j2; % joint.group differs from gr
                gr = j2.group;
                idx = j2.DHindex; 
                id=2;
                j2=j2.parent; 
            end
            mat=getTF(DH,joint,[],angles, robot.structure.H0,DHindexes.(joint.name),parents);
            points=mat*[chain2Original((triangleId-1)*12+1:triangleId*12,1:3),ones(12,1)]';%.*1000
            chain2Points((triangleId-1)*12+1:triangleId*12,1:3)=points(1:3,:)';
        end
    end
    
    % load taxel indexes (4th components of the vector from activated
    % points in the dataset), and add 1 to all of them (to get matlab
    % indexing)
    taxelsIds=datasetLocal.(chain1)(i).activatedUn(:,4)+1;
    % assign ids to right points
    newTaxels=[chain1Points(taxelsIds',:),taxelsIds];
    % delete activated taxels from chain1Points
    chain1Points(taxelsIds',:)=[];
    % copy activated taxels transformed to the base frame into dataset
    dataset.(chain1).newTaxels{end+1}=newTaxels;

    %the same for second chain
    taxelsIds=datasetLocal.(chain2)(i).activatedUn(:,4)+1;
    newTaxels=[chain2Points(taxelsIds',:),taxelsIds];
    chain2Points(taxelsIds',:)=[];
    dataset.(chain2).newTaxels{end+1}=newTaxels;
    
    % calculate cops and assigned them to dataset
    cops1=findCop(dataset.(chain1).newTaxels{end},0.01); %10
    cops2=findCop(dataset.(chain2).newTaxels{end},0.01); %10
    dataset.(chain1).cops{end+1}=cops1;
    dataset.(chain2).cops{end+1}=cops2;
    % find closest cops on the two chains
    [cop1,cop2, difs, actMin]=findClosestCop(cops1,cops2);
    dataset.(chain1).cop{end+1}=cop1;
    dataset.(chain2).cop{end+1}=cop2;
    dataset.mins=[dataset.mins;actMin];
    dataset.difs=[dataset.difs;difs];
    
    % Delete points (0,0,0) - heat taxels and unused triangles
    chain1Points(all(~chain1Points,2),:)=[];
    chain2Points(all(~chain2Points,2),:)=[];
    
    % assing non-activated points
    dataset.(chain1).newTaxelsNA{end+1}=chain1Points;
    dataset.(chain2).newTaxelsNA{end+1}=chain2Points;

end


%Ouput structure init
% fields are e.g. 's255', which means taxel 255
% data to the fields are assigned by 'minTaxelId', which is computed lower
taxelStruct=struct();
for i=1:384
    taxelStruct.(strcat('s',num2str(i))).secondTaxel=[]; %Selected taxel on second chain (1x3 double)
    taxelStruct.(strcat('s',num2str(i))).secondTaxelId=[]; %Id of the selected taxel (1 int)
    taxelStruct.(strcat('s',num2str(i))).angles=[]; %structure of joints angles
    taxelStruct.(strcat('s',num2str(i))).distances=[]; %distances of selected taxels
    taxelStruct.(strcat('s',num2str(i))).mins=[]; %cops distance
    taxelStruct.(strcat('s',num2str(i))).difs=[]; %cops distance in each coord
    taxelStruct.(strcat('s',num2str(i))).cops={}; %all cops
    taxelStruct.(strcat('s',num2str(i))).newTaxels={}; %all activated taxels
    taxelStruct.(strcat('s',num2str(i))).newTaxelsNA={}; %all non-activated taxels
    taxelStruct.(strcat('s',num2str(i))).cop={}; %selected cops
end

%Iterate over all selected cops
for i=1:size(dataset.(chain1).cop,2)
   % minDist init 
   minDist=9999;
   %Activated taxels
   taxels=dataset.(chain1).newTaxels{i};
   %selected COP
   cop=dataset.(chain1).cop{i};
   for j=1:size(taxels,1)
       %find closest taxel to the selected COP
       if round(norm(taxels(j,1:3)-cop,2),10)<=minDist
           % if taxel is closer than 'minDist', update minDist and
           % minTaxel,minTaxelIdx
           minDist=round(norm(taxels(j,1:3)-cop,2),10);
           minTaxel=taxels(j,1:3);
           taxelIdx=taxels(j,4);
       end
   end
   
   %minDist reinit
   minDist=9999;
   %used to 'bound' how far can be the second taxel from COP
   maxDistanceFromCop=5;
   minTaxel2=[];
   taxels=dataset.(chain2).newTaxels{i};
   cop=dataset.(chain2).cop{i};

   for j=1:size(taxels,1)
       %find taxel in radius from COP, which has the lowest dostance to
       %selected taxel (above) on the first chain1
       if round(norm(taxels(j,1:3)-cop,2),10)<=maxDistanceFromCop && round(norm(taxels(j,1:3)-minTaxel,2),10)<=minDist
           minDist=round(norm(taxels(j,1:3)-minTaxel,2),10);
           minTaxel2=taxels(j,1:3);
           minTaxel2Id=taxels(j,4);
       end
   end

   %If 'minDist' is lower than given number (could help to get rid of 'bad'
   %activations)
   if minDist<9999
       %Assign newData to the 'taxelStruct'
       taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxelId=[taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxelId;minTaxel2Id];
       taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxel=[taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxel;minTaxel2];
       taxelStruct.(strcat('s',num2str(taxelIdx))).angles=[taxelStruct.(strcat('s',num2str(taxelIdx))).angles;dataset.angles(i)];
       taxelStruct.(strcat('s',num2str(taxelIdx))).mins=[taxelStruct.(strcat('s',num2str(taxelIdx))).mins;dataset.mins(i)];
       taxelStruct.(strcat('s',num2str(taxelIdx))).difs=[taxelStruct.(strcat('s',num2str(taxelIdx))).difs;dataset.difs(i,:)];
       taxelStruct.(strcat('s',num2str(taxelIdx))).cops{end+1}={dataset.(chain1).cops{i},dataset.(chain2).cops{i}};
       taxelStruct.(strcat('s',num2str(taxelIdx))).newTaxels{end+1}={dataset.(chain1).newTaxels{i},dataset.(chain2).newTaxels{i}};
       taxelStruct.(strcat('s',num2str(taxelIdx))).newTaxelsNA{end+1}={dataset.(chain1).newTaxelsNA{i},dataset.(chain2).newTaxelsNA{i}};
       taxelStruct.(strcat('s',num2str(taxelIdx))).cop{end+1}={dataset.(chain1).cop{i},dataset.(chain2).cop{i}};
       taxelStruct.(strcat('s',num2str(taxelIdx))).distances=[taxelStruct.(strcat('s',num2str(taxelIdx))).distances;minDist];
   end
   
end
taxelStruct.chain1=chain1;
taxelStruct.chain2=chain2;

end