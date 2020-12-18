function [results, corrs, start_dh] = getResultKinematics(robot, opt_pars, start_dh, whitelist, optim)
%GETRESULTKINEMATICS - Returns final kinematics parameters and correction of each run
%   INPUT - opt_pars - 1xN vector of optimized parameters
%         - start_dh - structure of kinematics parameters used in calibration;
%                      fields are names of 'groups', and each is 4D array
%         - whitelist - structure of whitelist; 
%                       fields are names of 'groups', and each is 4D array
%         - optim - optim - structure of calibration settings
%   OUTPUT - results - structure of result kinematics, with optimized parameteres,
%                      wrapped to [-pi,pi]; field corresponds to 'groups'
%                      used in robot and each one is 4D array:
%                       - number of kinematics lines
%                       - 4/6 params for each line
%                       - number of repetitions
%                       - number of perturation levels (1 for no pert)
%          - corrs - corrections from nominal kinematics 
%          - start_dh -  structure with all 'groups' used in the robot. Each
%                        field is 4D array with kinematics parameters of given group
%                        for each repetition and perturation range
%
%
    
    % start with non-calibrated values
    results = start_dh;
    %get all fields
    fnames = fieldnames(start_dh);
    count = 1;
    for field=1:length(fnames)
        % if field in whitelist has any 1 (anything was calibrated) 
        if(isfield(whitelist, fnames{field}) && any(any(whitelist.(fnames{field}))))
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
            results.(fnames{field})(:,4:6,:,:)=ezwraptopi(results.(fnames{field})(:,4:6,:,:));
            count = new_count;
        end
        mResults = results.(fnames{field});
        % corrections = results - default 
        corrs.(fnames{field}) = zeros(size(mResults));
        corrs.(fnames{field})(:,1:3,:,:) = mResults(:,1:3,:,:)/optim.unitsCoef-robot.structure.kinematics.(fnames{field})(:,1:3,1); 
        corrs.(fnames{field})(:,4:6,:,:) = mResults(:,4:6,:,:)-robot.structure.kinematics.(fnames{field})(:,4:6,1);
        % wrap to [-pi,pi]
        corrs.(fnames{field})(:,4:6,:,:)=ezwraptopi(corrs.(fnames{field})(:,4:6,:,:));
        start_dh.(fnames{field})(:,1:3,:,:) = start_dh.(fnames{field})(:,1:3,:,:)/optim.unitsCoef;
    end
end

