function saveResults(rob,outfolder,res_dh,corrs_dh, before_tr_err, after_tr_err, before_ts_err, after_ts_err, before_tr_err_all, after_tr_err_all, before_ts_err_all, after_ts_err_all, chains, approach, jointTypes, optim, options, robot_fcn, dataset_fcn, config_fcn, dataset_params)
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
%      - options - lsqnonlin options object
%      - robot_fcn - string name of used robot_fcn
%      - dataset_fcn - string name of used dataset_fcn
%      - config_fcn  - string name of used config_fcn
%      - dataset_params - cell array of used dataset_params
        
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
    save([outfolder, 'info.mat'], 'optim', 'chains', 'approach',...
    'jointTypes', 'rob', 'options', 'robot_fcn', 'dataset_fcn', 'config_fcn',...
    'dataset_params');
    
    %% save info to txt
    file=fopen([outfolder,'info.txt'],'w');
    for str={'optim', 'chains', 'approach', 'jointTypes', 'options', 'robot_fcn', 'dataset_fcn', 'config_fcn'}
        str_ = str{1};
        str = eval(str_);
        if ~isstruct(str) && ~isobject(str)
            fprintf(file, '%-s \t %-s \n', str_, str);
        else
            fprintf(file, '%-s\n\n', str_);
            for fname=fieldnames((str))'
               fname = fname{1};
               if isstruct(str.(fname))
                   fprintf(file, '%-s\n', fname);
                   for fname_=fieldnames(str.(fname))'
                      outFormat = '\t%-s\t';
                      fname_=fname_{1};
                      if ischar(str.(fname).(fname_))
                          outFormat = [outFormat, '%-s\t']; 
                      elseif ~isempty(str.(fname).(fname_))
                          for val=str.(fname).(fname_)
                              outFormat = [outFormat, '%d\t']; 
                          end
                      end
                      outFormat = [outFormat, '\n'];
                      if ~isempty(str.(fname).(fname_))
                          fprintf(file, outFormat, fname_, str.(fname).(fname_));
                      else
                         fprintf(file, outFormat, fname);
                      end
                   end
               else
                   outFormat = '%-s\t ';
                   if ischar(str.(fname))
                       outFormat = [outFormat, '%-s\t']; 
                   elseif ~isempty(str.(fname))
                       for val=str.(fname)
                           outFormat = [outFormat, '%d\t']; 
                       end
                   end
                   outFormat = [outFormat, '\n'];
                   if ~isempty(str.(fname))
                       fprintf(file, outFormat, fname, str.(fname));
                   else
                       fprintf(file, outFormat, fname);
                   end
               end
            end
        end
        fprintf(file,'\n');
    end
    fclose(file);
    %% save DH to text files   
    for pert_level = (1+optim.skipNoPert):optim.pert_levels
        for rep = 1:optim.repetitions   
            file=fopen([outfolder,'DH-rep',num2str(rep), '-pert', num2str(pert_level),'.txt'],'w');
            for name=1:length(fnames)
                if ~rob.structure.type.(fnames{name})
                    fprintf(file, '%-s\t a \t d \t alpha \t offset\n', fnames{name});
                    formatSpec='%-s %-5.8f %-5.8f %-5.8f %-5.8f\n';
                    len=4;
                elseif rob.structure.type.(fnames{name})==1
                    fprintf(file, '%-s\t x \t y \t z \t alfa \t beta \t gama\n', fnames{name});
                    formatSpec='%-s %-5.8f %-5.8f %-5.8f %-5.8f %-5.8f %-5.8f\n';
                    len=6;
                else
                    fprintf(file, '%-s\t x(a) \t y(d) \t z(alfa) \t alfa(offset) \t beta(-) \t gama(-)\n', fnames{name});
                    formatSpec='%-s %-5.8f %-5.8f %-5.8f %-5.8f %-5.8f %-5.8f\n';
                    len=6;
                end
                joints=rob.findJointByGroup(fnames{name});
                for line=1:size(res_dh.(fnames{name}),1)
                    values = zeros(len,1);
                    for col=1:len
                        values(col) = res_dh.(fnames{name})(line,col,rep,pert_level);
                    end

                    fprintf(file,formatSpec, joints{line}.name, values);
                end
                fprintf(file,'\n');             
            end
            fclose(file);
        end
    end

end

