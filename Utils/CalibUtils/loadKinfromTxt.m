function loadKinfromTxt(robot, folder, file)
    %LOADKINFROMTXT Loading robot kinematics from a text file
    %   Function for loading robot kinematics from a text file saved in a subfolder in
    %   folder Results
    %INPUT - robot - Robot object to store kinematics 
    %      - folder - folder with the required txt file
    %      - file - file with the required kinematics
    
    
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
    
    if(nargin == 2)
        fileID = fopen(folder);
    else
        fileID = fopen(['Results/',folder,'/',file,'.txt']);
    end
    % load the columns with values
    C = textscan(fileID,'%s %s %s %s %s %s %s');
    % convert values to double
    A = [str2double(C{2}),str2double(C{3}),str2double(C{4}),str2double(C{5}),str2double(C{6}),str2double(C{7})];
    groups = {C{1}{isnan(A(:,1))}};
    idx = [find(isnan(A(:,1))); size(A,1)+1];
    % save kinematics for each group
    existing_fnames = unique(robot.linksStructure(:, end));
    for i = 1:length(groups)
        if ismember(groups{i}, existing_fnames)
            robot.structure.kinematics.(groups{i})= A(idx(i)+1:idx(i+1)-1,:);
        end
    end
    fclose(fileID);
end

