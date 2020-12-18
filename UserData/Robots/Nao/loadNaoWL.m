function WL = loadNaoWL()
% LOADNAOWL  Nao whitelist configuration function
%     Custom function for robot whitelist configuration. Position in
%     whitelist logical matrix corresponds with the position in kinematics matrix. 
%     Value 1 means the parameter will be calibrated. 
%  OUTPUT - WL - whitelist structure
    hands_upper=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
    hands_lower=[19,20,21,22,23,25,26,31];
    head_left=[0,1,2,3,4,5,6,7,8,12,13,15];
    head_right=[16,17,18,19,20,21,22,23,24,28,29,31];
    torso_left=[0,1,2,3,4,5,8,9,10,11,12,13,14,15];
    torso_right=[16,17,18,24,25,26,27,28,29,30,31];
    indexes = [250, 240, 240];
    WL.leftArm= ...
              [1, 1, 1, 1;
               1, 1, 1, 1;
               1, 1, 1, 1;
               1, 1, 1, 1;
               1, 1, 1, 1;
               1, 1, 1, 1];
    WL.rightArm= ...
              [1,1,1,1; 
               1,1,1,1;
               1,1,1,1;
               1,1,1,1;
               1,1,1,1;
               1,1,1,1];
    WL.head= ...
        [1, 1, 1, 1;
         1, 1, 1, 1;
         1, 1, 1, 1];
    WL.dummy = [0,0,0,0;
                0,0,0,0];
    WL.torsoSkin=[[1,1,1,1,1,1];ones(size(torso_left,2)+size(torso_right,2)+2+indexes(1),6)];
    WL.leftArmSkin=[[1,1,1,1,1,1];ones(size(hands_upper,2)+size(hands_lower,2)+2+indexes(3),6)];
    WL.rightArmSkin=[[1,1,1,1,1,1];ones(size(hands_upper,2)+size(hands_lower,2)+2+indexes(3),6)];
    WL.headSkin=[[1,1,1,1,1,1];ones(size(head_left,2)+size(head_right,2)+2+indexes(2),6)];
end