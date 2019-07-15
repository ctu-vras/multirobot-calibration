function [ datasets, indexes ] = loadDatasetICub(robot,optim, varargin )
%LOADDATASETICUB Summary of this function goes here
%   Detailed explanation goes here
    if(length(varargin) == 2)
        source_files = {varargin{2}{1}};
    else
        source_files = {'selfTouchConfigs_ICRA2019.log'};
    end
    nmb_of_files = length(source_files);
    datasets = cell(nmb_of_files*2,1);
    DEG2RAD = pi/180;
    for k = 1:nmb_of_files
        dataset.extCoords = [];
        fingers={'rightThumb','rightIndex','rightMiddle','leftThumb','leftIndex','leftMiddle'};
        for finger=fingers
           matrices.(finger{1})=dhpars2tfmat(robot.structure.DH.(finger{1})); 
        end
        dataset.cameras = [];
        f = strsplit(source_files{k}, '.');
        data2 = load(['Dataset/',source_files{k}]);
        path = sprintf('Dataset/distances_%s.mat', f{1});
        distances = load(path);
        [~, idxs] = sort(distances.distances);
        data2 = data2(idxs,:);
        if(isempty(varargin))
            nmbPoses = length(idxs);
        else
            nmbPoses = varargin{1}{1};
        end
        data2(nmbPoses+1:end,:) = [];
        
        dataset.joints = struct('torso', num2cell(data2(:,4:5)*DEG2RAD,2), 'leftArm',num2cell(data2(:, [6:13])*DEG2RAD,2),...
            'rightArm',num2cell(data2(:, [6,17:23])*DEG2RAD,2), 'head',num2cell(data2(:, [6,24:26])*DEG2RAD,2),...
            'leftEye',num2cell([data2(:, 27),data2(:,28)+eyeAngle]*DEG2RAD,2), 'rightEye',num2cell([data2(:, 27),data2(:,28)-eyeAngle]*DEG2RAD,2));
        
        for i = 1:size(data2,1)
            dhtorso=rob.structure.DH.torso;
            dhtorso(:,4)=dhtorso(:,4)+dataset.joints(i).torso';
            mat.torso = robot.structure.H0 * dhpars2tfmat(dhtorso);
            if(optim.chains.leftArm == 0)
                dhleft=rob.structure.DH.leftArm;
                dhleft(:,4)=dhtorso(:,4)+dataset.joints(i).leftArm';
                mat.leftArm = dhpars2tfmat(dhleft);
            end
            if(optim.chains.rightArm == 0)
                dhright=rob.structure.DH.rightArm;
                dhright(:,4)=dhright(:,4)+dataset.joints(i).rightArm';
                mat.rightArm = dhpars2tfmat(dhright);
            end
            for finger=fingers
                mat.(finger{1})=matrices.(finger{1}); 
            end
            dataset.rtMat = [dataset.rtMat;mat];
        end
        
        dataset.point = zeros(size(data2,1),6);
        dataset.pose = (1:size(data2,1))';
        C = cell(size(data2,1),1);
        C(:) = {'rightHandFinger'};
        dataset.frame = C;
        C(:) = {'leftHandFinger'};
        dataset.frame2 = C;
        eyeAngle = data2(:,29)/2;
        dataset.refPoints = data2(:,1:3);
            
        dataset2.frame =  reshape([dataset.frame'; dataset.frame2'],[],1);
        dataset2.point =  reshape([dataset.point'; dataset.point'],[],3);
        dataset2.joints = reshape([dataset.joints'; dataset.joints'],[],1);
        dataset2.extCoords = reshape([dataset.extCoords'; dataset.extCoords'],[],1);
        dataset2.rtMat = reshape([dataset.rtMat'; dataset.rtMat'],[],1);
        dataset2.pose = reshape([dataset.pose'; dataset.pose'],[],1);
        dataset2.cameras = ones(2*size(data2,1),2);
        dataset2.refPoints = ones(2*size(data2,1),2); % TODO: dopocitat projekce        
        
        datasets{k} = dataset; 
        datasets{k+nmb_of_files} = dataset2;
        
        
    end
    indexes = {1:nmb_of_files, [] ,[], nmb_of_files+1:nmb_of_files*2};
end
