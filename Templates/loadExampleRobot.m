function [ name, jointStructure, structure ] = loadExampleRobot()

%LOADEXAMPLEROBOT Template function for loading example robot 
% OUTPUT - name - robot name
%        - joints - cellarray of robot joints (name, type, parent, DHindex, isEE, group)
%        - structure - DH - table of DH parameters for each group (columns - a, d, alpha, offset)
%                    - WL - logical array of whitelisted parameters for calibration 
%                    - defaultJoints - stores robot default joint position
%                    (e.g. home position) for visualisation 
%                    - bounds - bounds for DH parameters (a, d, alpha, offset)
%                    - eyes - cameras and their instrinsic parameters
%                    (camera matrix, distortion coefficents - radial and tangential)
    name='example';
    % Each joint consists from 'name', 'jointType', 'parent', 'idx', 'group'
    %% Robot structure
    jointStructure={{'base',types.base,nan,0,group.torso},... %here idx is 0, because it does not point anywhere
        {'torso',types.joint,'base',1,group.torso},...
        ...
        {'leftShoulder',types.joint,'torso',1,group.leftArm},... 
        {'leftElbowRoll',types.joint,'leftShoulder',2,group.leftArm},... 
        {'leftElbowYaw',types.joint,'leftElbowRoll',3,group.leftArm},...
        {'leftWrist',types.joint,'leftElbowYaw',4,group.leftArm},...
        ...
        {'rightShoulder',types.joint,'torso',1,group.rightArm},...
        {'rightElbowRoll',types.joint,'rightShoulder',2,group.rightArm},...
        {'rightElbowYaw',types.joint,'rightElbowRoll',3,group.rightArm},...
        {'rightWrist',types.joint,'rightElbowYaw',4,group.rightArm},...
        ...
        {'neck',types.joint,'torso',1,group.head},...
        {'eyesTilt',types.joint,'neck',2,group.head},...
        ...
        {'leftEyeVersion',types.joint,'eyesTilt',1,group.leftEye},...
        {'leftEyeVergence',types.eye,'leftEyeVersion',2,group.leftEye},...
        {'rightEyeVersion',types.joint,'eyesTilt',1,group.rightEye},...
        {'rightEyeVergence',types.eye,'rightEyeVersion',2,group.rightEye}};  
        
    %% robot initial DH   fields of structure.DH are the ones  
    structure.DH.torso = [0.001, 0.000, 0, 0]; 
                    
    structure.DH.leftArm = [0.020, 0.140, -pi/2.0, pi/2.0; % this line corresponds to leftShoulder joint defined above
                             0.000, 0.100, -pi/2.0, pi/2.0;
                             0.000, 0.000, pi/2.0, -pi/2.0;
                             0.015, 0.150, -pi/2.0, pi/2.0];
            
    structure.DH.rightArm =  [-0.020, 0.140, pi/2.0, -pi/2.0;  
                               0.000, -0.100, pi/2.0, -pi/2.0;
                               0.000, 0.000, -pi/2.0, -pi/2.0;
                              -0.015, -0.150, -pi/2.0, -pi/2.0]; 
           
    structure.DH.head = [0.003, 0.193, -pi/2.0, -pi/2.0;  
                       0.033, 0.000,  pi/2.0,  pi/2.0];
                
    structure.DH.leftEye = [0.000, -0.034, -pi/2.0,   0.000;  
                       0.000,  0.000,  pi/2.0,  -pi/2.0];
                    
    structure.DH.rightEye = [0.000, 0.034, -pi/2.0, 0.000;  
                       0.000, 0.000, pi/2.0, -pi/2.0];                                  
                               
    %% robot initial whitelist          
    % not mandatory, but its better to define whitelist 
    structure.WL.torso = zeros(1,4);
    
    structure.WL.leftArm = ones(4,4);
                            
    structure.WL.rightArm = ones(4,4);
                          
    structure.WL.head = ones(2,4);
                
    structure.WL.leftEye = ones(2,4);
                    
    structure.WL.rightEye = ones(2,4);
       
    %% robot default joint position (e.g. home position) for visualisation    
    % joint angles for 'n' first groups (order defined in Utils/groups.m)
    structure.defaultJoints = {zeros(1,4), zeros(1,4), zeros(1,2), zeros(1,2), zeros(1,2)};
    
    %% robot bounds for DH parameters
    structure.bounds.joint = [0.5 0.5 0 0]; % +- 0.5m in a,d and 0 in alpha, theta
    structure.bounds.eye = [inf inf inf inf];  % no bounds

    %% robot cameras and their instrinsic parameters
    % distortion coefficients
    structure.eyes.dist = zeros(6,2);
    % tangential distortion coefficients
    structure.eyes.tandist = zeros(2,2);
    % right eye camera matrix                      
    structure.eyes.matrix(:,:,1) = [100,  0.000,  50;
                                    0.000,  100,  50;
                                    0.000, 0.000, 1.000];
    % left eye camera matrix                             
    structure.eyes.matrix(:,:,2) = [100,  0.000,  50;
                                    0.000,  100,  50;
                                    0.000, 0.000, 1.000];
end