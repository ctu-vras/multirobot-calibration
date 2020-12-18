function [ WL ] = loadICUBWL()
%LOADICUBWL iCub whitelist configuration function
%   Custom function for robot whitelist configuration. Position in
%   whitelist logical matrix corresponds with the position in kinematics matrix. 
%   Value 1 means the parameter will be calibrated. 
%OUTPUT - WL - whitelist structure
    WL.head = zeros(4,4);
    
    WL.leftArm = [0, 0, 0, 0;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 0, 1];
       
    WL.rightArm = [0, 0, 0, 0;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 1, 1;
                 1, 1, 0, 1];
                          
    WL.leftEye = ones(2,4);
        
    WL.rightEye = ones(2,4);
    
    WL.torso = zeros(2,4);
    
end

