function [ coeffs ] = proj2distCoef( points2Cam, eyes, cameras)
    %PROJ2DISTCOEF Projection errors coefficient to compare them with 3D errors
    %    When the error function contains both 3D and reprojection errors, 
    %    the reprojection errors are multiplied a coefficient determined 
    %    from the intrinsic parameters of cameras and distance of the end-effector from the eye
    %INPUT - points2Cam - points in cameras coordinate system
    %      - eyes - cameras intrinsic parameters (dist coeffs and camera matrix)
    %      - cameras - number of poses in poses set
    %OUTPUT - coeffs - row vector of coefficients for alternating coordinates
    
    
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
    

    fx = reshape(eyes.matrix(1,1,:), 1,[]);
    fy = reshape(eyes.matrix(2,2,:), 1,[]);
    cameras = cameras.*(1:size(cameras,2)); % convert logical array to array of used cameras
    cameras = reshape(cameras',[],1);
    cameras(cameras==0) = [];
    if(~isempty(cameras))
        coeffs(2*length(cameras)) = 0;
        coeffs(1:2:end) = sqrt(sum(points2Cam(1:3,:).^2,1))./fx(cameras);
        coeffs(2:2:end) = sqrt(sum(points2Cam(1:3,:).^2,1))./fy(cameras);
    else
        coeffs = [];
    end
    
end

