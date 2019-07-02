function [ dataset ] = getDatasetPart(dataset, indexes)
%GETDATASET Summary of this function goes here
%   Detailed explanation goes here
    dataset_names = {'dist', 'plane', 'ext', 'markers'};
    for name=dataset_names
        name = name{1};
        for i = 1:length(dataset.(name))
            dataset.(name){i}.point = dataset.(name){i}.point(indexes{dataset.(name){i}.id},:);
            dataset.(name){i}.pose = dataset.(name){i}.pose(indexes{dataset.(name){i}.id},:);
            dataset.(name){i}.frame = dataset.(name){i}.frame(indexes{dataset.(name){i}.id},:);
            dataset.(name){i}.frame2 = dataset.(name){i}.frame2(indexes{dataset.(name){i}.id},:);
            dataset.(name){i}.joints = dataset.(name){i}.joints(indexes{dataset.(name){i}.id},:);
            if(isfield(dataset.(name){i}, 'extCoords') && ~isempty(dataset.(name){i}.extCoords))
                dataset.(name){i}.extCoords = dataset.(name){i}.extCoords(indexes{dataset.(name){i}.id},:);
            end
            if(isfield(dataset.(name){i}, 'refPoints') && ~isempty(dataset.(name){i}.refPoints))
                dataset.(name){i}.refPoints = dataset.(name){i}.refPoints(indexes{dataset.(name){i}.id},:);
            end
            if(isfield(dataset.(name){i}, 'rtMat') && ~isempty(dataset.(name){i}.rtMat))
                dataset.(name){i}.rtMat = dataset.(name){i}.rtMat(indexes{dataset.(name){i}.id},:);
            end
            if(isfield(dataset.(name){i}, 'cameras') && ~isempty(dataset.(name){i}.cameras))
                dataset.(name){i}.cameras = dataset.(name){i}.cameras(indexes{dataset.(name){i}.id},:);
            end
            if(isfield(dataset.(name){i}, 'pixels') && ~isempty(dataset.(name){i}.pixels))
                dataset.(name){i}.pixels = dataset.(name){i}.pixels(indexes{dataset.(name){i}.id},:);
            end
        end 
    end
end

