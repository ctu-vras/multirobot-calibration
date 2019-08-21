function [results, corrs] = getResultDH(robot, opt_pars, start_dh, whitelist, optim)
%GETRESULTDH - Returns final DH parameters and correction of each run
%   INPUT - opt_pars - 1xN vector of optimized parameters
%         - start_dh - structure of DH parameters used in calibration;
%                      fields are names of 'groups', and each is 4D array
%         - whitelist - structure of whitelist; 
%                       fields are names of 'groups', and each is 4D array
%         - optim - optim - structure of calibration settings
%   OUTPUT - results - structure of result DH, with optimized parameteres,
%                      wrapped to [-pi,pi]; field corresponds to 'groups'
%                      used in robot and each one is 4D array:
%                       - number of DH lines
%                       - 4 params for each line
%                       - number of repetitions
%                       - number of perturation levels (1 for no pert)
    
    % start with non-calibrated values
    results = start_dh;
    %get all fields
    fnames = fieldnames(start_dh);
    count = 1;
    for field=1:length(fnames)
        % if field in whitelist has any 1 (anything was calibrated) 
        if(any(any(whitelist.(fnames{field}))))
            % find right index in whitelist 
            new_count = count + sum(sum(whitelist.(fnames{field})));
            % get whitelist in right format
            wh = repmat(whitelist.(fnames{field})',1,1,optim.repetitions, optim.pert_levels);
            % permute columns in given field
            a=permute(results.(fnames{field}),[2,1,3,4]);
            % add optimized params to their place
            a(wh) = reshape(opt_pars(count:new_count-1,:,:),[],1) + optim.optimizeDifferences * a(wh);
            % append to results
            results.(fnames{field})=permute(a,[2,1,3,4]);
            % wrap ti [-pi,pi];
            results.(fnames{field})(:,3:4,:,:)=ezwraptopi(results.(fnames{field})(:,3:4,:,:));
            count = new_count;
        end
        mResults = results.(fnames{field});
        mResults(:,1:2,:,:) = results.(fnames{field})(:,1:2,:,:)/optim.unitsCoef;
        % corrections = results - default 
        corrs.(fnames{field}) = mResults-robot.structure.DH.(fnames{field})(:,:,1); 
        % wrap to [-pi,pi]
        corrs.(fnames{field})(:,3:4,:,:)=ezwraptopi(corrs.(fnames{field})(:,3:4,:,:));
    end
end

