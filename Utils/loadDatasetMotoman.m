function [ datasets, indexes ] = loadDatasetMotoman( varargin )
%LOADDATASETMOTOMAN Summary of this function goes here
%   Detailed explanation goes here

if(nargin == 1)
    used_datasets = varargin{1};
else
    used_datasets = [1,1,1,1];
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
        'no_leica_self_lower1_4x4.csv', 'no_leica_self_lower2_4x4.csv', ...     
        'leica_right_hand_6x6x6.csv', 'leica_left_hand_6x6x6.csv'};
    dataset_count = sum(used_datasets);
    datasets = cell(dataset_count*2,1);
    indexes = {1:4, [5:6,9:10], [7:8, 11:12], 13:20};
    index = 0; 
    for k = 1:4
        dataset2.point = [];
        dataset2.pose = [];
        dataset2.frame = {};
        dataset2.joints = [];
        dataset2.extCoords = [];
        dataset2.refPoints = [];
        dataset2.rtMat = [];
        dataset2.cameras = [];
        if(used_datasets(k))      
            for i=indexes{k}
                f = strsplit(source_files{i}, '.');
                path = sprintf('dataset/leica_dataset/%s_dataset.mat', f{1});
                data2 = load(path);
                data2 = data2.dataset;
                data2(:,1) = data2(:,1) + i*1000;              
                dataset2.pose = [dataset2.pose; data2(:,1)];
                dataset2.frame = [dataset2.frame;cellstr(strcat('MK',num2str(data2(:,3)),num2str(data2(:,2),'%02d')))];
                dataset2.refPoints = [dataset2.refPoints; data2(:,5:6)];
                dataset2.cameras = [dataset2.cameras; data2(:,4)];
                dataset2.joints = [dataset2.joints; ...
                    struct('rightArm',num2cell([data2(:, [7:13]),zeros(size(data2,1),1)],2),...
                'leftArm',num2cell([data2(:, [7,14:19]),zeros(size(data2,1),1)],2), ...,
                'leftEye', num2cell([data2(:, 7),zeros(size(data2,1),1)],2), ...
                'rightEye', num2cell([data2(:, 7),zeros(size(data2,1),1)],2))];
                dataset2.extCoords = [dataset2.extCoords; data2(:,20:22)];
                dataset2.point = [dataset2.point; zeros(size(data2,1),6)];
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
            dataset.extCoords = dataset2.extCoords(index_pose, :);
            dataset.rtMat = [];         
            dataset.refDist = 0.116; 
            index = index + 1;
            dataset.id = index;
            dataset2.id = index;
            datasets{index} = dataset; 
            datasets{index+dataset_count} = dataset2;
        end
    end
    indexes = {index, 1:index-1 ,1:index, index+1:dataset_count*2};
end

