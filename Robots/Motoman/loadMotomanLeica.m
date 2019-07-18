function [ name, structure, structure2 ] = loadMotomanLeica()
%LOADMOTOMANLEICA Summary of this function goes here
%   Detailed explanation goes here
    name='motoman';
    %% Robot structure
    structure={{'base',types.base,nan,0,0,group.torso},...
        {'TT2',types.joint,'base',1,0,group.leftArm},...
        {'S2',types.joint,'TT2',2,0,group.leftArm},...
        {'L2',types.joint,'S2',3,0,group.leftArm},...
        {'U2',types.joint,'L2',4,0,group.leftArm},...
        {'R2',types.joint,'U2',5,0,group.leftArm},...
        {'B2',types.joint,'R2',6,0,group.leftArm},...
        {'T2',types.joint,'B2',7,0,group.leftArm},...
        {'LR2', types.joint,'T2',8,1,group.leftArm},...
        ...
        {'TT1',types.joint,'base',1,0,group.rightArm},...
        {'S1',types.joint,'TT1',2,0,group.rightArm},...
        {'L1',types.joint,'S1',3,0,group.rightArm},...
        {'U1',types.joint,'L1',4,0,group.rightArm},...
        {'R1',types.joint,'U1',5,0,group.rightArm},...
        {'B1',types.joint,'R1',6,0,group.rightArm},...
        {'T1',types.joint,'B1',7,0,group.rightArm},...
        {'LR1', types.joint,'T1',8,1,group.rightArm},...
        ...
        {'rightHead',types.joint,'base',1,0,group.rightEye},...
        {'rightEye',types.eye,'rightHead',2,1,group.rightEye},...
        {'leftHead',types.joint,'base',1,0,group.leftEye},...
        {'leftEye',types.eye,'leftHead',2,1,group.leftEye}};
    
    
    structure2.DH.leftArm = [0.000, -0.263, -15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.02,  0.25, 0, pi/2];
       
    structure2.DH.rightArm = [0.000, -0.263, 15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.05,  0.25, 0, 0];
       
    structure2.DH.leftEye = [0.15,   1.96, 3*pi/4, -10*pi/180;
            0.0, -0.445,    0.0,  pi];
        
    structure2.DH.rightEye = [0.15,   1.96, -3*pi/4, -170*pi/180;
            0.0, -0.445,     0.0,  0.0];
        
        
    structure2.WL.leftArm = [1, 0, 1, 0;
                             1, 1, 1, 1;
                             1, 0, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             0, 0, 1, 0;
                             1, 1, 0, 1];
       
    structure2.WL.rightArm = [0, 0, 0, 0;
                              1, 0, 1, 0;
                              1, 0, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              0, 0, 1, 0;
                              1, 1, 0, 1];
       
    structure2.WL.leftEye = [1, 1, 1, 1;
                             0, 1, 0, 1];
        
    structure2.WL.rightEye = [1, 1, 1, 1;
                              0, 1, 0, 1];
                           
    structure2.H0 = [1 0 0 0;
                     0 1 0 0;
                     0 0 1 0;
                     0 0 0 1];
                 
    structure2.defaultDH = structure2.DH;
    
    % distortion coefficients
    structure2.eyes.dist = [-0.021, -0.206, 0.719, 0.0, 0.0, 0.0; % right eye
                            -0.023, -0.213, 0.662, 0.0, 0.0, 0.0]'; % left eye
    % tangential distortion coefficients
    structure2.eyes.tandist = [-0.002, -0.001; % right eye
                               -0.001, -0.001]'; % left eye 
    % right eye camera matrix                      
    structure2.eyes.matrix(:,:,1) = [8185.397,  0.000,  2009.318;
                                     0.000,  8170.401,  2963.960;
                                     0.000,     0.000,     1.000];
    % left eye camera matrix                             
    structure2.eyes.matrix(:,:,2) = [8110.478,  0.000,  1949.921; 
                                     0.000,  8098.218,  2991.727;
                                     0.000,     0.000,     1.000];
        
    structure2.bounds.joint = [0.05, 0.05, 0.05, 0.1];
    structure2.bounds.eye = [0.15, 0.15, 0.05, 0.1];
    
end

