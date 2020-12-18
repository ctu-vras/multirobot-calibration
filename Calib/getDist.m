function [ dist ] = getDist(dh_pars, robot, datasets, optim)
    %GETDIST returns errors from selftouch configurations
    %   INPUT - dh_pars - structure with kinematics parameters, where field names corresponding to names of
    %                      the 'groups' in robot. Each group is matrix.
    %         - robot - instance of @Robot class
    %         - datasets - 1xN cellarray of datasets for selftouch;
    %                       each dataset is structure in common format
    %         - optim - structure of calibration settings
    %   OUTPUT - dist - MxN array of distance;
    %                   M=1 if optim.useNorm, M=3 if ~optim.useNorm;
    %                   N is number of errors from selftouch
    
    
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
    %iterate over datasets
    for dataset=datasets
        dataset = dataset{1};
        refPoints = dataset.refPoints;
        computeArm2 = ~optim.refPoints || (isempty(refPoints));
        % compute RT matrices and transform points to base frame
        [arm1,arm2] = getPointsIntern(dh_pars, dataset, computeArm2, robot.structure.type);
        
        % if only one arm, use the refPoints
        if(~computeArm2) 
            arm2 = refPoints';
        end
        
        % returns RMS distances
        if optim.useNorm
            distances = sqrt(sum((arm1(1:3,:)-arm2(1:3,:)).^2,1));
        % returns difference in each coordinate
        else
            distances = arm1(1:3,:)-arm2(1:3,:);
        end       
        % concatenate in one vector
        dist = [dist, distances];
    end
end
