function plotJacobian(folder, titles)
    %PLOTJACOBIAN Function for plotting jacobians
    %INPUT - folder - folder with results
    %      - titles - subplot titles
    
    
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
    
    
    info = load(['Results/',folder,'/info']);
    jac = load(['Results/',folder,'/jacobians']);
    jacobians = jac.jacobians;
    robot = info.rob;
    whitelist = info.whitelist;
    fnames=fieldnames(robot.structure.kinematics);
    for name = 1:size(fnames,1)
        whitelist.(fnames{name}) = double(whitelist.(fnames{name}));
    end
    [whitelist, ~] = padVectors(whitelist, 1);
    for name = 1:size(fnames,1)
        whitelist.(fnames{name}) = logical(whitelist.(fnames{name}));
    end
    params={'x/a','y/d','z','$\alpha$','$beta$','$\theta$'};
    %% xt contains the parameters names
    xt = {};
    for name=1:length(fnames)
        if any(any(whitelist.(fnames{name})))
           links=robot.findLinkByGroup(fnames{name});
           idx=find(whitelist.(fnames{name})')-1;
           col=mod(idx,6)+1;
           row=floor(idx/6)+1;
           for i=1:size(whitelist.(fnames{name}),1)
              for j=col(row==i)'
                  xt{end+1}=[links{i}.name,' ',params{j}];
              end       
           end
        end  
    end
    %% choose subplots grid
    jacobians = reshape(jacobians, [],1,1);
    count = 1;
    for fig=1:floor(length(jacobians)/6)+1
        rows = 2;
        cols = 3;
        h = figure();
        hold on;
        %% plot normalized jacobians
        for j = count:min(count+5,length(jacobians))
            subplot(rows,cols,j-count+1);
            maxs = max(max(abs(jacobians{j})));
            maxs(maxs == 0) = 1;
            jac = jacobians{j}./maxs;
            bplot(jac);
            set(gca, 'Xtick', 1:size(jac,2), 'XTickLabel',xt, 'FontSize',12)
            ylim([-1,1])
            xlim([0.5, size(jac,2)+0.5])
            bp = gca;
            xtickangle(15)
            bp.XAxis.TickLabelInterpreter = 'latex';
            ylabel('$\frac{\partial X_i}{\partial \phi_j}$', 'Interpreter', 'latex','FontSize',12);

            bp.XAxis.FontSize = 15;
            set(findobj(gca,'Type','text'),'FontSize')
            if nargin==1
                title(['Rep ',num2str(j)])
            elseif(iscell(titles))
                title(titles{j})
            else
                title(titles)
            end
            grid on;
        end
        count = count + 6;
        set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12)
    end
end

