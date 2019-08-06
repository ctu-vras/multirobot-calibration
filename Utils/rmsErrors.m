function [rms_errors, errors_all] = rmsErrors(dh, robot, datasets, dataset_indexes, optim, approach)
%RMSERRORS Compute rms errors
%   Function computes rms errors and individual errors and return them
%INPUT - dh - DH parameters for all repetititons and perturbations
%      - robot - Robot object
%      - datasets - dataset structure
%      - dataset_indexes - poses to use from datasets
%      - optim - calibration settings
%      - approach -calibration approach
%OUTPUT - rms_errors - rms errors
%       - errors_all - individual errors
    rms_distances = nan(1,optim.pert_levels*optim.repetitions);
    rms_plane_distances = nan(1,optim.pert_levels*optim.repetitions);
    rms_dist_from_ext = nan(1,optim.pert_levels*optim.repetitions);
    rms_marker_dist = nan(1,optim.pert_levels*optim.repetitions);
    distances_all = {};
    plane_distances_all = {};
    dist_from_ext_all = {};
    marker_dist_all = {};
    
    optim.useNorm=1;
    fnames = fieldnames(dh);
    for pert_level = 1:optim.pert_levels
        for rep = 1:optim.repetitions
            % slice dataset
            dataset = getDatasetPart(datasets, dataset_indexes{rep});
            % select corresponding dh parameters
            for field = 1:length(fnames)
                dh_pars.(fnames{field}) = dh.(fnames{field})(:,:, rep, pert_level);
            end
             %% Call appropriate functions if given approach is enabled and save errors
            if(approach.selftouch)
                distances = getDist(dh_pars, robot, dataset.dist, optim);
                refDist = dataset.dist{end}.refDist;
                distances_all{end+1} = (distances-refDist);
                rms_distances(rep+(pert_level-1)*optim.repetitions) = sqrt(sum((distances-refDist).^2)/size(distances, 2));
            end
            if(approach.planes)
                plane_distances = getPlaneDist(dh_pars, robot, dataset.plane, []);
                plane_distances_all{end+1} = plane_distances;
                rms_plane_distances(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(plane_distances.^2)/size(plane_distances, 2));
            end
            if(approach.external)
                dist_from_ext = getDistFromExt(dh_pars, robot, dataset.ext, optim, []);
                dist_from_ext_all{end+1} = dist_from_ext;
                rms_dist_from_ext(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(dist_from_ext.^2)/size(dist_from_ext, 2));
            end
            if(approach.eyes)
                marker_dist = getProjectionDist(dh_pars, robot, dataset.proj);
                marker_dist_all{end+1} = marker_dist;
                rms_marker_dist(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(marker_dist.^2)/size(marker_dist, 2));
            end
        end
    end
    rms_errors = [rms_distances; rms_plane_distances; rms_dist_from_ext; rms_marker_dist];
    errors_all = {distances_all, plane_distances_all, dist_from_ext_all, marker_dist_all};
end

