function plotErrorBars(folders,varargin)
%PLOTERRORBARS Function for plotting rms errors bars
%   INPUT - folders - char names cell array of folders with results
%         - varargin - Uses MATLABs argument parser, with these pairs:
%                       - 'pert' - int, determines which perturbation level to use
%                                - Default: 0
%                       - 'log' - 1/0 to use logarithmic scale
%                               - Default: 1
%                       - 'units' - 'm' or 'mm'
%                                 - Default: mm
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
    addParameter(p,'units','mm', @(x) any(validatestring(x,{'m','mm'})));
    addParameter(p,'location','northwest');
    addParameter(p,'type','minmax');
    addParameter(p, 'title', 'RMS errors');
    addParameter(p, 'train', 0)
    parse(p,folders,varargin{:});
    
    pert=p.Results.pert+1;
    location=p.Results.location;
    log=p.Results.log;
    type=p.Results.type;
    titl=p.Results.title;
    units=p.Results.units;
    if p.Results.train
        lines = [5,13,6,14,7,15,8,16];
    else
        lines = [9,13,10,14,11,15,12,16];
    end
    numLines = length(lines);

    lenFolders = length(folders); 
    
    mins = zeros(numLines, lenFolders);
    maxs = zeros(numLines, lenFolders);
    means = zeros(numLines, lenFolders);
    stds = zeros(numLines, lenFolders);
    %% names and colors to bars
    if p.Results.train
        optTypes={'Selftouch Train', 'Selftouch Test', 'Planes Train', 'Planes Test', 'External Train', 'External Test', 'Projection Train', 'Projection Test'};
    else
        optTypes={'Selftouch Before', 'Selftouch After', 'Planes Before', 'Planes After', 'External Before', 'External After', 'Projection Before', 'Projection After'};
    end
    colors=[[33,114,177]; [233,114,77];[14,215,39]; [214,215,39];[0,0,0]; [149,196,243]; [255,0,255]; [121,204,179]]./255;
    
    %% compute min, max, mean and std for each error file
    for fi=1:length(folders)
        folder=folders{fi};
        errors=load(['Results/',folder,'/errors.mat']);
        info = load(['Results/',folder,'/info.mat']);
        errors=errors.errors;
        optim = info.optim;
        if strcmp(units,'m') &&  strcmp(optim.units,'mm')
            const = 0.001;
        elseif strcmp(units,'mm') &&  strcmp(optim.units,'m')
            const = 1000;
        else
            const = 1;
        end
        for l = 1:numLines
            mins(l, fi) = min(errors(lines(l),  optim.repetitions*(pert-1)+(1:optim.repetitions)))*const;
            maxs(l, fi) = max(errors(lines(l), optim.repetitions*(pert-1)+(1:optim.repetitions)))*const;
            means(l, fi) = mean(errors(lines(l), optim.repetitions*(pert-1)+(1:optim.repetitions)))*const;
            stds(l, fi) = std(errors(lines(l),  optim.repetitions*(pert-1)+(1:optim.repetitions)))*const;
        end
    end
    
    %% plot bars
    figure()
    if(size(means,2) == 1)
        idxs = find(~isnan(means)');
    else
        idxs = find(any(~isnan(means)'));
    end
    set(gcf,'defaultaxesfontsize', 16)
    if(lenFolders > 1)
        hBar = bar(means(idxs,:)');
        hold on
        xs = hBar(1).XData + [hBar(:).XOffset]';
        ii = 1;
        for k = idxs % 1:numLines
            hBar(ii).FaceColor = colors(k,:);
            ii = ii + 1;
        end
        set(gca,'xticklabel', folders, 'FontSize', 16, 'XTickLabelRotation', -15);
    else % for only one folder no grouping
        hold on
        ii = 1;
        for i = idxs % 1:numLines
            bar(ii,means(i),'facecolor', colors(i,:));
            ii = ii + 1;
        end
        xs = 1:length(idxs);%  1:numLines;
        xlabel(folders{1},'FontSize', 16)
        set(gca,'xticklabel',[])
    end
    %% plot errorbars
    if(strcmp(type,'minmax'))
        errorbar(xs', means(idxs,:)', mins(idxs,:)' - means(idxs,:)', maxs(idxs,:)' - means(idxs,:)', 'LineStyle', 'none', 'Color', 'k')
    else
        errorbar(xs', means(idxs,:)', stds(idxs,:)', 'LineStyle', 'none', 'Color', 'k')
    end
    grid on
    grid minor
    if(log)
       set(gca,'YScale','log');
    end
    legend(optTypes(idxs), 'location', location, 'FontSize',16);
    ylabel(['Errors [',units,'/px]'], 'FontSize', 16);
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
    title(titl,'FontSize',22);
end
