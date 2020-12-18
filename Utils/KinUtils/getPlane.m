function [ plane ] = getPlane( points )
    %GETPLANE Compute a plane fitted to set of given points using svd.
    %INPUT - points - (4,X) or (3,X) row vector of points
    %OUTPUT - plane - fitted plane
    
    
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
    
    
    points = points(1:3,:);
    % compute centroid
    t = sum(points,2)/length(points);
    centered_points = points - t;
    [U,~,~] = svd(centered_points);
    plane = [U(:,3).' -t' * U(:,3)];
end

