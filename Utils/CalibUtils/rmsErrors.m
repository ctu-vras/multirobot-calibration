function [rms_errors, errors_all] = rmsErrors(kinematics, robot, datasets, dataset_indexes, optim, approach)
    %RMSERRORS Compute rms errors
    %   Function computes rms errors and individual errors and return them
    %INPUT - kinematics - kinematics parameters for all repetititons and perturbations
    %      - robot - Robot object
    %      - datasets - dataset structure
    %      - dataset_indexes - poses to use from datasets
    %      - optim - calibration settings
    %      - approach -calibration approach
    %OUTPUT - rms_errors - rms errors
    %       - errors_all - individual errors
    
    
    % Copyright (C) 2019-2021  Jakub Rozlivek and Lukas Rustler
    % Department of Cybernetics, Faculty of Electrical Engineering, 
    % Czech Technical University in Prague
    %
    % This file is part of Multisensorial robot calibration toolbox (MRC).
    % 
    % MRC is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Lesser General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % MRC is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Lesser General Public License for more details.
    % 
    % You should have received a copy of the GNU Leser General Public License
    % along with MRC.  If not, see <http://www.gnu.org/licenses/>.
    
    
    rms_distances = nan(1,optim.pert_levels*optim.repetitions);
    rms_plane_distances = nan(1,optim.pert_levels*optim.repetitions);
    rms_dist_from_ext = nan(1,optim.pert_levels*optim.repetitions);
    rms_marker_dist = nan(1,optim.pert_levels*optim.repetitions);
    distances_all = {};
    plane_distances_all = {};
    dist_from_ext_all = {};
    marker_dist_all = {};
    
    optim.useNorm=1;
    fnames = fieldnames(kinematics);
    for pert_level = 1:optim.pert_levels
        for rep = 1:optim.repetitions
            % slice dataset
            dataset = getDatasetPart(datasets, dataset_indexes{rep});
            % select corresponding kinematics parameters
            for field = 1:length(fnames)
                dh_pars.(fnames{field}) = kinematics.(fnames{field})(:,:, rep, pert_level);
            end
             %% Call appropriate functions if given approach is enabled and save errors
            if(approach.selftouch)
                distances = getDist(dh_pars, robot, dataset.selftouch, optim);
                refDist = dataset.selftouch{end}.refDist;
                distances_all{end+1} = (distances-refDist);
                rms_distances(rep+(pert_level-1)*optim.repetitions) = sqrt(sum((distances-refDist).^2)/size(distances, 2))/optim.unitsCoef;
            end
            if(approach.planes)
                plane_distances = getPlaneDist(dh_pars, robot, dataset.planes, []);
                plane_distances_all{end+1} = plane_distances;
                rms_plane_distances(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(plane_distances.^2)/size(plane_distances, 2))/optim.unitsCoef;
            end
            if(approach.external)
                dist_from_ext = getDistFromExt(dh_pars, robot, dataset.external, optim, []);
                dist_from_ext_all{end+1} = dist_from_ext;
                rms_dist_from_ext(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(dist_from_ext.^2)/size(dist_from_ext, 2))/optim.unitsCoef;
            end
            if(approach.projection)
                marker_dist = getProjectionDist(dh_pars, robot, dataset.projection);
                marker_dist_all{end+1} = marker_dist;
                rms_marker_dist(rep+(pert_level-1)*optim.repetitions) = sqrt(sum(marker_dist.^2)/size(marker_dist, 2));
            end
        end
    end
    rms_errors = [rms_distances; rms_plane_distances; rms_dist_from_ext; rms_marker_dist];
    errors_all = {distances_all, plane_distances_all, dist_from_ext_all, marker_dist_all};
end

