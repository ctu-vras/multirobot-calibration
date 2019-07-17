function loadTasksFromFile(fileName)
file=readtable(fileName,'Delimiter',';');

for lineId=1:size(file,1)
    line=table2cell(file(lineId,:));
    spl=strsplit(line{6},'!');
    varArgs={};
    for i=1:size(spl,2)
        try
            arg=eval(spl{i});
            varArgs{end+1}=arg;
        catch
            varArgs{end+1}=spl{i};
        end
    end
    if strcmp(line{8},'true') || strcmp(line{8},'True')
        line{8}=1;
    elseif strcmp(line{8},'false') || strcmp(line{8},'false')
        line{8}=0;
    end
    if ~any(isnan(line{9}))
        spl=strsplit(line{10},'!'); 
        if size(spl,2)>1
            loadDHfunc='loadDHfromMat';
        else
            loadDHfunc='loadDHfromTxt';
        end
    end
    main(line{1},line{2},line{3},line{4},line{5},varArgs,num2str(line{7}),line{8},loadDHfunc,spl, line{9});
end
end

