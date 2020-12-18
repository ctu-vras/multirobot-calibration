function runCalibration(robot_fcn, config_fcn, approaches, chains, linkTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadKinfunc, loadKinargs, loadKinfolder)
    % RUNCALIBRATION - prepares structures for calibration
    %    INPUT - robot_fcn - string, name of the robot functon
    %          - config_fcn - string, name of the config function
    %          - approches - cell array of strings, name of used approaches
    %          - chains - cell array of strings, name of calibrated chains
    %          - linkTypes - cell array of strings, name of used link types
    %          - dataset_fcn - string, name of dataset function
    %          - whhitelist_fcn - string, name of whitelist function
    %          - bounds_fcn, string, name of bounds_fcn
    %          - dataset_params - cell array, arguments for dataset function
    %          - folder - string, name of results folder
    %          - saveInfo - [0/1, 0/1, 0/1], to save given files
    %          - loadKinfunc - string, name of load kinematics function (loadKinfromMat,
    %                         loadKinfromTXT)
    %          - loadKinargs - cell array, arguments for kinematics function
    %          - loadKinfolder - string, name of folder with results for load kinematics
    %                           function
    
    
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
    
    
    %% preparation
    assert(~isempty(robot_fcn) && ~isempty(config_fcn) && ~isempty(dataset_fcn),'Empty name of robot, config or dataset function')
    rob = Robot(robot_fcn);
    
    [config.options, config.chains, config.approach, config.linkTypes, config.optim, config.pert] = loadConfig(config_fcn, approaches, chains, linkTypes);
    if ~isempty(loadKinfolder)
        loadKinfunc=str2func(loadKinfunc);
        loadKinfunc(rob, loadKinfolder, loadKinargs{:});
    end
    
    if ~isempty(bounds_fcn)
        [start_dh, lb_dh, ub_dh] = rob.prepareKinematics(config.pert, config.optim,bounds_fcn);
    else
        [start_dh, lb_dh, ub_dh] = rob.prepareKinematics(config.pert, config.optim);
    end
    
    if ~isempty(whitelist_fcn)
        [whpars.start_pars, whpars.min_pars, whpars.max_pars, whpars.whitelist, whpars.start_dh] = rob.createWhitelist(start_dh, lb_dh, ub_dh, config.optim, config.chains, config.linkTypes, whitelist_fcn);
    else
        [whpars.start_pars, whpars.min_pars, whpars.max_pars, whpars.whitelist, whpars.start_dh] = rob.createWhitelist(start_dh, lb_dh, ub_dh, config.optim, config.chains, config.linkTypes);
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