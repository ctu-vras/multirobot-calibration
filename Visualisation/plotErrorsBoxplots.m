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
    %                       - 'points' - 1/0 to show points in boxes
    %                               - Default: 0
    %                       - 'train' - show train and test set after
    %                                   calibration
    %                                 - Default: 0
    
    
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
    

    % Argument parser
    p=inputParser;
    addRequired(p,'folders');
    addParameter(p,'pert',0);
    addParameter(p,'log',0);
    addParameter(p,'units','mm', @(x) any(validatestring(x,{'m','mm'})));
    addParameter(p,'errorsType','errors');
    addParameter(p,'location','northeast');
    addParameter(p, 'points', 0);
    addParameter(p, 'train', 0);
    parse(p,folders,varargin{:});
    
    % get values from parser
    pert=p.Results.pert+1;
    location=p.Results.location;
    symLog=p.Results.log;
    errorsType=p.Results.errorsType;
    units=p.Results.units;
    showPoints = p.Results.points;
    figure();
    ax=axes();
    data = [];
    names={};
    colors=[];
    totalNum=0;
    positions=[];
    boxNum=0;
    usedNames={};
    boxOrder=[];
    linePositions=[];
    maxReps = 2;
    
    for folder=folders
        info = load(['Results/',folder{1},'/info.mat']);
        if(info.optim.repetitions > maxReps) 
            maxReps = info.optim.repetitions;
        end
    end
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
            if p.Results.train
                distsTr = num2cell(errors(5:8,(pert-1)*optim.repetitions+(1:optim.repetitions)).*const,2);
            else
                distsTr = num2cell(errors(9:12,(pert-1)*optim.repetitions+(1:optim.repetitions)).*const,2);
            end
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
                    if p.Results.train
                        dist=[errors{4+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
                    else
                        dist=[errors{8+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
                    end
                    distsTr{i,:}=[distsTr{i,:};(dist(:)').*const];
                end
            end
        end
        
        for i=1:4
           distsTs{i,:}(end+1:maxReps) = nan; 
           distsTr{i,:}(end+1:maxReps) = nan; 
        end
        
        % Prepare names and colors
        if p.Results.train
            optTypes={'Selftouch Test', 'Planes Test', 'External Test', 'Projection Test'};
            optTypes2={'Selftouch Train', 'Planes Train', 'External Train', 'Projection Train'};
        else
            optTypes={'Selftouch After', 'Planes After', 'External After', 'Projection After'};
            optTypes2={'Selftouch Before', 'Planes Before', 'External Before', 'Projection Before'};
        end
        colorTypes=[[233,114,77]; [214,215,39]; [149,196,243]; [121,204,179]]./255;
        colorTypes2=[[33,114,177]; [14,215,39]; [0,0,0]; [255,0,255]]./255;
        curNum=0;

        for i=1:4
            % if values for given calibration type
            if any(~isnan(distsTr{i,:}))
               data=[data,distsTr{i,:}'];
               names(end+1:end+size(distsTr{i,:},2),1)={[optTypes2{i},folder]};
               colors=[colors;colorTypes2(i,:)];
               curNum=curNum+1;
               boxNum=boxNum+1;
                if ~ismember(optTypes2{i},usedNames)
                   usedNames{end+1}=optTypes2{i};
                   boxOrder=[boxOrder,boxNum];
                end
            end
            if any(~isnan(distsTs{i,:}))
               % concatenate data
               data=[data,distsTs{i,:}'];
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
            
        end
        % compute position of the boxes - boxes are 1 from each other, so
        % next box is after all boxes + current_boxes/2 + 0.5 if there is
        % even number of current_boxes
        positions=[positions,totalNum+curNum/2+0.5*mod(curNum+1,2)];
        % lines are after all boxes +0.5
        linePositions=[linePositions,totalNum+curNum+0.5];
        totalNum=totalNum+curNum;     
    end
    
    names2 = [1, 2, zeros(1,10)+3, zeros(1,10)+4];
    bplot(data,'width',0.9, 'nolegend');
    hold on
    h = findobj(gca, 'Type', 'Patch');
    % get them in reverse order
    h=h(end:-1:1,:);
    % add colors
    for j=1:length(h)
        h(j).FaceColor = colors(j,:);
        h(j).FaceAlpha = 0.5;
    end
    if showPoints
        scatter(names2, data,'filled','MarkerFaceAlpha',0.6','jitter','on','jitterAmount',0.15);
    end
    if symLog
        bisymlog('y',log10(const)-2, 0) 
    end
    
    set(gca, 'Xtick', positions, 'Xticklabels', folders,'FontSize',15)
    xtickangle(ax,90)
    ax.XAxis.TickLabelInterpreter = 'latex';
    ax.YAxis.TickLabelInterpreter = 'latex';
    xlabel('Dataset');
    ylabel(['Error [',units,']']);
    title('Comparison of RMS errors')
    %get y limits for lines
    yl=ylim;
    %plot lines
    for i=1:length(folders)-1
        line([linePositions(i) linePositions(i)],yl,'Color','black','LineStyle','--')
    end
    % plot legend
    legend(h(boxOrder),usedNames,'Location',location);
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
end

