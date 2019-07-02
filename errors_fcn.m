function [ error_vec ] = errors_fcn( opt_pars, dh_pars, robot, whitelist, dataset, optim)
%ERRORS_FCN Summary of this function goes here
%   Detailed explanation goes here
    distances = [];
    plane_distances = [];
    dist_from_ext = [];
    marker_dist = [];
    refDist = 0;
    
    fnames = fieldnames(dh_pars);
    count = 1;
    for field=1:length(fnames)
        new_count = count + length(whitelist.(fnames{field})(whitelist.(fnames{field}) == 1));
        dh_pars.(fnames{field})(whitelist.(fnames{field})==1) = opt_pars(count:new_count-1);
        count = new_count;
    end
    
    if(optim.type.selftouch)
        distances = getDist(dh_pars, robot, dataset.dist, optim);
        refDist = dataset.dist{end}.refDist;
    end
    if(optim.type.planes)
        plane_distances = getDistFromPlane(dh_pars, robot, dataset.plane, optim);
    end
    if(optim.type.external)
        dist_from_ext = getDistFromExt(dh_pars, robot, dataset.ext, optim);
    end
    if(optim.type.eyes)
        marker_dist = getPositionFromEyes(dh_pars, robot, dataset.markers, optim);
    end
    
    error_vec = [(distances - refDist)*optim.type.selftouch, ...
        plane_distances*optim.type.planes, dist_from_ext*optim.type.external, ...
        marker_dist*optim.type.eyes];
end

