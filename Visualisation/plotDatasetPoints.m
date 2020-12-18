function plotDatasetPoints(robot,datasets)
    %PLOTDATASETPOINTS - plots robot model with all gathered points from
    %                    dataset
    %   INPUT - robot - instance of @Robot class
    %         - datasets - structure of datasets
    
    
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
    

    datasetsCell = struct2cell(datasets);
    datasetsCell = horzcat(datasetsCell{:});
    for dataset = datasetsCell
        figure()
        fig = robot.showModel('showText', 0);
        set(0, 'CurrentFigure', fig);
        hold on;
        [dh_pars, ~] = padVectors(robot.structure.kinematics);
        arm1 = getPoints(robot, dh_pars, dataset{1}, false);    
        scatter3(arm1(1,:), arm1(2,:), arm1(3,:), 'g', 'filled', 'MarkerEdgeColor', 'k');
    end
end

