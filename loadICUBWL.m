function [ WL ] = loadICUBWL()
%LOADICUBWL Summary of this function goes here
%   Detailed explanation goes here
    WL.head = zeros(4,4);
    
    WL.leftArm = [0, 0, 0, 0;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 0, 1];
       
    WL.rightArm = zeros(8,4);
                          
    WL.leftEye = zeros(2,4);
        
    WL.rightEye = zeros(2,4);
    
    WL.torso = zeros(2,4);

end

