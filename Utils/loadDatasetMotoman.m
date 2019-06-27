function [ datasets ] = loadDatasetMotoman( varargin )
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
    datasets = cell(4,1);
    indexes = {1:4, [5:6,9:10], [7:8, 11:12], 13:20};
    for k = 1:4
        dataset.point = [];
        dataset.group = [];
        dataset.frame = {};
        dataset.joints = [];
        dataset.extcoords = [];
        dataset.cameras = [];
        dataset.pixels = [];
        if(used_datasets(k))      
            for i=indexes{k}
                f = strsplit(source_files{i}, '.');
                path = sprintf('dataset/leica_dataset/%s_dataset.mat', f{1});
                data2 = load(path);
                data2 = data2.dataset;
                data2(:,1) = data2(:,1) + i*1000;
                dataset.point = [dataset.point; zeros(size(data2,1),3)];
                dataset.group = [dataset.group; data2(:,1)];
                dataset.frame = [dataset.frame;cellstr(strcat('EE',num2str(data2(:,3))))];
                dataset.joints = [dataset.joints; data2(:, 7:19)];
                dataset.extcoords = [dataset.extcoords; data2(:,20:22)];
                dataset.cameras = [dataset.cameras; data2(:,4)];
                dataset.pixels = [dataset.pixels; data2(:,5:6)];
            end      
        end
        datasets{k} = dataset;
    end
end
