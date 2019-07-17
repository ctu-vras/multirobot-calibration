function [ dist ] = getDist(dh_pars, robot, datasets, optim)
%GETDIST Summary of this function goes here
%   Detailed explanation goes here
    dist = [];
    H0 = robot.structure.H0;
    for dataset=datasets
        dataset = dataset{1};
        refPoints = dataset.refPoints;
        computeArm2 = ~optim.refPoints || (isempty(refPoints));
        [arm1,arm2] = getPoints(dh_pars, dataset, H0, computeArm2);
        
        if(~computeArm2) 
            arm2 = refPoints';
        end
        if optim.useNorm
            distances = sqrt(sum((arm1(1:3,:)-arm2(1:3,:)).^2,1));
        else
            distances = arm1(1:3,:)-arm2(1:3,:);
        end       
    dist = [dist, distances];
    end
end
