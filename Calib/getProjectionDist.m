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
        refPoints = reshape(dataset.refPoints',2,[]);
        refPoints(:,isnan(refPoints(1,:))) = [];
        poses = dataset.pose;
        cameras = dataset.cameras;
        points2Cam = nan(4, 2*size(points, 1));
        index = 1;    
        rtMats = dataset.rtMat;
        for i = 1:size(points, 1)      
            if(empty)
                rtMat = [];
            else
                rtMat = rtMats(i);
            end
            point = (getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)*[points(i,1:3),1]');
            if(cameras(i,1))
                points2Cam(:,index) =  inversetf(getTF(dh_pars,cam_frames{1},rtMat, empty, joints(i), H0))*point;
                index = index+1;
            end
            if(cameras(i,2))
                points2Cam(:,index) =  inversetf(getTF(dh_pars,cam_frames{2},rtMat, empty, joints(i), H0))*point;
                index = index+1;
            end
        end
        points2Cam(:,isnan(points2Cam(1,:))) = [];
        projs = projections(points2Cam, robot.structure.eyes, cameras);
        dist = [dist, reshape(projs-refPoints, 1, 2*size(projs, 2))];
    end
end

