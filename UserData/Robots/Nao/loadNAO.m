function [name, jointStructure, structure]=loadNAO()
    %LOADNAO returns structure of the NAO robot
    %   OUTPUT - name - string name of the robot
    %          - jointStructure - joint structure of the robot
    %          - structure - DH,WL and bounds of the robot
    
    %% Patches
    hands_upper=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
    hands_lower=[19,20,21,22,23,25,26,31];
    head_left=[0,1,2,3,4,5,6,7,8,12,13,15];
    head_right=[16,17,18,19,20,21,22,23,24,28,29,31];
    torso_left=[0,1,2,3,4,5,8,9,10,11,12,13,14,15];
    torso_right=[16,17,18,24,25,26,27,28,29,30,31];
    
    %% Robot structure
    jointStructure={{'base',types.base,nan,0,group.torso},...
        ...
        {'headYaw',types.joint,'base',1,group.head},...
        {'headPitch',types.joint,'headYaw',2,group.head},...
        {'headEE',types.joint,'headPitch',3,group.head},...
        ...
        {'headSkinMount',types.mount,'headEE',1,group.headSkin},...
        {'headLeftPatch',types.patch,'headSkinMount',2,group.headSkin},...
        {'headRightPatch',types.patch,'headSkinMount',3,group.headSkin},...
        ...
        {'leftShoulderPitch',types.joint,'base',1,group.leftArm},...
        {'leftShoulderRoll',types.joint,'leftShoulderPitch',2,group.leftArm},...
        {'leftElbowYaw',types.joint,'leftShoulderRoll',3,group.leftArm},...
        {'leftElbowRoll',types.joint,'leftElbowYaw',4,group.leftArm},...
        {'leftWristYaw',types.joint,'leftElbowRoll',5,group.leftArm},...
        {'leftEE',types.joint,'leftWristYaw',6,group.leftArm},...
        ...
        {'leftDummy', types.joint, 'leftWristYaw', 2, group.dummy},...
        ...
        {'leftSkinMount',types.mount,'leftDummy',1,group.leftArmSkin},...
        {'leftUpperPatch',types.patch,'leftSkinMount',2,group.leftArmSkin},...
        {'leftLowerPatch',types.patch,'leftSkinMount',3,group.leftArmSkin},...
        ...
        {'rightShoulderPitch',types.joint,'base',1,group.rightArm},...
        {'rightShoulderRoll',types.joint,'rightShoulderPitch',2,group.rightArm},...
        {'rightElbowYaw',types.joint,'rightShoulderRoll',3,group.rightArm},...
        {'rightElbowRoll',types.joint,'rightElbowYaw',4,group.rightArm},...
        {'rightWristYaw',types.joint,'rightElbowRoll',5,group.rightArm},...
        {'rightEE',types.joint,'rightWristYaw',6,group.rightArm},...
        ...
        {'rightDummy', types.joint, 'rightWristYaw', 1, group.dummy},...
        ...
        {'rightSkinMount',types.mount,'rightDummy',1,group.rightArmSkin},...
        {'rightUpperPatch',types.patch,'rightSkinMount',2,group.rightArmSkin},...
        {'rightLowerPatch',types.patch,'rightSkinMount',3,group.rightArmSkin},...
        ...
        {'torsoSkinMount',types.mount,'base',1,group.torsoSkin},...
        {'torsoLeftPatch',types.patch,'torsoSkinMount',2,group.torsoSkin},...
        {'torsoRightPatch',types.patch,'torsoSkinMount',3,group.torsoSkin},...
        ...
        {'leftFinger', types.joint, 'leftEE', 1, group.leftFinger},...
        {'rightFinger', types.joint, 'rightEE', 1, group.rightFinger}};
        
    
    %% Assign triangles into the structure
    for triangleId=1:size(hands_upper,2)
        jointStructure{end+1}={strcat('rightTriangle',num2str(hands_upper(triangleId))),types.triangle,'rightUpperPatch',triangleId+3,group.rightArmSkin};
        jointStructure{end+1}={strcat('leftTriangle',num2str(hands_upper(triangleId))),types.triangle,'leftUpperPatch',triangleId+3,group.leftArmSkin};
    end
    for triangleId=1:size(hands_lower,2)
        jointStructure{end+1}={strcat('rightTriangle',num2str(hands_lower(triangleId))),types.triangle,'rightLowerPatch',triangleId+3+size(hands_upper,2),group.rightArmSkin};
        jointStructure{end+1}={strcat('leftTriangle',num2str(hands_lower(triangleId))),types.triangle,'leftLowerPatch',triangleId+3+size(hands_upper,2),group.leftArmSkin};
    end
    for triangleId=1:size(head_left,2)
        jointStructure{end+1}={strcat('headTriangle',num2str(head_left(triangleId))),types.triangle,'headLeftPatch',triangleId+3,group.headSkin};
    end
    for triangleId=1:size(head_right,2)
        jointStructure{end+1}={strcat('headTriangle',num2str(head_right(triangleId))),types.triangle,'headRightPatch',triangleId+3+size(head_left,2),group.headSkin};
    end
    for triangleId=1:size(torso_left,2)
        jointStructure{end+1}={strcat('torsoTriangle',num2str(torso_left(triangleId))),types.triangle,'torsoLeftPatch',triangleId+3,group.torsoSkin};
    end
    for triangleId=1:size(torso_right,2)
        jointStructure{end+1}={strcat('torsoTriangle',num2str(torso_right(triangleId))),types.triangle,'torsoRightPatch',triangleId+3+size(torso_left,2),group.torsoSkin};
    end
    
    %% Assign taxels to the strucutre
    indexes = [0,0,0];
    index_offsets = [3+size(torso_left,2)+size(torso_right,2);
                     3+size(head_left,2)+size(head_right,2);
                     3+size(hands_upper,2)+size(hands_lower,2)];
    for i=0:383
       taxel_num = mod(i,12);
       if taxel_num ~= 6 && taxel_num ~= 10
            triangle_num = fix(i/12);
            if ismember(triangle_num, [torso_left,torso_right])
                indexes(1) = indexes(1) + 1;
                jointStructure{end+1}={strcat('torsoTaxel', num2str(triangle_num),'_',num2str(taxel_num)), ...
                    types.taxel, strcat('torsoTriangle', num2str(triangle_num)),...
                    index_offsets(1)+indexes(1), group.torsoSkin};
            end
            if ismember(triangle_num, [head_left,head_right])
                indexes(2) = indexes(2) + 1;
                jointStructure{end+1}={strcat('headTaxel', num2str(triangle_num),'_',num2str(taxel_num)), ...
                    types.taxel, strcat('headTriangle', num2str(triangle_num)),...
                    index_offsets(2)+indexes(2), group.headSkin};
                
            end
            if ismember(triangle_num, [hands_upper,hands_lower])
                indexes(3) = indexes(3) + 1;
                jointStructure{end+1}={strcat('leftTaxel', num2str(triangle_num),'_',num2str(taxel_num)), ...
                    types.taxel, strcat('leftTriangle', num2str(triangle_num)),...
                    index_offsets(3)+indexes(3), group.leftArmSkin};
                jointStructure{end+1}={strcat('rightTaxel', num2str(triangle_num),'_',num2str(taxel_num)), ...
                    types.taxel, strcat('rightTriangle', num2str(triangle_num)),...
                    index_offsets(3)+indexes(3), group.rightArmSkin};
            end
       end
    end

    %% DH
    structure.DH.leftArm=[0, 0.1, -pi/2, 0;
               0, 0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               0.015, 0.105, -pi/2, 0.0;
               0, 0.0, pi/2, 0;
               0, 0.05775+0.05595, -pi/2, pi];
    structure.DH.rightArm=[0, 0.1, -pi/2, 0; 
               0, -0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               -0.015, 0.105, -pi/2, 0.0;
               0, 0, pi/2, 0;
               0, 0.05775+0.05595, -pi/2, pi;];

    structure.DH.head=[0, 0.1265, 0, 0.0;
         0, 0, -pi/2, 0;
         0,0,0,0];
     structure.DH.dummy = [0, 0.05595, -pi/2, pi;
                           0, 0.05595, -pi/2, pi];
   
    %% robot default joint position (e.g. home position) for visualisation    
    structure.defaultJoints = {zeros(1,6), zeros(1,6), zeros(1,3), 0, 0};
    
    %% Bounds
    structure.bounds.joint=[inf, inf, inf, inf, inf, inf];
    structure.bounds.mount=[0.15,0.15,0.15,inf, inf, inf];
    structure.bounds.patch=[0.003,0.003,0.003,pi/30,pi/30,pi/30];
    structure.bounds.triangle=[0.0005,0.0005,0.0005,pi/40,pi/40,pi/40];
    structure.bounds.finger=[0.001,0.001,0.001,pi/20,pi/20,pi/20];
    structure.bounds.taxel=[0.001,0.001,0.001,pi/20,pi/20,pi/20];
    
    %% Whitelist
    structure.WL.leftArm= ...
              [0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0,  0, 0, nan, nan;
               0, 0, 0, 0.0, nan, nan;
               0, 0, 0, 0, nan, nan];
    structure.WL.rightArm= ...
              [0, 0, 0, 0, nan, nan; 
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan];
    structure.WL.head= ...
        [0, 0, 0, 0, nan, nan;
         0, 0, 0, 0, nan, nan;
         0,0,0,0, nan, nan];
    structure.WL.torsoSkin=[[1,1,1,1,1,1];ones(size(torso_left,2)+size(torso_right,2)+2+indexes(1),6)];
    structure.WL.leftArmSkin=[[1,1,1,1,1,1];ones(size(hands_upper,2)+size(hands_lower,2)+2+indexes(3),6)];
    structure.WL.rightArmSkin=[[1,1,1,1,1,1];ones(size(hands_upper,2)+size(hands_lower,2)+2+indexes(3),6)];
    structure.WL.headSkin=[[1,1,1,1,1,1];ones(size(head_left,2)+size(head_right,2)+2+indexes(2),6)];
    structure.WL.leftFinger = [1,1,1,0,0,0];
    structure.WL.rightFinger = [1,1,1,0,0,0];
    %% Name
    name='nao';
    
    %% Fingers    
    %Add zeros to angles and add to DH  
    structure.DH.leftFinger = [0, 0, 0.0600,zeros(1,3)];
    structure.DH.rightFinger = [0, 0, 0.0600,zeros(1,3)];
    %% Translatoon Matrices
    rightArmSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/rightArm.txt',' ', 0);                     
    structure.DH.rightArmSkin=[rightArmSkinTranslation,zeros(size(rightArmSkinTranslation,1),3)];
    structure.DH.rightArmSkin(1,:) = [-0.0292, -0.0300, -0.0222, -0.5452, 1.7668, 1.9904];    

    leftArmSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/leftArm.txt',' ', 0);
    structure.DH.leftArmSkin=[leftArmSkinTranslation,zeros(size(leftArmSkinTranslation,1),3)];
     structure.DH.leftArmSkin(1,:) = [0.0295,-0.0682,-0.0259,1.5291,0.5315,-0.4926];
    
    torsoSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/torso.txt',' ', 0);
    structure.DH.torsoSkin=[torsoSkinTranslation,zeros(size(torsoSkinTranslation,1),3)];
    structure.DH.torsoSkin(1,:) = [0.0646, 0.0006, 0.0468, -0.0012, 0.0427, 0.0005];

    
    headSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/head.txt',' ', 0);
    structure.DH.headSkin=[headSkinTranslation,zeros(size(headSkinTranslation,1),3)];
    structure.DH.headSkin(1,:)= [0.0597, -0.0704, -0.0013, 1.5512, -0.2112, -0.2574];


end