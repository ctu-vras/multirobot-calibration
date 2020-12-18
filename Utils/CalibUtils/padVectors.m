function [str, type] = padVectors(str,wl)
    % PADVECTORS pads all vectors to size 6, add nan to free spaces and reorder
    %            the vector
    %   INPUT - str - structure to pad
    %         - wl - 1/0, if 1 the structure is whitelist and nans are replaced
    %         with 0 to work as logical vector
    %   OUTPUT - str - structure with the same fields as input with padded
    %                  vectors
    %          - type - structure with the same fields as input with possible
    %          values: 0 - field contains only kinematics representation
    %                  1 - field contains only RT matrix representation 
    %                  2 - field contains mixed representation
    
    
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
    

    if ~isa(str, 'struct') % if input is not struct, return 
        type=[];
        return
    end
    if nargin==1 % if no second argument - str is not whitelist
        wl=0;
    end
    for name=fieldnames(str)'
       name = name{1}; 
       str.(name)(:,end+1:6,:, :) = nan; % pad nans to make vector of size 6
       nans = isnan(str.(name));
       if all(any(nans,2)) %Only kinematics
           type.(name) = 0;
           if all(isnan(str.(name)(:,6))) 
               str.(name)(:,[3,4,6],:, :) = str.(name)(:,[6,3,4],:, :); % a,d,nan,alpha,offset,nan
           end
       elseif all(~any(nans,2)) %Only RT mats
           type.(name) = 1; %x,y,z,alpha,beta,gama
       else %Both
           type.(name) = 2;
           for line=1:size(str.(name),1) %Need to check every line
               if any(isnan(str.(name)(line,:))) %if kinematics
                   if isnan(str.(name)(line, 6))
                       str.(name)(line,[3,4,6],:, :) = str.(name)(line,[6,3,4],:, :);
                   end
               %else keep vector as it is
               end
           end
       end
       if wl %if str is whitelist, replace nans with 0
          str.(name)(isnan(str.(name))) = 0; 
       end
    end    

end