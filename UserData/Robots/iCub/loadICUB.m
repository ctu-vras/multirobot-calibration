function [ name, jointStructure, structure ] = loadICUB()
%LOADICUBV2 Function for loading iCub version 2 robot 
% Custom function for loading iCub version 2 robot.
% OUTPUT - name - robot name
%        - joints - cellarray of robot joints (name, type, parent, DHindex, isEE, group)
%        - structure - DH - table of DH parameters for each group (columns - a, d, alpha, offset)
%                    - WL - logical array of whitelisted parameters for calibration 
%                    - defaultJoints - stores robot default joint position
%                    (e.g. home position) for visualisation  
%                    - bounds - bounds for DH parameters (a, d, alpha, offset)
%                    - eyes - cameras and their instrinsic parameters
%                    (camera matrix, distortion coefficents - radial and tangential)
    name='iCub';
    
    %% Robot structure
    jointStructure={{'base',types.base,nan,0,group.torso},...
        {'torsoYaw', types.joint, 'base',1,group.torso},...
        {'torsoRoll', types.joint, 'torsoYaw',2,group.torso},... % link from 1st to 2nd torso joint
        {'torsoPitch', types.joint, 'torsoRoll',3,group.torso},... % link from 2nd to 3rd torso joint 
        ...
        {'leftShoulderPitch',types.joint,'torsoPitch',1,group.leftArm},... 
        {'leftShoulderRoll',types.joint,'leftShoulderPitch',2,group.leftArm},... 
        {'leftShoulderYaw',types.joint,'leftShoulderRoll',3,group.leftArm},...
        {'leftElbow',types.joint,'leftShoulderYaw',4,group.leftArm},...
        {'leftWristProsup',types.joint,'leftElbow',5,group.leftArm},...
        {'leftWristPitch',types.joint,'leftWristProsup',6,group.leftArm},...
        {'leftWristYaw',types.joint,'leftWristPitch',7,group.leftArm},...
        {'leftHandFinger',types.joint,'leftWristYaw',8,group.leftArm},...
        ...
        {'rightShoulderPitch',types.joint,'torsoPitch',1,group.rightArm},...
        {'rightShoulderRoll',types.joint,'rightShoulderPitch',2,group.rightArm},...
        {'rightShoulderYaw',types.joint,'rightShoulderRoll',3,group.rightArm},...
        {'rightElbow',types.joint,'rightShoulderYaw',4,group.rightArm},...
        {'rightWristProsup',types.joint,'rightElbow',5,group.rightArm},...
        {'rightWristPitch',types.joint,'rightWristProsup',6,group.rightArm},...
        {'rightWristYaw',types.joint,'rightWristPitch',7,group.rightArm},...
        {'rightHandFinger',types.joint,'rightWristYaw',8,group.rightArm},...
        ...
        {'neckPitch',types.joint,'torsoPitch',1,group.head},... % from 3rd torso to first neck
        {'neckRoll',types.joint,'neckPitch',2,group.head},...
        {'neckYaw',types.joint,'neckRoll',3,group.head},...
        {'eyesTilt',types.joint,'neckYaw',4,group.head}, ...
        ...
        {'leftEyeVersion',types.joint,'eyesTilt',1,group.leftEye},...
        {'leftEyeVergence',types.eye,'leftEyeVersion',2,group.leftEye},...
        {'rightEyeVersion',types.joint,'eyesTilt',1,group.rightEye},...
        {'rightEyeVergence',types.eye,'rightEyeVersion',2,group.rightEye}};
        
    %% robot initial DH     
    structure.DH.torso = [0, 0, 0, 1.2092, -1.2092, 1.2092;
                        0.032, 0.000, pi/2.0, 0.000, nan, nan; 
                        0.000, -0.0055, pi/2.0, -pi/2, nan, nan]; 
                    
    structure.DH.leftArm = [0.0233647, -0.1433, -pi/2.0, 105.0*pi/180;
                             0.000, 0.10774, -pi/2.0, pi/2.0;
                             0.000, 0.000, pi/2.0, -pi/2.0;
                             0.015, 0.15228, -pi/2.0, 75.0*pi/180;
                            -0.015, 0.000, pi/2.0, 0.000;
                             0.000, 0.1413, pi/2.0, -pi/2;
                             0.000, 0.000, pi/2.0, pi/2;
                            0.0625, -0.02598, 0.000, 0.000 ];
            
    structure.DH.rightArm =  [-0.0233647, -0.1433, pi/2.0, -105.0*pi/180;  
                                 0.000, -0.10774, pi/2.0, -pi/2;
                                 0.000, 0.000, -pi/2.0, -pi/2;
                                -0.015, -0.15228, -pi/2.0, -105.0*pi/180;
                                 0.015, 0.000, pi/2.0, 0.000;
                                 0.000, -0.1413, pi/2.0, -pi/2;
                                 0.000, 0.000, pi/2.0, pi/2;
                                0.0625, 0.02598, 0, pi ]; 
           
    structure.DH.head = [0.000, -0.2233, -pi/2.0, -pi/2.0;  
                       0.0095, 0.000,  pi/2.0,  pi/2.0;
                       0.000, 0.000, -pi/2.0, -pi/2.0;
                       -0.059, 0.08205, -pi/2.0,  pi/2.0];
                
    structure.DH.leftEye = [0.000, -0.034, -pi/2.0,   0.000;  
                       0.000,  0.000,  pi/2.0,  -pi/2.0];
                    
    structure.DH.rightEye = [0.000, 0.034, -pi/2.0, 0.000;  
                       0.000, 0.000, pi/2.0, -pi/2.0]; 
                   
                                          
    
    %% robot initial whitelist                              
    structure.WL.torso = zeros(2,4);
    
    structure.WL.leftArm = [0, 0, 0, 0;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 0, 1];
                            
            
    structure.WL.rightArm = [0, 0, 0, 0;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 0, 1]; 
                          
    structure.WL.head = [0, 0, 0, 0;
                          1, 1, 1, 1;
                          1, 1, 1, 1;
                          1, 1, 1, 1];
                
    structure.WL.leftEye = [1, 1, 1, 1;
                             1, 1, 1, 1];
                    
    structure.WL.rightEye = [1, 1, 1, 1;
                              1, 1, 1, 1];
                            
     
    %% robot default joint position (e.g. home position) for visualisation    
    %zeros(1,7), zeros(1,7),
    structure.defaultJoints = {[0, -pi/2, 0, 0, 0, 0, 0, 0], [0, -pi/2, 0, 0, 0, 0, 0, 0], zeros(1,4),  zeros(1,2), zeros(1,2)};
    
    %% robot bounds for DH parameters
    structure.bounds.joint = [inf inf inf inf];
    structure.bounds.eye = [inf inf inf inf];

    %% robot cameras and their instrinsic parameters
    % distortion coefficients
    structure.eyes.dist = zeros(6,2);
    % tangential distortion coefficients
    structure.eyes.tandist = zeros(2,2);
    % right eye camera matrix                      
    structure.eyes.matrix(:,:,1) = [257.34,  0.000,  160.0;
                                     0.000,  257.34,  120.0;
                                     0.000, 0.000, 1.000];
    % left eye camera matrix                             
    structure.eyes.matrix(:,:,2) = [257.34,  0.000,  160.0; 
                                     0.000,  257.34,  120.0
                                     0.000, 0.000, 1.000];
end
