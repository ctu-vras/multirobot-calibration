function datasets = loadExampleDataset(rob,optim, chains, varargin)
%LOADEXAMPLEDATASET Loading example dataset loading function
% Template function for loading example dataset.
% INPUT - rob - object of class Robot
%       - optim - calibration options (not used here)
%       - chains - structure containing which chains will be calibrated
%       (not used here)
%       - varargin - cellarray of arguments - {'LREye', 'LEye', 'REye', ''}
%   OUTPUT - datasets - struct of cell arrays, fieldnames corresponds to
%                       approaches
    
    if(~isempty(varargin))
       chain = varargin{1}{1}; 
    end
    datasetsCount = 1; %your number of datasets
    % define empty cells for datasets
    datasets.selftouch = cell(1,datasetsCount); %datasets cell array MUST BE ROW VECTOR
    datasets.projection = {};
    for index = 1:datasetsCount 
        %% self touch dataset
        dataset = initDataset(true); %init dataset with all fields
        
        %Suppose we have an dataset named 'example.csv'
        %Load it into matrix
        data = readmatrix('example.csv');
        %It have 100 lines and 14 columns, where column represents random
        %joint angles for joints defined in  'loadExampleRobot.m' (from
        %leftShoulder to rightEyeVergence)
        posesCount = size(data, 1);
        
        % each pose is independent
        dataset.pose = 1:posesCount;
        
        % First frame always ends at leftWrist
        C = cell(posesCount,1);
        C(:) = {'leftWrist'};
        dataset.frame = C;
        
        % Second frame always ends at rightWrist
        C(:) = {'rightWrist'}; 
        dataset.frame2 = C;
        
        % Points have no translation from last frame
        dataset.point = zeros(posesCount,6);
        
        % Define array for joints
        dataset.joints = [];
        
        % define cell with all groups
        myGroups = {'leftArm', 'rightArm', 'head', 'leftEye', 'rightEye'};
        % define number of joints in each groups
        jointNums = [4,4,2,2,2];
        
        
        % iterate over the cell array
        for item=1:posesCount
            offset = 0;
            temp = struct();
            for gr = 1:length(myGroups)
                % add joint angles from offset to offset + number of joints for
                % given group
                temp.(myGroups{gr}) = data(item, offset+1:offset+jointNums(gr));
                %update offset
                offset = offset + jointNums(gr);
            end
            dataset.joints = [dataset.joints; temp];
        end
        
        for j = 1:length(dataset.pose)
            matrices.torso = [1, 0, 0, 0;  % torso is not calibrated so we can create fixed matrix to speed up
                              0, 1, 0, 0;
                              0, 0, 1, 0;
                              0, 0, 0, 1];
            %add to dataset
            dataset.rtMat = [dataset.rtMat; matrices]; 
        end   

        % add name and id
        dataset.id = index;
        dataset.name = ['Self-touch ', num2str(index)];
        
        %assign into selftouch dataset cell
        datasets.selftouch{index} = dataset; 
        
        %% projection dataset
        if (~isempty(chain))
            % init dataset
            dataset2 = initDataset(false);
            % copy from previous dataset
            dataset2.pose = dataset.pose;
            dataset2.frame = dataset.frame;
            dataset2.point = dataset.point;
            dataset2.joints = dataset.joints;
            dataset2.rtMat = dataset.rtMat;
            
            %Depending on selected chain add random camera positions to
            %dataset
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
            datasets.projection{index} = dataset2; 
        end
    end
    % dataset can be saved and then the mat-file can be used
%     save('example_dataset.mat', 'datasets'); 
    
end