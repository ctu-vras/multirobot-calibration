function [ dist ] = getPlaneDist( dh_pars, robot, datasets, optim )
%GETPLANEDIST Summary of this function goes here
%   Detailed explanation goes here
    dist = [];
    H0 = robot.structure.H0;
    for dataset=datasets
        dataset = dataset{1};        
        robPoints = getPoints(dh_pars, dataset, H0, false);
        plane = getPlane(robPoints);
        dist = [dist, plane*robPoints];
    end
end
