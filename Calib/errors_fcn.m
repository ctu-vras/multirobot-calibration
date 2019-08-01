function [ error_vec ] = errors_fcn( opt_pars, dh_pars, robot, whitelist, dataset, optim, approach)
%ERRORS_FCN returns vector of vector of errors for all types of calibration
%   INPUT - opt_pars - 1xN vector of optimized parameters
%         - dh_pars - structure with DH parameters, where field names corresponding to names of
%                     the 'groups' in robot. Each group is 4D array.
%         - robot - instance of @Robot class
%         - whitelist - structure with 1/0, where field names corresponding to names of
%                       the 'groups' in robot. Each group is 4D array.
%         - dataset - structure of dataset, where field names are {dist,
%                     plane, ext, proj} and and each field is 1xN cellArray
%         - optim - structure of calibration settings
%         - approach - structure of settings for each calibration approach
%   OUTPUT - error_vec - MxN array of distance;
%                        M=1 if optim.useNorm, M=3 if ~optim.useNorm;
%                        N is number of errors from all types of calib

    % Create matrices
    distances = [];
    plane_distances = [];
    dist_from_ext = [];
    proj_dist = [];
    refDist = 0;
    
    % Add optimized parameters from solver back to dh_pars
    fnames = fieldnames(dh_pars);
    count = 1;
    for field=1:length(fnames)
        % find indexes of params
        new_count = count + sum(sum(whitelist.(fnames{field})));
        a=dh_pars.(fnames{field})';
        % append pars to their place
        a(whitelist.(fnames{field})') = opt_pars(count:new_count-1);
        % append back to dh_pars
        dh_pars.(fnames{field})=a';
        count = new_count;
    end
    %% Call appropriate functions if given approach is enabled
    if(approach.selftouch)
        distances = getDist(dh_pars, robot, dataset.dist, optim);
        refDist = dataset.dist{end}.refDist;
    end
    if(approach.planes)
        plane_distances = getPlaneDist(dh_pars, robot, dataset.plane);
    end
    if(approach.external)
        dist_from_ext = getDistFromExt(dh_pars, robot, dataset.ext, optim);
    end
    if(approach.eyes)
        proj_dist = getProjectionDist(dh_pars, robot, dataset.proj);
    end
    
    % concat all results into output variable, with right scalling
    error_vec = [(distances - refDist)*approach.selftouch, ...
        plane_distances*approach.planes, dist_from_ext*approach.external, ...
        proj_dist*approach.eyes];
end

