function main(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder)
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
        [training_set_indexes, testing_set_indexes, datasets] = rob.prepareDataset(optim, chains, dataset_fcn,dataset_params);
    else
        [training_set_indexes, testing_set_indexes, datasets] = rob.prepareDataset(optim, chains, dataset_fcn);
    end
    
    %% calibration
    parsCount = size(start_pars, 1);
    if optim.optimizeInitialGuess
        parsCount = parsCount+length(datasets.plane)*optim.planeParams+length(datasets.ext)*optim.externalParams;
    end
    options = weightRobotParameters(whitelist, options, parsCount,optim);
    opt_pars = zeros(parsCount, optim.repetitions, optim.pert_levels);
        
    jacobians = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.resnorms = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.residuals = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.exitFlags = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.outputs = cell(1, optim.repetitions, optim.pert_levels);
    calibOut.lambdas = cell(1, optim.repetitions, optim.pert_levels);
    fnames = fieldnames(start_dh);
    for pert_level = 1:optim.pert_levels
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
            pars=start_pars(:,rep,pert_level)';
            if optim.optimizeInitialGuess && (approach.planes || approach.external) 
               [params, typicalX]=initialGuess(rob, tr_datasets, dh, approach, optim);
               pars=[pars,params];
               options.TypicalX(end-length(params)+1:end) = typicalX;
            end
            obj_func = @(pars)errors_fcn(pars, dh, rob, whitelist, tr_datasets, optim, approach);
            sprintf('%f percent done', 100*((pert_level-1)*optim.repetitions + rep - 1)/(optim.pert_levels*optim.repetitions))
            % optimization        
            [opt_result, calibOut.resnorms{1,rep, pert_level}, calibOut.residuals{1,rep, pert_level},...
                calibOut.exitFlags{1,rep, pert_level}, calibOut.outputs{1,rep, pert_level}, ...
                calibOut.lambdas{1,rep, pert_level}, jacobians{1,rep, pert_level}] = ...
            lsqnonlin(obj_func, pars, lb_pars, up_pars, options);  
            opt_pars(:, rep, pert_level) = opt_result';
        end
    end
    %% evaluation
    [res_dh, corrs_dh] = getResultDH(rob, opt_pars, start_dh, whitelist, optim);
    [before_tr_err,before_tr_err_all] = rmsErrors(start_dh, rob, datasets, training_set_indexes, optim, approach);
    [after_tr_err,after_tr_err_all] = rmsErrors(res_dh, rob, datasets, training_set_indexes, optim, approach);
    [before_ts_err,before_ts_err_all] = rmsErrors(start_dh, rob, datasets, testing_set_indexes, optim, approach);
    [after_ts_err,after_ts_err_all] = rmsErrors(res_dh, rob, datasets, testing_set_indexes, optim, approach);
    %% saving results
    outfolder = ['Results/', folder, '/'];
    saveResults(rob, outfolder, res_dh, corrs_dh, before_tr_err, after_tr_err, before_ts_err, after_ts_err, before_tr_err_all, after_tr_err_all, before_ts_err_all, after_ts_err_all, chains, approach, jointTypes, optim);
    vars_to_save = {'start_dh', 'rob', 'whitelist', 'options', 'pert', 'chains', 'robot_fcn', 'dataset_fcn', ...
        'config_fcn', 'training_set_indexes', 'testing_set_indexes', 'datasets', 'jacobians', 'calibOut'};
    if(saveInfo)
        save([outfolder, 'info.mat'], vars_to_save{:}, '-append');
    end
end