function [ datasets, indexes ] = loadDatasetICub( varargin )
%LOADDATASETICUB Summary of this function goes here
%   Detailed explanation goes here

    if(nargin == 1)
        source_files = varargin{2};
    else
        source_files = {'selfTouchConfigs_ICRA2019.log'};
    end
    nmb_of_files = length(source_files);
    datasets = cell(nmb_of_files,1);
    DEG2RAD = pi/180;
    for k = 1:length(source_files)
        dataset.extCoords = [];
        dataset.cameras = [];
        dataset.pixels = [];
        dataset.rtMat = [];
        f = strsplit(source_files{k}, '.');
        data2 = load(['dual-icub-ICRA2019Rebuttal/dataset/',source_files{k}]);
        path = sprintf('dual-icub-ICRA2019Rebuttal/dataset/distances_%s.mat', f{1});
        distances = load(path);
        [~, idxs] = sort(distances.distances);
        data2 = data2(idxs,:);
        data2(varargin{1}+1:end,:) = [];
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
        dataset.refPoints = [];
        datasets{k} = dataset; 
    end
    indexes = {1:length(source_files), [] ,[], 1:length(source_files)};
end

