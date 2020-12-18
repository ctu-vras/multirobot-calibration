function [ dataset ] = getDatasetPart(dataset, indexes)
    %GETDATASETPART Slice a dataset depends on the given pose numbers .
    %INPUT - dataset - dataset structure to slice
    %      - indexes - cell array of pose numbers for each dataset id
    %OUTPUT - dataset - sliced dataset structure
    
    
    % Copyright (C) 2019-2021  Jakub Rozlivek and Lukas Rustler
    % Department of Cybernetics, Faculty of Electrical Engineering, 
    % Czech Technical University in Prague
    %
    % This file is part of Multisensorial robot calibration toolbox (MRC).
    % 
    % MRC is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Lesser General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % MRC is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Lesser General Public License for more details.
    % 
    % You should have received a copy of the GNU Leser General Public License
    % along with MRC.  If not, see <http://www.gnu.org/licenses/>.
    
    
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

