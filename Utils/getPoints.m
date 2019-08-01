function [ arm1, arm2 ] = getPoints(dh_pars, dataset, H0, compute_arm2)
%GETPOINTS Compute a plane fitted to set of given points using svd.
%INPUT - points - (4,X) or (3,X) row vector of points
%OUTPUT - plane - fitted plane
    frames = dataset.frame;  
    joints = dataset.joints;
    points = dataset.point;
    arm1 = zeros(4, size(joints, 1));
    if(compute_arm2) 
        arm2 = zeros(4, size(joints, 1)); 
        frames2 = dataset.frame2;
    else
        arm2 = [];
    end 
    empty = isempty(dataset.rtMat);
    if (empty) % if no precomputed matrices -> fill up the array with []
        rtMats{size(joints,1)} = [];
    else
        rtMats = dataset.rtMat;
    end
    %% compute end effectors coordinates
    for i = 1:size(joints, 1)      
        arm1(:,i) =  getTF(dh_pars,frames(i),rtMats(i), empty, joints(i), H0)...
            *[points(i,1:3),1]';
        if compute_arm2
           arm2(:,i) =  getTF(dh_pars,frames2(i),rtMats(i), empty, joints(i), H0)...
               *[points(i,4:6),1]';
        end
    end

end

