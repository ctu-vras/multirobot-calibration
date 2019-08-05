function plotErrorBars(folders,varargin)
%PLOTERRORBARS Function for plotting rms errors bars
%   INPUT - folders - char names cell array of folders with results
%         - varargin - Uses MATLABs argument parser, with these pairs:
%                       - 'pert' - int, determines which perturbation level to use
%                                - Default: 0
%                       - 'log' - 1/0 to use logarithmic scale
%                               - Default: 1
%                       - 'const' - 1 or 1000, to use m or mm
%                                 - Default: 1
%                       - 'location' - legend location
%                                 - Default: northwest
%                       - 'type' - errorbar type - minmax or std
%                                 - Default: minmax
%                       - 'title' - plot title
%                                 - Default: RMS errors
    p=inputParser;
    addRequired(p,'folders');
    addParameter(p,'pert',0);
    addParameter(p,'log',1);
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
    
    mins = zeros(numLines, lenFolders);
    maxs = zeros(numLines, lenFolders);
    means = zeros(numLines, lenFolders);
    stds = zeros(numLines, lenFolders);
    %% names and colors to bars
    optTypes={'Selftouch Train', 'Selftouch Test', 'Planes Train', 'Planes Test', 'External Train', 'External Test', 'Projection Train', 'Projection Test'};
    colors=[[33,114,177]; [233,114,77];[14,215,39]; [214,215,39];[0,0,0]; [149,196,243]; [255,0,255]; [121,204,179]]./255;
    
    %% compute min, max, mean and std for each error file
    for fi=1:length(folders)
        folder=folders{fi};
        errors=load(['Results/',folder,'/errors.mat']);
        info = load(['Results/',folder,'/info.mat']);
        errors=errors.errors;
        optim = info.optim;
        for l = 1:numLines
            mins(l, fi) = min(errors(lines(l),  optim.repetitions*(pert-1)+(1:optim.repetitions)));
            maxs(l, fi) = max(errors(lines(l), optim.repetitions*(pert-1)+(1:optim.repetitions)));
            means(l, fi) = mean(errors(lines(l), optim.repetitions*(pert-1)+(1:optim.repetitions)));
            stds(l, fi) = std(errors(lines(l),  optim.repetitions*(pert-1)+(1:optim.repetitions)));
        end
    end
    
    %% plot bars
    figure()
    set(gcf,'defaultaxesfontsize', 16)
    if(lenFolders > 1)
        hBar = bar(means(1:numLines,:)');
        hold on
        xs = hBar(1).XData + [hBar(:).XOffset]';
        for k = 1:numLines
            hBar(k).FaceColor = colors(k,:);
        end
        set(gca,'xticklabel', folders, 'FontSize', 18, 'XTickLabelRotation', -15);  
    else % for only one folder no grouping
        hold on
        for i = 1:numLines
            bar(i,means(i),'facecolor', colors(i,:));
        end
        xs = 1:numLines;
        xlabel(folders{1},'FontSize', 18, 'Rotation', -15)
        set(gca,'xticklabel',[])
    end
    %% plot errorbars
    if(strcmp(type,'minmax'))
        errorbar(xs', means(1:numLines,:)', mins(1:numLines,:)' - means(1:numLines,:)', maxs(1:numLines,:)' - means(1:numLines,:)', 'LineStyle', 'none', 'Color', 'k')
    else
        errorbar(xs', means(1:numLines,:)', stds(1:numLines,:)', 'LineStyle', 'none', 'Color', 'k')
    end
    grid on
    grid minor
    if(log)
       set(gca,'YScale','log');
    end
    legend(optTypes, 'location', location, 'FontSize',19);
    ylabel(['Errors [',constName,'/px]'], 'FontSize', 20);
    title(titl,'FontSize',24);
end
