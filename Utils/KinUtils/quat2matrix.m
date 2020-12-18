function [mat] = quat2matrix(quat)
    %QUAT2MATRIX Convert the quaternion into rotation matrix.
    %INPUT - quat - quaternion vector [w,x,y,z]
    %OUTPUT - mat - rotation matrix
    
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
    
    
    quat = quat ./ sqrt(sum(quat.^2));

    mat = [1 - 2*quat(3)^2 - 2*quat(4)^2, 2*quat(2)*quat(3) - 2*quat(4)*quat(1), 2*quat(2)*quat(4) + 2*quat(3)*quat(1); ...
           2*quat(2)*quat(3) + 2*quat(4)*quat(1), 1 - 2*quat(2)^2 - 2*quat(4)^2, 2*quat(3)*quat(4) - 2*quat(2)*quat(1); ...
           2*quat(2)*quat(4) - 2*quat(3)*quat(1), 2*quat(3)*quat(4) + 2*quat(2)*quat(1), 1 - 2*quat(2)^2 - 2*quat(3)^2];
end
