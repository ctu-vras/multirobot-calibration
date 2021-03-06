%% Example of models supported in the toolbox
%
% For all of the function, you need to create a robot.

%%
% One possibility is to create a new one
rob=Robot('loadNAO');
%%
% Or you can load robot from results
load('Results/nao-right-arm/info.mat');

%% Graph model
% This model shows robot as tree-based graph
rob.showGraphModel()

%% Matlab model  
%
% This model shows 3D visualization of the robot  
%
% This function needs the joint angles to be provided. They need to be given in orded as are chains defined in Robot.

%%
% If you do not know this order, look at 
fieldnames(rob.structure.kinematics)

%%
% The angles for individual links are in order as they goes from root to the end-effector (or the last link). And there must
% be one joint angle for each link, which means it sometimes requires to add '0' (zero) to position, where virtual link is
% added and the robot does not normally has a joint angle - usually torso or end-effectors.
%
% *If the robot does not have 'moveable' torso (ie. joint angles are
% always zero), do not provide them into the function.*
%
% You can provide joint angles for all chains (all physical chain, providing joint angles of for example skin will not work).
close all
rob.showModel({[0,0,0,0,0,0],[0,0,0,0,0,0], [0,0,0]})

%%
% Or you can add joint angles just for first few chains. Here, the head will not be shown
close all
rob.showModel({[0,0,0,0,0,0],[0,0,0,0,0,0]})

%%
% The function also supports visualization of the nao skin
close all
rob.showModel({[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0]},'naoSkin',1)

%%
% The function also supports visualization of markers etc, as joints.
close all;
rob2 = Robot('loadMotoman');
rob2.showModel({[0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0]},'specialGroup',{'leftMarkers', 'rightMarkers'});

%%
% And to compare with other settings, two robots can be shown. 
%
% You can either just turn the other robot on and it will load kinematics from 'defaultKinematics' field of 'Robot.structure'
close all
rob.showModel({[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0]},'dual',1)

%%
% Or you can pass the new kinematics
close all
newKinematics=rob.structure.kinematics;
newKinematics.rightArm(6,1)=0.1;
rob.showModel({[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0]},'dual',1,'dualKinematics',newKinematics)