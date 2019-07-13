function [ dist ] = getProjectionDist( dh_pars, robot, datasets, optim )
%GETPROJECTIONDIST Summary of this function goes here
%   Detailed explanation goes here    
    H0 = robot.structure.H0;
    dist = [];
    cam_frames = robot.findJointByType('eye');
    for dataset=datasets
        dataset = dataset{1};
        frames = dataset.frame;
        empty = isempty(dataset.rtMat);
        joints = dataset.joints;
        points = dataset.point;
        secondFrames = isfield(dataset,'frame2') && ~isempty(dataset.frame2);
        if(secondFrames)
            frames2 = dataset.frame2;
        end
        refPoints = dataset.refPoints';
        if(size(refPoints,1) ==2)
            refPoints = repelem(refPoints,1,2);
        elseif(size(refPoints,1) ==4)
            refPoints = reshape(refPoints,2,[]);
        elseif(size(refPoints,1) == 3)
            refPoints = refPoints(1:2,:)./refPoints(3,:);
            refPoints = repelem(refPoints,1,2);
        elseif(size(refPoints,1) == 6)
            refPoints = [refPoints(1:2,:)./refPoints(3,:);refPoints(4:5,:)./refPoints(6,:)];
        end
        refPoints(:,isnan(refPoints(1,:))) = [];
        poses = dataset.pose;
        cameras = dataset.cameras;
        points2Cam = nan(4, (2*secondFrames+2)*size(points, 1));
        index = 1;
        for i = 1:size(points, 1)      
            if(empty)
                rtMat = [];
            else
                rtMat = dataset.rtMat(i);
            end
            if(cameras(i,1))
                points2Cam(:,index) =  inversetf(getTF(dh_pars,cam_frames{1},rtMat, empty, joints(i), H0))*...
                    (getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)*[points(i,1:3),1]');
                index = index+1;
                if(secondFrames)
                    points2Cam(:,index+1) =  inversetf(getTF(dh_pars,cam_frames{1},rtMat, empty, joints(i), H0))*...
                        (getTF(dh_pars,frames2(i),rtMat, empty, joints(i), H0)*[points(i,1:3),1]');
                    index= index+1;
                end
            end
            if(cameras(i,2))
                points2Cam(:,index) =  inversetf(getTF(dh_pars,cam_frames{2},rtMat, empty, joints(i), H0))*...
                (getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)*[points(i,1:3),1]');
                index = index+1;
                if(secondFrames)
                    points2Cam(:,index) =  inversetf(getTF(dh_pars,cam_frames{2},rtMat, empty, joints(i), H0))*...
                        (getTF(dh_pars,frames2(i),rtMat, empty, joints(i), H0)*[points(i,1:3),1]');
                index = index+1;
                end
                
            end
        end
        points2Cam(:,isnan(points2Cam(1,:))) = [];
        projs = projections(points2Cam, robot.structure.eyes, cameras);
        dist = [dist, reshape(projs-refPoints, 1, 2*size(projs, 2))];
    end
end

