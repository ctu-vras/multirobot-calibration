function [ datasets, indexes ]= loadDatasetNao(optim, robot,DH,datasetsNames)

    DH.torso=[0,0,0,0];
    datasets=cell(1,length(datasetsNames));
    indexes={1:length(datasetsNames),[],[],[]};
    for name=1:length(datasetsNames)
        spl=strsplit(datasetsNames{name},'_');
        chain1=spl{1};
        chain2=spl{2};
        if ~optim.chains.(chain1)
           chain1=spl{2};
           chain2=spl{1};
        end
        name1=strsplit(chain1,'Arm');
        name1=name1{1};
        name2=strsplit(chain2,'Arm');
        name2=name2{1};
        taxelStruct=prepareData(robot,datasetsNames{name},chain1,chain2,DH);
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
        firstLocal = importdata(strcat('Dataset/',chain1,'.txt'),' ',4);
        chain1Original=firstLocal.data;
        firstLocal = importdata(strcat('Dataset/',chain2,'.txt'),' ',4);
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
                            a=taxelStruct.(strcat('s',num2str(index))).secondTaxelId(i);
                            if optim.refPoints && ~all([optim.chains.(chain1),optim.chains.(chain2)])
                                datasetLocal.refPoints=[datasetLocal.refPoints;taxelStruct.(strcat('s',num2str(index))).secondTaxel(i,:)];
                                datasetLocal.point=[datasetLocal.point;chain1Original(index,1:3).*1000];
                            else
                                datasetLocal.point=[datasetLocal.point;chain1Original(index,1:3).*1000,chain2Original(a+1,1:3).*1000];
                            end
                            datasetLocal.joints=[datasetLocal.joints;angles];
                            datasetLocal.frame{end+1}=strcat(name1,'Triangle',num2str(triangleId));
                            datasetLocal.frame2{end+1} = strcat(name2,'Triangle',num2str(floor(a/12)));
                            datasetLocal.pose=[datasetLocal.pose;poseID];
                            poseID=poseID+1;
                            
                            dh=DH.(chain1)(:,:,1);
                            dh(:,4)=dh(:,4)+angles.(chain1)';
                            matrices.(chain1)=dhpars2tfmat(dh);
                            dh=DH.(chain2)(:,:,1);
                            dh(:,4)=dh(:,4)+angles.(chain2)';
                            matrices.(chain2)=dhpars2tfmat(dh);
                            
                            datasetLocal.rtMat=[datasetLocal.rtMat;matrices];
                        end
                    end

                end
                if size(datasetLocal.point,1)>10
                    dataset.refPoints=[dataset.refPoints;datasetLocal.refPoints];
                    dataset.point=[dataset.point;datasetLocal.point];
                    dataset.joints=[dataset.joints;datasetLocal.joints];
                    dataset.frame=[dataset.frame,datasetLocal.frame];
                    dataset.frame2=[dataset.frame2,datasetLocal.frame2];
                    dataset.pose=[dataset.pose;datasetLocal.pose];
                    dataset.rtMat=[dataset.rtMat;datasetLocal.rtMat];
                end
        end
        datasets{name}=dataset;
    end
    
end