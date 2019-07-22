function printTables( robot, tableType )
% PRINTTABLES displays tables from Robot.structure as 
%             'a, d, alpha, theta jointName'
%   INPUT - tableType - string 'DH'/'WL'

%get all fieldnames
fnames=fieldnames(robot.structure.(tableType));
for name=1:length(fnames)
    %Get right table
    table=robot.structure.(tableType).(fnames{name});
    %disp group name
    fprintf('%s\n',(fnames{name}));
    %find all joints in given group
    joints=robot.findJointByGroup(fnames{name});
    %print in given format
    for j=1:size(table,1)
        fprintf('%-5.2f %-5.2f %-5.2f %-5.2f %-s\n',table(j,:),joints{j}.name);
    end
end

end

