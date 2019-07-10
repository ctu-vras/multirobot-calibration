function [training_set_indexes, testing_set_indexes, datasetsStruct]=prepareDataset(r,optim, funcname, varargin)
    %% functions call
    if nargin>3
        func=str2func(funcname);
        [datasets, indexes]=func((varargin{:}));
    else
        func=str2func(funcname);
        [datasets, indexes]=func();
    end
    
    %% Assing joint to names and split
    for dataset=1:length(datasets)
        clear joints; 
        joints(length(datasets{dataset}.frame), 1) = joint();
        for name=1:length(datasets{dataset}.frame)
            j=findJoint(r,datasets{dataset}.frame{name});
            joints(name)=j{1};
        end
        datasets{dataset}.frame=joints;
        
        if isfield(datasets{dataset},'frame2')
            clear joints2;
            joints2(length(datasets{dataset}.frame2), 1) = joint();
            for name=1:length(datasets{dataset}.frame2)
                j2=findJoint(r,datasets{dataset}.frame2{name});
                joints2(name)=j2{1};
            end
            datasets{dataset}.frame2=joints2;
        
        end
        if ~isfield(datasets{dataset},'refDist')
            datasets{dataset}.refDist=0;
        end
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

    datasetsStruct.dist={datasets{indexes{1}}};
    datasetsStruct.plane={datasets{indexes{2}}};
    datasetsStruct.ext={datasets{indexes{3}}};
    datasetsStruct.markers={datasets{indexes{4}}};
    
end

