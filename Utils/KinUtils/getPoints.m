function [ arm1, arm2 ] = getPoints(robot, dh_pars, dataset, compute_arm2)
%GETPOINTS Compute points coordinates to base.
%INPUT - dh_pars - structure with DH parameters, where field names corresponding to names of
%                      the 'groups' in robot. Each group is matrix.
%      - dataset - dataset structure in common format
%      - compute_arm2 - whether compute second end effector or use
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
        for i = 1:size(joints, 1)      
            if (isobject(frames{i}))
                arm1(:,i) =  getTFtoFrame(dh_pars,frames{i},joints(i)) *[points(i,1:3),1]';
            else
                f=robot.findJoint(frames{i});
                arm1(:,i) =  getTFtoFrame(dh_pars,f{1},joints(i)) *[points(i,1:3),1]';
            end
            
            if compute_arm2
                if (isobject(frames2{i}))
                    arm2(:,i) =  getTFtoFrame(dh_pars,frames2{i}, joints(i)) *[points(i,4:6),1]';
                else
                    f=robot.findJoint(frames2{i});
                    arm2(:,i) =  getTFtoFrame(dh_pars,f{1}, joints(i)) *[points(i,4:6),1]';
                end
            end
            
        end
    end