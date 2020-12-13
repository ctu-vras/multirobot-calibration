function datasets = loadNewLeicaDataset(rob,~, ~, ~ )
%LOADDATASETMOTOMAN Loading Motoman dataset loading function
% Custom function for loading Motoman dataset collected in 
% august 2019 with additional data from Leica tracker.
% Dataset consists of poses with leica end effector.
% INPUT - rob - object of class Robot
%       - optim - calibration options (not used here - ~)
%       - chains - structure containing which chains will be calibrated
%       (not used here - ~)
%       - varargin - cellarray of arguments (not used here - ~)
%   OUTPUT - datasets - 1x4 ([self-touch, planes, external, projection]) 
%                       cell array of cell arrays (1xN) of datasets

    assert(~isempty(rob.findJoint('LR1')))
    
    
    dataset.cameras = [];
    data= load('leica_dataset/updated_leica_dataset.mat');
    leicaData = data.dataset;
    [~, index_pose, ~] = unique(leicaData(:,1));  % original dataset has multiple records for each pose
    leicaData = leicaData(index_pose,:);
    leicaData = leicaData(~isnan(leicaData(:,end)), :); % only poses logged by leica
    leicaData(13,:) = [];
    dataset.pose = leicaData(:,1);
    C = cell(size(leicaData,1),1);
    C(:) = {'LR1'}; % end effector name
    dataset.frame = C;
    dataset.joints = struct('rightArm',num2cell([leicaData(:, 7:13),zeros(size(leicaData,1),1)],2),...
    'leftArm',num2cell([leicaData(:, [7,14:19]),zeros(size(leicaData,1),1)],2), ...,
    'leftEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2), ...
    'rightEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2)); 
    dataset.point = zeros(size(leicaData,1),6);
    dataset.refPoints = leicaData(:,20:22);  
    for j = length(dataset.pose):-1:1
        matrices.torso = eye(4);
        dataset.rtMat(j) = matrices; 
    end   
    dataset.rtMat = reshape(dataset.rtMat, length(dataset.pose),1);
    dataset.name = 'leica';
    datasets.external = {dataset};    
end
