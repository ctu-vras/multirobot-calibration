function [params, typicalX] = initialGuess(datasets, dh_pars, approaches, optim)
%INITIALGUESS Compute initial guess of plane and/or external transformation parameters
% Compute plane parameters for each dataset.planes and rotation vector
% (quaternion) and translation vector for each dataset.external separately
%INPUT - datasets - structure of dataset, where field names are {selftouch,
%                     planes, external, projections} and and each field is 1xN cellArray
%      - dh_pars - structure with DH parameters, where field names corresponding to names of
%                     the 'groups' in robot. Each group is matrix.
%      - approaches - structure of settings for each calibration approach
%      - optim - structure of calibration settings
%OUTPUT - params - row vector of initial parameters for planes and/or external transformation 
%       - typicalX - row vector of scaling coefficients of the params
    params=[];
    typicalX = [];
    for type = {'planes','external'}
        type = type{1};
        if approaches.(type)
            for dataset = datasets.(type)
                dataset = dataset{1};
                robPoints = getPoints(dh_pars, dataset, false);
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

