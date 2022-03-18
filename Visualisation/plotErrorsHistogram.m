function plotErrorsHistogram(folder,varargin)
    % PLOTERRORSHISTOGRAM shows histogram with errors from given folder
    %   INPUT - folder - folder with results
    %         - varargin - Uses MATLABs argument parser, with these pairs:
    %                       - 'pert' - int, determines which perturbation
    %                                        level to use
    %                                      - Default: 0
    %                       - 'units' - 'm' or 'mm'
    %                                 - Default: mm
    %                       - 'location' - string, location of the legend
    %                                 - Default: 'northeast'
    
    
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
    addParameter(p,'units','mm', @(x) any(validatestring(x,{'m','mm'})));
    addParameter(p,'location','northeast');
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
        const = repmat(0.001, 1, 4);
    elseif strcmp(units,'mm') &&  strcmp(optim.units,'m')
        const = repmat(1000, 1, 4);
    else
        const = ones(1, 4);
    end
    const(end) = 1;
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
            distsTs{i,:}=[distsTs{i,:};(dist(:)').*const(i)];
            dist=[errors{4+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
            distsTs{i,:}=[distsTs{i,:},(dist(:)').*const(i)];

            dist=[errors{0+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
            distsTr{i,:}=[distsTr{i,:};(dist(:)').*const(i)];
            dist=[errors{8+i}{(pert-1)*optim.repetitions+(1:optim.repetitions)}];
            distsTr{i,:}=[distsTr{i,:},(dist(:)').*const(i)];
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
    title(['Comparison of errors for ', folder])
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
end

