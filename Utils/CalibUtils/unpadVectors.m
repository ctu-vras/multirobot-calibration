function str = unpadVectors(str, kinematics, type)
    % PADVECTORS unpad vector and get it back to default form set by user
    %   INPUT - str - structure to unpad
    %         - kinematics - Robot kinematics structure
    %         - type - structure: 0 - only DH; 1 - only RT; 2 - mixed trans
    %   OUTPUT - str - structure with the same fields as input with unpadded
    %                  values
    
    
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
    
    
    for name=fieldnames(str)'
        name = name{1};
        str.(name) = double(str.(name));
        if isfield(type, name) && type.(name) == 0 %if only kinematics
           str.(name) = str.(name)(:, [1,2,4,6],:, :); %reorder back to default vector of size 4  
        elseif isfield(type, name) && type.(name) == 2 % if mixed notation
           for line=size(type.(name),1)
              if any(isnan(kinematics.(name)(line, :))) %if kinematics line
                    %all maximal 4 dimension reordered and added nans to
                    %have vector of size 6
                    str.(name)(line, :, :, :) = [str.(name)(line, [1,2,4,6], :, :),nan(1,2,size(str.(name)(line, :, :, :),3),size(str.(name)(line, :, :, :),4))];
              end
           end
        end
    end
end