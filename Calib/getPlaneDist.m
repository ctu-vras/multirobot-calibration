function [ dist ] = getPlaneDist( dh_pars, robot, datasets, planePars)
    %GETPLANEDIST returns errors from selftouch configurations
    %   INPUT - dh_pars - structure with kinematics parameters, where field names corresponding to names of
    %                      the 'groups' in robot. Each group is matrix.
    %         - robot - instance of @Robot class
    %         - datasets - 1xN cellarray of datasets for selftouch;
    %                       each dataset is structure in common format
    %         - planePars - 1xN array of parameters to be optimized
    %   OUTPUT - dist - 1xN array of distance;
    %                   N is number of errors computed using planes
    
    
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
    
    
    dist = [];
    for datasetId=length(datasets)
        dataset = datasets{datasetId};    
        % compute points in the base frame
        robPoints = getPointsIntern(dh_pars, dataset, false, robot.structure.type);
        if isempty(planePars)
            % compute the plane
            plane = getPlane(robPoints);
        else
            plane=planePars((datasetId-1)*optim.planeParams+1:datasetId*optim.planeParams);
        end
        % concatenate into one vector
        dist = [dist, plane*robPoints];
    end
end
