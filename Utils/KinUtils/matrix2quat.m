function [ quat ] = matrix2quat( mat )
    %MATRIX2QUAT Convert the rotation matrix into quaternion
    %INPUT - mat - rotation matrix 
    %OUTPUT - quat - quaternion vector [w,x,y,z]
    
    
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
    
    
    tr = trace(mat);
    if (tr > 0) 
        S = sqrt(tr+1.0) * 2; 
        qw = 0.25 * S;
        qx = (mat(3,2) - mat(2,3)) / S;
        qy = (mat(1,3) - mat(3,1)) / S; 
        qz = (mat(2,1) - mat(1,2)) / S; 
    elseif ((mat(1,1) > mat(2,2))&&(mat(1,1) > mat(3,3)))
        S = sqrt(1.0 + mat(1,1) - mat(2,2) - mat(3,3)) * 2; 
        qw = (mat(3,2) - mat(2,3)) / S;
        qx = 0.25 * S;
        qy = (mat(1,2) + mat(2,1)) / S; 
        qz = (mat(1,3) + mat(3,1)) / S; 
    elseif (mat(2,2) > mat(3,3)) 
        S = sqrt(1.0 + mat(2,2) - mat(1,1) - mat(3,3)) * 2; 
        qw = (mat(1,3) - mat(3,1)) / S;
        qx = (mat(1,2) + mat(2,1)) / S; 
        qy = 0.25 * S;
        qz = (mat(2,3) + mat(3,2)) / S; 
    else 
        S = sqrt(1.0 + mat(3,3) - mat(1,1) - mat(2,2)) * 2; 
        qw = (mat(2,1) - mat(1,2)) / S;
        qx = (mat(1,3) + mat(3,1)) / S;
        qy = (mat(2,3) + mat(3,2)) / S;
        qz = 0.25 * S;
    end
    quat = [qw,qx,qy,qz];
end
