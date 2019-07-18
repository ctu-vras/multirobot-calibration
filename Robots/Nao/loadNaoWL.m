function WL = loadNaoWL()
%LOADMOTOMANWL Summary of this function goes here
%   Detailed explanation goes here
    hands_upper=[7,8,9,10,11,14,15,0,13,12,1,2,3,4,5,6];
    hands_lower=[19,22,23,25,26,20,21,31];
    head_left=[0,1,2,3,4,5,6,7,8,12,13,15];
    head_right=[16,17,18,19,20,21,22,23,24,28,29,31];
    torso_left=[0,1,2,3,4,5,8,9,10,11,12,13,14,15];
    torso_right=[16,17,18,24,25,26,27,28,29,30,31];
    WL.leftArm= ...
              [0, 0, 0, 0;
               0, 0, 0, 0;
               0, 0,  0, 0;
               0, 0, 0, 0.0;
               0, 0, 0, 0;
               0, 0, 0, 0];
    WL.rightArm= ...
              [1,1,0,0; 
               1,1,1,1;
               0,0,1,1;
               1,1,1,1;
               1,1,1,1;
               1,1,1,1];
    WL.head= ...
        [0, 0, 0, 0;
         0, 0, 0, 0;
         0,0,0,0];
    WL.torsoSkin=[1,1,1,1;ones(size(hands_upper,2)+size(hands_lower,2)+2,4)];
    WL.leftArmSkin=[1,1,1,1;ones(size(hands_upper,2)+size(hands_lower,2)+2,4)];
    %WL.rightArmSkin=ones(size(hands_upper,2)+size(hands_lower,2)+3,4);
    WL.rightArmSkin=[1,1,1,1;
        1,1,1,1;
        ones(size(hands_upper,2)+size(hands_lower,2)+1,4)];
    WL.headSkin=zeros(size(head_left,2)+size(head_right,2)+3,4);
end