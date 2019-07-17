function loadTasksFromFile(fileName)
opts=detectImportOptions(fileName);
for i=1:length(opts.VariableNames)
    opts.VariableTypes{i}='char';
    opts = setvaropts(opts,opts.VariableNames{i},'FillValue','');
end
opts.Delimiter=';';
file=readtable(fileName,opts);

keyWords={'min','max'};
for lineId=1:size(file,1)
    line=table2cell(file(lineId,:));
    if strcmp(line{8},'true') || strcmp(line{8},'True')
        line{8}=1;
    elseif strcmp(line{8},'false') || strcmp(line{8},'false')
        line{8}=0;
    end
    
    % loadDH
    if ~isempty(line{9})
        spl=strsplit(line{10},','); 
        mat=0;
        for key=1:length(keyWords)
            if any(cellfun(@(x) strcmp(x,keyWords{key}), spl))
                mat=1;
                break
            end
        end
        args={};
        if mat
            loadDHfunc='loadDHfromMat';
            for j=1:size(spl,2)
                if ismember(spl{j},keyWords)
                   args{end+1}='type';
                   args{end+1}=spl{j};                   
                else
                    args{end+1}='pert';
                    args{end+1}=spl{j};
                end
            end
        else
            loadDHfunc='loadDHfromTxt';
            args=spl;
        end
    end
    
    varArgsRaw=line(11:end);
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
    main(line{2},line{3},line{4},line{5},line{6},varArgs,num2str(line{7}),str2num(line{8}),loadDHfunc,args, line{9});
    stamp=datestr(now,'HH:MM:SS.FFF');
    file.Timestamp{lineId,1}=stamp;
    writetable(file,fileName,'Delimiter',';')
    
end
end

