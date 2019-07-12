function [ name, structure, structure2 ] = loadICUBv17()
%LOADMOTOMAN Summary of this function goes here
%   Detailed explanation goes here
    name='icub';
    %% Robot structure
    structure={{'torsoYaw',types.base,nan,0,0,group.torso},...
        {'torsoRoll',types.joint,'torsoYaw',1,0,group.torso},... % link from 1st to 2nd torso joint
        {'torsoPitch',types.joint,'torsoRoll',2,0,group.torso},... % link from 2nd to 3rd torso joint 
        ...
        {'leftShoulderPitch',types.joint,'torsoPitch',1,0,group.leftArm},... 
        {'leftShoulderRoll',types.joint,'leftShoulderPitch',2,0,group.leftArm},... 
        {'leftShoulderYaw',types.joint,'leftShoulderRoll',3,0,group.leftArm},...
        {'leftElbow',types.joint,'leftShoulderYaw',4,0,group.leftArm},...
        {'leftWristProsup',types.joint,'leftElbow',5,0,group.leftArm},...
        {'leftWristPitch',types.joint,'leftWristProsup',6,0,group.leftArm},...
        {'leftWristYaw',types.joint,'leftWristPitch',7,0,group.leftArm},...
        {'leftHandFinger',types.joint,'leftWristYaw',8,1,group.leftArm},...
        ...
        {'rightShoulderPitch',types.joint,'torsoPitch',1,0,group.rightArm},...
        {'rightShoulderRoll',types.joint,'rightShoulderPitch',2,0,group.rightArm},...
        {'rightShoulderYaw',types.joint,'rightShoulderRoll',3,0,group.rightArm},...
        {'rightElbow',types.joint,'rightShoulderYaw',4,0,group.rightArm},...
        {'rightWristProsup',types.joint,'rightElbow',5,0,group.rightArm},...
        {'rightWristPitch',types.joint,'rightWristProsup',6,0,group.rightArm},...
        {'rightWristYaw',types.joint,'rightWristPitch',7,0,group.rightArm},...
        {'rightHandFinger',types.joint,'rightWristYaw',8,1,group.rightArm},...
        ...
        {'neckPitch',types.joint,'torsoPitch',1,0,group.head},... % from 3rd torso to first neck
        {'neckRoll',types.joint,'neckPitch',2,0,group.head},...
        {'neckYaw',types.joint,'neckRoll',3,0,group.head},...
        {'eyesTilt',types.joint,'neckYaw',4,0,group.head}, ...
        ...
        {'leftEyeVersion',types.joint,'eyesTilt',1,0,group.leftEye},...
        {'leftEyeVergence',types.eye,'leftEyeVersion',2,1,group.leftEye},...
        {'rightEyeVersion',types.joint,'eyesTilt',1,0,group.rightEye},...
        {'rightEyeVergence',types.eye,'rightEyeVersion',2,1,group.rightEye},...
        ...
        {'leftHipPitch',types.joint,'torsoYaw',1,0,group.leftLeg},...
        {'leftHipRoll',types.joint,'leftHipPitch',2,0,group.leftLeg},...
        {'leftHipYaw',types.joint,'leftHipRoll',3,0,group.leftLeg},...
        {'leftKnee',types.joint,'leftHipYaw',4,0,group.leftLeg},...
        {'leftAnklePitch',types.joint,'leftKnee',5,0,group.leftLeg},...
        {'leftAnkleRoll',types.joint,'leftAnklePitch',6,0,group.leftLeg},...
        ...
        {'rightHipPitch',types.joint,'torsoYaw',1,0,group.rightLeg},...
        {'rightHipRoll',types.joint,'rightHipPitch',2,0,group.rightLeg},...
        {'rightHipYaw',types.joint,'rightHipRoll',3,0,group.rightLeg},...
        {'rightKnee',types.joint,'rightHipYaw',4,0,group.rightLeg},...
        {'rightAnklePitch',types.joint,'rightKnee',5,0,group.rightLeg},...
        {'rightAnkleRoll',types.joint,'rightAnklePitch',6,0,group.rightLeg}};  
          
        
    structure2.DH.torso = [0.032, 0.000, pi/2.0, 0.000; 
                        0.000, -0.0055, pi/2.0, -pi/2]; 
                    
    structure2.DH.leftArm = [0.0233647, -0.1433, -pi/2.0, 105.0*pi/180;
                             0.000, 0.10774, -pi/2.0, pi/2.0;
                             0.000, 0.000, pi/2.0, -pi/2.0;
                             0.015, 0.15228, -pi/2.0, 75.0*pi/180;
                            -0.015, 0.000, pi/2.0, 0.000;
                             0.000, 0.1413, pi/2.0, -pi/2;
                             0.000, 0.000, pi/2.0, pi/2;
                            0.0625, -0.016, 0.000, 0.000 ];
            
    structure2.DH.rightArm =  [-0.0233647, -0.1433, pi/2.0, -105.0*pi/180;  
                                 0.000, -0.10774, pi/2.0, -pi/2;
                                 0.000, 0.000, -pi/2.0, -pi/2;
                                -0.015, -0.15228, -pi/2.0, -105.0*pi/180;
                                 0.015, 0.000, pi/2.0, 0.000;
                                 0.000, -0.1413, pi/2.0, -pi/2;
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
                   
    structure2.DH.leftLeg=[0, 0, -pi/2, pi/2;
                           0, 0, -pi/2, pi/2;
                           0, -0.2236, pi/2, -pi/2;
                           -0.213, 0, pi, pi/2;
                           0, 0, -pi/2, 0;
                           -0.041, 0, 0, 0];

    structure2.DH.rightLeg=[0, 0, pi/2, pi/2;
                            0, 0, pi/2, pi/2;
                            0, 0.2236, -pi/2, -pi/2;
                            -0.213, 0, pi, pi/2;
                            0, 0, pi/2, 0;
                            0, 0, pi, 0];               
    structure2.WL.torso = zeros(2,4);
    
    structure2.WL.leftArm = [0, 0, 0, 0;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 0, 1];
                            
            
    structure2.WL.rightArm = [0, 0, 0, 0;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 0, 1];
           
    structure2.WL.head = [0, 0, 0, 0;
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
                 
    structure2.defaultDH = structure2.DH;
    
    structure2.bounds.joint = [inf inf inf inf];
    structure2.bounds.eye = [inf inf inf inf];

    % distortion coefficients
    structure2.eyes.dist = zeros(6,2);
    % tangential distortion coefficients
    structure2.eyes.tandist = zeros(2,2);
    % right eye camera matrix                      
    structure2.eyes.matrix(:,:,1) = [257.34,  0.000,  160.0;
                                     0.000,  257.34,  120.0;
                                     0.000, 0.000, 1.000];
    % left eye camera matrix                             
    structure2.eyes.matrix(:,:,2) = [257.34,  0.000,  160.0; 
                                     0.000,  257.34,  120.0
                                     0.000, 0.000, 1.000];
        
end

