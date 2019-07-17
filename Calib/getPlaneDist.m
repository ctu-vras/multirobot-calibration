function [ dist ] = getPlaneDist( dh_pars, robot, datasets, optim )
%GETPLANEDIST Summary of this function goes here
%   Detailed explanation goes here
    dist = [];
    H0 = robot.structure.H0;
    for dataset=datasets
        dataset = dataset{1};
        frames = dataset.frame;
        empty = isempty(dataset.rtMat);
        joints = dataset.joints;
        points = dataset.point;       
        robPoints=zeros(4,size(joints, 1));
        for i = 1:size(joints, 1)      
            if(empty)
                rtMat = [];
            else
                rtMat = dataset.rtMat(i);
            end
            robPoints(:,i) =  getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)...
                *[points(i,1:3),1]';
        end
        plane = getPlane(robPoints);
        dist = [dist, plane*robPoints];
    end
end

