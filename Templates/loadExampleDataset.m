function datasets = loadExampleDataset(rob,optim, chains, varargin)
%LOADEXAMPLEDATASET Loading example dataset loading function
% Template function for loading example dataset.
% INPUT - rob - object of class Robot
%       - optim - calibration options (not used here)
%       - chains - structure containing which chains will be calibrated
%       (not used here)
%       - varargin - cellarray of arguments - {'LREye', 'LEye', 'REye', ''}
%   OUTPUT - datasets - 1x4 ([self-touch, planes, external, projection]) 
%                       cell array of cell arrays (1xN) of datasets
    
    assert(strcmp(rob.name,'example'))
    if(~isempty(varargin))
       chain = varargin{1}{1}; 
    end
    datasetsCount = 3;
    datasets_st = cell(1,datasetsCount); %datasets cell array MUST BE ROW VECTOR
    datasets_projs = {};
    posesCount = 100;
    for index = 1:datasetsCount 
        %% self touch dataset
        dataset.cameras = [];
        dataset.refPoints = [];
        dataset.pose = 1:posesCount;
        C = cell(posesCount,1);
        C(:) = {'rightWrist'}; % end effector name
        dataset.frame = C;
        C(:) = {'leftWrist'}; % end effector name
        dataset.frame2 = C;
        dataset.point = zeros(posesCount,6);
        
        dataset.joints = struct('torso', num2cell(zeros(posesCount,1),2),...
        'rightArm',num2cell(rand(posesCount,4),2),...
        'leftArm',num2cell(rand(posesCount,4),2), ...
        'head', num2cell(rand(posesCount,2),2), ...
        'leftEye', num2cell(rand(posesCount,2),2), ...
        'rightEye', num2cell(rand(posesCount,2),2)); 
        
        for j = length(dataset.pose):-1:1
            matrices.torso = [1, 0, 0, 0.001;  % torso is not calibrated
                              0, 1, 0, 0;
                              0, 0, 1, 0;
                              0, 0, 0, 1];
            dataset.rtMat(j) = matrices; 
        end   
        dataset.rtMat = reshape(dataset.rtMat, length(dataset.pose),1);
        dataset.id = index;
        dataset.name = ['Self-touch ', num2str(index)];
        datasets_st{index} = dataset; 
        
        %% projection dataset
        if (~isempty(chain))
            dataset2.pose = dataset.pose;
            dataset2.frame = dataset.frame;
            dataset2.point = dataset.point;
            dataset2.joints = dataset.joints;
            dataset2.rtMat = dataset.rtMat;
            
            if(strcmp(chain, 'LREye'))
                dataset2.cameras = ones(posesCount, 2);
                % refPoints here are pixel coordinates of end effector from the captured photo
                dataset2.refPoints = randi(5000,posesCount,4); 
            elseif(strcmp(chain, 'REye')) % index 1 is right camera - right camera has first camera matrix in robot function
                dataset2.cameras = [ones(posesCount,1), zeros(posesCount,1)];
                dataset2.refPoints = [randi(5000,posesCount,2), nan(posesCount,2)];
            elseif(strcmp(chain, 'LEye'))
                dataset2.cameras = [zeros(posesCount,1), ones(posesCount,1)];
                dataset2.refPoints = [nan(posesCount,2), randi(5000,posesCount,2)];
            end
            dataset2.id = index;
            dataset2.name = ['Projection ', num2str(index)];
            datasets_projs{index} = dataset2; 
        end
    end
    %           self-touch, planes, external, projection
    datasets = {datasets_st,{},{}, datasets_projs};
    % dataset can be saved and then the mat-file can be used
%     save('example_dataset.mat', 'datasets'); 
    
end