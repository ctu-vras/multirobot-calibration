function [rms_errors] = rmsErrors(start_dh, robot, datasets, dataset_indexes, optim)
%RMSERRORS Summary of this function goes here
%   Detailed explanation goes here
    rms_distances = nan(1,optim.pert_levels*optim.repetitions);
    rms_plane_distances = nan(1,optim.pert_levels*optim.repetitions);
    rms_dist_from_ext = nan(1,optim.pert_levels*optim.repetitions);
    rms_marker_dist = nan(1,optim.pert_levels*optim.repetitions);
    optim.useNorm=1;
    fnames = fieldnames(start_dh);
    for pert_level = 1:optim.pert_levels
        for rep = 1:optim.repetitions
            dataset = getDatasetPart(datasets, dataset_indexes{rep});
            for field = 1:length(fnames)
                dh_pars.(fnames{field}) = start_dh.(fnames{field})(:,:, rep, pert_level);
            end
            
            if(optim.type.selftouch)
                distances = getDist(dh_pars, robot, dataset.dist, optim);
                refDist = dataset.dist{end}.refDist;
                rms_distances(rep+(pert_level-1)*optim.repetitions) = sqrt(sum((distances-refDist).^2)/size(distances, 2));

            end
            if(optim.type.planes)
                plane_distances = getDistFromPlane(dh_pars, robot, dataset.plane, optim);
                rms_plane_distances(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(plane_distances.^2)/size(plane_distances, 2));
            end
            if(optim.type.external)
                dist_from_ext = getDistFromExt(dh_pars, robot, dataset.ext, optim);
                rms_dist_from_ext(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(dist_from_ext.^2)/size(dist_from_ext, 2));
            end
            if(optim.type.eyes)
                marker_dist = getProjectionDist(dh_pars, robot, dataset.markers, optim);
                rms_marker_dist(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(marker_dist.^2)/size(marker_dist, 2));
            end
        end
    end
    rms_errors = [rms_distances; rms_plane_distances; rms_dist_from_ext; rms_marker_dist];
end
