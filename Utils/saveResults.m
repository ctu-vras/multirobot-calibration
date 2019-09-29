function saveResults(rob,outfolder,res_dh,corrs_dh, before_tr_err, after_tr_err, before_ts_err, after_ts_err, before_tr_err_all, after_tr_err_all, before_ts_err_all, after_ts_err_all, chains, approach, jointTypes, optim)
%SAVERESULTS Save results to mat files
%   Saving inputed variables to mat files
%INPUT - rob - Robot object
%      - outfolder - save folder name
%      - res_dh - robot result DH
%      - corrs_dh - corrections from nominal DH
%      - before_tr_err, after_tr_err, before_ts_err, after_ts_err - before/after training rms errors, before/after testing rms errors
%      - before_tr_err_all, after_tr_err_all, before_ts_err_all, after_ts_err_all - before/after training individual errors, before/after testing individual errors
%      - chains - chains to calibrate
%      - approach - calibration approaches
%      - jointTypes -joint types to calibrate
%      - optim - calibration settings
        
    if strcmp(optim.units, 'm')
        units = 1;       
    else
        units = 1000;
    end
    %% merge all rms errors
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

    errorsAll=[before_tr_err_all, after_tr_err_all, before_ts_err_all, after_ts_err_all];
    %% convert DH to metres
    fnames=fieldnames(res_dh);
    for name=1:length(fnames)
       res_dh.(fnames{name})(:,1:2,:,:) =  res_dh.(fnames{name})(:,1:2,:,:)/units;
    end
    %% save variables
    s = mkdir(outfolder);
    assert(s, 'Could not make folder');
    save([outfolder, 'results.mat'], 'res_dh');
    save([outfolder, 'corrections.mat'], 'corrs_dh');
    save([outfolder, 'errors.mat'], 'errors','errorsAll');
    save([outfolder, 'info.mat'], 'optim', 'chains', 'approach', 'jointTypes', 'rob');
    %% save DH to text files   
    for pert_level = (1+optim.skipNoPert):optim.pert_levels
        for rep = 1:optim.repetitions   
            file=fopen([outfolder,'DH-rep',num2str(rep), '-pert', num2str(pert_level),'.txt'],'w');
            for name=1:length(fnames)
                fprintf(file, '%-s\t a \t d \t alpha \t offset\n', fnames{name});
                joints=rob.findJointByGroup(fnames{name});
                for line=1:size(res_dh.(fnames{name}),1)
                    formatSpec='%-s %-5.8f %-5.8f %-5.8f %-5.8f\n';                    
                    fprintf(file,formatSpec, joints{line}.name, [res_dh.(fnames{name})(line,1,rep,pert_level),res_dh.(fnames{name})(line,2,rep,pert_level),res_dh.(fnames{name})(line,3),res_dh.(fnames{name})(line,4,rep,pert_level)]');
                end
                fprintf(file,'\n');             
            end
            fclose(file);
        end
    end

end

