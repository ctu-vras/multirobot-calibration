function [params, typicalX] = initialGuess(datasets, dh_pars, approaches, optim, dh_type)
    %INITIALGUESS Compute initial guess of plane and/or external transformation parameters
    % Compute plane parameters for each dataset.planes and rotation vector
    % (quaternion) and translation vector for each dataset.external separately
    %INPUT - datasets - structure of dataset, where field names are {selftouch,
    %                     planes, external, projections} and and each field is 1xN cellArray
    %      - dh_pars - structure with kinematics parameters, where field names corresponding to names of
    %                     the 'groups' in robot. Each group is matrix.
    %      - approaches - structure of settings for each calibration approach
    %      - optim - structure of calibration settings
    %OUTPUT - params - row vector of initial parameters for planes and/or external transformation 
    %       - typicalX - row vector of scaling coefficients of the params
    
    
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
    
    
    params=[];
    typicalX = [];
    for type = {'planes','external'}
        type = type{1};
        if approaches.(type)
            for dataset = datasets.(type)
                dataset = dataset{1};
                robPoints = getPointsIntern(dh_pars, dataset, dh_type);
                if strcmp(type,'planes')
                    newParams = getPlane(robPoints);
                    newParams = newParams(1:3)/newParams(4); % plane equation in format ax+by+cz = 1
                    paramWeights = ones(1,3)*optim.parametersWeights.(type);
                else
                    extPoints = dataset.refPoints;
                    [R,T] = fitSets(extPoints,robPoints(1:3,:)');
                    if(strcmp(optim.rotationType,'vector')) % compute rotation vector from rotation matrix
                        newParams = [rotMatrix2rotVector(R)',T'];
                        paramWeights = [ones(1,3)*optim.parametersWeights.(type)(1),ones(1,3)*optim.parametersWeights.(type)(2)];
                    elseif(strcmp(optim.rotationType,'quat')) % compute quaternion from rotation matrix
                        newParams = [matrix2quat(R),T'];
                        paramWeights = [ones(1,4)*optim.parametersWeights.(type)(1),ones(1,3)*optim.parametersWeights.(type)(2)];
                    else
                        continue
                    end
                end
                typicalX = [typicalX,paramWeights];
                params = [params, newParams];
            end
        end
    end

end

