function runCalibration(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder)
    %% preparation
    assert(~isempty(robot_fcn) && ~isempty(config_fcn) && ~isempty(dataset_fcn),'Empty name of robot, config or dataset function')
    rob = Robot(robot_fcn);
    
    [options, chains, approach, jointTypes, optim, pert] = loadConfig(config_fcn, approaches, chains, jointTypes);
    if ~isempty(loadDHfolder)
        loadDHfunc=str2func(loadDHfunc);
        loadDHfunc(rob, loadDHfolder, loadDHargs{:});
    end
    
    if ~isempty(bounds_fcn)
        [start_dh, lb_dh, ub_dh] = rob.prepareDH(pert, optim,bounds_fcn);
    else
        [start_dh, lb_dh, ub_dh] = rob.prepareDH(pert, optim);
    end
    
    if ~isempty(whitelist_fcn)
        [start_pars, min_pars, max_pars, whitelist, start_dh] = rob.createWhitelist(start_dh, lb_dh, ub_dh, optim, chains, jointTypes, whitelist_fcn);
    else
        [start_pars, min_pars, max_pars, whitelist, start_dh] = rob.createWhitelist(start_dh, lb_dh, ub_dh, optim, chains, jointTypes);
    end
    
    if ~isempty(dataset_fcn) && iscell(dataset_params)
        [training_set_indexes, testing_set_indexes, datasets, datasets_out] = rob.prepareDataset(optim, chains, dataset_fcn,dataset_params);
    else
        [training_set_indexes, testing_set_indexes, datasets, datasets_out] = rob.prepareDataset(optim, chains, dataset_fcn);
    end
    
    %% calibration
    parsCount = size(start_pars, 1);
    if optim.optimizeInitialGuess 
        if (approach.external)
            parsCount = parsCount+length(datasets.external)*optim.externalParams;
        end
        if(approach.planes)
            parsCount = parsCount+length(datasets.planes)*optim.planeParams;
        end
    end
    options = weightRobotParameters(whitelist, options, parsCount,optim);
    opt_pars = zeros(parsCount, optim.repetitions, optim.pert_levels);
    ext_pars_init = zeros(parsCount-size(start_pars,1), optim.repetitions, optim.pert_levels);
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
                lb_pars = min_pars(:,rep, pert_level);
                up_pars = max_pars(:,rep, pert_level);
            end

            tr_datasets = getDatasetPart(datasets, training_set_indexes{rep});
            for field = 1:length(fnames)
               dh.(fnames{field}) = start_dh.(fnames{field})(:,:, rep, pert_level);
            end
            % objective function setup
            if(optim.optimizeDifferences)
                pars = zeros(1, parsCount);
            else
                pars=start_pars(:,rep,pert_level)';
            end
            initialParamValues = [];
            if optim.optimizeInitialGuess && (approach.planes || approach.external) 
                [params, typicalX]=initialGuess(rob, tr_datasets, dh, approach, optim);
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
                calibOut.lambdas{1,rep, pert_level}, jacobians{1,rep, pert_level}] = ...
            lsqnonlin(obj_func, pars, lb_pars, up_pars, options);  
            opt_pars(:, rep, pert_level) = opt_result';
            obsIndexes(rep, pert_level) = computeObservability(jacobians{1,rep, pert_level}, length(training_set_indexes{rep}));
        end
    end
    %% evaluation
    [res_dh, corrs_dh] = getResultDH(rob, opt_pars, start_dh, whitelist, optim);
    [before_tr_err,before_tr_err_all] = rmsErrors(start_dh, rob, datasets, training_set_indexes, optim, approach);
    [after_tr_err,after_tr_err_all] = rmsErrors(res_dh, rob, datasets, training_set_indexes, optim, approach);
    [before_ts_err,before_ts_err_all] = rmsErrors(start_dh, rob, datasets, testing_set_indexes, optim, approach);
    [after_ts_err,after_ts_err_all] = rmsErrors(res_dh, rob, datasets, testing_set_indexes, optim, approach);
    
    %% unpad all variables to default state
    res_dh = unpadVectors(res_dh, rob);
    start_dh = unpadVectors(start_dh, rob);
    whitelist = unpadVectors(whitelist, rob);
    corrs_dh = unpadVectors(corrs_dh, rob);
    rob.structure.DH = unpadVectors(rob.structure.DH, rob);
    %% saving results
    outfolder = ['Results/', folder, '/'];
    ext_pars_result = opt_pars(size(start_pars,1)+1:end,:,:);
    saveResults(rob, outfolder, res_dh, corrs_dh, before_tr_err, after_tr_err, before_ts_err, after_ts_err, before_tr_err_all, after_tr_err_all, before_ts_err_all, after_ts_err_all, chains, approach, jointTypes, optim, options, robot_fcn, dataset_fcn, config_fcn, dataset_params);
    vars_to_save = {'start_dh', 'rob', 'whitelist', 'pert', 'chains', ...
        'training_set_indexes', 'testing_set_indexes', 'calibOut', ...
        'ext_pars_init', 'ext_pars_result', 'obsIndexes'};
    if saveInfo(1)
        save([outfolder, 'info.mat'], vars_to_save{:}, '-append');
    end
    if saveInfo(2)
       save([outfolder, 'jacobians.mat'], 'jacobians');
    end
    if saveInfo(3)
       save([outfolder, 'datasets.mat'], 'datasets_out')
    end
end