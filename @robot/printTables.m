function printTables( robot, tableType )

fnames=fieldnames(robot.structure.(tableType));
for name=1:length(fnames)
    table=robot.structure.(tableType).(fnames{name});
    fprintf('%s\n',(fnames{name}));
    for j=1:size(table,1)
        joint=robot.findJointById(j);
        joint=robot.findJointByGroup(fnames{name},joint);
        fprintf('%-5.2f %-5.2f %-5.2f %-5.2f %-s\n',table(j,:),joint.name);
    end
end

end

