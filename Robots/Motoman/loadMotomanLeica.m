function [ name, jointStructure, structure ] = loadMotomanLeica()
%LOADMOTOMANLEICA Motoman robot configuration function
%   Custom function for Motoman robot configuration with leica end effector.
% OUTPUT - name - robot name
%        - joints - cellarray of robot joints (name, type, parent, DHindex, isEE, group)
%        - structure - DH - table of DH parameters for each group (columns - a, d, alpha, offset)
%                    - WL - logical array of whitelisted parameters for calibration 
%                    - H0 - initial robot transformation 
%                    - defaultDH - stores robot DH 
%                    - bounds - bounds for DH parameters (a, d, alpha, offset)
%                    - eyes - cameras and their instrinsic parameters
%                    (camera matrix, distortion coefficents - radial and tangential)
%                    - markers - transformation matrices of ArUco markers
    name='motoman';
    %% Robot structure
    jointStructure={{'base',types.base,nan,0,group.torso},...
        {'TT2',types.joint,'base',1,group.leftArm},...
        {'S2',types.joint,'TT2',2,group.leftArm},...
        {'L2',types.joint,'S2',3,group.leftArm},...
        {'U2',types.joint,'L2',4,group.leftArm},...
        {'R2',types.joint,'U2',5,group.leftArm},...
        {'B2',types.joint,'R2',6,group.leftArm},...
        {'T2',types.joint,'B2',7,group.leftArm},...
        {'LR2', types.joint,'T2',8,group.leftArm},...
        ...
        {'TT1',types.joint,'base',1,group.rightArm},...
        {'S1',types.joint,'TT1',2,group.rightArm},...
        {'L1',types.joint,'S1',3,group.rightArm},...
        {'U1',types.joint,'L1',4,group.rightArm},...
        {'R1',types.joint,'U1',5,group.rightArm},...
        {'B1',types.joint,'R1',6,group.rightArm},...
        {'T1',types.joint,'B1',7,group.rightArm},...
        {'LR1', types.joint,'T1',8,group.rightArm},...
        ...
        {'rightHead',types.joint,'base',1,group.rightEye},...
        {'rightEye',types.eye,'rightHead',2,group.rightEye},...
        {'leftHead',types.joint,'base',1,group.leftEye},...
        {'leftEye',types.eye,'leftHead',2,group.leftEye}};
    
    %% robot initial DH
    structure.DH.leftArm = [0.000, -0.263, -15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
            0.05,  0.25, 0, 0];
       
    structure.DH.rightArm = [0.000, -0.263, 15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.045,  0.245, 0, -0.38];  %  0.05,  0.25, 0, 0];
       
    structure.DH.leftEye = [0.15,   1.96, 3*pi/4, -10*pi/180;
            0.0, -0.445,    0.0,  pi];
        
    structure.DH.rightEye = [0.15,   1.96, -3*pi/4, -170*pi/180;
            0.0, -0.445,     0.0,  0.0];
        
    %% robot initial whitelist      
    structure.WL.leftArm = [0, 0, 0, 0;
                             0, 0, 0, 0;
                             1, 0, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             0, 0, 0, 0;
                             1, 1, 0, 1];
       
    structure.WL.rightArm = [0, 0, 0, 0;
                              0, 0, 0, 0;
                              1, 0, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              0, 0, 0, 0;
                              1, 1, 0, 1];
       
    structure.WL.leftEye = [1, 1, 1, 1;
                             0, 1, 0, 1];
        
    structure.WL.rightEye = [1, 1, 1, 1;
                              0, 1, 0, 1];
    
    %% robot H0 transformation                      
    structure.H0 = [1 0 0 0;
                     0 1 0 0;
                     0 0 1 0;
                     0 0 0 1];
                 
    %% robot default DH (permanent)              
    structure.defaultDH = structure.DH;
    
    %% robot bounds for DH parameters
    structure.bounds.joint = [0.05, 0.05, 0.05, 0.1];
    structure.bounds.eye = [0.15, 0.15, 0.05, 0.1];
    
    %% robot cameras and their instrinsic parameters
    % distortion coefficients
    structure.eyes.dist = [-0.021, -0.206, 0.719, 0.0, 0.0, 0.0; % right eye
                            -0.023, -0.213, 0.662, 0.0, 0.0, 0.0]'; % left eye
    % tangential distortion coefficients
    structure.eyes.tandist = [-0.002, -0.001; % right eye
                               -0.001, -0.001]'; % left eye 
    % right eye camera matrix                      
    structure.eyes.matrix(:,:,1) = [8185.397,  0.000,  2009.318;
                                     0.000,  8170.401,  2963.960;
                                     0.000,     0.000,     1.000];
    % left eye camera matrix                             
    structure.eyes.matrix(:,:,2) = [8110.478,  0.000,  1949.921; 
                                     0.000,  8098.218,  2991.727;
                                     0.000,     0.000,     1.000];
end

