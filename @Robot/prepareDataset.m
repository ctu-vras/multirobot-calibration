function [training_set_indexes, testing_set_indexes, datasets, datasets_out]=prepareDataset(r,optim, chains, funcname, varargin)
    % PREPAREDATASET returns datasets in universal format, together with
    %                training/testing indexes
    %   INPUT - optim - structure of calibration settings
    %         - chains - structure of chain settings
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
    %                         - joints are kept as stings and not instances
    %                         of a class
    
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
    
    %% Assing joint to names and split
    index = 0;
        % Assigning datasets to the right groups
    for part={'selftouch', 'planes', 'external', 'projection'}
        part = part{1};
        if isfield(datasets, part)
            for dataset=1:length(datasets.(part))
                index = index + 1;
                clear joints; 
                uniqueFrames = unique(datasets.(part){dataset}.frame); % unique (end effector) joint names
                camFrames = r.findJointByType('eye');
                if(~isempty(camFrames)) % append eye end effector joint names
                    camFrames = [camFrames{:}];
                    uniqueFrames = [uniqueFrames; {camFrames.name}'];
                end
                %part
                %dataset
                %datasets.(part){dataset}.rtMat
                rtFields = fieldnames(datasets.(part){dataset}.rtMat)';
                % Preallocate arrays
                joints(length(datasets.(part){dataset}.frame), 1) = Joint();
                for name=1:length(datasets.(part){dataset}.frame)
                    % find joint by name
                    j=findJoint(r,datasets.(part){dataset}.frame{name});
                    joints(name)=j{1};
                    for field = rtFields
                        datasets.(part){dataset}.rtMat(name).(field{1})(1:3,4) = datasets.(part){dataset}.rtMat(name).(field{1})(1:3,4) * optim.unitsCoef;
                    end
                end
                datasets.(part){dataset}.frame=joints;

                if strcmp(part, 'projection')
                   datasets.(part){dataset}.refPoints = datasets.(part){dataset}.refPoints * optim.unitsCoef;
                end

                if isfield(datasets.(part){dataset},'frame2')
                    uniqueFrames = [uniqueFrames; unique(datasets.(part){dataset}.frame2)];
                    clear joints2;
                    joints2(length(datasets.(part){dataset}.frame2), 1) = Joint();
                    for name=1:length(datasets.(part){dataset}.frame2)
                        j2=findJoint(r,datasets.(part){dataset}.frame2{name});
                        joints2(name)=j2{1};
                    end
                    datasets.(part){dataset}.frame2=joints2;       
                end

                % iterate over joint names
                for name=1:length(uniqueFrames)
                    joint = r.findJoint(uniqueFrames{name});
                    joint = joint{1};
                    datasets.(part){dataset}=getIndexes(datasets.(part){dataset},joint);
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

%     % Assigning datasets to the right groups
%     datasetsStruct.selftouch=datasets{1};
%     datasetsStruct.planes=datasets{2};
%     datasetsStruct.external=datasets{3};
%     datasetsStruct.projection=datasets{4};
    
end

