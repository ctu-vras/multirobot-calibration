function [ datasets, indexes ] = loadDatasetMotoman(rob,optim, chains, varargin )
%LOADDATASETMOTOMAN Summary of this function goes here
%   Detailed explanation goes here
    varargin = varargin{1};
    if(nargin >= 3)
        used_datasets = varargin{1};
    else
        used_datasets = [1,1,1,1];
    end
    leica = '';
    if(length(varargin) == 2)
        leica = varargin{2};
    end
    source_files = {'leica_wall_table1_5x5.csv', 'leica_wall_table2_5x5.csv', ...
        'no_leica_wall_table1_5x5.csv', 'no_leica_wall_table2_5x5.csv', ...
        'leica_higher_table1_5x5.csv',  'leica_higher_table2_5x5.csv', ...
        'leica_lower_table1_5x5.csv', 'leica_lower_table2_5x5.csv', ...
        'no_leica_higher_table1_5x5.csv',  'no_leica_higher_table2_5x5.csv', ...
        'no_leica_lower_table1_5x5.csv', 'no_leica_lower_table2_5x5.csv', ...        
        'leica_self_upper1_4x4.csv', 'leica_self_upper2_4x4.csv', ...
        'leica_self_lower1_4x4.csv',  'leica_self_lower2_4x4.csv', ...
        'no_leica_self_upper1_4x4.csv', 'no_leica_self_upper2_4x4.csv', ...
        'no_leica_self_lower1_4x4.csv', 'no_leica_self_lower2_4x4.csv'};
    dataset_count = sum(used_datasets);
    datasets = cell(1,dataset_count*2); %datasets cell array MUST BE ROW VECTOR
    indexes = {1:4, [5:6,9:10], [7:8, 11:12], 13:20};
    index = 0; 
    for k = 1:4
        dataset2.point = [];
        dataset2.pose = [];
        dataset2.frame = {};
        dataset2.joints = [];
        dataset2.refPoints = [];
        dataset2.cameras = [];
        dataset2.rtMat = [];
        
        dataset3.rtMat = [];
        dataset3.refPoints = [];
        dataset3.joints = [];
        dataset3.frame = {};
        dataset3.pose = [];
        dataset3.point = [];
        dataset3.cameras = [];
        
        if(used_datasets(k))      
            for i=indexes{k}
                f = strsplit(source_files{i}, '.');
                path = sprintf('leica_dataset/%s_dataset.mat', f{1});
                data2 = load(path);
                data3 = data2.dataset;
                [~, first_unique_index, first_indexInUnique] = unique(data3(:,[1,2,3]),'rows', 'first');
%                 [~, last_unique_index, last_indexInUnique] = unique(data3(:,[1,2,3]),'rows', 'last');
                data2 = data3(first_unique_index,:);
                data2(:,1) = data2(:,1) + i*1000;              
                dataset2.pose = [dataset2.pose; data2(:,1)];
                dataset2.frame = [dataset2.frame;cellstr(strcat('MK',num2str(data2(:,3)),num2str(data2(:,2),'%02d')))];
                dataset2.joints = [dataset2.joints; ...
                    struct('rightArm',num2cell([data2(:, [7:13]),zeros(size(data2,1),1)],2),...
                'leftArm',num2cell([data2(:, [7,14:19]),zeros(size(data2,1),1)],2), ...,
                'leftEye', num2cell([data2(:, 7),zeros(size(data2,1),1)],2), ...
                'rightEye', num2cell([data2(:, 7),zeros(size(data2,1),1)],2))];
                dataset2.point = [dataset2.point; zeros(size(data2,1),6)];
                cams = zeros(size(data2,1),2);
                refPoints = nan(size(data2,1),4);
                cam_index = 1;
%                 cams(first_unique_index,1) = 1;
%                 cams(last_unique_index,2) = 1;
%                 [inter_indexes,~,~] = intersect(first_unique_index, last_unique_index);
%                 cams(inter_indexes,3-data3(inter_indexes,4)) = 0;
                [unique_pose, index_pose, ~] = unique(data2(:,1));
                preMatrixLeft = zeros(4,4,length(unique_pose));
                preMatrixRight = zeros(4,4,length(unique_pose));
                if (chains.leftArm == 0)
                    for j = 1:length(index_pose)
                        dh=rob.structure.DH.leftArm(1:8,:);
                        dh(:,4)=dh(:,4)+dataset2.joints(index_pose(j)).leftArm';
                        preMatrixLeft(:,:,j) = dhpars2tfmat(dh);
                    end
                end
                if (chains.rightArm == 0)
                    for j = 1:length(index_pose)
                        dh=rob.structure.DH.rightArm(1:8,:);
                        dh(:,4)=dh(:,4)+dataset2.joints(index_pose(j)).rightArm';
                        preMatrixRight(:,:,j) = dhpars2tfmat(dh);
                    end
                end
                for j = 1:size(data2,1)
                matrices.markers = rob.structure.markers(:,:,data2(j,2));
                matrices.torso = eye(4);
                if(chains.leftArm == 0)
                    matrices.leftArm = preMatrixLeft(:,:,data2(j,1)-i*1000);
                end
                if(chains.rightArm == 0)
                    matrices.rightArm = preMatrixRight(:,:,data2(j,1)-i*1000);
                end
                dataset2.rtMat = [dataset2.rtMat; matrices]; 
                end
                for j = 1:(size(data3,1))
                    if(j > 1 && (first_indexInUnique(j-1) ~= first_indexInUnique(j)))
                        cam_index = cam_index + 1;
                    end
                     cams(cam_index,data3(j,4)) = 1;
                    if(data3(j,4) == 1)
                        refPoints(cam_index,1:2) = data3(j,5:6);
                    else
                        refPoints(cam_index,3:4) = data3(j,5:6);
                    end
                end
                dataset2.cameras = [dataset2.cameras;cams];
                dataset2.refPoints = [dataset2.refPoints;refPoints];
                
                 [~, index_pose, ~] = unique(data2(:,1));
                data2 = data2(index_pose,:);
                
                leicaData = data2(~isnan(data2(:,end)), :);
                dataset3.pose = [dataset3.pose; leicaData(:,1)];
                C = cell(size(leicaData,1),1);
                C(:) = {'LR1'};
                dataset3.frame = [dataset3.frame;C];
                dataset3.joints = [dataset3.joints; ...
                    struct('rightArm',num2cell([leicaData(:, [7:13]),zeros(size(leicaData,1),1)],2),...
                'leftArm',num2cell([leicaData(:, [7,14:19]),zeros(size(leicaData,1),1)],2), ...,
                'leftEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2), ...
                'rightEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2))];
                dataset3.point = [dataset3.point; zeros(size(leicaData,1),6)];
                dataset3.refPoints = [dataset3.refPoints; leicaData(:,20:22)];            
            end  
            [~, index_pose, ~] = unique(dataset2.pose);
            C = cell(size(index_pose, 1) ,1);
            C(:) = {'EE1'};
            dataset.frame = C;
            C(:) = {'EE2'};
            dataset.frame2 = C;
            dataset.joints = dataset2.joints(index_pose);
            dataset.pose = dataset2.pose(index_pose);
            dataset.refPoints = [];
            dataset.point = zeros(size(index_pose, 1),6);
            dataset.rtMat = dataset2.rtMat(index_pose);         
            dataset.refDist = 0.116; 
            index = index + 1;
            dataset.id = index;
            dataset2.id = index;
            dataset3.id = index;
            datasets{index} = dataset; 
            
            datasets{index+dataset_count} = dataset2;
            datasets{index+dataset_count*2} = dataset3;
        end  
    end
    
    
    if(strcmp(leica, 'right') && chains.rightArm)
    dataset3.rtMat = [];
    dataset3.cameras = [];
    
    data2 = load('leica_dataset/leica_right_hand_6x6x6_dataset.mat');
    data2 = data2.dataset;
    
    [~, index_pose, ~] = unique(data2(:,1));
    data2 = data2(index_pose,:);

    leicaData = data2(~isnan(data2(:,end)), :);
    dataset3.pose = leicaData(:,1);
    C = cell(size(leicaData,1),1);
    C(:) = {'LR1'};
    dataset3.frame = C;
    dataset3.joints = struct('rightArm',num2cell([leicaData(:, [7:13]),zeros(size(leicaData,1),1)],2),...
    'leftArm',num2cell([leicaData(:, [7,14:19]),zeros(size(leicaData,1),1)],2), ...,
    'leftEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2), ...
    'rightEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2));

    dataset3.point = zeros(size(leicaData,1),6);
    dataset3.refPoints = leicaData(:,20:22);
    datasets{end+1} = dataset3;
    end
    
    dataset3.rtMat = [];
    dataset3.cameras = [];
    
    
    if(strcmp(leica, 'left') && chains.leftArm)
    data2 = load('leica_dataset/leica_left_hand_6x6x6_dataset.mat');
    data2 = data2.dataset;
    
    [~, index_pose, ~] = unique(data2(:,1));
    data2 = data2(index_pose,:);

    leicaData = data2(~isnan(data2(:,end)), :);
    dataset3.pose = leicaData(:,1);
    C = cell(size(leicaData,1),1);
    C(:) = {'LR2'};
    dataset3.frame = C;
    dataset3.joints = struct('rightArm',num2cell([leicaData(:, [7:13]),zeros(size(leicaData,1),1)],2),...
    'leftArm',num2cell([leicaData(:, [7,14:19]),zeros(size(leicaData,1),1)],2), ...,
    'leftEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2), ...
    'rightEye', num2cell([leicaData(:, 7),zeros(size(leicaData,1),1)],2));

    dataset3.point = zeros(size(leicaData,1),6);
    dataset3.refPoints = leicaData(:,20:22);
    datasets{end+1} = dataset3;
    end
    
    if(index == 0)
        idx = [];
    else
        idx = index;
    end
    indexes = {idx, 1:index-1 ,dataset_count*2+1:length(datasets), index+1:dataset_count*2};
end

