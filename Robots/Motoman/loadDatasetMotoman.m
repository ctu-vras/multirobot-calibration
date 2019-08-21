function [ datasets, indexes ] = loadDatasetMotoman(rob,optim, chains, varargin )
%LOADDATASETMOTOMAN Loading Motoman dataset loading function
% Custom function for loading Motoman dataset collected in 
% february/march 2019 with additional data from Leica tracker.
% Dataset consists of several groups. First contains data from self-touch,
% 2nd - 4th contain data from touches to different planes. 
% Fifth one is leica dataset with leica end effector.
% INPUT - rob - object of class Robot
%       - optim - calibration options (not used here)
%       - chains - structure containing which chains will be calibrated
%       - varargin - cellarray of arguments to specify which datasets will
%       be used - vector(1x5) or cellarray(1x4} or string 'leica'
% OUTPUT - datasets - structure containing datasets for calibration
%        - indexes - cellarray of indexes to datasets to separate them into
%        specific datasets (self-touch, planes, external, projections)

    varargin = varargin{1};
    % default selection of datasets groups
    used_datasets = [1,1,1,1,0]; 
    % check if robot has Leica end effector
    if(isempty(rob.findJoint('LR1')))
         % parts of individual groups of dataset (indexes to source_files array)
        indexes = {1:8, 9:12, 13:16, 17:20};
        isLeica = false;
    else
        indexes = {1:4, 9:10, 13:14, 17:18};
        isLeica = true;
    end
        
    % check if varargin is not empty
    if(nargin >= 4)
        if(ismatrix(varargin{1}) && ~ischar(varargin{1})) % use selected groups of datasets
        used_datasets = varargin{1}; 
        elseif(strcmp('leica', varargin{1})) % use only leica dataset for robot calibration
            used_datasets = [0,0,0,0,1];
        elseif(iscell(varargin{1}))
            indexes = varargin{1}; % use default groups of datasets but only the selected parts
        end
    end
    
    folder = 'leica_dataset/';
    source_files = {'leica_self_upper1_4x4_dataset.mat', 'leica_self_upper2_4x4_dataset.mat', ...
        'leica_self_lower1_4x4_dataset.mat',  'leica_self_lower2_4x4_dataset.mat', ...
        'no_leica_self_upper1_4x4_dataset.mat', 'no_leica_self_upper2_4x4_dataset.mat', ...
        'no_leica_self_lower1_4x4_dataset.mat', 'no_leica_self_lower2_4x4_dataset.mat',...
        'leica_wall_table1_5x5_dataset.mat', 'leica_wall_table2_5x5_dataset.mat', ...
        'no_leica_wall_table1_5x5_dataset.mat', 'no_leica_wall_table2_5x5_dataset.mat', ...
        'leica_higher_table1_5x5_dataset.mat',  'leica_higher_table2_5x5_dataset.mat', ...
        'no_leica_higher_table1_5x5_dataset.mat',  'no_leica_higher_table2_5x5_dataset.mat',...
        'leica_lower_table1_5x5_dataset.mat', 'leica_lower_table2_5x5_dataset.mat', ...
        'no_leica_lower_table1_5x5_dataset.mat', 'no_leica_lower_table2_5x5_dataset.mat'};
    datasets_leica = {};
    datasets_projection = {};
    datasets_selftouch = {};
    datasets_planes = {};
    index = 0; 
    
    if(isLeica) % leica end effector
        for k = 1:5
            if(used_datasets(k)) 
                dataset.rtMat = [];
                dataset.cameras = [];
                if (k == 5) % only leica dataset
                    if(chains.rightArm)
                        data= load('leica_dataset/leica_right_hand_6x6x6_dataset.mat');
                        jointName = 'LR1';
                    else
                        data= load('leica_dataset/leica_left_hand_6x6x6_dataset.mat');
                        jointName = 'LR2';
                    end
                    leicaData = data.dataset;
                else
                    leicaData = [];
                    last_index = 0;
                    for i=indexes{k} % merge individual files into one for concrete group
                        data = load([folder,source_files{i}]);
                        data = data.dataset;
                        data(:,1) = data(:,1) + last_index;
                        last_index = data(end,1);
                        leicaData = [leicaData;data];
                    end
                end              
                [~, index_pose, ~] = unique(leicaData(:,1));  % original dataset has multiple records for each pose
                leicaData = leicaData(index_pose,:);
                leicaData = leicaData(~isnan(leicaData(:,end)), :); % only poses logged by leica
                dataset.pose = leicaData(:,1);
                C = cell(size(leicaData,1),1);
                C(:) = {jointName}; % end effector name
                dataset.frame = C;
                dataset.joints = struct('rightArm',num2cell([leicaData(:, [7:13]),zeros(size(leicaData,1),1)],2),...
                'leftArm',num2cell([leicaData(:, [7,14:19]),zeros(size(leicaData,1),1)],2), ...,
                'leftEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2), ...
                'rightEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2)); 
                dataset.point = zeros(size(leicaData,1),6);
                dataset.refPoints = leicaData(:,20:22);  
                index = index + 1;
                datasets_leica{index} = dataset; 
            end
        end       
    else
        for k = 1:4
            if(used_datasets(k)) 
                clear dataset % projections dataset
                clear dataset2 % touch datasets
                mergedData = [];
                last_index = 0;
                for i=indexes{k} % merge individual files into one for concrete group
                    data = load([folder,source_files{i}]);
                    data = data.dataset;
                    data(:,1) = data(:,1) + last_index;
                    last_index = data(end,1);
                    mergedData = [mergedData;data];
                end
                %select data rows with unique pose number, marker and arm to create dataset
                [~, first_unique_index, first_indexInUnique] = unique(mergedData(:,[1,2,3]),'rows', 'first');  
                projData = mergedData(first_unique_index,:);
                dataset.pose = projData(:,1);
                dataset.frame = cellstr(strcat('MK',num2str(projData(:,3)),num2str(projData(:,2),'%02d')));
                dataset.joints = struct('rightArm',num2cell([projData(:, 7:13),zeros(size(projData,1),1)],2),...
                'leftArm',num2cell([projData(:, [7,14:19]),zeros(size(projData,1),1)],2), ...,
                'leftEye', num2cell([projData(:, 7),zeros(size(projData,1),1)],2), ...
                'rightEye', num2cell([projData(:, 7),zeros(size(projData,1),1)],2));
                dataset.point = zeros(size(projData,1),6);
                cams = zeros(size(projData,1),2); % logical array - the marker is seen by [right, left] camera
                refPoints = nan(size(projData,1),4); % refPoints of marker projections into [right(x,y), left(x,y)] camera
                cam_index = 1;
                
                %% assign refPoints and cameras to the marker
                for j = 1:(size(mergedData,1))
                    if(j > 1 && (first_indexInUnique(j-1) ~= first_indexInUnique(j)))
                        cam_index = cam_index + 1;
                    end
                     cams(cam_index,mergedData(j,4)) = 1;
                    if(mergedData(j,4) == 1)
                        refPoints(cam_index,1:2) = mergedData(j,5:6);
                    else
                        refPoints(cam_index,3:4) = mergedData(j,5:6);
                    end
                end
                dataset.cameras = cams;
                dataset.refPoints = refPoints;       
                
                %% precompute tf matrices
                % only unique poses are important for tfMatrices
                [~, index_pose, ~] = unique(dataset.pose); 
                preMatrixLeft = zeros(4,4,length(index_pose));
                preMatrixRight = zeros(4,4,length(index_pose));
                preMatrixRightEye = zeros(4,4,length(index_pose));
                preMatrixLeftEye = zeros(4,4,length(index_pose));
                if (chains.leftArm == 0)
                    for j = 1:length(index_pose)
                        dh=rob.structure.DH.leftArm;
                        dh(:,4)=dh(:,4)+ dataset.joints(index_pose(j)).leftArm';
                        preMatrixLeft(:,:,dataset.pose(index_pose(j))) = dhpars2tfmat(dh);
                    end
                end
                if (chains.rightArm == 0)
                    for j = 1:length(index_pose)
                        dh=rob.structure.DH.rightArm;
                        dh(:,4)=dh(:,4)+ dataset.joints(index_pose(j)).rightArm';
                        preMatrixRight(:,:,dataset.pose(index_pose(j))) = dhpars2tfmat(dh);
                    end
                end
                if (chains.rightEye == 0)
                    for j = 1:length(index_pose)
                        dh=rob.structure.DH.rightEye;
                        dh(:,4)=dh(:,4)+ dataset.joints(index_pose(j)).rightEye';
                        preMatrixRightEye(:,:,dataset.pose(index_pose(j))) = dhpars2tfmat(dh);
                    end
                end            
                if (chains.leftEye == 0)
                    for j = 1:length(index_pose)
                        dh=rob.structure.DH.leftEye;
                        dh(:,4)=dh(:,4)+ dataset.joints(index_pose(j)).leftEye';
                        preMatrixLeftEye(:,:,dataset.pose(index_pose(j))) = dhpars2tfmat(dh);
                    end
                end
                  
                %% assign corresponding tf matrices to each pose
                for j = length(dataset.pose):-1:1
                    matrices.rightMarkers = rob.structure.rightMarkers(:,:,projData(j,2));
                    matrices.leftMarkers = rob.structure.leftMarkers(:,:,projData(j,2));
                    matrices.torso = eye(4);
                    if(chains.leftArm == 0)
                        matrices.leftArm = preMatrixLeft(:,:,dataset.pose(j));
                    end
                    if(chains.rightArm == 0)
                        matrices.rightArm = preMatrixRight(:,:,dataset.pose(j));
                    end
                    if(chains.rightEye == 0)
                        matrices.rightEye = preMatrixRightEye(:,:,dataset.pose(j));
                    end
                    if(chains.leftEye == 0)
                        matrices.leftEye = preMatrixLeftEye(:,:,dataset.pose(j));
                    end
                    dataset.rtMat(j) = matrices; 
                end   
                dataset.rtMat = reshape(dataset.rtMat, length(dataset.pose),1);

                %% dataset2 is a part of dataset where poses are unique
                C = cell(size(index_pose, 1) ,1);
                C(:) = {'EE1'}; % right end effector
                dataset2.frame = C;
                C(:) = {'EE2'}; % left end effector
                dataset2.frame2 = C;
                dataset2.joints = dataset.joints(index_pose);
                dataset2.pose = dataset.pose(index_pose);
                dataset2.refPoints = [];
                dataset2.point = zeros(size(index_pose, 1),6);
                dataset2.refDist = 0.116; 
                dataset2.rtMat = dataset.rtMat(index_pose);    
                % index must be same for touch and projections datasets
                % because of splitting into training and testing parts
                index = index+1;
                dataset.id = index; 
                dataset.name =['Proj ', num2str(index)];
                dataset2.id = index;
                if(k == 1)
                    dataset2.name = ['Dist ', num2str(index)];
                    datasets_selftouch{1} = dataset2;
                else
                    dataset2.name = ['Plane ', num2str(index)];
                    datasets_planes{end+1} = dataset2;
                end
                datasets_projection{index} = dataset;                   
            end
        end        
    end
    
    indexes = {1:length(datasets_selftouch), (1:length(datasets_planes))+length(datasets_selftouch),...
        1:length(datasets_leica), (1:length(datasets_projection))+sum(used_datasets)};
    datasets = [datasets_selftouch, datasets_planes, datasets_leica, datasets_projection];
end
