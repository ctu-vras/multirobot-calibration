function [ datasets, indexes ]= loadDatasetNao(robot,DH)


    taxelStruct=prepareData(robot,'rightArm','torso',DH);
    dataset.point = [];
    dataset.pose = [];
    dataset.frame = {};
    dataset.frame2 = {};
    dataset.joints = [];
    dataset.extCoords = [];
    dataset.cameras = [];
    dataset.pixels = [];
    dataset.refPoints = [];
    dataset.rtMat = [];
    firstLocal = importdata(strcat('Dataset/','rightArm','.txt'),' ',4);
    chain1Original=firstLocal.data;
    firstLocal = importdata(strcat('Dataset/','torso','.txt'),' ',4);
    chain2Original=firstLocal.data;
    poseID=1;
    for triangleId=0:31
            
            datasetLocal.point = [];
            datasetLocal.pose = [];
            datasetLocal.frame = {};
            datasetLocal.frame2 = {};
            datasetLocal.joints = [];
            datasetLocal.extCoords = [];
            datasetLocal.cameras = [];
            datasetLocal.pixels = [];
            datasetLocal.refPoints = [];
            datasetLocal.rtMat = [];
            for taxelId=1:12
                index=triangleId*12+taxelId;
                if isstruct(taxelStruct.(strcat('s',num2str(index)))) && size(taxelStruct.(strcat('s',num2str(index))).secondTaxel,1)>0
                    for i=1:size(taxelStruct.(strcat('s',num2str(index))).secondTaxel,1)
                        angles=taxelStruct.(strcat('s',num2str(index))).angles(i);
                        datasetLocal.refPoints=[datasetLocal.refPoints;taxelStruct.(strcat('s',num2str(index))).secondTaxel(i,:)];
                        a=taxelStruct.(strcat('s',num2str(index))).secondTaxelId(i);
                        datasetLocal.point=[datasetLocal.point;chain1Original(index,1:3).*1000];%,to2.torso(a+1,:).*1000];
                        datasetLocal.joints=[datasetLocal.joints;angles];
                        datasetLocal.frame{end+1}=strcat('rightTriangle',num2str(triangleId));
                        datasetLocal.frame2{end+1} = strcat('torsoTriangle',num2str(floor(a/12)));
                        datasetLocal.pose=[datasetLocal.pose;poseID];
                        poseID=poseID+1;
                        dh=DH.rightArm(:,:,1);
                        dh(:,4)=dh(:,4)+angles.rightArm';
                        matrices.rightArm=dhpars2tfmat(dh);
                        matrices.torso=eye(4);
                        datasetLocal.rtMat=[datasetLocal.rtMat;matrices];
                    end
                end

            end
            if size(datasetLocal.point,1)>1
                dataset.refPoints=[dataset.refPoints;datasetLocal.refPoints];
                dataset.point=[dataset.point;datasetLocal.point];
                dataset.joints=[dataset.joints;datasetLocal.joints];
                dataset.frame=[dataset.frame,datasetLocal.frame];
                dataset.frame2=[dataset.frame2,datasetLocal.frame2];
                dataset.pose=[dataset.pose;datasetLocal.pose];
                dataset.rtMat=[dataset.rtMat;datasetLocal.rtMat];
            end
    end
    datasets={dataset};
    indexes={1,[],[],[]};
end