function [ dataset ] = getDatasetPart(dataset, indexes)
%GETDATASET Summary of this function goes here
%   Detailed explanation goes here
    dataset_names = {'dist', 'plane', 'ext', 'proj'};
    for name=dataset_names
        name = name{1};
        for i = 1:length(dataset.(name))
            chosen_lines = ismember(dataset.(name){i}.pose, indexes{dataset.(name){i}.id});
           
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

