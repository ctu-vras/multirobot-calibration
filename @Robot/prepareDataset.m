function [training_set_indexes, testing_set_indexes, datasetsStruct]=prepareDataset(r,optim, chains, funcname, varargin)
    % PREPAREDATASET returns datasets in universal format, together with
    %                training/testing indexes
    %   INPUT - optim - structure of calibration settings
    %         - chains - structure of chain settings
    %         - funcname - name of the robot-specific function
    %         - varargin - agrument which will be passed to the
    %                      robot-specific function
    %   OUTPUT - training_set_indexes - 1xN cellarrays with Mx1 array of
    %                                   indexes; N = number of repetitions
    %          - testing_set_indexes - 1xN cellarrays with Mx1 array of
    %                                  indexes
    %                                  M = optim.splitPoints*dataset length
    %          - datasetsStruct - structure with 4 fields, which are 1xN
    %                             cellarrays
    
    %% Call appropriate functions with arguments 
    if nargin>4
        func=str2func(funcname);
        [datasets, indexes]=func(r,optim, chains, varargin{:});
    else
        func=str2func(funcname);
        [datasets, indexes]=func(r,optim, chains);
    end
    
    %% Assing joint to names and split
    for dataset=1:length(datasets)
        clear joints; 
        uniqueFrames = unique(datasets{dataset}.frame); % unique (end effector) joint names
        camFrames = r.findJointByType('eye');
        if(~isempty(camFrames)) % append eye end effector joint names
            camFrames = [camFrames{:}];
            uniqueFrames = [uniqueFrames; {camFrames.name}'];
        end
        
        % Preallocate arrays
        joints(length(datasets{dataset}.frame), 1) = Joint();
        for name=1:length(datasets{dataset}.frame)
            % find joint by name
            j=findJoint(r,datasets{dataset}.frame{name});
            joints(name)=j{1};
        end
        datasets{dataset}.frame=joints;
        
        if isfield(datasets{dataset},'frame2')
            uniqueFrames = [uniqueFrames; unique(datasets{dataset}.frame2)];
            clear joints2;
            joints2(length(datasets{dataset}.frame2), 1) = Joint();
            for name=1:length(datasets{dataset}.frame2)
                j2=findJoint(r,datasets{dataset}.frame2{name});
                joints2(name)=j2{1};
            end
            datasets{dataset}.frame2=joints2;       
        end
        
        % iterate over joint names
        for name=1:length(uniqueFrames)
            joint = r.findJoint(uniqueFrames{name});
            joint = joint{1};
            gr = joint.group;
            idx = [];
            id=1;
            while isobject(joint) 
                while strcmp(joint.group,gr) && ~strcmp(joint.type,types.base) % save indexes into DH table for all joints of the group
                   idx(id)=joint.DHindex;
                   id=id+1;
                   joint=joint.parent;
                end
                datasets{dataset}.DHindexes.(uniqueFrames{name}).(gr) = idx(end:-1:1);
                datasets{dataset}.parents.(gr) = joint; % joint.group differs from gr
                gr = joint.group;
                idx = joint.DHindex; 
                id=2;
                joint=joint.parent; 
            end
        end
    
        % Default refDist=0
        if ~isfield(datasets{dataset},'refDist')
            datasets{dataset}.refDist=0;
        end
        % Default id=index of dataset in datasets
        if ~isfield(datasets{dataset},'id')
            datasets{dataset}.id = dataset;
        end       
    end
    
    %% split dataset
    training_set_indexes = cell(1,optim.repetitions);
    testing_set_indexes = cell(1,optim.repetitions);
    
    for i = 1:optim.repetitions
        training_set_indexes_dataset = cell(1,length(datasets));
        testing_set_indexes_dataset = cell(1,length(datasets));
            
        for j = 1:length(datasets)
            dataset = datasets{j};
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
            training_set_indexes_dataset{j} = random_order_poses(1:splitting_point);
            % pick testing set
            testing_set_indexes_dataset{j} = random_order_poses((splitting_point + 1):end);           
        end
        training_set_indexes{i} = training_set_indexes_dataset;
        testing_set_indexes{i} = testing_set_indexes_dataset;
    end

    % Assigning datasets to the right groups
    datasetsStruct.dist=datasets(indexes{1});
    datasetsStruct.plane=datasets(indexes{2});
    datasetsStruct.ext=datasets(indexes{3});
    datasetsStruct.proj=datasets(indexes{4});
    
end

