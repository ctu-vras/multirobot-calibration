function plotErrorResiduals( computed_points, real_points )
    %PLOTERRORRESIDUALS Function for plotting error residuals
    %INPUT - computed_points - 2xN vector of points in metres
    %      - real_points - 2xN vector of points in metres
    
    
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
    

    %% convert points to mm
    real_points = real_points*1000;
    computed_points = computed_points*1000;
    
    %% scatter plot of residuals in 2D
    figure()
    subplot(2,1,1)     
    scatter(computed_points(1,:)-real_points(1,:), computed_points(2,:)-real_points(2,:))
    xlabel('error in X [mm]')
    ylabel('error in Y [mm]')
    title('Residuals of end effector position error')
    subplot(2,1,2)
    scatter(computed_points(2,:)-real_points(2,:), computed_points(3,:)-real_points(3,:))
    xlabel('error in Y [mm]') 
    ylabel('error in Z [mm]')
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
    
    %% quiver plot of residuals in 2D
    figure()
    subplot(2,1,1)
    quiver(real_points(1,:), real_points(2,:), computed_points(1,:)-real_points(1,:), computed_points(2,:)-real_points(2,:), 1, 'Color', 'b');
    xlabel('X [mm]')
    ylabel('Y [mm]')
    title('End effector position and residuals of error')
    subplot(2,1,2)
    quiver(real_points(2,:), real_points(3,:), computed_points(2,:)-real_points(2,:), computed_points(3,:)-real_points(3,:), 1, 'Color', 'b');
    xlabel('Y [mm]')
    ylabel('Z [mm]')
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
    
    %% quiver plot of residuals in 3D
    figure()
    quiver3(real_points(1,:), real_points(2,:), real_points(3,:), computed_points(1,:)-real_points(1,:), computed_points(2,:)-real_points(2,:), computed_points(3,:)-real_points(3,:), 1, 'Color', 'b');
    xlabel('X [mm]')
    ylabel('Y [mm]')
    zlabel('Z [mm]')
    title('Residuals of end effector position error')
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
end

