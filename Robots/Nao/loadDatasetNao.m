function [ datasets, indexes]= loadDatasetNao(robot,optim, datasetsNames)
    DH=robot.structure.DH;
    DH.torso=[0,0,0,0];
    fnames=fieldnames(robot.structure.skinDH);
    for name=1:length(fnames)
        DH.(fnames{name})=robot.structure.skinDH.(fnames{name});
    end
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
        dataset.mins=[];
        dataset.difs=[];
        dataset.cops=[];
        dataset.cop=[];
        dataset.newTaxelsNA=[];
        dataset.newTaxels=[];
        dataset.name=strcat(chain1,'_',chain2);
        firstLocal = importdata(strcat('Dataset/Points/',chain1,'.txt'),' ',4);
        chain1Original=firstLocal.data;
        firstLocal = importdata(strcat('Dataset/Points/',chain2,'.txt'),' ',4);
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
                datasetLocal.mins=[];
                datasetLocal.difs=[];
                datasetLocal.numberOfCops=[];
                datasetLocal.numberOfTaxels=[];
                datasetLocal.cops=[];
                datasetLocal.cop=[];
                datasetLocal.newTaxelsNA=[];
                datasetLocal.newTaxels=[];
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
                                datasetLocal.point=[datasetLocal.point;chain1Original(index,1:3).*1000,chain2Original(a,1:3).*1000];
                            end
                            datasetLocal.joints=[datasetLocal.joints;angles];
                            datasetLocal.frame{end+1}=strcat(name1,'Triangle',num2str(triangleId));
                            datasetLocal.frame2{end+1} = strcat(name2,'Triangle',num2str(floor((a-1)/12)));
                            datasetLocal.pose=[datasetLocal.pose;poseID];
                            datasetLocal.mins=[datasetLocal.mins;taxelStruct.(strcat('s',num2str(index))).mins(i)];
                            datasetLocal.difs=[datasetLocal.difs;taxelStruct.(strcat('s',num2str(index))).difs(i,:)];
                            poseID=poseID+1;
                            
                            dh=DH.(chain1);
                            dh(:,4)=dh(:,4)+angles.(chain1)';
                            matrices.(chain1)=dhpars2tfmat(dh);
                            dh=DH.(chain2);
                            dh(:,4)=dh(:,4)+angles.(chain2)';
                            matrices.(chain2)=dhpars2tfmat(dh);
                            
                            matrices.torso=eye(4);
                            
                            %datasetLocal.rtMat=[datasetLocal.rtMat;matrices];
                            datasetLocal.cops=[datasetLocal.cops;taxelStruct.(strcat('s',num2str(index))).cops{i}];
                            datasetLocal.cop=[datasetLocal.cop;taxelStruct.(strcat('s',num2str(index))).cop{i}];
                            datasetLocal.newTaxelsNA=[datasetLocal.newTaxelsNA;taxelStruct.(strcat('s',num2str(index))).newTaxelsNA{i}];
                            datasetLocal.newTaxels=[datasetLocal.newTaxels;taxelStruct.(strcat('s',num2str(index))).newTaxels{i}];
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
                    dataset.mins=[dataset.mins;datasetLocal.mins];
                    dataset.difs=[dataset.difs;datasetLocal.difs];
                    dataset.cops=[dataset.cops;datasetLocal.cops];
                    dataset.cop=[dataset.cop;datasetLocal.cop];
                    dataset.newTaxelsNA=[dataset.newTaxelsNA;datasetLocal.newTaxelsNA];
                    dataset.newTaxels=[dataset.newTaxels;datasetLocal.newTaxels];
                end
        end
        dataset.avg=mean(dataset.mins);
        dataset.avgDifs=mean(dataset.difs);
        datasets{name}=dataset;
    end
    
end