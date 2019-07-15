function [ dist ] = getDist(dh_pars, robot, datasets, optim)
%GETDIST Summary of this function goes here
%   Detailed explanation goes here
    index = 0;
    dist = [];
    H0 = robot.structure.H0;
    for dataset=datasets
        index = index + 1;
        dataset = dataset{1};
        frames = dataset.frame;
        frames2 = dataset.frame2;
        empty = isempty(dataset.rtMat);
        joints = dataset.joints;
        if optim.useNorm
            distances = zeros(1, size(joints, 1));
        else
            distances = zeros(3, size(joints, 1));
        end
        points = dataset.point;
        refPoints = dataset.refPoints;
        
        for i = 1:size(joints, 1)      
            if(empty)
                rtMat = [];
            else
                rtMat = dataset.rtMat(i);
            end
            arm1 =  getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)...
                *[points(i,1:3),1]';
            if ~optim.refPoints || (isempty(dataset.refPoints))
               arm2 =  getTF(dh_pars,frames2(i),rtMat, empty, joints(i), H0)...
                   *[points(i,4:6),1]';
            elseif optim.refPoints
               arm2 = refPoints(i,:)';
            end
            if optim.useNorm
                distances(i) = sqrt(sum((arm1(1:3)-arm2(1:3)).^2,1));
            else
                distances(:,i) = arm1(1:3)-arm2(1:3);
            end
        end
    dist = [dist, distances];
    end
end

