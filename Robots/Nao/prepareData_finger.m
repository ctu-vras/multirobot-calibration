function taxelStruct=prepareData_finger(robot, datasetName, chain1, chain2, DH, alt, optim)
% PREPAREDATA returns 'taxelStruct' with Nao dataset informations
%   INPUT - robot - instance of @robot class
%         - datasetName - string with name of the dataset
%         - chain1, chain2 - strings with the names of the chains
%         - DH - structure with 'groups' as fields
%   OUTPUT - taxelStruct - structure with fields for each taxel

if strcmp(alt,'Alt')
    rtMat.([chain1,'Skin','Mats'])=robot.structure.matrices.([chain1,'Skin']);
    rtMat.([chain2,'Skin','Mats'])=robot.structure.matrices.([chain2,'Skin']);
    rtFields = fieldnames(rtMat);
else
    rtMat=[];
    rtFields = [];
end

% Load taxels in local frames
firstLocal = importdata(strcat('Dataset/Points/',chain1,alt,'.txt'),' ',4);
chain1Original=firstLocal.data;
firstLocal = importdata(strcat('Dataset/Points/',chain2,alt,'.txt'),' ',4);
chain2Original=firstLocal.data;

% Load given dataset
datasetLocal=load(strcat('Dataset/Datasets/',datasetName,'.mat'));
if iscell(datasetLocal.(chain1))
    n = datasetLocal;
    fnames = fieldnames(n);
    for field=reshape(fieldnames(n.(fnames{1}){1}), 1, [])
       field = field{1};
       s.(field) = [];
    end
    datasetLocal.(fnames{1}) = repmat(s, size(n.(fnames{1}), 1), 1);
    datasetLocal.(fnames{2}) = repmat(s, size(n.(fnames{2}), 1), 1);

    for val=1:size(n.(fnames{1}), 1)
        datasetLocal.(fnames{1})(val) = n.(fnames{1}){val};
        datasetLocal.(fnames{2})(val) = n.(fnames{2}){val};
    end 
end

% Split string with word 'Arm' to get just side ...right for
% rightArm, '' for Torso
name1=strsplit(chain1,'Arm');
name1=name1{1};
name2=strsplit(chain2,'Arm');
name2=name2{1};

%Prepare matrices for fingers
indexM = robot.structure.matrices.([name2,'Index']);
rtMat.([name2,'Index']) = indexM(:,:,1)*indexM(:,:,2)*indexM(:,:,3);

middleM = robot.structure.matrices.([name2,'Middle']);
rtMat.([name2,'Middle']) = middleM(:,:,1)*middleM(:,:,2)*middleM(:,:,3);

thumbM = robot.structure.matrices.([name2,'Thumb']);
rtMat.([name2,'Thumb']) = thumbM(:,:,1)*thumbM(:,:,2);

rtMat.([name2,'Finger','Mats'])=robot.structure.matrices.([name2,'Finger']);

% Prepare instances of each frame to speed-up the computation
chain1Joints=[];
chain2Joints=[];

for taxelId=0:383
    tri_num = fix(taxelId/12);
    taxel_num = mod(taxelId, 12);
    %Find frame from string, e.g. rightTaxel5
    joint=robot.findJoint([name1,'Taxel',int2str(tri_num),'_',int2str(taxel_num)]);
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
end

%Add finger as second joint
joint=robot.findJoint([name2,'Finger']);
if ~isempty(joint)
    joint=joint{1};
    chain2Joints=[joint];
else
    chain2Joints=[nan];
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
%     angles.leftIndex = [0, ang.LFinger11, ang.LFinger12, ang.LFinger13];
%     angles.rightIndex = [0, ang.RFinger11, ang.RFinger12, ang.RFinger13];
%     angles.leftMiddle = [0, ang.LFinger21, ang.LFinger12, ang.LFinger23];
%     angles.rightMiddle = [0, ang.RFinger21, ang.RFinger22, ang.RFinger23];
%     angles.leftThumb = [0, ang.LThumb1, ang.LThumb2];
%     angles.rightThumb = [0, ang.RThumb1, ang.Rthumb2];
    angles.leftIndex = zeros(1,4);
    angles.rightIndex = zeros(1,4);
    angles.leftMiddle = zeros(1,4);
    angles.rightMiddle = zeros(1,4);
    angles.leftThumb = zeros(1,3);
    angles.rightThumb = zeros(1,3);
    angles.leftFinger = [0];
    angles.rightFinger = [0];
    angles.rightArmSkin=[0,0,0,0];
    angles.leftArmSkin=[0,0,0,0];
    angles.torsoSkin=[0,0,0,0];
    angles.headSkin=[0,0,0,0];
    angles.torso=[0];
    dataset.angles=[dataset.angles;angles];
    
    % Init variables - 384 taxels
    chain1Points=zeros(384,3);
    s=[];
    
    dh=DH.(chain1);
    dh(:,4)=dh(:,4)+angles.(chain1)';
    rtMat.(chain1)=dhpars2tfmat(dh);
    
    dh=DH.(chain2);
    dh(:,4)=dh(:,4)+angles.(chain2)';
    rtMat.(chain2)=dhpars2tfmat(dh);
   
    rtFields = fieldnames(rtMat(1));

    for taxelId=0:383
        % Get joint
        joint=chain1Joints(taxelId+1);
        % If parent is not empty == not 'nan'
        if ~isempty(joint.parent)
            % compute RT matrix
            s=getIndexes(s,joint,isfield(robot.structure,'matrices'));
            mat=getTFIntern(DH,joint,rtMat,angles, s.DHindexes.(joint.name),s.parents, rtFields);
            % transform all points for given frame
            points=mat*[chain1Original(taxelId+1, 1:3),1]';%.*1000
            % assign 1:3 component of the vectors
            chain1Points(taxelId+1, :)=points(1:3,:)';
        end
    end
    
    joint=chain2Joints(1);
    if ~isempty(joint.parent)
        s=getIndexes(s,joint,isfield(robot.structure,'matrices'));
        mat=getTFIntern(DH,joint,rtMat,angles, s.DHindexes.(joint.name),s.parents, rtFields);
        points=mat*[chain2Original(taxelId+1, 1:3),1]';%.*1000
        chain2Points=points(1:3,:)';
    end
    
    % load taxel indexes (4th components of the vector from activated
    % points in the dataset), and add 1 to all of them (to get matlab
    % indexing)
    if isfield(datasetLocal.(chain1), 'activatedUn') %Old dataset structure
        taxelsIds=datasetLocal.(chain1)(i).activatedUn(:,4)+1;
    else
        taxelsIds=datasetLocal.(chain1)(i).activatedTaxels' + 1;%New dataset structure
    end
    % assign ids to right points
    newTaxels=[chain1Points(taxelsIds',:),taxelsIds];
    % delete activated taxels from chain1Points
    chain1Points(taxelsIds',:)=[];
    % copy activated taxels transformed to the base frame into dataset
    dataset.(chain1).newTaxels{end+1}=newTaxels;

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