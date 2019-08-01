function [ dist ] = getDist(dh_pars, robot, datasets, optim)
%GETDIST returns errors from selftouch configurations
%   INPUT - dh_pars - structure with DH parameters, where field names corresponding to names of
%                      the 'groups' in robot. Each group is 4D array.
%         - robot - instance of @Robot class
%         - datasets - 1xN cellarray of datasets for selftouch;
%                       each dataset is structure in common format
%         - optim - structure of calibration settings
%   OUTPUT - dist - MxN array of distance;
%                   M=1 if optim.useNorm, M=3 if ~optim.useNorm;
%                   N is number of errors from selftouch
    dist = [];
    H0 = robot.structure.H0;
    %terate over datasets
    for dataset=datasets
        dataset = dataset{1};
        refPoints = dataset.refPoints;
        computeArm2 = ~optim.refPoints || (isempty(refPoints));
        % compute RT matrices and transform points to base frame
        [arm1,arm2] = getPoints(dh_pars, dataset, H0, computeArm2);
        
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
