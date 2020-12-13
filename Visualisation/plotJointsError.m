function plotJointsError(robot, errors, dataset, group, plotTitle, skipIndexes)
%PLOTJOINTSERROR Function for plotting mean errors for each joint value
%INPUT - robot - Robot object
%      - errors - 1xN array of errors
%      - dataset - dataset structure
%      - group - group of joints
%      - plotTitle - plot title, can be empty ('')
%      - skipIndexes - vector of joint indexes which should be skipped
    if(nargin <6)
        skipIndexes = [];
    end
    joints = robot.findJointByGroup(group);
    joints = [joints{:}];
    names = {joints.name};    
    joint_angles = [];
    
    %% merge dataset joint angles
    for i = 1:length(dataset)
       [~, index_new_poses, ~] = unique(dataset{i}.pose);
       angles = reshape([dataset{i}.joints.(group)],length(names),[])';
       joint_angles = [joint_angles; angles(index_new_poses,:)];
    end
    joint_angles = joint_angles/pi*180;
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
    
    %% plot
    index = 1;
    figure()
    for i=1:length(names)
        if ismember(i, skipIndexes) % skip unwanted joint
            continue
        end
        subplot(rows,cols,index);
        index = index + 1;
        ang = joint_angles(:,i);
        [~,idx,ib] = unique(ang); % unique joint values
        a = accumarray(ib,errors,[],@mean);  % mean error for each joint value
        plot(ang(idx),a);
        xlabel([names{i},' [deg]']);
        ylabel('error [m]');
        grid on
    end
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.45, 0.98, plotTitle, 'FontSize', 14)
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12)
end