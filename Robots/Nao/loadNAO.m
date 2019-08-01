function [name, joints, structure]=loadNAO()
    %LOADNAO returns structure of the NAO robot
    %   OUTPUT - name - string name of the robot
    %          - joints - joint structure of the robot
    %          - structure - DH,WL and bounds of the robot
    
    %% Patches
    hands_upper=[7,8,9,10,11,14,15,0,13,12,1,2,3,4,5,6];
    hands_lower=[19,22,23,25,26,20,21,31];
    head_left=[0,1,2,3,4,5,6,7,8,12,13,15];
    head_right=[16,17,18,19,20,21,22,23,24,28,29,31];
    torso_left=[0,1,2,3,4,5,8,9,10,11,12,13,14,15];
    torso_right=[16,17,18,24,25,26,27,28,29,30,31];
    
    %% Robot structure
    joints={{'base',types.base,nan,0,0,group.torso},...
        ...
        {'headYaw',types.joint,'base',1,0,group.head},...
        {'headPitch',types.joint,'headYaw',2,0,group.head},...
        {'headEE',types.joint,'headPitch',3,0,group.head},...
        ...
        {'headPlastic',types.mount,'headEE',1,1,group.headSkin},...
        {'headLeftPatch',types.patch,'headPlastic',2,1,group.headSkin},...
        {'headRightPatch',types.patch,'headPlastic',3,1,group.headSkin},...
        ...
        {'leftShoulderPitch',types.joint,'base',1,0,group.leftArm},...
        {'leftShoulderRoll',types.joint,'leftShoulderPitch',2,0,group.leftArm},...
        {'leftElbowYaw',types.joint,'leftShoulderRoll',3,0,group.leftArm},...
        {'leftElbowRoll',types.joint,'leftElbowYaw',4,0,group.leftArm},...
        {'leftWristYaw',types.joint,'leftElbowRoll',5,0,group.leftArm},...
        {'leftEE',types.joint,'leftWristYaw',6,0,group.leftArm},...
        ...
        {'leftPlastic',types.mount,'leftEE',1,1,group.leftArmSkin},...
        {'leftUpperPatch',types.patch,'leftPlastic',2,1,group.leftArmSkin},...
        {'leftLowerPatch',types.patch,'leftPlastic',3,1,group.leftArmSkin},...
        ...
        {'rightShoulderPitch',types.joint,'base',1,0,group.rightArm},...
        {'rightShoulderRoll',types.joint,'rightShoulderPitch',2,0,group.rightArm},...
        {'rightElbowYaw',types.joint,'rightShoulderRoll',3,0,group.rightArm},...
        {'rightElbowRoll',types.joint,'rightElbowYaw',4,0,group.rightArm},...
        {'rightWristYaw',types.joint,'rightElbowRoll',5,0,group.rightArm},...
        {'rightEE',types.joint,'rightWristYaw',6,0,group.rightArm},...
        ...
        {'rightPlastic',types.mount,'rightEE',1,1,group.rightArmSkin},...
        {'rightUpperPatch',types.patch,'rightPlastic',2,1,group.rightArmSkin},...
        {'rightLowerPatch',types.patch,'rightPlastic',3,1,group.rightArmSkin},...
        ...
        {'torsoPlastic',types.mount,'base',1,1,group.torsoSkin},...
        {'torsoLeftPatch',types.patch,'torsoPlastic',2,1,group.torsoSkin},...
        {'torsoRightPatch',types.patch,'torsoPlastic',3,1,group.torsoSkin}};
    %% Assign triangles into the structure
    for triangleId=1:size(hands_upper,2)
        joints{end+1}={strcat('rightTriangle',num2str(hands_upper(triangleId))),types.triangle,'rightUpperPatch',triangleId+3,1,group.rightArmSkin};
        joints{end+1}={strcat('leftTriangle',num2str(hands_upper(triangleId))),types.triangle,'leftUpperPatch',triangleId+3,1,group.leftArmSkin};
    end
    for triangleId=1:size(hands_lower,2)
        joints{end+1}={strcat('rightTriangle',num2str(hands_lower(triangleId))),types.triangle,'rightLowerPatch',triangleId+3+size(hands_upper,2),1,group.rightArmSkin};
        joints{end+1}={strcat('leftTriangle',num2str(hands_lower(triangleId))),types.triangle,'leftLowerPatch',triangleId+3+size(hands_upper,2),1,group.leftArmSkin};
    end
    for triangleId=1:size(head_left,2)
        joints{end+1}={strcat('headTriangle',num2str(head_left(triangleId))),types.triangle,'headLeftPatch',triangleId+3,1,group.headSkin};
    end
    for triangleId=1:size(head_right,2)
        joints{end+1}={strcat('headTriangle',num2str(head_right(triangleId))),types.triangle,'headRightPatch',triangleId+3+size(head_left,2),1,group.headSkin};
    end
    for triangleId=1:size(torso_left,2)
        joints{end+1}={strcat('torsoTriangle',num2str(torso_left(triangleId))),types.triangle,'torsoLeftPatch',triangleId+3,1,group.torsoSkin};
    end
    for triangleId=1:size(torso_right,2)
        joints{end+1}={strcat('torsoTriangle',num2str(torso_right(triangleId))),types.triangle,'torsoRightPatch',triangleId+3+size(torso_left,2),1,group.torsoSkin};
    end
    %% DH
    structure.DH.leftArm=[0, 0.1, -pi/2, 0;
               0, 0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               0, 0.105, -pi/2, 0.0;
               0, 0.0, pi/2, 0;
               0, 0, -pi/2, pi];
    structure.DH.rightArm=[0, 0.1, -pi/2, 0; 
               0, -0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               0, 0.105, -pi/2, 0.0;
               0, 0, pi/2, 0;
               0, 0, -pi/2, pi];
    structure.DH.head=[0, 0.1265, 0, 0.0;
         0, 0, -pi/2, 0;
         0,0,0,0];
    structure.DH.torsoSkin=zeros(3+size(torso_left,2)+size(torso_right,2),4);
    structure.DH.leftArmSkin=[0,0,0,0;zeros(size(hands_upper,2)+size(hands_lower,2)+2,4)];
    structure.DH.rightArmSkin=zeros(size(hands_upper,2)+size(hands_lower,2)+3,4);
    structure.DH.headSkin=zeros(size(head_left,2)+size(head_right,2)+3,4);
    structure.H0 = [1 0 0 0;
                     0 1 0 0;
                     0 0 1 0;
                     0 0 0 1];
    structure.defaultDH = structure.DH;
    
    %% Bounds
    structure.bounds.joint=[inf, inf, inf, inf];
    structure.bounds.mount=[0.15,0.15,pi,pi];
    structure.bounds.patch=[0.007,0.007,pi/20,pi/20];
    structure.bounds.triangle=[0.001,0.001,pi/20,pi/20];
    
    %% Whitelist
    structure.WL.leftArm= ...
              [0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0,  0, 0;
               0, 0, 0, 0.0;
               0, 0, 0, 0;
               0, 0, 0, 0];
    structure.WL.rightArm= ...
              [0, 0, 0, 0; 
               0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0, 0, 0];
    structure.WL.head= ...
        [0, 0, 0, 0;
         0, 0, 0, 0;
         0,0,0,0];
    structure.WL.torsoSkin=ones(3+size(torso_left,2)+size(torso_right,2),4);
    structure.WL.leftArmSkin=ones(size(hands_upper,2)+size(hands_lower,2)+3,4);
    structure.WL.rightArmSkin=ones(size(hands_upper,2)+size(hands_lower,2)+3,4);
    structure.WL.headSkin=ones(size(head_left,2)+size(head_right,2)+3,4);
    %% Name
    name='nao';
end