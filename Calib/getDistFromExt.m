function [dist] = getDistFromExt(dh_pars, robot, datasets, optim, extParams)
    %GETDISTFROMEXT returns errors from configurations with external camera
    %   INPUT - dh_pars - structure with kinematics parameters, where field names corresponding to names of
    %                      the 'groups' in robot. Each group is matrix.
    %         - robot - instance of @Robot class
    %         - datasets - 1xN cellarray of datasets for selftouch;
    %                       each dataset is structure in common format
    %         - optim - structure of calibration settings
    %         - extParams - 1xN array of parameters to be optimized
    %   OUTPUT - dist - MxN array of distance;
    %                   M=1 if optim.useNorm, M=3 if ~optim.useNorm;
    %                   N is number of errors computed from external cameras
    
    
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
    for datasetId=1:length(datasets) 
        dataset = datasets{datasetId};
        extPoints=dataset.refPoints;
        % compute points in the base frame
        robPoints = getPointsIntern(dh_pars, dataset, robot.structure.type);
        if isempty(extParams)
            % find transformation between external camera and robot
            [R,T]=fitSets(extPoints,robPoints(1:3,:)'); 
        else
            actParams=extParams((datasetId-1)*optim.externalParams+1:datasetId*optim.externalParams);
            T=actParams(optim.externalParams-2:end)';
            if(strcmp(optim.rotationType,'vector'))
                R=rotVector2rotMatrix(actParams(1:3));
            else
                R=quat2matrix(actParams(1:4));
            end
        end

        % transform ext point to robot's base frame
        extPoints = R*extPoints' + T;
        % returns RMS distances
        if optim.useNorm
            distances = sqrt(sum((robPoints(1:3,:)-extPoints(1:3,:)).^2,1));
        % returns difference in each coordinate
        else
            distances = robPoints(1:3,:)-extPoints(1:3,:);
        end     
        % concatenate in one vector
        dist = [dist, distances];
    end
end
