
%% Matej Hoffmann, July 2017
% based on ../icub-matlab (which was in turn based on https://github.com/alecive/kinematics-visualization-matlab by
% Alessandro Roncone)
close all;clc,clear all;
TORSO_CHAIN_ON = true; % this chain is mandatory - from the original iCub root frame to 3rd (last) torso joint
% USER CHOICE 
LEFT_ARM_CHAIN_ON = true;
RIGHT_ARM_CHAIN_ON = true;
HEAD_CHAIN_ON = true;
TOP_CAMERA_CHAIN_ON = false; % requires HEAD_CHAIN_ON == true;

addpath('../utils/');
addpath('/home/rustli/NAO/Skin/3Dpoints/code-nao-skin/matlabcodes/fullBodySkin_baseFrame/Output');

M_PI = pi;
CTRL_DEG2RAD = pi/180;

LINK_COLOR_REAL = [0.8 0.5 0.5]; % redish

%% Joint values (as read from the encoders)
   %  These will be common to both models: real and estimate
   joints_torso_deg = [0.0]; % Torso = base frame

   % canonical arm posture 
   %joints_Larm_deg  = [-30.0  30.0   0.0  -45.0   0.0 ];
   %joints_Rarm_deg  = [-30.0  -30.0   0.0  45.0   0.0 ];
   %hands infront of body
   %joints_Larm_deg=[0.7961039543151855, -0.05986785888671875, -0.5538160800933838, -1.556968092918396, -0.9112381935119629]
   %joints_Larm_deg=[1.1,1.3,0.5,0,0.6];
   joints_Larm_deg  = [0 0 0 0 0];
   
   %joints_Larm_deg=[1.284 0.1226 -1.509 -0.759 -0.4];
   %joints_Larm_deg=[1.168 0.217 -0.5 -1.457 1.82];
   %joints_Larm_deg=[1.48 0.09 -1.017 -1.53 -0.859]
   %joints_Larm_deg=[1.449 0.085 -0.948 -1.454 0.572];
   %joints_Rarm_deg=[0.5890979766845703, 0.31136012077331543, 0.24539804458618164, 1.1444058418273926, 0.687190055847168];
   %joints_Larm_deg=[0.527 -0.155 -0.199 -1.344 1.827]
   joints_Rarm_deg  = [0 0 0 0 0];
   %hands beyond head
   %joints_Larm_deg  = [ 20 100 -95 -45 -45];
   %joints_Rarm_deg  = [ 20 -100 95 45 45];

   joints_neck_deg = [0,0];
   joint_eyeTilt_deg = 0.0;
   joint_LeyePan_deg = 0.0;
   joint_ReyePan_deg = 0.0;

%% INIT AND PLOT BODY PARTS   

% Each body part has the same structure:
%     name = the name of the body_part;
%     H0   = is the roto-translation matrix in the origin of the chain (if the body part is attached
%            to another one, typically the last reference frame of the previous body part goes here)
%     DH   = it's the parameter matrix. Each row has 4 DH parameters (a, d, alpha, offset), thus each
%            row completely describes a link. The more rows are added, the more links are attached.
%     Th   = it's the joint values vector (as read from the encoders)
%  Please note that everything is in SI units (i.e. meters and radians), 
%  unless the variables have the _deg suffix (the eventual conversions will be handled by
%  the algorithm itself). However, the FwdKin.m works internally with
%  mm and so the chains and transforms returned have translations in mm.

% The plotting is done by the FwdKin function, which also outputs the chain
% of the corresponding body part. This is needed as input to subsequent
% chains (e.g. torso is needed for arm and head chains).
figure('Position', [1436 30 1300 750]);
    axes  ('Position', [0 0 1 1]); hold on; grid on;
    xlabel('x (mm)'); ylabel('y (mm)'),zlabel('z (mm)');



%% ROOT - plot the original iCub root reference frame
    root = eye(4);
    DrawRefFrame(root,1,40,'hat','ROOT');

%% TORSO
if TORSO_CHAIN_ON 
   % root to 3rd torso joint
   % real robot    
    robot.tor.name = 'torso';
    robot.tor.H0      = [1  0 0  0;
                         0  1 0  0;
                         0  0 1  0;
                         0  0  0  1];
    robot.tor.DH = [0,0,0,0]; % link from Root to torso
    robot.tor.Th = joints_torso_deg;  
    robot.tor.Th = robot.tor.Th * (CTRL_DEG2RAD);
    robot.tor.LinkColor = LINK_COLOR_REAL;
    robot.chain.rootToTorso = FwdKin(robot.tor,'noFrames'); % we don't draw this chain common to all

end

% LEFT_ARM
if LEFT_ARM_CHAIN_ON
   robot.larm.name = 'leftHand';
   if TORSO_CHAIN_ON
      robot.larm.H0 = robot.chain.rootToTorso.RFFrame{end};
      robot.larm.H0(1:3,4)  = robot.larm.H0(1:3,4)./1000 % converting the translational part from mm back to m 
   else
      error('Torso needs to be enabled in this version,');
   end
   robot.larm.DH = [        0,  0.1, -M_PI/2,  0;  %torso to ShoulderPitch
                           0, 0.098+0.015,   M_PI/2,    0; %ShoulderPitch to ShoulderRoll
                          0,      0,  M_PI/2,  M_PI/2; %ShoulderRoll to ElbowYaw
                          0,     0.105,  -M_PI/2,  0.0; %ElbowYaw to ElbowRoll
                         0,   0.0, M_PI/2,   0; %ElbowRoll to WristYaw
                         0, 0, -M_PI/2,    M_PI];   %WristYaw to end-effector
   robot.larm.Th = [joints_torso_deg, joints_Larm_deg];
   robot.larm.Th = robot.larm.Th;% * (CTRL_DEG2RAD);
   robot.larm.LinkColor = LINK_COLOR_REAL;
   robot.chain.left_arm = FwdKin(robot.larm);

end
%% RIGHT_ARM
if RIGHT_ARM_CHAIN_ON
   robot.rarm.name = 'rightHand';
   if TORSO_CHAIN_ON
      robot.rarm.H0 = robot.chain.rootToTorso.RFFrame{end};
      robot.rarm.H0(1:3,4)  = robot.rarm.H0(1:3,4)./1000;  
   else
      error('Torso needs to be enabled in this version,');
   end
   robot.rarm.DH = [        0,  0.1, -M_PI/2,  0; 
                           0.0,  -0.098-0.015, M_PI/2, 0;
                          0,      0,  M_PI/2,  M_PI/2;
                           0,     0.105,  -M_PI/2,  0.0;
                         0,   0, M_PI/2,   0;
                         0, 0.11370, -M_PI/2,    M_PI]; 
   robot.rarm.Th = [joints_torso_deg joints_Rarm_deg];
   robot.rarm.Th = robot.rarm.Th * (CTRL_DEG2RAD);
   robot.rarm.LinkColor = LINK_COLOR_REAL;
   robot.chain.right_arm = FwdKin(robot.rarm);

end

%% HEAD 
% up to the camera
if HEAD_CHAIN_ON
        robot.head.name = 'head';

        if TORSO_CHAIN_ON == 1
            robot.head.H0 = robot.chain.rootToTorso.RFFrame{end}; 
            robot.head.H0(1:3,4)  = robot.head.H0(1:3,4)./1000;
        else
           error('Torso needs to be enabled in this version.');
        end
        robot.head.DH = [0,    0.1265,    0,  0.0; %Torso to HeadYaw
                         0,    0, -M_PI/2, 0; %HeadYaw to HeadPitch
                         0.0679, 0, -M_PI/2, -M_PI/2]; %HeadYaw to camera - 0.0679 may not be exact

        robot.head.Th = [joints_torso_deg joints_neck_deg];
        robot.head.Th = robot.head.Th * (CTRL_DEG2RAD);
        robot.head.LinkColor = LINK_COLOR_REAL;

        robot.chain.head = FwdKin(robot.head);

end






view(90,0);
axis equal;
status=true;