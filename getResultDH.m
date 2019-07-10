function [results, corrs] = getResultDH(opt_pars, start_dh, whitelist, optim)
%SAVERESULTS Summary of this function goes here
%   Detailed explanation goes here
    % log result
    results = start_dh;
    corrs = start_dh;
    fnames = fieldnames(start_dh);
    count = 1;
    for field=1:length(fnames)
        if(any(any(whitelist.(fnames{field}))))
            new_count = count + sum(sum(whitelist.(fnames{field})));
            wh = repmat(whitelist.(fnames{field}),1,1,optim.repetitions, optim.pert_levels);
            results.(fnames{field})(wh) = opt_pars(count:new_count-1,:,:);
            count = new_count;
        end
        corrs.(fnames{field}) = results.(fnames{field})-corrs.(fnames{field}); % TODO: wrap to pi
    end
end

