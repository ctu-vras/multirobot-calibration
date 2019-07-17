function [ arm1, arm2 ] = getPoints(dh_pars, dataset, H0, compute_arm2)
%GETPOINTS Summary of this function goes here
%   Detailed explanation goes here
    frames = dataset.frame;
    
    empty = isempty(dataset.rtMat);
    joints = dataset.joints;
    points = dataset.point;
    arm1 = zeros(4, size(joints, 1));
    if(compute_arm2) 
        arm2 = zeros(4, size(joints, 1)); 
        frames2 = dataset.frame2;
    else
        arm2 = [];
    end
    for i = 1:size(joints, 1)      
        if(empty)
            rtMat = [];
        else
            rtMat = dataset.rtMat(i);
        end
        arm1(:,i) =  getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)...
            *[points(i,1:3),1]';
        if compute_arm2
           arm2(:,i) =  getTF(dh_pars,frames2(i),rtMat, empty, joints(i), H0)...
               *[points(i,4:6),1]';
        end
    end

end

