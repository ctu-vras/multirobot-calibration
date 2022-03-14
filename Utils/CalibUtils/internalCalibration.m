function internalCalibration(rob, config, whpars, data, folder, saveInfo, saveData)
    % INTERNALCALIBRATION - function defining calibration problem and running it
    %    INPUT - rob - instance of @Robot class
    %          - config - structure of configuration - (optim, chains...)
    %          - whpars - structure of whitelist parameters
    %          - data - structure with datasets and training/testing indexes
    %          - folder - folder to which save the results
    %          - saveInfo - [0/1, 0/1, 0/1] 
    %          - saveData - structure with filenames of loaded function
    
    
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
    
    
    %% calibration
    whitelist = whpars.whitelist;
    start_dh = whpars.start_dh;
    options = config.options;
    chains = config.chains;
    approach = config.approach;
    linkTypes = config.linkTypes;
    optim = config.optim;
    
    parsCount = size(whpars.start_pars, 1);
    if optim.optimizeInitialGuess 
        if (approach.external)
            parsCount = parsCount+length(data.datasets.external)*optim.externalParams;
        end
        if(approach.planes)
            parsCount = parsCount+length(data.datasets.planes)*optim.planeParams;
        end
    end
    assert(parsCount, 'Vector of calibrated parameters is empty! Check your settings.');
    options = weightRobotParameters(whitelist, options, parsCount,optim);
    opt_pars = zeros(parsCount, optim.repetitions, optim.pert_levels);
    ext_pars_init = zeros(parsCount-size(whpars.start_pars,1), optim.repetitions, optim.pert_levels);
    jacobians = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.resnorms = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.residuals = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.exitFlags = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.outputs = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.lambdas = cell(1, optim.repetitions, optim.pert_levels);
    obsIndexes = struct('Dopt', cell(optim.repetitions, optim.pert_levels), ...
        'Ecc', cell(optim.repetitions, optim.pert_levels), ...
        'Min', cell(optim.repetitions, optim.pert_levels), ...
        'O4', cell(optim.repetitions, optim.pert_levels));
    fnames = fieldnames(start_dh);
    for pert_level = 1+optim.skipNoPert:optim.pert_levels
        for rep = 1:optim.repetitions    
            % levenberg-marquardt is incompatible with constrains, remove them
            if ~optim.bounds || strcmpi(options.Algorithm, 'levenberg-marquardt')
                lb_pars = [];
                up_pars = [];
            else
                lb_pars = whpars.min_pars(:,rep, pert_level);
                up_pars = whpars.max_pars(:,rep, pert_level);
            end

            tr_datasets = getDatasetPart(data.datasets, data.training_set_indexes{rep});
            for field = 1:length(fnames)
               kinematics.(fnames{field}) = start_dh.(fnames{field})(:,:, rep, pert_level);
            end
            % objective function setup
            if(optim.optimizeDifferences)
                pars = zeros(1, parsCount);
            else
                pars=whpars.start_pars(:,rep,pert_level)';
            end
            initialParamValues = [];
            if optim.optimizeInitialGuess && (approach.planes || approach.external) 
                [params, typicalX]=initialGuess(tr_datasets, kinematics, approach, optim, robot.structure.type);
                options.TypicalX(end-length(params)+1:end) = typicalX;
                if(optim.optimizeDifferences)
                    initialParamValues = params;
                else
                    pars=[pars,params];
                end
                ext_pars_init(:, rep, pert_level) = params;
            end

            obj_func = @(pars)errors_fcn(pars, kinematics, rob, whitelist, tr_datasets, optim, approach, initialParamValues);
            sprintf('%f percent done', 100*((pert_level-1-optim.skipNoPert)*optim.repetitions + rep - 1)/((optim.pert_levels-optim.skipNoPert)*optim.repetitions))
            % optimization        
            [opt_result, calibOut.resnorms{1,rep, pert_level}, calibOut.residuals{1,rep, pert_level},...
                calibOut.exitFlags{1,rep, pert_level}, calibOut.outputs{1,rep, pert_level}, ...
                calibOut.lambdas{1,rep, pert_level}, jac] = ...
            lsqnonlin(obj_func, pars, lb_pars, up_pars, options);  
            opt_pars(:, rep, pert_level) = opt_result';
            jacobians{1, rep, pert_level} = full(jac);
            obsIndexes(rep, pert_level) = computeObservability(jacobians{1,rep, pert_level}, length(data.training_set_indexes{rep}));
        end
    end
    %% evaluation
    [res_dh, corrs_dh, start_dh] = getResultKinematics(rob, opt_pars, start_dh, whitelist, optim);
    
    errors = nan(16,optim.repetitions * optim.pert_levels);    
    errorsAll = cell(16,1);
    [errors(1:4,:), errorsAll(1:4)] = rmsErrors(start_dh, rob, data.datasets, data.training_set_indexes, optim, approach);  % before calib on training data
    [errors(5:8,:), errorsAll(5:8)] = rmsErrors(res_dh, rob, data.datasets, data.training_set_indexes, optim, approach);    % after calib on training data
    [errors(9:12,:), errorsAll(9:12)] = rmsErrors(start_dh, rob, data.datasets, data.testing_set_indexes, optim, approach); % before calib on testing data
    [errors(13:16,:), errorsAll(13:16)] = rmsErrors(res_dh, rob, data.datasets, data.testing_set_indexes, optim, approach); % after calib on testing data

    %% unpad all variables to default state
    res_dh = unpadVectors(res_dh, rob.structure.kinematics, rob.structure.type);
    start_dh = unpadVectors(start_dh, rob.structure.kinematics, rob.structure.type);
    whitelist = unpadVectors(whitelist, rob.structure.kinematics, rob.structure.type);
    corrs_dh = unpadVectors(corrs_dh, rob.structure.kinematics, rob.structure.type);
    rob.structure.kinematics = unpadVectors(rob.structure.kinematics, rob.structure.kinematics, rob.structure.type);
    rob.structure.defaultKinematics = unpadVectors(rob.structure.defaultKinematics, rob.structure.defaultKinematics, rob.structure.type);
    %% saving results
    outfolder = ['Results/', folder, '/'];
    ext_pars_result = opt_pars(size(whpars.start_pars,1)+1:end,:,:);
    
    saveResults(rob, outfolder, res_dh, corrs_dh, errors, errorsAll, whitelist, chains, approach, linkTypes, optim, options, obsIndexes, saveData.robot_fcn, saveData.dataset_fcn, saveData.config_fcn, saveData.dataset_params);
    
    if saveInfo(1)
        vars_to_save = {'start_dh', 'pert', ...
        'training_set_indexes', 'testing_set_indexes', 'calibOut', ...
        'ext_pars_init', 'ext_pars_result'};
        testing_set_indexes = data.testing_set_indexes;
        training_set_indexes = data.training_set_indexes;
        pert = config.pert;
        save([outfolder, 'info.mat'], vars_to_save{:}, '-append');
    end
    if saveInfo(2)
       save([outfolder, 'jacobians.mat'], 'jacobians', '-v7.3');
    end
    addpath(outfolder);
end