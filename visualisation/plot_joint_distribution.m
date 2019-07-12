function plot_joint_distribution(robot, dataset, dataset2, group, plot_title, legends, type, skip_indexes)
%PLOT_JOINT_DISTRIBUTION
%type 1 - two independent datasets
%type 2 - first dataset is part of second dataset
if(nargin <8)
    skip_indexes = [];
end
joints = robot.findJointByGroup(group);
joints = [joints{:}];
names = {joints.name};
pose_number = [];
joint_angles = [];
pose_number2 = [];
joint_angles2 = [];
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

if(type == 1)
    transparency = 0.6;
else
    transparency = 1;
end
 figure('Position', [10 10 1200 800]);
% 
% posun = 0;
index = 1;
count = length(names)-length(skip_indexes);
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

for i=1:length(names)
    if ismember(i, skip_indexes)
        continue
    end
    subplot(rows,cols,index);
    index = index + 1;
    hold on;
    grid on;
    if(~isempty(dataset))
        histogram(joint_angles(:,i),'BinWidth',0.1, 'FaceAlpha',transparency, 'FaceColor', 'b');
    end
    histogram(joint_angles2(:,i),'BinWidth',0.1, 'FaceAlpha',transparency, 'FaceColor', [0.4660 0.6740 0.1880]);  
    title(names{i});
    xlabel('joint angle [rad]');
    ylabel('# of poses');
        
end
lh = legend(legends,'Location','east');
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.45, 0.98, plot_title, 'FontSize', 14)
plot_title = strrep(plot_title, ' ','_');
% % saveas(gcf, ['joint-distribution-',plot_title '.png']);

