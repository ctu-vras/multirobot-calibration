function [training_set_indexes, testing_set_indexes, datasets]=prepareDataset(r,optim, funcname, varargin)
    %% functions call
    if nargin>3
        func=str2func(funcname);
        datasets=func((varargin{1}));
    else
        func=str2func(funcname);
        datasets=func();
    end
    
    %% Assing joint to names and split
    for dataset=1:length(datasets)
        clear joints
        joints(length(datasets{dataset}.frame),1) = joint();
        for name=1:length(datasets{dataset}.frame)
            j=findJoint(r,datasets{dataset}.frame{name});
            joints(name)=j{1};
        end
        datasets{dataset}.frame=joints;
    end
    
    %% split dataset
    training_set_indexes = cell(1,length(datasets));
    testing_set_indexes = cell(1,length(datasets));
    for j = 1:length(datasets)
        dataset = datasets{j};
        if(isempty(dataset.joints))
            continue
        end
        
        % division of the dataset into training and testing set
        pose_nums = dataset.group;
        % find lines with new poses
        [new_poses, ~, ~] = unique(pose_nums);

        splitting_point = floor(size(new_poses, 1)*0.7);
        training_set_indexes_dataset = {};
        testing_set_indexes_dataset = {};
        for i = 1:optim.repetitions
            % randomly reorder poses
            random_order_poses = new_poses(randperm(size(new_poses, 1))); 
            % pick training set
            training_poses = random_order_poses(1:splitting_point);
            % pick testing set
            testing_poses = random_order_poses((splitting_point + 1):end);
            % find where pose numbers equal
            training_set_indexes_dataset{i} = find(ismember(pose_nums', training_poses));
            testing_set_indexes_dataset{i} = find(ismember(pose_nums', testing_poses));
        end
        training_set_indexes{j} = training_set_indexes_dataset;
        testing_set_indexes{j} = testing_set_indexes_dataset;
    end

end

