function plotObserIndexes(folder)
    %PLOTOBSERINDEXES Function for plotting jacobians
    %INPUT - folder - folder with results
    
    
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
    obsIndexes = cell2mat(permute(struct2cell(info.obsIndexes), [2,3,1]));
    figure();
    titles = fieldnames(info.obsIndexes);
    ticks = cell(1, size(obsIndexes,2));     
    perts = find(info.optim.pert == 1);
    if (info.optim.skipNoPert) 
        index = 1;
    else
        ticks{1} = 'no pert';  
        index = 2;
    end
    for i = perts
        ticks{index} = ['pert ', num2str(i)];
        index = index+1;
    end
    hold on;
    for j= 1:4
        subplot(2,2,j);
        bplot(obsIndexes(:,:,j));
        set(gca, 'Xtick', 1:size(obsIndexes,2), 'XTickLabel',ticks, 'FontSize',16)
        title(titles(j));
        xlim([0.5, size(obsIndexes,2)+0.5])
        bp = gca;
        xtickangle(30)
        ylabel('Value [-]','FontSize',15);
        bp.XAxis.FontSize = 15;
        set(findobj(gca,'Type','text'),'FontSize')
        grid on;
        set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
    end
end

