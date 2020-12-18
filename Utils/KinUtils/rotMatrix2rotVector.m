function rotationVector = rotMatrix2rotVector(rotMatrix)
    %ROTMATRIX2ROTVEC Convert a 3D rotation matrix into a rotation vector.
    % Computation of a rotation vector (axis-angle representation) corresponding to a 3D 
    % rotation matrix using the Rodrigues formula.
    %INPUT - rotMatrix - 3x3 3D rotation matrix
    %OUTPUT - rotationVector - 3x1 rotation vector representing the axis of rotation in 3D, and its 
    % magnitude is the rotation angle in radians.
    
    
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
    
    
    [U, ~, V] = svd(rotMatrix);
    rotMatrix = U * V';
    t = trace(rotMatrix);
    theta = real(acos((t - 1) / 2));
    r = [rotMatrix(3,2) - rotMatrix(2,3); ...
         rotMatrix(1,3) - rotMatrix(3,1); ...
         rotMatrix(2,1) - rotMatrix(1,2)];
    if sin(theta) >= 1e-7
        % theta is not close to 0 or pi
        rotationVector = theta / (2 * sin(theta)) * r;
    elseif t-1 > 0
        % theta is close to 0 -> series expansion around t=3
        rotationVector = (0.5 - (t - 3) / 12) * r;
    else
        % theta is close to pi -> from rotation matrix to vector over quaternion
        v = matrix2quat(rotMatrix);
        rotationVector = theta * v(2:4) / norm(v(2:4));
    end



