function setRobot(robot)
    if strcmp(robot.name,'nao')
        loadNAO(robot);
    end
    
    
    joints=cell(size(robot.optProperties.structure,2));
    for jointId=1:size(robot.optProperties.structure,2)
        curJoint=robot.optProperties.structure{jointId};
        if ~isnan(curJoint{3})
            j=joints{curJoint{3}};
        else
            j=nan;
        end
        joints{jointId}=joint(curJoint{1},curJoint{2},j,curJoint{4},curJoint{5},curJoint{6},curJoint{7},curJoint{8},curJoint{9});
        robot.joints{end+1}=joints{jointId};
        %if curJoint{8}
        %   robot.endEffectors{end+1}= joints{jointId};
        %end
    end
    
    
end