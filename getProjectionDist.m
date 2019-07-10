function [ dist ] = getProjectionDist( dh_pars, robot, datasets, optim )
%GETPROJECTIONDIST Summary of this function goes here
%   Detailed explanation goes here    
    H0 = robot.structure.H0;
    markers = robot.structure.fingers;
    dist = [];
    cam_frames = robot.findJointByType('eye');
    index = 0;
    for dataset=datasets
        index = index + 1;
        dataset = dataset{1};
        frames = dataset.frame;
        empty = isempty(dataset.rtMat);
        joints = dataset.joints;
        points = dataset.point;
        refPoints = dataset.refPoints';
        poses = dataset.pose;
        cameras = dataset.cameras;
        points2Cam = zeros(4, size(points, 1));
        for i = 1:size(points, 1)      
            if(empty)
                rtMat = [];
            else
                rtMat = dataset.rtMat(i);
            end
            points2Cam(:,i) =  inversetf(getTF(dh_pars,cam_frames{cameras(i)},rtMat, empty, joints(i), H0))*...
                (getTF(dh_pars,frames(i),rtMat, empty, joints(i), H0)*(markers(:,:,frames(i).DHindex)*[points(i,1:3),1]'));
        end

        projs = projections(points2Cam, robot.structure.eyes, cameras);
        dist = [dist, reshape(projs-refPoints, 1, 2*size(projs, 2))];
    end
end

