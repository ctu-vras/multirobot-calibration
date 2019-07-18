function [ error_vec ] = errors_fcn( opt_pars, dh_pars, robot, whitelist, dataset, optim, approach)
%ERRORS_FCN Summary of this function goes here
%   Detailed explanation goes here
    distances = [];
    plane_distances = [];
    dist_from_ext = [];
    proj_dist = [];
    refDist = 0;
    
    fnames = fieldnames(dh_pars);
    count = 1;
    for field=1:length(fnames)
        new_count = count + sum(sum(whitelist.(fnames{field})));
        a=dh_pars.(fnames{field})';
        a(whitelist.(fnames{field})') = opt_pars(count:new_count-1);
        dh_pars.(fnames{field})=a';
        count = new_count;
    end
    if(approach.selftouch)
        distances = getDist(dh_pars, robot, dataset.dist, optim);
        refDist = dataset.dist{end}.refDist;
    end
    if(approach.planes)
        plane_distances = getPlaneDist(dh_pars, robot, dataset.plane, optim);
    end
    if(approach.external)
        dist_from_ext = getDistFromExt(dh_pars, robot, dataset.ext, optim);
    end
    if(approach.eyes)
        proj_dist = getProjectionDist(dh_pars, robot, dataset.proj, optim);
    end
    
    error_vec = [(distances - refDist)*approach.selftouch, ...
        plane_distances*approach.planes, dist_from_ext*approach.external, ...
        proj_dist*approach.eyes];
end

