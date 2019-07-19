function plotErrorBars(folders,varargin)
%PLOTERRORBARS Summary of this function goes here
%   Detailed explanation goes here
    p=inputParser;
    addRequired(p,'folders');
    addParameter(p,'pert',0);
    addParameter(p,'log',0);
    addParameter(p,'const',1, @(x) ismember(x,[1,1000]));
    addParameter(p,'location','northwest');
    addParameter(p,'type','minmax');
    addParameter(p, 'title', 'RMS errors');
    parse(p,folders,varargin{:});
    
    pert=p.Results.pert+1;
    location=p.Results.location;
    log=p.Results.log;
    type=p.Results.type;
    titl=p.Results.title;
    const=p.Results.const;
    if const==1
        constName='m';
    elseif const==1000
        constName='mm';
    end
    
    lines = [5,13,6,14,7,15,8,16];
    numLines = length(lines);

    lenFolders = length(folders);
    if(lenFolders == 1)
        lenFolders = 2;
    end
    
    
    mins = zeros(numLines, lenFolders);
    maxs = zeros(numLines, lenFolders);
    means = zeros(numLines, lenFolders);
    stds = zeros(numLines, lenFolders);
    
    optTypes={'Selftouch Train', 'Selftouch Test', 'Planes Train', 'Planes Test', 'External Train', 'External Test', 'Projection Train', 'Projection Test'};
    colors=[[33,114,177]; [233,114,77];[14,215,39]; [214,215,39];[0,0,0]; [149,196,243]; [255,0,255]; [121,204,179]]./255;
    
    for fi=1:length(folders)
        folder=folders{fi};
        errors=load(['results/',folder,'/errors.mat']);
        info = load(['results/',folder,'/info.mat']);
        errors=errors.errors;
        optim = info.optim;
        for l = 1:numLines
            mins(l, fi) = min(errors(lines(l),  optim.repetitions*(pert-1)+(1:optim.repetitions)));
            maxs(l, fi) = max(errors(lines(l), optim.repetitions*(pert-1)+(1:optim.repetitions)));
            means(l, fi) = mean(errors(lines(l), optim.repetitions*(pert-1)+(1:optim.repetitions)));
            stds(l, fi) = std(errors(lines(l),  optim.repetitions*(pert-1)+(1:optim.repetitions)));
        end
    end
    
    figure('Position', [10 10 1200 1200]);
    set(gcf,'defaultaxesfontsize', 16)
    hBar = bar(means(1:numLines,:)');
    hold on
    xs = hBar(1).XData + [hBar(:).XOffset]'; 
    for k = 1:numLines
        hBar(k).FaceColor = colors(k,:);
    end
    if(strcmp(type,'minmax'))
        errorbar(xs', means(1:numLines,:)', mins(1:numLines,:)' - means(1:numLines,:)', maxs(1:numLines,:)' - means(1:numLines,:)', 'LineStyle', 'none', 'Color', 'k')
    else
        errorbar(xs', means(1:numLines,:)', stds(1:numLines,:)', 'LineStyle', 'none', 'Color', 'k')
    end
    grid on
    grid minor
    set(gca,'xticklabel', folders, 'FontSize', 18, 'XTickLabelRotation', -15);
    if(log)
       set(gca,'YScale','log');
    end
    legend(optTypes, 'location', location, 'FontSize',19);
    ylabel(['Errors [',constName,'/px]'], 'FontSize', 20);
    title(titl,'FontSize',24);
end

