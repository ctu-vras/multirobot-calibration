function [ dist ] = getDist( dh_pars, robot, datasets, optim)
%GETDIST Summary of this function goes here
%   Detailed explanation goes here
    index = 0;
    distances = cell(1,length(datasets));
    for dataset=datasets
        index = index + 1;
        dataset = dataset{1};
        [unique_pose_nums, index_pose, ~] = unique(dataset.pose);
        if(optim.multi_pose)
            distances{index} = zeros(1, size(unique_pose_nums, 1));
        else
            distances{index} = [];
        end
        empty = isempty(dataset.rtMat);
        for i = 1:size(unique_pose_nums, 1)      
            if(empty)
                rtMat = [];
            else
                rtMat = dataset.rtMat(index_pose(i));
            end
            if(optim.multi_pose)
                arm1 =  getTF(dh_pars,dataset.frame(index_pose(i)),rtMat, empty, dataset.joints(index_pose(i)), robot.structure.H0)...
                    *[dataset.point(index_pose(i),1:3),1]';
                if(isempty(dataset.refPoints))
                   arm2 =  getTF(dh_pars,dataset.frame2(index_pose(i)),rtMat, empty, dataset.joints(index_pose(i)), robot.structure.H0)...
                       *[dataset.point(index_pose(i),4:6),1]';
                else
                   arm2 = dataset.refPoints(index_pose(i),:)';
                end
                distances{index}(i) = sqrt(sum((arm1(1:3)-arm2(1:3)).^2,1));
            else
                arm1 = getTF(dh_pars,dataset.frame(index_pose(i)),rtMat, empty, dataset.joints(index_pose(i)), robot.structure.H0)...
                    *[dataset.point(dataset.pose==unique_pose_nums(i),1:3), ones(length(dataset.pose(dataset.pose==unique_pose_nums(i))),1)]';
                if(isempty(dataset.refPoints))
                    arm2 = getTF(dh_pars,dataset.frame2(index_pose(i)),rtMat, empty, dataset.joints(index_pose(i)), robot.structure.H0)...
                    *[dataset.point(dataset.pose==unique_pose_nums(i),4:6), ones(length(dataset.pose(dataset.pose==unique_pose_nums(i))),1)]';
                else
                   arm2 = dataset.refPoints(dataset.pose==unique_pose_nums(i),:)'; 
                end
                distances{index} = [distances{index}, sqrt(sum((arm1(1:3,:)-arm2(1:3,:)).^2,1))];
            end
            
        end
    end
    dist = distances{:};
end

