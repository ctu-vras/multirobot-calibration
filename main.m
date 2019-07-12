clear all
clc
robot_fcn = 'loadNAO';
dataset_fcn = 'loadDatasetNao';
config_fcn = 'optimizationConfig';
whitelist_fcn = 'loadNaoWL';
bounds_fcn='loadMotomanBounds';
datasetsNames={'rightArm_torso'};
% robot_fcn = 'loadMotoman';
% dataset_fcn = 'loadDatasetMotoman';
% config_fcn = 'optimizationConfig';
% whitelist_fcn = 'loadMotomanWL';
% bounds_fcn='loadMotomanBounds';
folder = 'bla3';
saveInfo = true;
rob = robot(robot_fcn);
[options, chains, optim, pert] = loadConfig(config_fcn);

%loadDHfromMat(rob, 'bla3', 'type','min')
%loadDHfromTxt(rob,'bla3', 'DH-rep1-pert1');
[start_dh, lb_dh, ub_dh] = rob.prepareDH(pert, optim);

[start_pars, min_pars, max_pars, whitelist, start_dh] = rob.createWhitelist(start_dh, lb_dh, ub_dh, optim, whitelist_fcn);

[training_set_indexes, testing_set_indexes, datasets] = rob.prepareDataset(optim, dataset_fcn,rob,start_dh,datasetsNames);

%%

opt_pars = zeros(size(start_pars, 1), optim.repetitions, optim.pert_levels);
jacobians = cell(1, optim.repetitions, optim.pert_levels);
fnames = fieldnames(start_dh);
tic
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
         obj_func = @(pars)errors_fcn(pars, dh, rob, whitelist, tr_datasets, optim);
         
         sprintf('%f percent done', 100*((pert_level-1)*optim.repetitions + rep - 1)/(optim.pert_levels*optim.repetitions))
         % optimization        
         [opt_result, RESNORM, RESIDUAL, EXITFLAG, OUTPUT, LAMBDA, jacobians{rep, pert_level}] = ...
         lsqnonlin(obj_func, pars, lb_pars, up_pars, options);  
         opt_pars(:, rep, pert_level) = opt_result';
         opt_result
    end
end
toc
%%
[res_dh, corrs_dh] = getResultDH(opt_pars, start_dh, whitelist, optim);
before_tr_err = rmsErrors(start_dh, rob, datasets, training_set_indexes, optim);
after_tr_err = rmsErrors(res_dh, rob, datasets, training_set_indexes, optim);
before_ts_err = rmsErrors(start_dh, rob, datasets, testing_set_indexes, optim);
after_ts_err = rmsErrors(res_dh, rob, datasets, testing_set_indexes, optim);
%%
outfolder = ['results/', folder, '/'];
saveResults(rob, outfolder, res_dh, corrs_dh, before_tr_err, after_tr_err, before_ts_err, after_ts_err, optim);
vars_to_save = {'start_dh', 'rob', 'whitelist', 'options', 'pert', 'chains', 'robot_fcn', 'dataset_fcn', ...
    'config_fcn', 'training_set_indexes', 'testing_set_indexes', 'optim'};
if(saveInfo)
    save([outfolder, 'info.mat'], vars_to_save{:}, '-append');
end