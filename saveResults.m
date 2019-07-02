function saveResults(outfolder,res_dh,corrs_dh, before_tr_err, after_tr_err, before_ts_err, after_ts_err, optim, varargin)
%SAVERESULTS Summary of this function goes here
%   Detailed explanation goes here
errors = nan(16,optim.repetitions * optim.pert_levels);
if(~isempty(before_tr_err))
    errors(1:4,:) = before_tr_err;
end
if(~isempty(after_tr_err))
    errors(5:8,:) = after_tr_err;
end
if(~isempty(before_ts_err))
    errors(9:12,:) = before_ts_err;
end
if(~isempty(after_ts_err))
    errors(13:16,:) = after_ts_err;
end

s = mkdir(outfolder);
assert(s, 'Could not make folder');
save([outfolder, 'results.mat'], 'res_dh');
save([outfolder, 'corrections.mat'], 'corrs_dh');
save([outfolder, 'errors.mat'], 'errors');
save([outfolder, 'info.mat'], 'optim');
end

