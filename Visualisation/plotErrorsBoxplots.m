function plotErrorsBoxplots(folders,varargin)
    close all
% folders - cell array of folder names
    p=inputParser;
    addRequired(p,'folders');
    addParameter(p,'pert',0);
    addParameter(p,'log',0);
    addParameter(p,'const',1, @(x) ismember(x,[1,1000]));
    addParameter(p,'errorsType','errors');
    addParameter(p,'location','northwest');
    parse(p,folders,varargin{:});
    
    pert=p.Results.pert+1;
    location=p.Results.location;
    symLog=p.Results.log;
    errorsType=p.Results.errorsType;
    const=p.Results.const;
    if const==1
        constName='m';
    elseif const==1000
        constName='mm';
    end
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
    for folder=folders
        folder=folder{1};
        errors=load(['results/',folder,'/errors.mat']);
        info = load(['results/',folder,'/info.mat']);
        errors=errors.(errorsType);
        optim = info.optim;
        robot=info.rob;
        if strcmp(errorsType,'errors')
            distsTs = num2cell(errors(13:16,(pert-1)*optim.repetitions+(1:optim.repetitions)).*const,2);
            distsTr = num2cell(errors(5:8,(pert-1)*optim.repetitions+(1:optim.repetitions)).*const,2);
        else
            distsTs=cell(4,1);
            distsTr=cell(4,1);
            for i=1:4
                if isempty(errors{12+i})
                    distsTs{i,:}=[distsTs{i,:};nan];
                    distsTr{i,:}=[distsTr{i,:};nan];
                else
                    dist=errors{12+i}((pert-1)*optim.repetitions+(1:optim.repetitions),:);
                    distsTs{i,:}=[distsTs{i,:};(dist(:)').*const];
                    dist=errors{4+i}((pert-1)*optim.repetitions+(1:optim.repetitions),:);
                    distsTr{i,:}=[distsTr{i,:};(dist(:)').*const];
                end
            end
        end

        optTypes={'Selftouch Test', 'Planes Test', 'External Test', 'Projection Test'};
        optTypes2={'Selftouch Train', 'Planes Train', 'External Train', 'Projection Train'};
        colorTypes=[[233,114,77]; [214,215,39]; [149,196,243]; [121,204,179]]./255;
        colorTypes2=[[33,114,177]; [14,215,39]; [0,0,0]; [255,0,255]]./255;
        curNum=0;

        for i=1:4
            if any(~isnan(distsTs{i,:}))
               data=[data;distsTs{i,:}'];
               names(end+1:end+size(distsTs{i,:},2),1)={[optTypes{i},folder]};
               colors=[colors;colorTypes(i,:)];
               curNum=curNum+1;
               boxNum=boxNum+1;
               if ~ismember(optTypes{i},usedNames)
                  usedNames{end+1}=optTypes{i};
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
        positions=[positions,totalNum+curNum/2+0.5*mod(curNum+1,2)];
        linePositions=[linePositions,totalNum+curNum+0.5];
        totalNum=totalNum+curNum;     
    end
    boxplot(ax,data,names,'position',1:size(unique(names),1),'width',0.9,'colors',colors)
    h = findobj(gca,'Tag','Box');
    h=h(end:-1:1,:);
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
    c = get(gca, 'Children');
    c=c(end-1:-1:1,:);
    xlabel('Dataset');
    ylabel(['Error [',constName,']']);
    title('Comparison of RMS errors')
    yl=ylim;
    for i=1:length(folders)-1
        line([linePositions(i) linePositions(i)],yl,'Color','black','LineStyle','--')
    end
    legend(c(boxOrder),usedNames,'Location',location);
end

