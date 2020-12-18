function [ name, linkStructure, structure ] = loadMotoman()
%LOADMOTOMAN Motoman robot configuration function
%Custom function for Motoman robot configuration with original end effector.
% OUTPUT - name - robot name
%        - links - cellarray of robot links (name, type, parent, DHindex, isEE, group)
%        - structure - kinematics - table of kinematics parameters for each group (columns - a, d, alpha, offset)
%                    - WL - logical array of whitelisted parameters for calibration 
%                    - defaultJoints - stores robot default joint position
%                    (e.g. home position) for visualisation 
%                    - bounds - bounds for kinematics parameters (a, d, alpha, offset)
%                    - eyes - cameras and their instrinsic parameters
%                    (camera matrix, distortion coefficents - radial and tangential)
%                    - markers - transformation matrices of ArUco markers
    name='motoman';
    %% Robot links
    linkStructure={{'base',types.base,nan,0,group.torso},...
        {'TT2',types.joint,'base',1,group.leftArm},...
        {'S2',types.joint,'TT2',2,group.leftArm},...
        {'L2',types.joint,'S2',3,group.leftArm},...
        {'U2',types.joint,'L2',4,group.leftArm},...
        {'R2',types.joint,'U2',5,group.leftArm},...
        {'B2',types.joint,'R2',6,group.leftArm},...
        {'T2',types.joint,'B2',7,group.leftArm},...
        {'EE2',types.joint,'T2',8,group.leftArm},...
        ...
        {'TT1',types.joint,'base',1,group.rightArm},...
        {'S1',types.joint,'TT1',2,group.rightArm},...
        {'L1',types.joint,'S1',3,group.rightArm},...
        {'U1',types.joint,'L1',4,group.rightArm},...
        {'R1',types.joint,'U1',5,group.rightArm},...
        {'B1',types.joint,'R1',6,group.rightArm},...
        {'T1',types.joint,'B1',7,group.rightArm},...
        {'EE1',types.joint,'T1',8,group.rightArm},...
        ...
        {'rightHead',types.joint,'base',1,group.rightEye},...
        {'rightEye',types.eye,'rightHead',2,group.rightEye},...
        {'leftHead',types.joint,'base',1,group.leftEye},...
        {'leftEye',types.eye,'leftHead',2,group.leftEye},...
        ...
        {'MK101', types.finger, 'EE1', 1, group.rightMarkers},...
        {'MK102', types.finger, 'EE1', 2, group.rightMarkers},...
        {'MK103', types.finger, 'EE1', 3, group.rightMarkers},...
        {'MK104', types.finger, 'EE1', 4, group.rightMarkers},...
        {'MK105', types.finger, 'EE1', 5, group.rightMarkers},...
        {'MK106', types.finger, 'EE1', 6, group.rightMarkers},...
        {'MK107', types.finger, 'EE1', 7, group.rightMarkers},...
        {'MK108', types.finger, 'EE1', 8, group.rightMarkers},...
        {'MK109', types.finger, 'EE1', 9, group.rightMarkers},...
        {'MK110', types.finger, 'EE1', 10, group.rightMarkers},...
        {'MK111', types.finger, 'EE1', 11, group.rightMarkers},...
        {'MK112', types.finger, 'EE1', 12, group.rightMarkers},...
        {'MK113', types.finger, 'EE1', 13, group.rightMarkers},...
        {'MK114', types.finger, 'EE1', 14, group.rightMarkers},...
        {'MK115', types.finger, 'EE1', 15, group.rightMarkers},...
        {'MK116', types.finger, 'EE1', 16, group.rightMarkers},...
        {'MK117', types.finger, 'EE1', 17, group.rightMarkers},...
        {'MK118', types.finger, 'EE1', 18, group.rightMarkers},...
        {'MK119', types.finger, 'EE1', 19, group.rightMarkers},...
        {'MK120', types.finger, 'EE1', 20, group.rightMarkers},...
        {'MK201', types.finger, 'EE2', 1, group.leftMarkers},...
        {'MK202', types.finger, 'EE2', 2, group.leftMarkers},...
        {'MK203', types.finger, 'EE2', 3, group.leftMarkers},...
        {'MK204', types.finger, 'EE2', 4, group.leftMarkers},...
        {'MK205', types.finger, 'EE2', 5, group.leftMarkers},...
        {'MK206', types.finger, 'EE2', 6, group.leftMarkers},...
        {'MK207', types.finger, 'EE2', 7, group.leftMarkers},...
        {'MK208', types.finger, 'EE2', 8, group.leftMarkers},...
        {'MK209', types.finger, 'EE2', 9, group.leftMarkers},...
        {'MK210', types.finger, 'EE2', 10, group.leftMarkers},...
        {'MK211', types.finger, 'EE2', 11, group.leftMarkers},...
        {'MK212', types.finger, 'EE2', 12, group.leftMarkers},...
        {'MK213', types.finger, 'EE2', 13, group.leftMarkers},...
        {'MK214', types.finger, 'EE2', 14, group.leftMarkers},...
        {'MK215', types.finger, 'EE2', 15, group.leftMarkers},...
        {'MK216', types.finger, 'EE2', 16, group.leftMarkers},...
        {'MK217', types.finger, 'EE2', 17, group.leftMarkers},...
        {'MK218', types.finger, 'EE2', 18, group.leftMarkers},...
        {'MK219', types.finger, 'EE2', 19, group.leftMarkers},...
        {'MK220', types.finger, 'EE2', 20, group.leftMarkers}};
    
    %% robot initial kinematics
    structure.kinematics.leftArm = [0.000, -0.263, -15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.000,  0.354, 0.000, 0.000];
       
    structure.kinematics.rightArm = [0.000, -0.263, 15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.000,  0.354, 0.000, 0.000];
       
% this kinematics not working
%     structure.kinematics.leftEye = [0.15,   1.96, 3*pi/4, -10*pi/180;
%             0.0, -0.445,    0.0,  pi];
%         
%     structure.kinematics.rightEye = [0.15,   1.96, -3*pi/4, -170*pi/180;
%             0.0, -0.445,     0.0,  0.0];
    % kinematics after camera calibration    
    structure.kinematics.rightEye = [0.0741 1.8034 -2.5086 -2.7753;
            0.0000 -0.5670 0.0000 0.2863];
    structure.kinematics.leftEye = [0.2315 1.8602 2.5486 0.0860;
            0.0000 -0.4982 0.0000 -3.0618];
    
    %% robot initial whitelist    
    structure.WL.leftArm = [1, 0, 1, 0;
                             1, 1, 1, 1;
                             1, 0, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 1, 1, 1;
                             1, 0, 1, 0;
                             0, 1, 0, 1];
       
    structure.WL.rightArm = [0, 0, 0, 0;
                              0, 0, 0, 0;
                              1, 0, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 0, 1, 0;
                              0, 1, 0, 1];
       
    structure.WL.leftEye = [1, 1, 1, 1;
                             0, 1, 0, 1];
        
    structure.WL.rightEye = [1, 1, 1, 1;
                              0, 1, 0, 1];
                 
    %% robot default joint position (e.g. home position) for visualisation    
    structure.defaultJoints = {zeros(1,8), zeros(1,8), zeros(1,2), zeros(1,2)};
    
    %% robot bounds for kinematics parameters
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
    %% robot ArUco markers on the end effectors                              
    structure.kinematics.leftMarkers = [
   0.032000570000000  0                  -0.041890750000000   0                   2.489251283624426   0
   0.009890000000000  0.030434990000000  -0.041889980000000  -2.367371516321296   0.769288792697395   0.000000000000000
  -0.025889960000000  0.018809970000000  -0.041889930000000  -1.463120740121269  -2.013832860131754  -0.000000000000001
  -0.025889960000000 -0.018809970000000  -0.041889930000000   1.463120740121269  -2.013832860131754   0.000000000000001
   0.009890000000000 -0.030434990000000  -0.041889980000000   2.367371516321296   0.769288792697395  -0.000000000000000
   0.051778980000000  0                  -0.009889810000000   0                   1.759523631232189   0
   0.015999970000000  0.049244900000000  -0.009889980000000  -1.673416321975956   0.543703145323541  -0.000000000000000
  -0.041889980000000  0.030434990000000  -0.009890000000000  -1.034227171016859  -1.423485339092727   0.000000000000000
  -0.041889980000000 -0.030434990000000  -0.009890000000000   1.034227171016859  -1.423485339092727  -0.000000000000000
   0.015999970000000 -0.049244900000000  -0.009889980000000   1.673416321975956   0.543703145323541   0.000000000000000
   0.041889980000000 -0.030434990000000   0.009890000000000   0.812359962492363   1.118112657426993   0.000000000000000
   0.041889980000000  0.030434990000000   0.009890000000000  -0.812359962492363   1.118112657426993  -0.000000000000000
  -0.015999970000000  0.049244900000000   0.009889980000000  -1.314427795778142  -0.427065587745111  -0.000000000000000
  -0.051778980000000  0                   0.009889810000000   0                  -1.382069022357604   0
  -0.015999970000000 -0.049244900000000   0.009889980000000   1.314427795778142  -0.427065587745111   0.000000000000000
   0.025889960000000 -0.018809970000000   0.041889930000000   0.383449133864229   0.527777671724884   0.000000000000000
   0.025889960000000  0.018809970000000   0.041889930000000  -0.383449133864229   0.527777671724884  -0.000000000000000
  -0.009890000000000  0.030434990000000   0.041889980000000  -0.620429804418819  -0.201611656909703  -0.000000000000000
  -0.032000570000000  0                   0.041890750000000   0                  -0.652341369965366   0
  -0.009890000000000 -0.030434990000000   0.041889980000000   0.620429804418819  -0.201611656909703   0.000000000000000];
    structure.kinematics.rightMarkers = structure.kinematics.leftMarkers;
end

