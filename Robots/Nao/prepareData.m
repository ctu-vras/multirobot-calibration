function taxelStruct=prepareData(robot,datasetName, chain1,chain2,DH)
tic
%tranformation from given tringles to centre, which is (0,0)...not needed
%right now
% transf=...
%     [-6.533,0;
%     -9.8, 5.66;
%     -3.267, 5.66;
%     0,0;
%     3.267, 5.66;
%     9.8, 5.66;
%     999,999;
%     6.533,0;
%     3.267, -5.66;
%     0,-11.317;
%     999,999;
%     -3.627,-5.66];

firstLocal = importdata(strcat('Dataset/',chain1,'.txt'),' ',4);
chain1Original=firstLocal.data;
firstLocal = importdata(strcat('Dataset/',chain2,'.txt'),' ',4);
chain2Original=firstLocal.data;


datasetLocal=load(strcat('Dataset/',datasetName,'.mat'));
name1=strsplit(chain1,'Arm');
name1=name1{1};
name2=strsplit(chain2,'Arm');
name2=name2{1};

chain1Joints=[];
chain2Joints=[];
for triangleId=1:32
    joint=robot.findJoint([name1,'Triangle',int2str(triangleId-1)]);
    if ~isempty(joint)
        joint=joint{1};
        chain1Joints=[chain1Joints;joint];
    else
        chain1Joints=[chain1Joints;nan];
    end
    joint=robot.findJoint([name2,'Triangle',int2str(triangleId-1)]);
    if ~isempty(joint)
        joint=joint{1};
        chain2Joints=[chain2Joints;joint];
    else
        chain2Joints=[chain2Joints;nan];
    end
end


dataset.(chain1).newTaxels={};
dataset.(chain2).newTaxels={};
dataset.(chain1).cops={};
dataset.(chain2).cops={};
dataset.(chain1).cop={};
dataset.(chain2).cop={};
dataset.angles=[];
dataset.mins=[];
dataset.difs=[];
dataset.(chain1).newTaxelsNA={};
dataset.(chain2).newTaxelsNA={};

fprintf('%s\n',datasetName);
for i=1:size(datasetLocal.(chain1),1)
    if rem(i,100)==0
        fprintf('Completed %d out of %d\n',i,size(datasetLocal.(chain1),1))
    end
    ang=datasetLocal.(chain1)(i).angles;
    angles.rightArm=[0,ang.RShoulderPitch, ang.RShoulderRoll, ang.RElbowYaw,...
        ang.RElbowRoll, ang.RWristYaw];
    angles.leftArm=[0,ang.LShoulderPitch, ang.LShoulderRoll, ang.LElbowYaw,...
        ang.LElbowRoll, ang.LWristYaw];
    angles.head=[0,ang.HeadYaw, ang.HeadPitch];
    angles.rightArmSkin=[0,0,0];
    angles.leftArmSkin=[0,0,0];
    angles.torsoSkin=[0,0,0];
    angles.torso=[0];
    dataset.angles=[dataset.angles;angles];
    
    chain1Points=zeros(384,3);
    chain2Points=zeros(384,3);

    for triangleId=1:32
        joint=chain1Joints(triangleId);
        if ~isempty(joint.parent)
            mat=getTF(DH,joint,[],1,angles, robot.structure.H0);
            points=mat*[chain1Original((triangleId-1)*12+1:triangleId*12,1:3).*1000,ones(12,1)]';
            chain1Points((triangleId-1)*12+1:triangleId*12,1:3)=points(1:3,:)';
        end
        joint=chain2Joints(triangleId);
        if ~isempty(joint.parent)
            mat=getTF(DH,joint,[],1,angles, robot.structure.H0);
            points=mat*[chain2Original((triangleId-1)*12+1:triangleId*12,1:3).*1000,ones(12,1)]';
            chain2Points((triangleId-1)*12+1:triangleId*12,1:3)=points(1:3,:)';
        end
    end
    
    taxelsIds=datasetLocal.(chain1)(i).activatedUn(:,4)+1;
    newTaxels=[chain1Points(taxelsIds',:),taxelsIds];
    chain1Points(taxelsIds',:)=[];
    dataset.(chain1).newTaxels{end+1}=newTaxels;

    taxelsIds=datasetLocal.(chain2)(i).activatedUn(:,4)+1;
    newTaxels=[chain2Points(taxelsIds',:),taxelsIds];
    chain2Points(taxelsIds',:)=[];
    dataset.(chain2).newTaxels{end+1}=newTaxels;
    
    cops1=findCop(dataset.(chain1).newTaxels{end},10);
    cops2=findCop(dataset.(chain2).newTaxels{end},10);
    dataset.(chain1).cops{end+1}=cops1;
    dataset.(chain2).cops{end+1}=cops2;
    [cop1,cop2, difs, actMin]=findClosestCop(cops1,cops2);
    dataset.(chain1).cop{end+1}=cop1;
    dataset.(chain2).cop{end+1}=cop2;
    dataset.mins=[dataset.mins;actMin];
    dataset.difs=[dataset.difs;difs];
    
    chain1Points(all(~chain1Points,2),:)=[];
    chain2Points(all(~chain2Points,2),:)=[];
    
    dataset.(chain1).newTaxelsNA{end+1}=chain1Points;
    dataset.(chain2).newTaxelsNA{end+1}=chain2Points;

end


%struct for new taxels positions
taxelStruct=struct();
for i=1:384
    taxelStruct.(strcat('s',num2str(i))).secondTaxel=[];
    taxelStruct.(strcat('s',num2str(i))).secondTaxelId=[];
    taxelStruct.(strcat('s',num2str(i))).angles=[];
    taxelStruct.(strcat('s',num2str(i))).mins=[];
    taxelStruct.(strcat('s',num2str(i))).difs=[];
    taxelStruct.(strcat('s',num2str(i))).cops={};
    taxelStruct.(strcat('s',num2str(i))).newTaxels={};
    taxelStruct.(strcat('s',num2str(i))).newTaxelsNA={};
    taxelStruct.(strcat('s',num2str(i))).cop={};
end

for i=1:size(dataset.(chain1).cop,2)
   minDist=9999;
   %Find taxel closest to COP on part1
   taxels=dataset.(chain1).newTaxels{i};
   cop=dataset.(chain1).cop{i};
   for j=1:size(taxels,1)
       if round(norm(taxels(j,1:3)-cop,2),10)<=minDist
           minDist=round(norm(taxels(j,1:3)-cop,2),10);
           minTaxel=taxels(j,1:3);
           taxelIdx=taxels(j,4);
       end
   end
   minDist=9999;
   maxDistanceFromCop=5;
   minTaxel2=[];
   %Find taxel closest to taxel found above
   taxels=dataset.(chain2).newTaxels{i};
   cop=dataset.(chain2).cop{i};

   for j=1:size(taxels,1)
       if round(norm(taxels(j,1:3)-cop,2),10)<=maxDistanceFromCop && round(norm(taxels(j,1:3)-minTaxel,2),10)<=minDist
           minDist=round(norm(taxels(j,1:3)-minTaxel,2),10);
           minTaxel2=taxels(j,1:3);
           minTaxel2Id=taxels(j,4);
       end
   end

   if minDist<9999
       %Assign new taxels position to struct
       taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxelId=[taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxelId;minTaxel2Id];
       taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxel=[taxelStruct.(strcat('s',num2str(taxelIdx))).secondTaxel;minTaxel2];
       taxelStruct.(strcat('s',num2str(taxelIdx))).angles=[taxelStruct.(strcat('s',num2str(taxelIdx))).angles;dataset.angles(i)];
       taxelStruct.(strcat('s',num2str(taxelIdx))).mins=[taxelStruct.(strcat('s',num2str(taxelIdx))).mins;dataset.mins(i)];
       taxelStruct.(strcat('s',num2str(taxelIdx))).difs=[taxelStruct.(strcat('s',num2str(taxelIdx))).difs;dataset.difs(i,:)];
       taxelStruct.(strcat('s',num2str(taxelIdx))).cops{end+1}={dataset.(chain1).cops{i},dataset.(chain2).cops{i}};
       taxelStruct.(strcat('s',num2str(taxelIdx))).newTaxels{end+1}={dataset.(chain1).newTaxels{i},dataset.(chain2).newTaxels{i}};
       taxelStruct.(strcat('s',num2str(taxelIdx))).newTaxelsNA{end+1}={dataset.(chain1).newTaxelsNA{i},dataset.(chain2).newTaxelsNA{i}};
       taxelStruct.(strcat('s',num2str(taxelIdx))).cop{end+1}={dataset.(chain1).cop{i},dataset.(chain2).cop{i}};
   end
   
end
taxelStruct.chain1=chain1;
taxelStruct.chain2=chain2;
toc
end