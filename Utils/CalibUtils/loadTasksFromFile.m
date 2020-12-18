function loadTasksFromFile(fileName)
    %LOADTASKSFROMFILE Loading the calibration task from csv file
    %Function for loading calibrations tasks from csv file and running main
    %INPUT - fileName - csv file name
    
    
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
    
    
    %% loading column names and type from file
    opts=detectImportOptions(fileName);
    for i=1:length(opts.VariableNames)
        opts.VariableTypes{i}='char';
        opts = setvaropts(opts,opts.VariableNames{i},'FillValue','');
    end
    opts.Delimiter=';';
    file=readtable(fileName,opts);

    keyWords={'min', 'max', 'median'}; % type of selecting kinematics from Mat
    for lineId=1:size(file,1)
        line=table2cell(file(lineId,:));
        %% save info switch
        if strcmpi(line{11},'true')
            line{11}=1;
        elseif strcmpi(line{11},'false')
            line{11}=0;
        end

        %% loadkinematics
        if ~isempty(line{12})
            spl=strsplit(line{13},','); 
            mat=0;
            % If type {min,max,median} selected -> use loadKinfromMat
            for key=1:length(keyWords)
                if any(cellfun(@(x) strcmp(x,keyWords{key}), spl))
                    mat=1;
                    break
                end
            end
            args=cell(1,2*size(spl,2));
            if mat
                loadKinfunc='loadKinfromMat';
                %% args can be type and perturbation together
                for j=1:size(spl,2)
                    if ismember(spl{j},keyWords)
                       args{2*j-1}='type';
                    else
                        args{2*j-1}='pert';
                    end
                    args{2*j}=spl{j};  
                end
            else
                loadKinfunc='loadKinfromTxt';
                args=spl;
            end
        else
            loadKinfunc='';
            args='';
        end
        %% dataset params as varargs
        varArgsRaw=line(14:end);
        varArgs={};
        for i=1:size(varArgsRaw,2)
            try
                arg=eval(varArgsRaw{i});
                varArgs{end+1}=arg;
            catch
                if ~isempty(varArgsRaw{i})
                    varArgs{end+1}=varArgsRaw{i};
                end
            end
        end
        %% config params
        approaches = strsplit(line{4},','); 
        chains = strsplit(line{5},','); 
        linkTypes = strsplit(line{6},','); 
        
        %% save info
        saveInfo = [];
        for saveInfo_=line{11}
            saveInfo_ = str2num(saveInfo_);
            if ~isempty(saveInfo_)
                saveInfo = [saveInfo, saveInfo_];
            end
        end
        %% run the main script and write timestamp after end of program
        runCalibration(line{2},line{3},approaches, chains, linkTypes, line{7},line{8},line{9},varArgs,num2str(line{10}),saveInfo,loadKinfunc,args, line{12});
        stamp=datestr(now,'HH:MM:SS.FFF');
        file.Timestamp{lineId,1}=stamp;
        writetable(file,fileName,'Delimiter',';')
    end
end

