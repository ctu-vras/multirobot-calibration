function taxelStruct=prepareData(robot,datasetName, chain1,chain2,DH)

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

fnames=fieldnames(DH);
for name=1:length(fnames)
   DH.(fnames{name})=DH.(fnames{name})(:,:,1); 
end
datasetLocal=load(strcat('Dataset/',datasetName,'.mat'));
name1=strsplit(chain1,'Arm');
name1=name1{1};
name2=strsplit(chain2,'Arm');
name2=name2{1};

dataset.(chain1).newTaxels={};
dataset.(chain2).newTaxels={};
dataset.(chain1).cops={};
dataset.(chain2).cops={};
dataset.(chain1).cop={};
dataset.(chain2).cop={};
dataset.angles=[];

joints = containers.Map('KeyType','char','ValueType','double');
matId=1;
mats=cell(1,64);
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
    taxels=datasetLocal.(chain1)(i).activatedUn;
    newTaxels=cell(1,size(taxels,1));
    for j=1:size(taxels,1)
        idx=taxels(j,4);
        taxel=chain1Original(idx+1,1:3);
        triangleId=floor(idx/12);
        trName=strcat(name1,'Triangle',num2str(triangleId));
        if ~isKey(joints, trName)
            joint=robot.findJoint(trName);
            joint=joint{1};
            mat=getTF(DH,joint,[],1,angles, robot.structure.H0);
            mats{matId}=mat;
            newTaxel=mat*[taxel(1:3).*1000,1]';
            joints(trName)=matId;
            matId=matId+1;
        else
            newTaxel=mats{joints(trName)}*[taxel(1:3).*1000,1]';
        end
        
        newTaxels{j}=[newTaxel(1:3)',idx];
    end
    dataset.(chain1).newTaxels{end+1}=newTaxels;

    taxels=datasetLocal.(chain2)(i).activatedUn;
    newTaxels=cell(1,size(taxels,1));
    for j=1:size(taxels,1)
        idx=taxels(j,4);
        taxel=chain2Original(idx+1,1:3);
        triangleId=floor(idx/12);
        trName=strcat(name2,'Triangle',num2str(triangleId));
        if ~isKey(joints, trName)
            joint=robot.findJoint(trName);
            joint=joint{1};
            mat=getTF(DH,joint,[],1,angles, robot.structure.H0);
            mats{matId}=mat;
            newTaxel=mat*[taxel(1:3).*1000,1]';
            joints(trName)=matId;
            matId=matId+1;
        else
            newTaxel=mats{joints(trName)}*[taxel(1:3).*1000,1]';
        end
        
        newTaxels{j}=[newTaxel(1:3)',idx];
    end     
    dataset.(chain2).newTaxels{end+1}=newTaxels;
    
    cops1=findCop(dataset.(chain1).newTaxels{end},10);
    cops2=findCop(dataset.(chain2).newTaxels{end},10);
    
    dataset.(chain1).cops{end+1}=cops1;
    dataset.(chain2).cops{end+1}=cops2;
        
    [cop1,cop2]=findClosestCop(cops1,cops2);
    dataset.(chain1).cop{end+1}=cop1;
    dataset.(chain2).cop{end+1}=cop2;
end


%struct for new taxels positions
taxelStruct=struct();
for i=1:384
    taxelStruct.(strcat('s',num2str(i))).secondTaxel=[];
    taxelStruct.(strcat('s',num2str(i))).secondTaxelId=[];
    taxelStruct.(strcat('s',num2str(i))).angles=[];
    taxelStruct.(strcat('s',num2str(i))).distances=[];
end

for i=1:size(dataset.(chain1).cop,2)
   minDist=9999;
   %Find taxel closest to COP on part1
   taxels=dataset.(chain1).newTaxels{i};
   cop=dataset.(chain1).cop{i};

   for j=1:size(taxels,2)
       
       if round(norm(taxels{j}(1:3)-cop,2),10)<=minDist
           minDist=round(norm(taxels{j}(1:3)-cop,2),10);
           minTaxel=taxels{j}(1:3);
           taxelIdx=taxels{j}(4);
       end
   end
   minDist=9999;
   maxDistanceFromCop=5;
   minTaxel2=[];
   %Find taxel closest to taxel found above
   taxels=dataset.(chain2).newTaxels{i};
   cop=dataset.(chain2).cop{i};

   for j=1:size(taxels,2)
       if round(norm(taxels{j}(1:3)-cop,2),10)<=maxDistanceFromCop && round(norm(taxels{j}(1:3)-minTaxel,2),10)<=minDist
           minDist=round(norm(taxels{j}(1:3)-minTaxel,2),10);
           minTaxel2=taxels{j}(1:3);
           minTaxel2Id=taxels{j}(4);
       end
   end

   if minDist<9999
       %Assign new taxels position to struct
       taxelStruct.(strcat('s',num2str(taxelIdx+1))).secondTaxelId=[taxelStruct.(strcat('s',num2str(taxelIdx+1))).secondTaxelId;minTaxel2Id];
       taxelStruct.(strcat('s',num2str(taxelIdx+1))).secondTaxel=[taxelStruct.(strcat('s',num2str(taxelIdx+1))).secondTaxel;minTaxel2];
       taxelStruct.(strcat('s',num2str(taxelIdx+1))).angles=[taxelStruct.(strcat('s',num2str(taxelIdx+1))).angles;dataset.angles(i)];
       taxelStruct.(strcat('s',num2str(taxelIdx+1))).distances=[taxelStruct.(strcat('s',num2str(taxelIdx+1))).distances;minDist];
   end
   
end
taxelStruct.chain1=chain1;
taxelStruct.chain2=chain2;
end