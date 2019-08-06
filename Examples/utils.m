%% Example of using the utils in toolbox
% Examples of some of the important utils, which could be useful even
% outside existing functions

%%  Find RT matrix to any joint

%%
% Variable with created robot is needed, we can for example create a new one
rob=Robot('loadNAO');

%% 
% Then choose the joint. You can take any joint from robot
joint=rob.joints{53};

%%
% Or find the joint by its name
joint=rob.findJoint('rightTriangle3');
joint=joint{1}; % The function can return more than one result, if robot include joint with the same name
% Robot allows to find joint not just by name, but also by group, type or
% id (in these cases there will usually be more than 1 joint returned).

%% 
% Then you need to find all groups on the way to the root and indexes in DH
% arrays of these groups
str=[];
str=getIndexes(str, joint);

% We get that 'rightTriangle3' need to compute matrices through
% 'rightArmSkin' and 'rightArm' 

%%
% The last thing needed are the joint angles, for this example we can use
% zeros
angles.rightArmSkin=[0,0,0];
angles.rightArm=[0,1,0.5,0.3,0,0.5];

%% 
% With this, we can compute the RT matrix
mat=getTF(rob.structure.DH,joint,[],angles, rob.structure.H0,str.DHindexes.(joint.name),str.parents);


%% 
% You can also get transformation to given frame
mat2=getTFtoFrame(rob.structure.DH,joint, angles, rob.structure.H0,'rightShoulderPitch');

%%
% And easily compute the rest then
joint=rob.findJoint('rightShoulderPitch');
joint=joint{1};
mat3=getTFtoFrame(rob.structure.DH,joint, angles, rob.structure.H0,'base');


%%
% We can test it
disp(norm(mat-mat3*mat2,'fro')<eps)
% Frobenius norm of matrix should be very low number (not 0 in most cases 
% beacuse of floating point numbers errors) 

%% Mass transformation of points
% If you need to tranform more points to the base frame, you can use
% 'getPoints'.

% We can load dataset to get everything we need
load('Results/exampleNao/info.mat');

% And easily transform all point from local frame to the base frame
newPoints=getPoints(rob.structure.DH, datasets.dist{:}, rob.structure.H0, 0);
