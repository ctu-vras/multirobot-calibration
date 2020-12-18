function saveResults(rob,outfolder,res_dh,corrs_dh, errors, errorsAll, whitelist, chains, approach, linkTypes, optim, options, obsIndexes, robot_fcn, dataset_fcn, config_fcn, dataset_params)
    %SAVERESULTS Save results to mat files
    %   Saving inputed variables to mat files
    %INPUT - rob - Robot object
    %      - outfolder - save folder name
    %      - res_dh - robot result Kinematics
    %      - corrs_dh - corrections from nominal Kinematics
    %      - errors - before/after training rms errors, before/after testing rms errors
    %      - errorsAll - before/after training individual errors, before/after testing individual errors
    %      - whitelist - parameters to calibrate
    %      - chains - chains to calibrate
    %      - approach - calibration approaches
    %      - linkTypes -link types to calibrate
    %      - optim - calibration settings
    %      - options - lsqnonlin options object
    %      - obsIndexes - observability indexes
    %      - robot_fcn - string name of used robot_fcn
    %      - dataset_fcn - string name of used dataset_fcn
    %      - config_fcn  - string name of used config_fcn
    %      - dataset_params - cell array of used dataset_params
    
    
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
    
        
    if strcmp(optim.units, 'm')
        units = 1;       
    else
        units = 1000;
    end
    %% convert Kinematics to metres
    fnames=fieldnames(res_dh);
    for name=1:length(fnames)
       for line=1:size(res_dh.(fnames{name}), 1)
           if size(res_dh.(fnames{name})(line,:,1,1),2)==4 || any(isnan(res_dh.(fnames{name})(line,:,1,1)))
               res_dh.(fnames{name})(line,1:2,:,:) =  res_dh.(fnames{name})(line,1:2,:,:)/units;
           else
               res_dh.(fnames{name})(line,1:3,:,:) =  res_dh.(fnames{name})(line,1:3,:,:)/units;
           end
       end
    end
    %% save variables
    s = mkdir(outfolder);
    assert(s, 'Could not make folder');
    save([outfolder, 'results.mat'], 'res_dh');
    save([outfolder, 'corrections.mat'], 'corrs_dh');
    save([outfolder, 'errors.mat'], 'errors','errorsAll');
    save([outfolder, 'info.mat'], 'whitelist', 'optim', 'chains', 'approach',...
    'linkTypes', 'rob', 'options', 'robot_fcn', 'dataset_fcn', 'config_fcn',...
    'dataset_params', 'obsIndexes');
    
    %% save info to txt
    file=fopen([outfolder,'info.txt'],'w');
    for str={'optim', 'chains', 'approach', 'linkTypes', 'options', 'robot_fcn', 'dataset_fcn', 'config_fcn'}
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
    %% save Kinematics to text files   
    for pert_level = (1+optim.skipNoPert):optim.pert_levels
        for rep = 1:optim.repetitions   
            file=fopen([outfolder,'kin-rep',num2str(rep), '-pert', num2str(pert_level),'.txt'],'w');
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
                links=rob.findLinkByGroup(fnames{name});
                for line=1:size(res_dh.(fnames{name}),1)
                    values = zeros(len,1);
                    for col=1:len
                        values(col) = res_dh.(fnames{name})(line,col,rep,pert_level);
                    end

                    fprintf(file,formatSpec, links{line}.name, values);
                end
                fprintf(file,'\n');             
            end
            fclose(file);
        end
    end

end

