function [ dist ] = getDist( dh_pars, robot, datasets, optim)
%GETDIST Summary of this function goes here
%   Detailed explanation goes here
    index = 0;
    distances = cell(1,length(datasets));
    for dataset=datasets
        index = index + 1;
        dataset = dataset{1};
        [unique_pose_nums, index_pose, ~] = unique(dataset.group);
        if(optim.multi_pose)
            distances{index} = zeros(1, size(unique_pose_nums, 1));
        else
            distances{index} = [];
        end
        for i = 1:1 %size(unique_pose_nums, 1)
            [RTarm1,par] = dataset.frame(index_pose(i)).computeRTMatrix(dh_pars, robot.structure.H0, dataset.joints(index_pose(i)), dataset.frame(index_pose(i)).group);
            RTarm2 = dataset.frame2(index_pose(i)).computeRTMatrix(dh_pars, robot.structure.H0, dataset.joints(index_pose(i)), dataset.frame(index_pose(i)).group);
%             RTarm1
%             dhpars2tfmat(robot.structure.DH.leftArm')
%             dhpars2tfmat(robot.structure.DH.leftArm(1,:)')*RTarm1
            if(optim.multi_pose)
                arm1 =  RTarm1*[dataset.point(index_pose(i),1:3),1]';
                if(isempty(dataset.refPoints))
                   arm2 =  RTarm2*[dataset.point(index_pose(i),4:6),1]';
                else
                   arm2 = dataset.refPoints(index_pose(i),:)';
                end
                distances{index}(i) = sqrt(sum((arm1(1:3)-arm2(1:3)).^2,1));
            else
                arm1 = RTarm1*[dataset.point(dataset.group==unique_pose_nums(i),1:3), ones(length(dataset.group(dataset.group==unique_pose_nums(i))),1)]';
                if(isempty(dataset.refPoints))
                    arm2 = RTarm2*[dataset.point(dataset.group==unique_pose_nums(i),4:6), ones(length(dataset.group(dataset.group==unique_pose_nums(i))),1)]';
                else
                   arm2 = dataset.refPoints(dataset.group==unique_pose_nums(i),:)'; 
                end
                distances{index} = [distances{index}, sqrt(sum((arm1(1:3,:)-arm2(1:3,:)).^2,1))];
            end
            
        end
    end
    dist = distances{:};
end

