function [ dist ] = getProjectionDist( dh_pars, robot, datasets)
%GETPROJECTIONDIST returns errors from projections
%   INPUT - dh_pars - structure with DH parameters, where field names corresponding to names of
%                      the 'groups' in robot. Each group is 4D array.
%         - robot - instance of @Robot class
%         - datasets - 1xN cellarray of datasets for selftouch;
%                       each dataset is structure in common format
%   OUTPUT - dist - 1xN array of distance;
%                   N is number of errors from projections
    H0 = robot.structure.H0;
    dist = [];
    cam_frames = robot.findJointByType('eye');
    for dataset=datasets
        dataset = dataset{1};
        frames = dataset.frame;
        empty = isempty(dataset.rtMat);
        joints = dataset.joints;
        points = dataset.point;
        DHindexes = dataset.DHindexes;
        parents = dataset.parents;
        refPoints = reshape(dataset.refPoints',2,[]);
        refPoints(:,isnan(refPoints(1,:))) = [];
        cameras = dataset.cameras;
        points2Cam = nan(4, 2*size(points, 1));
        index = 1;    
        if (empty && ~isempty(joints)) % if no precomputed matrices -> fill up the array with []
            rtMats{size(joints,1)} = [];
        else
            rtMats = dataset.rtMat;
        end
        poses = dataset.pose;
        [unique_poses, index_poses, ~] = unique(poses);
        %% precompute transformation from base to cameras
        Cam1TF = zeros(4,4,unique_poses(end));
        Cam2TF = zeros(4,4,unique_poses(end));
        for i = 1:length(index_poses)
            Cam1TF(:,:,unique_poses(i)) =  inversetf(getTF(dh_pars,cam_frames{1},rtMats(index_poses(i)), joints(index_poses(i)), H0, DHindexes.(cam_frames{1}.name), parents));
            Cam2TF(:,:,unique_poses(i)) =  inversetf(getTF(dh_pars,cam_frames{2},rtMats(index_poses(i)), joints(index_poses(i)), H0, DHindexes.(cam_frames{2}.name), parents));
        end
        %% Compute point coordinates to cameras
        for i = 1:size(points, 1)      
            point = getTF(dh_pars,frames(i),rtMats(i), joints(i), H0, DHindexes.(frames(i).name), parents)*[points(i,1:3),1]';
            if(cameras(i,1))
                points2Cam(:,index) = Cam1TF(:,:,poses(i))*point;
                index = index+1;
            end
            if(cameras(i,2))
                points2Cam(:,index) = Cam2TF(:,:,poses(i))*point;
                index = index+1;
            end
        end
        points2Cam(:,isnan(points2Cam(1,:))) = [];
        %% compute projections
        projs = projections(points2Cam, robot.structure.eyes, cameras);
        dist = [dist, reshape(projs-refPoints, 1, 2*size(projs, 2))];
    end
end
