function plotErrorsBoxplots(folders,varargin)
% PLOTERRORSBOXPLOTS shows boxplots with RMS errors from given folders
%   INPUT - folders - 1xN cellArray of string names of folders with results
%         - varargin - Uses MATLABs argument parser, with these pairs:
%                       - 'pert' - int, determines which perturbation
%                                        level to use
%                                      - Default: 0
%                       - 'log' - 1/0 to use logarithmic scale
%                               - Default: 0
%                       - 'units' - 'm' or 'mm'
%                                 - Default: mm
%                       - 'errorsType' - 'errors'/'errorsAll'
%                                      - Default: 'errors'
%                       - 'location' - string, location of the legend
%                                 - Default: 'northwest'

    % Argument parser
    close all;
    p=inputParser;
    addRequired(p,'folders');
    addParameter(p,'pert',0);
    addParameter(p,'log',0);
    addParameter(p,'units','mm', @(x) any(validatestring(x,{'m','mm'})));
    addParameter(p,'errorsType','errors');
    addParameter(p,'location','northwest');
    parse(p,folders,varargin{:});
    
    % get values from parser
    pert=p.Results.pert+1;
    location=p.Results.location;
    symLog=p.Results.log;
    errorsType=p.Results.errorsType;
    units=p.Results.units;
    figure();
    ax=axes();
    data=[];
    names={};
    colors=[];
    totalNum=0;
    positions=[];
    boxNum=0;
    usedNames={};
    boxOrder=[];
    linePositions=[];
    % iterate over all folders
    for folder=folders
        folder=folder{1};
        % load saved variables
        errors=load(['Results/',folder,'/errors.mat']);
        info = load(['Results/',folder,'/info.mat']);
        errors=errors.(errorsType);
        optim = info.optim;
        if strcmp(units,'m') &&  strcmp(optim.units,'mm')
            const = 0.001;
        elseif strcmp(units,'mm') &&  strcmp(optim.units,'m')
            const = 1000;
        else
            const = 1;
        end
        robot=info.rob;
        if strcmp(errorsType,'errors')
            % get cellArray from arrays
            distsTs = num2cell(errors(13:16,(pert-1)*optim.repetitions+(1:optim.repetitions)).*const,2);
            distsTr = num2cell(errors(5:8,(pert-1)*optim.repetitions+(1:optim.repetitions)).*const,2);
        else
            distsTs=cell(4,1);
            distsTr=cell(4,1);
            % get right values from cellArray of results
            for i=1:4
                if isempty(errors{12+i})
                    distsTs{i,:}=[distsTs{i,:};nan];
                    distsTr{i,:}=[distsTr{i,:};nan];
                else
                    dist=[errors{12+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
                    distsTs{i,:}=[distsTs{i,:};(dist(:)').*const];
                    dist=[errors{4+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
                    distsTr{i,:}=[distsTr{i,:};(dist(:)').*const];
                end
            end
        end
        
        % Prepare names and colors
        optTypes={'Selftouch Test', 'Planes Test', 'External Test', 'Projection Test'};
        optTypes2={'Selftouch Train', 'Planes Train', 'External Train', 'Projection Train'};
        colorTypes=[[233,114,77]; [214,215,39]; [149,196,243]; [121,204,179]]./255;
        colorTypes2=[[33,114,177]; [14,215,39]; [0,0,0]; [255,0,255]]./255;
        curNum=0;

        for i=1:4
            % if values for given calibration type
            if any(~isnan(distsTs{i,:}))
               % concatenate data
               data=[data;distsTs{i,:}'];
               % concatenate names
               names(end+1:end+size(distsTs{i,:},2),1)={[optTypes{i},folder]};
               % add colors
               colors=[colors;colorTypes(i,:)];
               curNum=curNum+1;
               boxNum=boxNum+1;
               % if new type of calib
               if ~ismember(optTypes{i},usedNames)
                  usedNames{end+1}=optTypes{i};
                  % new box
                  boxOrder=[boxOrder,boxNum];
               end
            end
            if any(~isnan(distsTr{i,:}))
               data=[data;distsTr{i,:}'];
               names(end+1:end+size(distsTr{i,:},2),1)={[optTypes2{i},folder]};
               colors=[colors;colorTypes2(i,:)];
               curNum=curNum+1;
               boxNum=boxNum+1;
                if ~ismember(optTypes2{i},usedNames)
                   usedNames{end+1}=optTypes2{i};
                   boxOrder=[boxOrder,boxNum];
                end
            end
        end
        % compute position of the boxes - boxes are 1 from each other, so
        % next box is after all boxes + current_boxes/2 + 0.5 if there is
        % even number of current_boxes
        positions=[positions,totalNum+curNum/2+0.5*mod(curNum+1,2)];
        % lines are after all boxes +0.5
        linePositions=[linePositions,totalNum+curNum+0.5];
        totalNum=totalNum+curNum;     
    end
    boxplot(ax,data,names,'position',1:size(unique(names),1),'width',0.9,'colors',colors)
    % find all object
    h = findobj(gca,'Tag','Box');
    % get them in reverse order
    h=h(end:-1:1,:);
    % add colors
    for j=1:length(h)
       patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:), 'FaceAlpha',.5);
    end
    if symLog
        symlog('y',log10(const)-2) 
    end
    
    set(gca, 'Xtick', positions, 'Xticklabels', folders,'FontSize',15)
    xtickangle(ax,90)
    ax.XAxis.TickLabelInterpreter = 'latex';
    ax.YAxis.TickLabelInterpreter = 'latex';
    % find all children
    c = get(gca, 'Children');
    % get them in reverse order and cut the last one
    c=c(end-1:-1:1,:);
    xlabel('Dataset');
    ylabel(['Error [',units,']']);
    title('Comparison of RMS errors')
    %get y limits for lines
    yl=ylim;
    %plot lines
    for i=1:length(folders)-1
        line([linePositions(i) linePositions(i)],yl,'Color','black','LineStyle','--')
    end
    % plot legent
    legend(c(boxOrder),usedNames,'Location',location);
end

