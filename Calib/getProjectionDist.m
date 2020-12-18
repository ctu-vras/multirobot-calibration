function [ dist, coeffs ] = getProjectionDist( dh_pars, robot, datasets)
    %GETPROJECTIONDIST returns errors from projections
    %   INPUT - dh_pars - structure with kinematics parameters, where field names corresponding to names of
    %                      the 'groups' in robot. Each group is 4D array.
    %         - robot - instance of @Robot class
    %         - datasets - 1xN cellarray of datasets for selftouch;
    %                       each dataset is structure in common format
    %   OUTPUT - dist - 1xN array of distance;
    %                   N is number of errors from projections
    %          - coeffs - 1xN array of conversions from pixels to meters
    
    
    % Copyright (C) 2019-2021  Jakub Rozlivek and Lukas Rustler
    % Department of Cybernetics, Faculty of Electrical Engineering, 
    % Czech Technical University in Prague
    %
    % This file is part of Multisensorial robot calibration toolbox (MRC).
    % 
    % MRC is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Lesser General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % MRC is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Lesser General Public License for more details.
    % 
    % You should have received a copy of the GNU Leser General Public License
    % along with MRC.  If not, see <http://www.gnu.org/licenses/>.
    
    
    dist = [];
    coeffs = [];
    cam_frames = robot.findJointByType('eye');
    type = robot.structure.type;
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
                CamTF(:,:,unique_poses(i), j) =  getTFIntern(dh_pars,cam_frames{j},rtMats(index_poses(i)), joints(index_poses(i)), DHindexes.(cam_frames{j}.name), parents, rtFields, type);
            end
        end
        for j = 1:length(cam_frames)
            CamTF(:,:,:, j) =  inversetf(CamTF(:,:,:,j));
        end
        %% Compute point coordinates to cameras
        for i = 1:size(points, 1)      
            point = getTFIntern(dh_pars,frames(i),rtMats(i), joints(i), DHindexes.(frames(i).name), parents, rtFields,type)*[points(i,1:3),1]';
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
        coeffs = [coeffs, proj2distCoef(points2Cam, robot.structure.eyes, cameras)];
    end
end
