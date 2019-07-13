function [ datasets, indexes ] = loadDatasetICub(robot,optim, varargin )
%LOADDATASETICUB Summary of this function goes here
%   Detailed explanation goes here
    if(length(varargin) == 2)
        source_files = {varargin{2}};
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
        dataset.rtMat = repmat(matrices,size(data2,1),1);
        dataset.cameras [];
        f = strsplit(source_files{k}, '.');
        data2 = load(['dual-icub-ICRA2019Rebuttal/dataset/',source_files{k}]);
        path = sprintf('dual-icub-ICRA2019Rebuttal/dataset/distances_%s.mat', f{1});
        distances = load(path);
        [~, idxs] = sort(distances.distances);
        data2 = data2(idxs,:);
        if(isempty(varargin))
            nmbPoses = length(idxs);
        else
            nmbPoses = varargin{1};
        end
        data2(nmbPoses+1:end,:) = [];
        dataset.point = zeros(size(data2,1),6);
        dataset.pose = [1:size(data2,1)]';
        C = cell(size(data2,1),1);
        C(:) = {'rightHandFinger'};
        dataset.frame = C;
        C(:) = {'leftHandFinger'};
        dataset.frame2 = C;
        eyeAngle = data2(:,29)/2;
        dataset.joints = struct('torso', num2cell(data2(:,4:5)*DEG2RAD,2), 'leftArm',num2cell(data2(:, [6:13])*DEG2RAD,2),...
            'rightArm',num2cell(data2(:, [6,17:23])*DEG2RAD,2), 'head',num2cell(data2(:, [6,24:26])*DEG2RAD,2),...
            'leftEye',num2cell([data2(:, 27),data2(:,28)+eyeAngle]*DEG2RAD,2), 'rightEye',num2cell([data2(:, 27),data2(:,28)-eyeAngle]*DEG2RAD,2));
        dataset.refPoints = data2(:,1:3);
        
        
        dataset2.frame = dataset.frame;
        dataset2.frame2 = dataset.frame2;
        dataset2.point = dataset.point;
        dataset2.joints = dataset.joints;
        dataset2.extCoords = dataset.extCoords;
        dataset2.rtMat = dataset.rtMat;
        dataset2.pose = dataset.pose;
        dataset2.cameras = ones(size(data2,1),2);
        dataset2.refPoints = ones(size(data2,1),2); % TODO: dopocitat projekce
        
        
        datasets{k} = dataset; 
        datasets{k+nmb_of_files} = dataset2;
        
        
    end
    indexes = {1:nmb_of_files, [] ,[], nmb_of_files+1:nmb_of_files*2};
end

