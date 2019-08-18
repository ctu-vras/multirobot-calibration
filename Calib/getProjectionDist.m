function [ dist, coeffs ] = getProjectionDist( dh_pars, robot, datasets)
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
    coeffs = [];
    cam_frames = robot.findJointByType('eye');
    for dataset=datasets
        dataset = dataset{1};
        frames = dataset.frame;
        empty = isempty(dataset.rtMat);
        joints = dataset.joints;
        if(isempty(joints))
            continue
        end
        points = dataset.point;
        DHindexes = dataset.DHindexes;
        parents = dataset.parents;
        refPoints = reshape(dataset.refPoints',2,[]);
        refPoints(:,isnan(refPoints(1,:))) = [];
        cameras = dataset.cameras;
        points2Cam = nan(4, 2*size(points, 1));
        index = 1;    
        if (empty) % if no precomputed matrices -> fill up the array with []
            rtMats{size(joints,1)} = [];
            rtFields = [];
        else
            rtMats = dataset.rtMat;
            rtFields = fieldnames(rtMats(1));
        end
        poses = dataset.pose;
        [unique_poses, index_poses, ~] = unique(poses);
        %% precompute transformation from base to cameras
        CamTF = zeros(4,4,unique_poses(end), length(cam_frames));
        for i = 1:length(index_poses)
            for j = 1:length(cam_frames)
                CamTF(:,:,unique_poses(i), j) =  getTFIntern(dh_pars,cam_frames{j},rtMats(index_poses(i)), joints(index_poses(i)), H0, DHindexes.(cam_frames{j}.name), parents, rtFields);
            end
        end
        for j = 1:length(cam_frames)
            CamTF(:,:,:, j) =  inversetf(CamTF(:,:,:,j));
        end
        %% Compute point coordinates to cameras
        for i = 1:size(points, 1)      
            point = getTFIntern(dh_pars,frames(i),rtMats(i), joints(i), H0, DHindexes.(frames(i).name), parents, rtFields)*[points(i,1:3),1]';
            for j = 1:size(cameras,2)
                if(cameras(i,j))
                    points2Cam(:,index) = CamTF(:,:,poses(i),j)*point;
                    index = index+1;
                end
            end
        end
        points2Cam(:,isnan(points2Cam(1,:))) = [];
        %% compute projections
        projs = projections(points2Cam, robot.structure.eyes, cameras);
        dist = [dist, reshape(projs-refPoints, 1, 2*size(projs, 2))];
        coeffs = [coeffs, dist2projCoef(points2Cam, robot.structure.eyes, cameras)];
    end
end
