function plotProjections(points, points2, plotTitle, legends )
    %PLOTPROJECTIONS Function for plotting projections
    %INPUT - points - Nx2 vector of points
    %      - points2 - Nx2 or Nx4 vector of points or pair of points
    %      - plotTitle - plot title
    %      - legends - cell array of legend labels
    
    
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
    
    
    if(~isempty(points))
    scatter(points(1:2:end,1), points(1:2:end,2), 'filled', 'b');
    hold on;
    end
    if(~isempty(points2))
    scatter(points2(1:2:end,1), points2(1:2:end,2), 'filled', 'r');
    hold on;
    if(size(points2,2) > 2)
    scatter(points2(1:2:end,3), points2(1:2:end,4), 'filled', 'g');
    end
    end
    grid on;
    legend(legends,'Location','east');
    title(plotTitle)
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
end

