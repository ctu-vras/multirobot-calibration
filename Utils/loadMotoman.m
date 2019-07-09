function [ name, structure, structure2 ] = loadMotoman()
%LOADMOTOMAN Summary of this function goes here
%   Detailed explanation goes here
    name='motoman';
    %% Robot structure
    structure={{'base',types.base,nan,0,0,group.torso},...
        {'TT2',types.joint,1,1,0,group.leftArm},...
        {'S2',types.joint,2,2,0,group.leftArm},...
        {'L2',types.joint,3,3,0,group.leftArm},...
        {'U2',types.joint,4,4,0,group.leftArm},...
        {'R2',types.joint,5,5,0,group.leftArm},...
        {'B2',types.joint,6,6,0,group.leftArm},...
        {'T2',types.joint,7,7,0,group.leftArm},...
        {'EE2',types.joint,8,8,1,group.leftArm},...
        ...
        {'TT1',types.joint,1,1,0,group.rightArm},...
        {'S1',types.joint,10,2,0,group.rightArm},...
        {'L1',types.joint,11,3,0,group.rightArm},...
        {'U1',types.joint,12,4,0,group.rightArm},...
        {'R1',types.joint,13,5,0,group.rightArm},...
        {'B1',types.joint,14,6,0,group.rightArm},...
        {'T1',types.joint,15,7,0,group.rightArm},...
        {'EE1',types.joint,16,8,1,group.rightArm},...
        ...
        {'leftHead',types.joint,1,1,0,group.leftEye},...
        {'leftEye',types.eye,18,2,1,group.leftEye},...
        {'rightHead',types.joint,1,1,0,group.rightEye},...
        {'rightEye',types.eye,20,2,1,group.rightEye},...
        ...
        {'MK101', types.finger, 17, 1, 1,group.fingers},...
        {'MK102', types.finger, 17, 2, 1,group.fingers},...
        {'MK103', types.finger, 17, 3, 1,group.fingers},...
        {'MK104', types.finger, 17, 4, 1,group.fingers},...
        {'MK105', types.finger, 17, 5, 1,group.fingers},...
        {'MK106', types.finger, 17, 6, 1,group.fingers},...
        {'MK107', types.finger, 17, 7, 1,group.fingers},...
        {'MK108', types.finger, 17, 8, 1,group.fingers},...
        {'MK109', types.finger, 17, 9, 1,group.fingers},...
        {'MK110', types.finger, 17, 10, 1,group.fingers},...
        {'MK111', types.finger, 17, 11, 1,group.fingers},...
        {'MK112', types.finger, 17, 12, 1,group.fingers},...
        {'MK113', types.finger, 17, 13, 1,group.fingers},...
        {'MK114', types.finger, 17, 14, 1,group.fingers},...
        {'MK115', types.finger, 17, 15, 1,group.fingers},...
        {'MK116', types.finger, 17, 16, 1,group.fingers},...
        {'MK117', types.finger, 17, 17, 1,group.fingers},...
        {'MK118', types.finger, 17, 18, 1,group.fingers},...
        {'MK119', types.finger, 17, 19, 1,group.fingers},...
        {'MK120', types.finger, 17, 20, 1,group.fingers},...
        {'MK201', types.finger, 17, 1, 1,group.fingers},...
        {'MK202', types.finger, 17, 2, 1,group.fingers},...
        {'MK203', types.finger, 17, 3, 1,group.fingers},...
        {'MK204', types.finger, 17, 4, 1,group.fingers},...
        {'MK205', types.finger, 17, 5, 1,group.fingers},...
        {'MK206', types.finger, 17, 6, 1,group.fingers},...
        {'MK207', types.finger, 17, 7, 1,group.fingers},...
        {'MK208', types.finger, 17, 8, 1,group.fingers},...
        {'MK209', types.finger, 17, 9, 1,group.fingers},...
        {'MK210', types.finger, 17, 10, 1,group.fingers},...
        {'MK211', types.finger, 17, 11, 1,group.fingers},...
        {'MK212', types.finger, 17, 12, 1,group.fingers},...
        {'MK213', types.finger, 17, 13, 1,group.fingers},...
        {'MK214', types.finger, 17, 14, 1,group.fingers},...
        {'MK215', types.finger, 17, 15, 1,group.fingers},...
        {'MK216', types.finger, 17, 16, 1,group.fingers},...
        {'MK217', types.finger, 17, 17, 1,group.fingers},...
        {'MK218', types.finger, 17, 18, 1,group.fingers},...
        {'MK219', types.finger, 17, 19, 1,group.fingers},...
        {'MK220', types.finger, 17, 20, 1,group.fingers}};
    
    
    structure2.DH.leftArm = [0.000, -0.263, -15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.000,  0.354 0.000, 0];
       
    structure2.DH.rightArm = [0.000, -0.263, 15*pi/180, -pi/2;
           0.150, 1.4159, -pi/2, 0.000;
           0.614,  0.000,    pi, -pi/2;
           0.200,  0.000, -pi/2, 0.000;
           0.000, -0.640,  pi/2, 0.000;
           0.030,  0.000,  pi/2, -pi/2;
           0.000,  0.200, 0.000, 0.000;
           0.000,  0.354, 0.000, 0];
       
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
                             0, 1, 0, 1];
       
    structure2.WL.rightArm = [0, 0, 0, 0;
                              1, 0, 1, 0;
                              1, 0, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 1, 1, 1;
                              1, 0, 1, 0;
                              0, 1, 0, 1];
       
    structure2.WL.leftEye = [1, 1, 1, 1;
                             0, 1, 0, 1];
        
    structure2.WL.rightEye = [1, 1, 1, 1;
                              0, 1, 0, 1];
                           
    structure2.H0 = [1 0 0 0;
                     0 1 0 0;
                     0 0 1 0;
                     0 0 0 1];
                 
    structure2.defaultDH = structure2.DH;
    
    structure2.eyes.leftEye.dist = [-0.023, -0.213, 0.662, 0.0, 0.0, 0.0]; % distortion coefficients
    structure2.eyes.leftEye.tandist = [-0.001, -0.001]; % tangential distortion coefficients
    structure2.eyes.leftEye.matrix = [ 8110.478,  0.000,  1949.921; % camera matrix
                        0.000,  8098.218,  2991.727;
                        0.000,   0.000,   1.000];
    
    structure2.eyes.rightEye.dist = [ -0.021, -0.206, 0.719, 0.0, 0.0, 0.0]; % distortion coefficients
    structure2.eyes.rightEye.tandist = [ -0.002, -0.001]; % tangential distortion coefficients
    structure2.eyes.rightEye.matrix = [ 8185.397,  0.000,  2009.318; % camera matrix
                        0.000,  8170.401,  2963.960;
                        0.000,   0.000,   1.000];

                 
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

                 
    structure2.fingers =  reshape([tf_mk_01, tf_mk_02, tf_mk_03, tf_mk_04, tf_mk_05, ...
            tf_mk_06, tf_mk_07, tf_mk_08, tf_mk_09, tf_mk_10, ...
            tf_mk_11, tf_mk_12, tf_mk_13, tf_mk_14, tf_mk_15, ...
            tf_mk_16, tf_mk_17, tf_mk_18, tf_mk_19, tf_mk_20], 4,4,20);
        
    structure2.bounds.joint = [0.05, 0.05, 0.05, 0.1];
    structure2.bounds.eye = [0.15, 0.15, 0.05, 0.1];
    
end

