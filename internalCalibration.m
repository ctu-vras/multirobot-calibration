function internalCalibration(rob, config, whpars, data, folder, saveInfo, saveData)
    %% calibration
    whitelist = whpars.whitelist;
    start_dh = whpars.start_dh;
    options = config.options;
    chains = config.chains;
    approach = config.approach;
    jointTypes = config.jointTypes;
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
               dh.(fnames{field}) = start_dh.(fnames{field})(:,:, rep, pert_level);
            end
            % objective function setup
            if(optim.optimizeDifferences)
                pars = zeros(1, parsCount);
            else
                pars=whpars.start_pars(:,rep,pert_level)';
            end
            initialParamValues = [];
            if optim.optimizeInitialGuess && (approach.planes || approach.external) 
                [params, typicalX]=initialGuess(rob.structure.H0, tr_datasets, dh, approach, optim);
                options.TypicalX(end-length(params)+1:end) = typicalX;
                if(optim.optimizeDifferences)
                    initialParamValues = params;
                else
                    pars=[pars,params];
                end
                ext_pars_init(:, rep, pert_level) = params;
            end

            obj_func = @(pars)errors_fcn(pars, dh, rob, whitelist, tr_datasets, optim, approach, initialParamValues);
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
    [res_dh, corrs_dh, start_dh] = getResultDH(rob, opt_pars, start_dh, whitelist, optim);
    
    errors = nan(16,optim.repetitions * optim.pert_levels);    
    errorsAll = cell(16,1);
    [errors(1:4,:), errorsAll(1:4)] = rmsErrors(start_dh, rob, data.datasets, data.training_set_indexes, optim, approach);  % before calib on training data
    [errors(5:8,:), errorsAll(5:8)] = rmsErrors(res_dh, rob, data.datasets, data.training_set_indexes, optim, approach);    % after calib on training data
    [errors(9:12,:), errorsAll(9:12)] = rmsErrors(start_dh, rob, data.datasets, data.testing_set_indexes, optim, approach); % before calib on testing data
    [errors(13:16,:), errorsAll(13:16)] = rmsErrors(res_dh, rob, data.datasets, data.testing_set_indexes, optim, approach); % after calib on testing data

    %% unpad all variables to default state
    res_dh = unpadVectors(res_dh, rob.structure.DH, rob.structure.type);
    start_dh = unpadVectors(start_dh, rob.structure.DH, rob.structure.type);
    whitelist = unpadVectors(whitelist, rob.structure.DH, rob.structure.type);
    corrs_dh = unpadVectors(corrs_dh, rob.structure.DH, rob.structure.type);
    rob.structure.DH = unpadVectors(rob.structure.DH, rob.structure.DH, rob.structure.type);
    rob.structure.defaultDH = unpadVectors(rob.structure.defaultDH, rob.structure.defaultDH, rob.structure.type);
    %% saving results
    outfolder = ['Results/', folder, '/'];
    ext_pars_result = opt_pars(size(whpars.start_pars,1)+1:end,:,:);
    
    saveResults(rob, outfolder, res_dh, corrs_dh, errors, errorsAll, whitelist, chains, approach, jointTypes, optim, options, saveData.robot_fcn, saveData.dataset_fcn, saveData.config_fcn, saveData.dataset_params);
    
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
end