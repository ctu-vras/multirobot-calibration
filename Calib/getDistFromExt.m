function [dist] = getDistFromExt(dh_pars, robot, datasets, optim, extParams)
%GETDISTFROMEXT returns errors from configurations with external camera
%   INPUT - dh_pars - structure with DH parameters, where field names corresponding to names of
%                      the 'groups' in robot. Each group is matrix.
%         - robot - instance of @Robot class
%         - datasets - 1xN cellarray of datasets for selftouch;
%                       each dataset is structure in common format
%         - optim - structure of calibration settings
%         - extParams - 1xN array of parameters to be optimized
%   OUTPUT - dist - MxN array of distance;
%                   M=1 if optim.useNorm, M=3 if ~optim.useNorm;
%                   N is number of errors computed from external cameras
    dist = [];
    H0 = robot.structure.H0;
    for datasetId=1:length(datasets) 
        dataset = datasets{datasetId};
        extPoints=dataset.refPoints;
        % compute points in the base frame
        robPoints = getPoints(dh_pars, dataset, H0, false);
        if isempty(extParams)
            % find transformation between external camera and robot
            [R,T]=fitSets(extPoints,robPoints(1:3,:)'); 
        else
            actParams=extParams((datasetId-1)*optim.externalParams+1:datasetId*optim.externalParams);
            T=actParams(optim.externalParams-2:end)';
            if(optim.externalParams == 6)
                R=rotationVectorToMatrix(actParams(1:3));
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
