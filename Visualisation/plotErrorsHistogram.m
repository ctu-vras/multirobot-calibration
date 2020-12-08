function plotErrorsHistogram(folder,varargin)
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

    % Argument parser
%     close all;
    p=inputParser;
    addRequired(p,'folders');
    addParameter(p,'pert',0);
    addParameter(p,'units','mm', @(x) any(validatestring(x,{'m','mm'})));
    addParameter(p,'location','northwest');
    parse(p,folder,varargin{:});
    
    % get values from parser
    pert=p.Results.pert+1;
    location=p.Results.location;
    units=p.Results.units;
    ax=axes();
    names={};
    maxReps = 2;
    
    info = load(['Results/',folder,'/info.mat']);
    if(info.optim.repetitions > maxReps) 
        maxReps = info.optim.repetitions;
    end
    
    % load saved variables
    errors=load(['Results/',folder,'/errors.mat']);
    info = load(['Results/',folder,'/info.mat']);
    errors=errors.errorsAll;
    optim = info.optim;
    if strcmp(units,'m') &&  strcmp(optim.units,'mm')
        const = 0.001;
    elseif strcmp(units,'mm') &&  strcmp(optim.units,'m')
        const = 1000;
    else
        const = 1;
    end
    robot=info.rob;
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
            distsTs{i,:}=[distsTs{i,:},(dist(:)').*const];

            dist=[errors{0+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
            distsTr{i,:}=[distsTr{i,:};(dist(:)').*const];
            dist=[errors{8+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
            distsTr{i,:}=[distsTr{i,:},(dist(:)').*const];
        end
    end

    for i=1:4
       distsTs{i,:}(end+1:maxReps) = nan; 
       distsTr{i,:}(end+1:maxReps) = nan; 
    end

    % Prepare names and colors
    optTypes={'Selftouch After', 'Planes After', 'External After', 'Projection After'};
    optTypes2={'Selftouch Before', 'Planes Before', 'External Before', 'Projection Before'};
    colorTypes=[[233,114,77]; [214,215,39]; [149,196,243]; [121,204,179]]./255;
    colorTypes2=[[33,114,177]; [14,215,39]; [0,0,0]; [255,0,255]]./255;

    for i=1:4
        % if values for given calibration type
        if any(~isnan(distsTr{i,:}))
           data = distsTr{i,:}';
           histogram(data, 'FaceColor', colorTypes2(i,:));
           hold on;
           names{end+1}=optTypes2{i};
        end
        if any(~isnan(distsTs{i,:}))
           data=distsTs{i,:}';
           histogram(data, 'FaceColor', colorTypes(i,:));
           names{end+1}=optTypes{i};
        end
    end     
    legend(names,'Location',location);
    
    ax.XAxis.TickLabelInterpreter = 'latex';
    ax.YAxis.TickLabelInterpreter = 'latex';
    xlabel(['Error [', units, ']']);
    ylabel('Number of poses [-]');
    title(['Comparison of RMS errors for ', folder])
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
end

