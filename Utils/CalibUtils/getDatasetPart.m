function [ dataset ] = getDatasetPart(dataset, indexes)
%GETDATASETPART Slice a dataset depends on the given pose numbers .
%INPUT - dataset - dataset structure to slice
%      - indexes - cell array of pose numbers for each dataset id
%OUTPUT - dataset - sliced dataset structure
    dataset_names = {'selftouch', 'planes', 'external', 'projection'};
    for name=dataset_names
        name = name{1};
        for i = 1:length(dataset.(name))
            % choose dataset lines with the selected pose numbers
            chosen_lines = ismember(dataset.(name){i}.pose, indexes{dataset.(name){i}.id});
            %% split dataset field by field
            dataset.(name){i}.point = dataset.(name){i}.point(chosen_lines,:);
            dataset.(name){i}.pose = dataset.(name){i}.pose(chosen_lines,:);
            dataset.(name){i}.frame = dataset.(name){i}.frame(chosen_lines,:);
            dataset.(name){i}.joints = dataset.(name){i}.joints(chosen_lines,:);
            if(isfield(dataset.(name){i}, 'frame2') && ~isempty(dataset.(name){i}.frame2))
                dataset.(name){i}.frame2 = dataset.(name){i}.frame2(chosen_lines,:);
            end
            if(isfield(dataset.(name){i}, 'refPoints') && ~isempty(dataset.(name){i}.refPoints))
                dataset.(name){i}.refPoints = dataset.(name){i}.refPoints(chosen_lines,:);
            end
            if(isfield(dataset.(name){i}, 'rtMat') && ~isempty(dataset.(name){i}.rtMat))
                dataset.(name){i}.rtMat = dataset.(name){i}.rtMat(chosen_lines,:);
            end
            if(isfield(dataset.(name){i}, 'cameras') && ~isempty(dataset.(name){i}.cameras))
                dataset.(name){i}.cameras = dataset.(name){i}.cameras(chosen_lines,:);
            end            
        end 
    end
end

