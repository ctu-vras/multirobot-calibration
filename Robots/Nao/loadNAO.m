function [name, jointStructure, structure]=loadNAO()
    %LOADNAO returns structure of the NAO robot
    %   OUTPUT - name - string name of the robot
    %          - jointStructure - joint structure of the robot
    %          - structure - DH,WL and bounds of the robot
    
    %% Patches
%     hands_upper=[7,8,9,10,11,14,15,0,13,12,1,2,3,4,5,6];
%     hands_lower=[19,22,23,25,26,20,21,31];
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
        {'headPlastic',types.mount,'headEE',1,group.headSkin},...
        {'headLeftPatch',types.patch,'headPlastic',2,group.headSkin},...
        {'headRightPatch',types.patch,'headPlastic',3,group.headSkin},...
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
        {'leftPlastic',types.mount,'leftDummy',1,group.leftArmSkin},...
        {'leftUpperPatch',types.patch,'leftPlastic',2,group.leftArmSkin},...
        {'leftLowerPatch',types.patch,'leftPlastic',3,group.leftArmSkin},...
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
        {'rightPlastic',types.mount,'rightDummy',1,group.rightArmSkin},...
        {'rightUpperPatch',types.patch,'rightPlastic',2,group.rightArmSkin},...
        {'rightLowerPatch',types.patch,'rightPlastic',3,group.rightArmSkin},...
        ...
        {'torsoPlastic',types.mount,'base',1,group.torsoSkin},...
        {'torsoLeftPatch',types.patch,'torsoPlastic',2,group.torsoSkin},...
        {'torsoRightPatch',types.patch,'torsoPlastic',3,group.torsoSkin}};
%         ...
%         {'LFinger11', types.finger, 'leftEE', 1, group.leftIndex},...
%         {'LFinger12', types.finger, 'LFinger11', 2, group.leftIndex},...
%         {'LFinger13', types.finger, 'LFinger12', 3, group.leftIndex},...
%         {'LFinger21', types.finger, 'leftEE', 1, group.leftMiddle},...
%         {'LFinger22', types.finger, 'LFinger21', 2, group.leftMiddle},...
%         {'LFinger23', types.finger, 'LFinger22', 3, group.leftMiddle},...
%         {'LThumb1', types.finger, 'leftEE', 1, group.leftThumb},...
%         {'LThumb2', types.finger, 'LThumb1', 2, group.leftThumb},...
%         {'leftFinger', types.joint, 'leftEE', 1, group.leftFinger},...}
%         ...
%         {'RFinger11', types.finger, 'rightEE', 1, group.rightIndex},...
%         {'RFinger12', types.finger, 'RFinger11', 2, group.rightIndex},...
%         {'RFinger13', types.finger, 'RFinger12', 3, group.rightIndex},...
%         {'RFinger21', types.finger, 'rightEE', 1, group.rightMiddle},...
%         {'RFinger22', types.finger, 'RFinger21', 2, group.rightMiddle},...
%         {'RFinger23', types.finger, 'RFinger22', 3, group.rightMiddle},...
%         {'RThumb1', types.finger, 'rightEE', 1, group.rightThumb},...
%         {'RThumb2', types.finger, 'RThumb1', 2, group.rightThumb},...
%         {'rightFinger', types.joint, 'rightEE', 1, group.rightFinger}};
    
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
               0, 0.05775+0.05595, -pi/2, pi];%0, 0.05775+0.05595, -pi/2, pi
%     structure.DH.leftArm = [0, 0.098, 0.1, 0, 0, 0;
%                             0, 0, -pi/2, 0, nan, nan;
%                             0, 0, pi/2, pi/2, nan, nan;
%                             0.015, 0.105, pi/2, 0, nan, nan;
%                             0, 0, 0, 0, 0, -pi/2;
%                             0.05595, 0, 0, 0, 0, 0];
    structure.DH.rightArm=[0, 0.1, -pi/2, 0; 
               0, -0.098, pi/2, 0;
               0, 0,  pi/2, pi/2;
               -0.015, 0.105, -pi/2, 0.0;
               0, 0, pi/2, 0;
               0, 0.05775+0.05595, -pi/2, pi;];%0, 0.05775+0.05595, -pi/2, pi

    structure.DH.head=[0, 0.1265, 0, 0.0;
         0, 0, -pi/2, 0;
         0,0,0,0];
     structure.DH.dummy = [0, 0, -pi/2, pi;
                           0, 0, -pi/2, pi];
%     structure.DH.torsoSkin=zeros(3+size(torso_left,2)+size(torso_right,2)+indexes(1),6);
%     structure.DH.headSkin=zeros(size(head_left,2)+size(head_right,2)+3+indexes(2),6);
%     structure.DH.leftArmSkin=zeros(size(hands_upper,2)+size(hands_lower,2)+3+indexes(3),6);
%     structure.DH.rightArmSkin=zeros(size(hands_upper,2)+size(hands_lower,2)+3+indexes(3),6);
    structure.H0 = [1 0 0 0;
                     0 1 0 0;
                     0 0 1 0;
                     0 0 0 1];
    
    %% robot default joint position (e.g. home position) for visualisation    
    structure.defaultJoints = {zeros(1,6), zeros(1,6), zeros(1,3)};
    
    %% Bounds
    structure.bounds.joint=[inf, inf, inf, inf, inf, inf];
    structure.bounds.mount=[0.15,0.15,0.15,pi,pi,pi];
    structure.bounds.patch=[0.007,0.007,0.007,pi/20,pi/20,pi/20];
    structure.bounds.triangle=[0.0005,0.0005,0.0005,pi/40,pi/40,pi/40];
    structure.bounds.finger=[0.001,0.001,0.001,pi/20,pi/20,pi/20];
    structure.bounds.taxel=[0.001,0.001,0.001,pi/20,pi/20,pi/20];
    
    %% Whitelist
    structure.WL.leftArm= ...
              [0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0,  0, 0, nan, nan;
               0, 0, 0, 0.0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan];
    structure.WL.rightArm= ...
              [0, 0, 0, 0, nan, nan; 
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan;
               0, 0, 0, 0, nan, nan];
    structure.WL.head= ...
        [0, 0, 0, 0, nan, nan;
         0, 0, 0, 0, nan, nan;
         0,0,0,0, nan, nan];
%     structure.WL.dummy = [0,0,0,0; 0 0 0 0];
    structure.WL.rightArmSkin=[[1,1,1,1,nan, nan];ones(size(hands_upper,2)+size(hands_lower,2)+2+indexes(3),6)];
    structure.WL.leftArmSkin=[[1,1,1,1,nan, nan];ones(size(hands_upper,2)+size(hands_lower,2)+2+indexes(3),6)];
    structure.WL.torsoSkin=[[1,1,1,1, nan, nan];ones(size(torso_left,2)+size(torso_right,2)+2+indexes(1),6)];
    structure.WL.headSkin=[[1,1,1,1,nan, nan];ones(size(head_left,2)+size(head_right,2)+2+indexes(2),6)];
%     structure.WL.leftIndex = zeros(3,6);
%     structure.WL.rightIndex = zeros(3,6);
%     structure.WL.leftMiddle = zeros(3,6);
%     structure.WL.rightMiddle = zeros(3,6);
%     structure.WL.leftThumb = zeros(2,6);
%     structure.WL.rightThumb = zeros(2,6);
%     structure.WL.leftFinger = [1,1,1,0,0,0];
%     structure.WL.rightFinger = [1,1,1,0,0,0];
    %% Name
    name='nao';
    
    %% Fingers
    % Translation of each finger -- same for left and right arm
    fingers = [0.06907, 0.01157, -0.00304;
                   0.01436, 0, 0;
                   0.01436, 0, 0;
                   0.06907, -0.01157, -0.00304;
                   0.01436, 0, 0;
                   0.01436, 0, 0;
                   0.04895, 0, -0.02638;
                   0.01436, 0, 0;
                   0, 0, 0];
    
%     %Add zeros to angles and add to DH
%     structure.DH.leftIndex = [fingers(1:3,:),zeros(3,3)];
%     structure.DH.rightIndex = [fingers(1:3,:),zeros(3,3)];
% 
%     structure.DH.leftMiddle = [fingers(4:6,:),zeros(3,3)];
%     structure.DH.rightMiddle = [fingers(4:6,:),zeros(3,3)];
%     
%     structure.DH.leftThumb = [fingers(7:8,:),zeros(2,3)];
%     structure.DH.rightThumb = [fingers(7:8,:),zeros(2,3)];
%     
%     structure.DH.leftFinger = [fingers(9,:),zeros(1,3)];
%     structure.DH.rightFinger = [fingers(9,:),zeros(1,3)];
    %% Translatoon Matrices
    rightArmSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/rightArm.txt',' ', 0);                     
    structure.DH.rightArmSkin=[rightArmSkinTranslation,zeros(size(rightArmSkinTranslation,1),3)];
%     structure.DH.rightArmSkin(1,:) = [0.0147583849496236,-0.00443192627587114,2.74767239286415,-1.60296822098659,nan,nan];
    structure.DH.rightArmSkin(1,:) = [0,0,0,0,nan, nan];

    leftArmSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/leftArm.txt',' ', 0);
    structure.DH.leftArmSkin=[leftArmSkinTranslation,zeros(size(leftArmSkinTranslation,1),3)];
%     structure.DH.leftArmSkin(1,:) = [0.0156903503206978,-0.00540526356648849,-2.97543773911731,-1.59420115139453,nan,nan];
     structure.DH.leftArmSkin(1,:) = [0, 0, 0, 0,nan,nan];
    
    torsoSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/torso.txt',' ', 0);
    structure.DH.torsoSkin=[torsoSkinTranslation,zeros(size(torsoSkinTranslation,1),3)];
%     structure.DH.torsoSkin(1,:) = [2.23560066606708e-05,0.000110417865904946,0.00895097260336288,-0.00289365818304649,nan,nan];
    structure.DH.torsoSkin(1,:) = [0, 0, 0, 0,nan, nan];
    
    headSkinTranslation=importdata('Robots/Nao/Dataset/Transformations/head.txt',' ', 0);
    structure.DH.headSkin=[headSkinTranslation,zeros(size(headSkinTranslation,1),3)];
%     structure.DH.headSkin(1,:) = [-0.00114580222204280,0.00579003189040555,1.59493010477590,0.234818194892817,nan,nan];
    structure.DH.headSkin(1,:) = [0, 0, 0, 0,nan,nan];

end