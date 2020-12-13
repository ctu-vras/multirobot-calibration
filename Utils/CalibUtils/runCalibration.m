function runCalibration(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder)
    %% preparation
    assert(~isempty(robot_fcn) && ~isempty(config_fcn) && ~isempty(dataset_fcn),'Empty name of robot, config or dataset function')
    rob = Robot(robot_fcn);
    
    [config.options, config.chains, config.approach, config.jointTypes, config.optim, config.pert] = loadConfig(config_fcn, approaches, chains, jointTypes);
    if ~isempty(loadDHfolder)
        loadDHfunc=str2func(loadDHfunc);
        loadDHfunc(rob, loadDHfolder, loadDHargs{:});
    end
    
    if ~isempty(bounds_fcn)
        [start_dh, lb_dh, ub_dh] = rob.prepareDH(config.pert, config.optim,bounds_fcn);
    else
        [start_dh, lb_dh, ub_dh] = rob.prepareDH(config.pert, config.optim);
    end
    
    if ~isempty(whitelist_fcn)
        [whpars.start_pars, whpars.min_pars, whpars.max_pars, whpars.whitelist, whpars.start_dh] = rob.createWhitelist(start_dh, lb_dh, ub_dh, config.optim, config.chains, config.jointTypes, whitelist_fcn);
    else
        [whpars.start_pars, whpars.min_pars, whpars.max_pars, whpars.whitelist, whpars.start_dh] = rob.createWhitelist(start_dh, lb_dh, ub_dh, config.optim, config.chains, config.jointTypes);
    end
    
    if ~isempty(dataset_fcn) && iscell(dataset_params)
        [data.training_set_indexes, data.testing_set_indexes, data.datasets, datasets_out] = rob.prepareDataset(config.optim, config.chains, config.approach, dataset_fcn,dataset_params);
    else
        [data.training_set_indexes, data.testing_set_indexes, data.datasets, datasets_out] = rob.prepareDataset(config.optim, config.chains, config.approach, dataset_fcn);
    end
    saveData.robot_fcn = robot_fcn;
    saveData.config_fcn = config_fcn;
    saveData.dataset_fcn = dataset_fcn;
    saveData.dataset_params = dataset_params;
    internalCalibration(rob, config, whpars, data, folder, saveInfo, saveData);
    if saveInfo(3)
       save(['Results/', folder,  '/datasets.mat'], 'datasets_out')
    end
end