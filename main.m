rob = robot('loadMotoman');
[options, chains, optim, pert] = optimizationConfig();
[training_set_indexes, testing_set_indexes, datasets] = rob.prepareDataset(optim, 'loadDatasetMotoman');

[start_dh, lb_dh, ub_dh] = rob.prepareDH(pert, 'uniform', optim);

[start_pars, min_pars, max_pars] = rob.createWhitelist(start_dh, lb_dh, ub_dh, optim);
%%
opt_pars = zeros(size(start_pars, 1), optim.repetitions, 1+length(optim.pert(optim.pert==1)));
fnames = fieldnames(start_dh);
for pert_level = 1:(1+length(optim.pert(optim.pert==1)))
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
         pars=start_pars(:,rep,pert_level);
         obj_func = @(pars)errors_fcn(pars, dh, rob, rob.structure.WL, tr_datasets, optim);
         
         sprintf('%f percent done', 100*((pert_level-1)*optim.repetitions + rep - 1)/((1+length(optim.pert(optim.pert==1)))*optim.repetitions))
         % optimization        
         [opt_result, RESNORM, RESIDUAL, EXITFLAG, OUTPUT, LAMBDA, JACOBIAN] = ...
         lsqnonlin(obj_func, pars, lb_pars, up_pars, options);  
         opt_pars(:, rep, pert_level) = opt_result';
    end
end