function structure=getIndexes(structure, link)
    % GETINDEXES computes indexes and parents needed to find transformations
    %   INPUT - structure - structure where new fields will be added/updated
    %         - link - link object for which we want find the informations
    %   OUTPUT - structure - updated input variable
    
    
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
    
    
    gr = link.group;
    name=link.name;
    idx = [];
    id=1;
    while isobject(link) 
        while strcmp(link.group,gr) && ~strcmp(link.type,types.base) % save indexes into kinematics table for all links of the group
           idx(id)=link.DHindex;
           id=id+1;
           link=link.parent;
        end
        structure.DHindexes.(name).(gr) = idx(end:-1:1);
        structure.parents.(gr) = link; % link.group differs from gr
        gr = link.group;
        idx = link.DHindex; 
        id=2;
        link=link.parent; 
    end
end