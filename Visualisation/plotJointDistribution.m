function plotJointDistribution(robot, dataset, dataset2, group, plotTitle, legends, type, skipIndexes)
    %PLOTJOINTDISTRIBUTION Function for plotting joint distribution
    %INPUT - robot - Robot object
    %      - dataset - first dataset structure
    %      - dataset2 - second dataset structure, can be empty ([])
    %      - group - group of joints
    %      - plotTitle - plot title, can be empty ('')
    %      - legends - cell array of legend labels, can be empty ('')
    %      - type - 1 - two independent datasets; 2 - first dataset is part of second dataset
    %      - skipIndexes - vector of joint indexes which should be skipped
    
    
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
    
    
    if(nargin <8)
        skipIndexes = [];
    end
    links = robot.findLinkByGroup(group);
    links = [links{:}];
    names = {links.name};
    pose_number = [];
    joint_angles = [];
    pose_number2 = [];
    joint_angles2 = [];
    %% merge dataset joint angles and pose numbers
    for i = 1:length(dataset)
       pose_number = [pose_number; dataset{i}.pose];
       [~, index_new_poses, ~] = unique(dataset{i}.pose);
       angles = reshape([dataset{i}.joints.(group)],length(names),[])';
       joint_angles = [joint_angles; angles(index_new_poses,:)];
    end
    for i = 1:length(dataset2)
        pose_number2 = [pose_number2; dataset2{i}.pose];
        [~, index_new_poses, ~] = unique(dataset2{i}.pose);
        angles =  reshape([dataset2{i}.joints.(group)],length(names),[])';
        joint_angles2 = [joint_angles2; angles(index_new_poses,:)];
    end
    %% set transparency depends on type
    if(type == 1)
        transparency = 0.6;
    else
        transparency = 1;
    end
    %% choose subplots grid
    count = length(names)-length(skipIndexes);
    if(count < 4)
        rows = 1;
        cols = 3;
    elseif(count < 5)
       rows = 2;
       cols = 2; 
    elseif(count < 7)
        rows = 2;
        cols = 3;
    elseif(count < 9)
        rows = 2;
        cols = 4;
    elseif(count < 10)
        rows = 3;
        cols = 3;
    elseif(count < 13)
        rows = 3;
        cols = 4;
    else
        rows = 4;
        cols = 4;
    end
    figure();
    %% plot histograms
    index = 1;
    for i=1:length(names)
        if ismember(i, skipIndexes) % skip unwanted link
            continue
        end
        subplot(rows,cols,index);
        index = index + 1;
        hold on;
        grid on;
        histogram(joint_angles(:,i),'BinWidth',0.1, 'FaceAlpha',transparency, 'FaceColor', [0.4660 0.6740 0.1880]);
        if(~isempty(dataset2))
            histogram(joint_angles2(:,i),'BinWidth',0.1, 'FaceAlpha',transparency, 'FaceColor', 'b');  
        end
        title(names{i});
        xlabel('joint angle [rad]');
        ylabel('# of poses');
    end
    if isempty(legends)
        legends={'dataset1','dataset2'};
    end
    legend(legends,'Location','east');
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.55-length(plotTitle)/100, 0.98, plotTitle, 'FontSize', 14)
    %set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12)
end
