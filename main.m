rob = robot('loadMotoman');
[options, chains, optim, pert] = optimizationConfig();
[training_set_indexes, testing_set_indexes, datasets] = rob.prepareDataset(optim, 'loadDatasetMotoman');

[start_dh, lb_dh, ub_dh] = rob.prepareDH(pert, 'uniform', optim);

[start_pars, min_pars, max_pars] = rob.createWhitelist(start_dh, lb_dh, ub_dh, optim);

opt_pars = zeros(size(start_pars, 1), optim.repetitions, 1+length(optim.pert(optim.pert==1)));

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

%         % objective function setup
%         obj_func = @(opt_par)error2d3d_new(opt_par, working_dh, tr_datasets, markers_tfs, camera, opt_whitelist, optimize_using_cameras, optimize_using_touch, optimize_using_table, optimize_using_leica, use_mixed_notation, planes);         
% %        % sprintf('%f percent done', 100*((ran-1)*repetitions + rep - 1)/(size(perturbation_ranges, 2)*repetitions))
% %         
%         % optimization        
%         [opt_result, RESNORM, RESIDUAL, EXITFLAG, OUTPUT, LAMBDA, JACOBIAN] = ...
%         lsqnonlin(obj_func, start_pars(:,rep,pert_level), lb_pars, up_pars, options);  
%      
%         opt_pars(:, rep, pert_level) = opt_result';
    end
end