function [ arm1, arm2 ] = getPoints(dh_pars, dataset, H0, compute_arm2)
%GETPOINTS Compute points coordinates to base.
%INPUT - dh_pars - structure with DH parameters, where field names corresponding to names of
%                      the 'groups' in robot. Each group is matrix.
%      - dataset - dataset structure in common format
%      - H0 - H0 robot transformation
%      - compute_arm2 - wheather compute second end effector or use
%      refPoints
%OUTPUT - arm1 - points coordinates of first end effector
%       - arm2 - points coordinates of second end effector
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
    if(~isempty(joints))
        empty = isempty(dataset.rtMat);
        if (empty) % if no precomputed matrices -> fill up the array with []
            rtMats{size(joints,1)} = [];
            rtFields = [];
        else
            rtMats = dataset.rtMat;
            rtFields = fieldnames(rtMats(1));
        end
        DHindexes = dataset.DHindexes;
        parents = dataset.parents;
        %% compute end effectors coordinates
        for i = 1:size(joints, 1)      
            arm1(:,i) =  getTFIntern(dh_pars,frames(i),rtMats(i), joints(i), H0, DHindexes.(frames(i).name), parents, rtFields)...
                *[points(i,1:3),1]';
            if compute_arm2
               arm2(:,i) =  getTFIntern(dh_pars,frames2(i),rtMats(i), joints(i), H0, DHindexes.(frames2(i).name), parents, rtFields)...
                   *[points(i,4:6),1]';
            end
        end
    end
end

