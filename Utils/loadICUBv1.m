function [ name, structure, structure2 ] = loadICUBv1()
%LOADMOTOMAN Summary of this function goes here
%   Detailed explanation goes here
    name='icub';
    %% Robot structure
    structure={{'torsoYaw',types.base,nan,0,0,group.torso},...
        {'torsoRoll',types.joint,1,1,0,group.torso},... % link from 1st to 2nd torso joint
        {'torsoPitch',types.joint,2,2,0,group.torso},... % link from 2nd to 3rd torso joint 
        ...
        {'leftShoulderPitch',types.joint,3,1,0,group.leftArm},... 
        {'leftShoulderRoll',types.joint,4,2,0,group.leftArm},... 
        {'leftShoulderYaw',types.joint,5,3,0,group.leftArm},...
        {'leftElbow',types.joint,6,4,0,group.leftArm},...
        {'leftWristProsup',types.joint,7,5,0,group.leftArm},...
        {'leftWristPitch',types.joint,8,6,0,group.leftArm},...
        {'leftWristYaw',types.joint,9,7,0,group.leftArm},...
        {'leftHandFinger',types.joint,10,8,1,group.leftArm},...
        ...
        {'rightShoulderPitch',types.joint,3,1,0,group.rightArm},...
        {'rightShoulderRoll',types.joint,12,2,0,group.rightArm},...
        {'rightShoulderYaw',types.joint,13,3,0,group.rightArm},...
        {'rightElbow',types.joint,14,4,0,group.rightArm},...
        {'rightWristProsup',types.joint,15,5,0,group.rightArm},...
        {'rightWristPitch',types.joint,16,6,0,group.rightArm},...
        {'rightWristYaw',types.joint,17,7,0,group.rightArm},...
        {'rightHandFinger',types.joint,18,8,1,group.rightArm},...
        ...
        {'neckPitch',types.joint,3,1,0,group.head},... % from 3rd torso to first neck
        {'neckRoll',types.joint,20,2,0,group.head},...
        {'neckYaw',types.joint,21,3,0,group.head},...
        {'eyesTilt',types.joint,22,4,0,group.head}, ...
        ...
        {'leftEyeVersion',types.joint,23,1,0,group.leftEye},...
        {'leftEyeVergence',types.eye,24,2,1,group.leftEye},...
        {'rightEyeVersion',types.joint,23,1,0,group.rightEye},...
        {'rightEyeVergence',types.eye,26,2,1,group.rightEye}};  
        
        
    structure2.torso = [0.032, 0.000, pi/2.0, 0.000; 
                        0.000, -0.0055, pi/2.0, -pi/2]; 
                    
    structure2.DH.leftArm = [0.0233647, -0.1433, -pi/2.0, 105.0*pi/180;
                             0.000, 0.10774, -pi/2.0, pi/2.0;
                             0.000, 0.000, pi/2.0, -pi/2.0;
                             0.015, 0.15228, -pi/2.0, 75.0*pi/180;
                            -0.015, 0.000, pi/2.0, 0.000;
                             0.000, 0.1373, pi/2.0, -pi/2;
                             0.000, 0.000, pi/2.0, pi/2;
                            0.0625, -0.016, 0.000, 0.000 ];
            
    structure2.DH.rightArm =  [-0.0233647, -0.1433, pi/2.0, -105.0*pi/180;  
                                 0.000, -0.10774, pi/2.0, -pi/2;
                                 0.000, 0.000, -pi/2.0, -pi/2;
                                -0.015, -0.15228, -pi/2.0, -105.0*pi/180;
                                 0.015, 0.000, pi/2.0, 0.000;
                                 0.000, -0.1373, pi/2.0, -pi/2;
                                 0.000, 0.000, pi/2.0, pi/2;
                                0.0625, 0.016, 0, pi ]; 
           
    structure2.DH.head = [0.00231, -0.1933, -pi/2.0, -pi/2.0;  
                       0.033, 0.000,  pi/2.0,  pi/2.0;
                       0.000, 0.001, -pi/2.0, -pi/2.0;
                       -0.054, 0.0825, -pi/2.0,  pi/2.0];
                
    structure2.DH.leftEye = [0.000, -0.034, -pi/2.0,   0.000;  
                       0.000,  0.000,  pi/2.0,  -pi/2.0];
                    
    structure2.DH.rightEye = [0.000, 0.034, -pi/2.0, 0.000;  
                       0.000, 0.000, pi/2.0, -pi/2.0]; 
                                     
                   
    structure2.WL.leftArm = [0, 0, 0, 0;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1];
                            
            
    structure2.WL.rightArm = [0, 0, 0, 0;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1];
           
    structure2.WL.head = [1, 1, 1, 1;
                          1, 1, 1, 1;
                          1, 1, 1, 1;
                          1, 1, 1, 1];
                
    structure2.WL.leftEye = [1, 1, 1, 1;
                             1, 1, 1, 1];
                    
    structure2.WL.rightEye = [1, 1, 1, 1;
                              1, 1, 1, 1];
          
    structure2.H0 = [0 -1  0  0;
                     0  0 -1  0;
                     1  0  0  0;
                     0  0  0  1];
                 
    structure2.bounds.joint = [inf inf inf inf];
    structure2.bounds.eye = [inf inf inf inf];
        
end

