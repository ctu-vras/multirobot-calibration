function [ dist ] = getPlaneDist( dh_pars, robot, datasets)
%GETPLANEDIST returns errors from selftouch configurations
%   INPUT - dh_pars - structure with DH parameters, where field names corresponding to names of
%                      the 'groups' in robot. Each group is matrix.
%         - robot - instance of @Robot class
%         - datasets - 1xN cellarray of datasets for selftouch;
%                       each dataset is structure in common format
%   OUTPUT - dist - MxN array of distance;
%                   M=1 if optim.useNorm, M=3 if ~optim.useNorm;
%                   N is number of errors computed using planes
    dist = [];
    H0 = robot.structure.H0;
    for dataset=datasets
        dataset = dataset{1};    
        % compute points in the base frame
        robPoints = getPoints(dh_pars, dataset, H0, false);
        % compute the plane
        plane = getPlane(robPoints);
        % concatenate into one vector
        dist = [dist, plane*robPoints];
    end
end
