function R = rotVector2rotMatrix(v)
    %ROTVEC2ROTMATRIX Convert a 3-D rotation vector into a rotation matrix
    % Reconstruction of a  3D rotationMatrix from a rotationVector (axis-angle representation) using
    % the Rodrigues formula.
    %INPUT - rotationVector - 3x1 rotation vector representing the axis of rotation in 3D, and its 
    % magnitude is the rotation angle in radians.
    %OUTPUT -  rotMatrix - 3x3 3D rotation matrix
    
    
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
    

    th=norm(v);
    if th>eps
        v=v/th;
    end
    x=v(1);
    y=v(2);
    z=v(3);
    R = [cos(th)+x^2*(1-cos(th)), x*y*(1-cos(th))-z*sin(th), x*z*(1-cos(th))+y*sin(th);
         y*x*(1-cos(th))+z*sin(th), cos(th)+y^2*(1-cos(th)), y*z*(1-cos(th))-x*sin(th);
         z*x*(1-cos(th))-y*sin(th), z*y*(1-cos(th))+x*sin(th), cos(th)+z^2*(1-cos(th))];
end

