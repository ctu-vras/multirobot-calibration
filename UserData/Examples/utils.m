%% Example of using the utils in toolbox
%
% Examples of some of the important utils, which could be useful even
% outside existing functions

%%  Find RT matrix to any link

%%
% Variable with created robot is needed, we can for example create a new one
rob=Robot('loadMotoman');

%% 
% Then choose the link. You can take any link from robot
link=rob.links{15};

%%
% Or find the link by its name
link=rob.findLink('EE1');

link=link{1}; % The function can return more than one result, if robot include link with the same name

% Robot allows to find link not just by name, but also by group, type or
% id (in these cases there will usually be more than 1 link returned).

%% 
% Then you need to find all groups on the way to the root and indexes in kinematics
% arrays of these groups
str=getIndexes([], link);

%%
% The last thing needed are the joint angles, for this example we can use
% random numbers
angles.rightArm=[0,1,0.5,0.3,0,0.5,0.3,0.1];
rtMat=[];
%% 
% With this, we can compute the RT matrix as it is in the calibration
% It is too complicated and not recommended for normal users
[kinematics, type] = padVectors(rob.structure.kinematics); % Pad to size 6 vector
matInt=getTFIntern(kinematics,link,rtMat,angles, str.DHindexes.(link.name),str.parents, [],type);

%% 
% You can also get transformation to given frame
mat2=getTFtoFrame(rob.structure.kinematics,link, angles, 'L1');

%%
% And easily compute the rest then
link=rob.findLink('L1');
link=link{1};
mat3=getTFtoFrame(rob.structure.kinematics,link, angles, 'base');


%%
% We can test it
disp(norm(matInt-mat3*mat2,'fro')<10*eps)
% Frobenius norm of matrix should be very low number (not 0 in most cases 
% beacuse of floating point numbers errors) 

%% Mass transformation of points
% If you need to tranform more points to the base frame, you can use
% 'getPointsIntern'.

% We can load dataset to get everything we need
load('Results/nao-right-arm/info.mat');
load('Results/nao-right-arm/datasets.mat');

% And easily transform all point from local frame to the base frame
[kinematics, ~] = padVectors(rob.structure.kinematics); % Pad to size 6 vector
newPoints=getPoints(rob, kinematics, datasets_out.selftouch{1}, 0);
