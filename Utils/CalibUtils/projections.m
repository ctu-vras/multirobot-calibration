function camera_points = projections(points, eyes, cameras)
    %PROJECTIONS Project points to the cameras
    % Project points given by 4x4xN transformation matrices array tfs to the cameras
    %INPUT - points - points in cameras coordinate system
    %      - eyes - cameras intrinsic parameters (dist coeffs and camera matrix)
    %      - cameras - number of poses in poses set
    %OUTPUT - camera_points - row vector of projection coords (u,v)
    
    
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
    
    
    dc = eyes.dist; % radial distortion coeffs
    tdc = eyes.tandist; % tangential distortion coeffs
    mat = eyes.matrix(1:2,:,:); % camera matrix
    cameras = cameras.*(1:size(cameras,2)); % convert logical array to array of used cameras
    cameras = reshape(cameras',[],1);
    cameras(cameras==0) = [];

    %% compute distorted coords
    x_ = points(1:2,:)./points(3,:);
    r_sq = sum(x_.^2);
    x_ = [x_.*((1 + dc(1,cameras).*r_sq + dc(2,cameras).*r_sq.^2 + dc(3,cameras).*r_sq.^3) ./ ...
            (1 + dc(4,cameras).*r_sq + dc(5,cameras).*r_sq.^2 + dc(6,cameras).*r_sq.^3)) ...
            + [2*tdc(1,cameras).*x_(1,:).*x_(2,:) + tdc(2,cameras).*(r_sq + 2*x_(1,:).^2);...
            tdc(1,cameras).*(r_sq + 2*x_(2,:).^2) + 2*tdc(2,cameras).*x_(1,:).*x_(2,:)]; ...
            ones(1,size(points,2))];
    %% compute the projection from distorted coords
    camera_points = squeeze(sum(mat(:,:,cameras).*reshape(x_,1,3,[]),2));
end
