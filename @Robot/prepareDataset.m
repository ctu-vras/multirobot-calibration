function [training_set_indexes, testing_set_indexes, datasets, datasets_out]=prepareDataset(r,optim, chains, approaches, funcname, varargin)
    % PREPAREDATASET returns datasets in universal format, together with
    %                training/testing indexes
    %   INPUT - optim - structure of calibration settings
    %         - chains - structure of chain settings
    %         - approaches - calibration approaches
    %         - funcname - name of the robot-specific function or mat-file
    %         with the datasets (and indexes)
    %         - varargin - agrument which will be passed to the
    %                      robot-specific function
    %   OUTPUT - training_set_indexes - 1xN cellarrays with Mx1 array of
    %                                   indexes; N = number of repetitions
    %          - testing_set_indexes - 1xN cellarrays with Mx1 array of
    %                                  indexes
    %                                  M = optim.splitPoints*dataset length
    %          - datasets - structure with 4 fields, which are 1xN
    %                             cellarrays
    %          - datasets_out - structure with 4 fields, which are 1xN
    %                             cellarrays
    %                         - links are kept as stings and not instances
    %                         of a class
    
    
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
    %% Call appropriate functions with arguments
    if isstruct(funcname)
        datasets = funcname;
    elseif(contains(funcname, '.mat'))
        file = load(funcname);
        assert(isfield(file, 'datasets'));
        datasets = file.datasets;
    else
        if nargin>4
            func=str2func(funcname);
            datasets=func(r,optim, chains, varargin{:});
        else
            func=str2func(funcname);
            datasets=func(r,optim, chains);
        end
    end
    datasets_out = datasets;

    for appr=fieldnames(approaches)'
       assert(~((~isfield(datasets, appr{1}) || isempty(datasets.(appr{1}))) && approaches.(appr{1})), ['Dataset for ', appr{1}, ' is emtpy!'])
       if approaches.(appr{1}) && isfield(datasets, appr{1})
          for i=1:length(datasets.(appr{1}))
              assert(~isempty(datasets.(appr{1}){i}.point), ['Dataset for ', appr{1}, ' is emtpy!'])
          end
       end
       
    end
    %% Assing link to names and split
    index = 0;
        % Assigning datasets to the right groups
    for part={'selftouch', 'planes', 'external', 'projection'}
        part = part{1};
        if isfield(datasets, part)
            for dataset=1:length(datasets.(part))
                index = index + 1;
                clear links; 
                uniqueFrames = unique(datasets.(part){dataset}.frame); % unique (end effector) link names
                camFrames = r.findLinkByType('eye');
                if(~isempty(camFrames)) % append eye end effector link names
                    camFrames = [camFrames{:}];
                    uniqueFrames = [uniqueFrames; {camFrames.name}'];
                end
                if isfield(datasets.(part){dataset}, 'rtMat') && isstruct(datasets.(part){dataset}.rtMat)
                    rtFields = fieldnames(datasets.(part){dataset}.rtMat)';
                else
                    rtFields = {};
                    datasets.(part){dataset}.rtMat = [];
                end
                % Preallocate arrays
                links(length(datasets.(part){dataset}.frame), 1) = Link();
                for name=1:length(datasets.(part){dataset}.frame)
                    % find link by name
                    j=findLink(r,datasets.(part){dataset}.frame{name});
                    links(name)=j{1};
                    for field = rtFields
                        datasets.(part){dataset}.rtMat(name).(field{1})(1:3,4) = datasets.(part){dataset}.rtMat(name).(field{1})(1:3,4) * optim.unitsCoef;
                    end
                end
                datasets.(part){dataset}.frame=links;

                if strcmp(part, 'projection')
                   datasets.(part){dataset}.refPoints = datasets.(part){dataset}.refPoints * optim.unitsCoef;
                end

                if strcmp(part, 'selftouch') && isfield(datasets.(part){dataset},'frame2')
                    uniqueFrames = [uniqueFrames; unique(datasets.(part){dataset}.frame2)];
                    clear links2;
                    links2(length(datasets.(part){dataset}.frame2), 1) = Link();
                    for name=1:length(datasets.(part){dataset}.frame2)
                        j2=findLink(r,datasets.(part){dataset}.frame2{name});
                        links2(name)=j2{1};
                    end
                    datasets.(part){dataset}.frame2=links2;       
                end

                % iterate over link names
                for name=1:length(uniqueFrames)
                    link = r.findLink(uniqueFrames{name});
                    link = link{1};
                    datasets.(part){dataset}=getIndexes(datasets.(part){dataset},link);
                end

                % Default refDist=0
                if ~isfield(datasets.(part){dataset},'refDist')
                    datasets.(part){dataset}.refDist=0;
                end
                % Default id=index of dataset in datasets
                if ~isfield(datasets.(part){dataset},'id')
                    datasets.(part){dataset}.id = index;
                end       
            end
        else
            datasets.(part) = {};
        end
    end
    
    %% split dataset
    training_set_indexes = cell(1,optim.repetitions);
    testing_set_indexes = cell(1,optim.repetitions);
    
    for i = 1:optim.repetitions
        training_set_indexes_dataset = cell(1,length(datasets));
        testing_set_indexes_dataset = cell(1,length(datasets));
        index = 0;
        for part = {'selftouch', 'planes', 'external', 'projection'}
            part = part{1};
            for j = 1:length(datasets.(part))
                index = index+1;
                dataset = datasets.(part){j};
                if(isempty(dataset.joints))
                    continue
                end

                % division of the dataset into training and testing set
                pose_nums = dataset.pose;
                % find lines with new poses
                [new_poses, ~, ~] = unique(pose_nums);

                splitting_point = floor(size(new_poses, 1)*optim.splitPoint);
                % randomly reorder poses
                random_order_poses = new_poses(randperm(size(new_poses, 1))); 
                % pick training set
                training_set_indexes_dataset{index} = random_order_poses(1:splitting_point);
                % pick testing set
                testing_set_indexes_dataset{index} = random_order_poses((splitting_point + 1):end);           
            end
        end
        training_set_indexes{i} = training_set_indexes_dataset;
        testing_set_indexes{i} = testing_set_indexes_dataset;
    end   
end

