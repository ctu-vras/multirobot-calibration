function [ name, structure, structure2 ] = loadMotoman()
%LOADMOTOMAN Summary of this function goes here
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
        {'EE2',types.joint,'T2',8,1,group.leftArm},...
        {'LR2', types.joint,'T2',9,1,group.leftArm},...
        ...
        {'TT1',types.joint,'base',1,0,group.rightArm},...
        {'S1',types.joint,'TT1',2,0,group.rightArm},...
        {'L1',types.joint,'S1',3,0,group.rightArm},...
        {'U1',types.joint,'L1',4,0,group.rightArm},...
        {'R1',types.joint,'U1',5,0,group.rightArm},...
        {'B1',types.joint,'R1',6,0,group.rightArm},...
        {'T1',types.joint,'B1',7,0,group.rightArm},...
        {'EE1',types.joint,'T1',8,1,group.rightArm},...
        {'LR1', types.joint,'T1',9,1,group.rightArm},...
        ...
        {'rightHead',types.joint,'base',1,0,group.rightEye},...
        {'rightEye',types.eye,'rightHead',2,1,group.rightEye},...
        {'leftHead',types.joint,'base',1,0,group.leftEye},...
        {'leftEye',types.eye,'leftHead',2,1,group.leftEye},...
        ...
        {'MK101', types.finger, 'EE1', 1, 1,group.markers},...
        {'MK102', types.finger, 'EE1', 2, 1,group.markers},...
        {'MK103', types.finger, 'EE1', 3, 1,group.markers},...
        {'MK104', types.finger, 'EE1', 4, 1,group.markers},...
        {'MK105', types.finger, 'EE1', 5, 1,group.markers},...
        {'MK106', types.finger, 'EE1', 6, 1,group.markers},...
        {'MK107', types.finger, 'EE1', 7, 1,group.markers},...
        {'MK108', types.finger, 'EE1', 8, 1,group.markers},...
        {'MK109', types.finger, 'EE1', 9, 1,group.markers},...
        {'MK110', types.finger, 'EE1', 10, 1,group.markers},...
        {'MK111', types.finger, 'EE1', 11, 1,group.markers},...
        {'MK112', types.finger, 'EE1', 12, 1,group.markers},...
        {'MK113', types.finger, 'EE1', 13, 1,group.markers},...
        {'MK114', types.finger, 'EE1', 14, 1,group.markers},...
        {'MK115', types.finger, 'EE1', 15, 1,group.markers},...
        {'MK116', types.finger, 'EE1', 16, 1,group.markers},...
        {'MK117', types.finger, 'EE1', 17, 1,group.markers},...
        {'MK118', types.finger, 'EE1', 18, 1,group.markers},...
        {'MK119', types.finger, 'EE1', 19, 1,group.markers},...
        {'MK120', types.finger, 'EE1', 20, 1,group.markers},...
        {'MK201', types.finger, 'EE2', 1, 1,group.markers},...
        {'MK202', types.finger, 'EE2', 2, 1,group.markers},...
        {'MK203', types.finger, 'EE2', 3, 1,group.markers},...
        {'MK204', types.finger, 'EE2', 4, 1,group.markers},...
        {'MK205', types.finger, 'EE2', 5, 1,group.markers},...
        {'MK206', types.finger, 'EE2', 6, 1,group.markers},...
        {'MK207', types.finger, 'EE2', 7, 1,group.markers},...
        {'MK208', types.finger, 'EE2', 8, 1,group.markers},...
        {'MK209', types.finger, 'EE2', 9, 1,group.markers},...
        {'MK210', types.finger, 'EE2', 10, 1,group.markers},...
        {'MK211', types.finger, 'EE2', 11, 1,group.markers},...
        {'MK212', types.finger, 'EE2', 12, 1,group.markers},...
        {'MK213', types.finger, 'EE2', 13, 1,group.markers},...
        {'MK214', types.finger, 'EE2', 14, 1,group.markers},...
        {'MK215', types.finger, 'EE2', 15, 1,group.markers},...
        {'MK216', types.finger, 'EE2', 16, 1,group.markers},...
        {'MK217', types.finger, 'EE2', 17, 1,group.markers},...
        {'MK218', types.finger, 'EE2', 18, 1,group.markers},...
        {'MK219', types.finger, 'EE2', 19, 1,group.markers},...
        {'MK220', types.finger, 'EE2', 20, 1,group.markers}};
    
    
    structure2.DH.leftArm = [0.000, -0.263, -15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.000,  0.354, 0.000, 0.000;
           0.02,  0.25, 0, pi/2];
       
    structure2.DH.rightArm = [0.000, -0.263, 15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0,  0.200, 0.000, 0.000;
           0.000,  0.354, 0.000, 0.000;
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
                             1, 0, 1, 0;
                             0, 1, 0, 1;
                             1, 1, 0, 1];
       
    structure2.WL.rightArm = [0, 0, 0, 0;
                              1, 0, 1, 0;
                              1, 0, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 0, 1, 0;
                              0, 1, 0, 1;
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
                 
    tf_mk_01 = [-0.79466465  0.0         0.60704867  0.03200057;
                        0.0         1.0         0.0         0.0;
                -0.60704867  0.0        -0.79466465 -0.04189075;
                        0.0         0.0         0.0         1.0];
    tf_mk_02 = [ 0.82859264 -0.52748058  0.18761256  0.00989000;
                -0.52748058 -0.62324281  0.57734967  0.03043499;
                -0.18761256 -0.57734967 -0.79465016 -0.04188998;
                0.0         0.0         0.0         1.0        ];
    tf_mk_03 = [-0.17462117  0.85340379 -0.49113075 -0.02588996;
                 0.85340379  0.37997199  0.35682385  0.01880997;
                 0.49113075 -0.35682385 -0.79464918 -0.04188993;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_04 = [-0.17462117 -0.85340379 -0.49113075 -0.02588996;
                -0.85340379  0.37997199 -0.35682385 -0.01880997;
                 0.49113075  0.35682385 -0.79464918 -0.04188993;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_05 = [ 0.82859264  0.52748058  0.18761256  0.00989000;
                 0.52748058 -0.62324281 -0.57734967 -0.03043499;
                -0.18761256  0.57734967 -0.79465016 -0.04188998;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_06 = [-0.18760895  0.0          0.9822438  0.05177898;
                        0.0         1.0         0.0         0.0;
                -0.98224380  0.0        -0.18760895 -0.00988981;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_07 = [ 0.88660172 -0.34901866  0.30351833  0.01599997;
                -0.34901866 -0.07421398  0.93417250  0.04924490;
                -0.30351833 -0.93417250 -0.18761227 -0.00988998;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_08 = [ 0.22269984  0.5647441  -0.79465016 -0.04188998;
                 0.56474410  0.58968760  0.57734967  0.03043499;
                 0.79465016 -0.57734967 -0.18761256 -0.00989000;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_09 = [ 0.22269984 -0.5647441  -0.79465016 -0.04188998;
                -0.56474410  0.58968760 -0.57734967 -0.03043499;
                 0.79465016  0.57734967 -0.18761256 -0.00989000;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_10 = [ 0.88660172  0.34901866  0.30351833  0.01599997;
                 0.34901866 -0.07421398 -0.93417250 -0.04924490;
                -0.30351833  0.93417250 -0.18761227 -0.00988998;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_11 = [ 0.46828713  0.38631371  0.79465016  0.04188998;
                 0.38631371  0.71932543 -0.57734967 -0.03043499;
                -0.79465016  0.57734967  0.18761256  0.00989000;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_12 = [ 0.46828713 -0.38631371  0.79465016  0.04188998;
                -0.38631371  0.71932543  0.57734967  0.03043499;
                -0.79465016 -0.57734967  0.18761256  0.00989000;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_13 = [ 0.92242975  0.23874667 -0.30351833 -0.01599997;
                 0.23874667  0.26518251  0.93417250  0.04924490;
                 0.30351833 -0.93417250  0.18761227  0.00988998;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_14 = [ 0.18760895  0.0         -0.9822438 -0.05177898;
                 0.0         1.0         0.0         0.0;
                 0.98224380  0.0         0.18760895  0.00988981;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_15 = [ 0.92242975 -0.23874667 -0.30351833 -0.01599997;
                -0.23874667  0.26518251 -0.93417250 -0.04924490;
                 0.30351833  0.9341725   0.18761227  0.00988998;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_16 = [ 0.86559523  0.09764982  0.49113075  0.02588996;
                 0.09764982  0.92905396 -0.35682385 -0.01880997;
                -0.49113075  0.35682385  0.79464918  0.04188993;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_17 = [ 0.86559523 -0.09764982  0.49113075  0.02588996;
                -0.09764982  0.92905396  0.35682385  0.01880997;
                -0.49113075 -0.35682385  0.79464918  0.04188993;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_18 = [ 0.980387    0.06035608 -0.18761256 -0.00989000;
                 0.06035608  0.81426316  0.57734967  0.03043499;
                 0.18761256 -0.57734967  0.79465016  0.04188998;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_19 = [ 0.79466465  0.0        -0.60704867 -0.03200057;
                 0.0         1.0         0.0         0.0;
                 0.60704867  0.0         0.79466465  0.04189075;
                 0.0         0.0         0.0         1.0       ];
    tf_mk_20 = [ 0.98038700 -0.06035608 -0.18761256 -0.00989000;
                -0.06035608  0.81426316 -0.57734967 -0.03043499;
                 0.18761256  0.57734967  0.79465016  0.04188998;
                 0.0         0.0         0.0         1.0       ];

                 
    structure2.markers =  reshape([tf_mk_01, tf_mk_02, tf_mk_03, tf_mk_04, tf_mk_05, ...
            tf_mk_06, tf_mk_07, tf_mk_08, tf_mk_09, tf_mk_10, ...
            tf_mk_11, tf_mk_12, tf_mk_13, tf_mk_14, tf_mk_15, ...
            tf_mk_16, tf_mk_17, tf_mk_18, tf_mk_19, tf_mk_20], 4,4,20);
        
    structure2.bounds.joint = [0.05, 0.05, 0.05, 0.1];
    structure2.bounds.eye = [0.15, 0.15, 0.05, 0.1];
    
end

