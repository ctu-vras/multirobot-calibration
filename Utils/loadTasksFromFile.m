function loadTasksFromFile(fileName)
%LOADTASKSFROMFILE Loading the calibration task from csv file
%Function for loading calibrations tasks from csv file and running main
%INPUT - fileName - csv file name
    %% loading column names and type from file
    opts=detectImportOptions(fileName);
    for i=1:length(opts.VariableNames)
        opts.VariableTypes{i}='char';
        opts = setvaropts(opts,opts.VariableNames{i},'FillValue','');
    end
    opts.Delimiter=';';
    file=readtable(fileName,opts);

    keyWords={'min', 'max', 'median'}; % type of selecting DH from Mat
    for lineId=1:size(file,1)
        line=table2cell(file(lineId,:));
        %% save info switch
        if strcmpi(line{10},'true')
            line{10}=1;
        elseif strcmpi(line{10},'false')
            line{10}=0;
        end

        %% loadDH
        if ~isempty(line{11})
            spl=strsplit(line{12},','); 
            mat=0;
            % If type {min,max,median} selected -> use loadDHfromMat
            for key=1:length(keyWords)
                if any(cellfun(@(x) strcmp(x,keyWords{key}), spl))
                    mat=1;
                    break
                end
            end
            args=cell(1,2*size(spl,2));
            if mat
                loadDHfunc='loadDHfromMat';
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
                loadDHfunc='loadDHfromTxt';
                args=spl;
            end
        else
            loadDHfunc='';
            args='';
        end
        %% dataset params as varargs
        varArgsRaw=line(13:end);
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
        
        %% run the main script and write timestamp after end of program
        main(line{2},line{3},approaches, chains, line{6},line{7},line{8},varArgs,num2str(line{9}),str2double(line{10}),loadDHfunc,args, line{11});
        stamp=datestr(now,'HH:MM:SS.FFF');
        file.Timestamp{lineId,1}=stamp;
        writetable(file,fileName,'Delimiter',';')
    end
end

