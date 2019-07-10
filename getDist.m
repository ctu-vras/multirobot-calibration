function [ dist ] = getDist( dh_pars, robot, datasets, optim)
%GETDIST Summary of this function goes here
%   Detailed explanation goes here
    index = 0;
    distances = cell(1,length(datasets));
    H0 = robot.structure.H0;
    for dataset=datasets
        index = index + 1;
        dataset = dataset{1};
        [unique_pose_nums, index_pose, ~] = unique(dataset.pose);
        if(optim.multi_pose)
            distances{index} = zeros(1, size(unique_pose_nums, 1));
        else
            distances{index} = [];
        end
        frames = dataset.frame(index_pose);
        frames2 = dataset.frame2(index_pose);
        empty = isempty(dataset.rtMat);
        joints = dataset.joints(index_pose);
        points = dataset.point;
        refPoints = dataset.refPoints;
        poses = dataset.pose;

        for i = 1:size(unique_pose_nums, 1)      
            if(empty)
                rtMat = [];
            else
                rtMat = dataset.rtMat(index_pose(i));
            end
            if(optim.multi_pose)  %TODO: neni to zbytecny? pripadne bych jenom prepsal dataset motomana
                arm1 =  getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)...
                    *[points(index_pose(i),1:3),1]';
                if(isempty(dataset.refPoints))
                   arm2 =  getTF(dh_pars,frames2(i),rtMat, empty, joints(i), H0)...
                       *[points(index_pose(i),4:6),1]';
                else
                   arm2 = refPoints(index_pose(i),:)';
                end
%                 getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)
% %                 points(index_pose(i),1:3)
% %                 points(index_pose(i),4:6)
% %                 refPoints(index_pose(i),:)'
% %                 asd
                distances{index}(i) = sqrt(sum((arm1(1:3)-arm2(1:3)).^2,1));
                %distances{index}(i)=norm(arm1(1:3)-arm2(1:3),2);
            else
                arm1 = getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)...
                    *[points(poses==unique_pose_nums(i),1:3), ones(length(poses(poses==unique_pose_nums(i))),1)]';
                if(isempty(dataset.refPoints))
                    arm2 = getTF(dh_pars,frames2(i),rtMat, empty, joints(i), H0)...
                    *[points(poses==unique_pose_nums(i),4:6), ones(length(poses(poses==unique_pose_nums(i))),1)]';
                else
                   arm2 = refPoints(poses==unique_pose_nums(i),:)'; 
                end
                distances{index} = [distances{index}, sqrt(sum((arm1(1:3,:)-arm2(1:3,:)).^2,1))];
            end       
        end
    end
    dist = distances{:};
end

