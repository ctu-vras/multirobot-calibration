function [ error_vec ] = errors_fcn( opt_pars, robot, whitelist, dataset, optim)
%ERRORS_FCN Summary of this function goes here
%   Detailed explanation goes here
    distances = [];
    plane_distances = [];
    dist_from_ext = [];
    markers = [];
    if(optim.type.selftouch)
        distances = getDist(opt_pars, robot, whitelist, dataset.dist, optim);
    end
    if(optim.type.planes)
        plane_distances = getDistFromPlane(opt_pars, robot, whitelist, dataset.plane, optim);
    end
    if(optim.type.external)
        dist_from_ext = getDistFromExt(opt_pars, robot, whitelist, dataset.ext, optim);
    end
    if(optim.type.eyes)
        marker_dist = getPositionFromEyes(opt_pars, robot, whitelist, dataset.markers, optim);
    end
    
    error_vec = [(distances - dataset.dist{end}.refDist)*optim.type.selftouch, ...
        plane_distances*optim.type.planes, dist_from_ext*optim.type.external, ...
        marker_dist*optim.type.eyes];
end

