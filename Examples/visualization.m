%% Examples of visualization
% Its better to create some robot to add everything important to path
rob = Robot('loadNAO');
r
%%
% Most of the functions support optional arguments. To see the options try
% to view the help for the function, e.g.
help plotCorrections;

%% NAO skin
% Special function for NAO to show his skin with trinagles and taxels
% numbers
showNaoSkin();

%% Corrections
% To show corrections, you just need to provide folder with results
folder = 'NAOOO';
plotCorrections(folder);

%%
% The function also supporst more arguments. For example, to use length in
% mm
folder = 'leica-comp';
plotCorrections(folder,'units','mm');

%% Error boxplots
% Boxplots of errors work very similar, but you can pass more than one
% folder
folder = 'plane-comp';
folder2 = 'leica-comp';
plotErrorsBoxplots({folder,folder2});

%%
% Again, the function takes more optional arguments
% E.g. to change location of the legend and use logaritmic scale
folder = 'NAOOO';
folder2 = 'NAO';
plotErrorsBoxplots({folder, folder2},'log',1,'location','northeast');


%% Error bars
% Errors can be also shown as bars
folder = 'plane-comp';
folder2 = 'leica-comp';
plotErrorBars({folder,folder2})

%% Error Residuals
% Shows residual errors using quiver plot
% We need two set of points, which can be computed for example like this

load('Results/NAOOO/info'); %Load saved data
load('Results/NAOOO/datasets'); %Load saved data
dataset = datasets_out.selftouch{1};
extPoints=dataset.refPoints';
robPoints = zeros(4, size(dataset.joints, 1));
for i = 1:size(dataset.joints,1) % Transform all point to base frame
    joint = rob.findJoint(dataset.frame{i});
    robPoints(:,i) =  getTFtoFrame(rob.structure.defaultDH, joint{1}, dataset.joints(i)) *[dataset.point(i,1:3),1]';
end
% And the function itself can be called
plotErrorResiduals(extPoints, robPoints(1:3,:))


%% Joint distribution
% Shows comparison of joint distributions
% Function takes 2 datasets, where both of them are cellArray of structs
close all
folder = 'self-touch-motoman';
% load(['Results/',folder,'/info']);
load(['Results/',folder,'/datasets']);
% This example does not 'make sense', it just for demonstration of input.
% Argument with 'rightArm' determines which chain to show.
plotJointDistribution(rob, {datasets_out.selftouch{1},datasets_out.projection{1}},{datasets_out.projection{1}}, 'rightArm', '', '', 2);

%%
% Alternatively you can pass just one dataset
close all
folder = 'NAOOO';
load(['Results/',folder,'/info']);
load(['Results/',folder,'/datasets']);
% This example shows also title and legend settings
plotJointDistribution(rob, {datasets_out.selftouch{1}},[], 'rightArm', 'myFig', {'myDataset'}, 1);

%% Joint-error plot
% shows mean errors for each joint value of given joints
close all
folder = 'leica-motoman';
load(['Results/',folder,'/info']);
load(['Results/',folder,'/errors']);
% errors must be for whole dataset (train + test together)
plotJointsError(rob, [errorsAll{3}{1}, errorsAll{11}{1}], datasets.external, group.rightArm, 'Joint-error plot', [1,8])


%% Projections

%% Jacobian
% Shows Jacobians computed in each repetition of calibration. All the
% mandatory arguments can be loaded from results
folder = 'NAOOO';
plotJacobian(folder)

%% Moveable model
% This model uses 'showModel' method of Robot and allows to change
% activations by 'left' and 'right' arrow keys.
% You need to have datasets from calibration, which can be easile loaded
load('Results/NAOOO/info');
load('Results/NAOOO/datasets');
activationsView(rob,{datasets_out.selftouch{:}})

%%
% For Nao robot it allows to show skin and info about activations
folder = 'NAOOO';
load(strcat('Results/',folder, '/info'));
load(strcat('Results/',folder, '/results.mat'));
% rob=Robot('loadNAO');
rob.structure.DH = res_dh;
dataset_params ={'rightArm_torso', 'leftArm_torso', 'rightArm_head', 'leftArm_head'};
[~,~,datasets] = rob.prepareDataset(optim, chains, dataset_fcn,dataset_params);
activationsView(rob,{datasets.selftouch{:}},'info',1,'skin',1)


%% Robots equipped with skin
% Right now, the functions are developed for Nao and will probably not work
% on any other robot

%% Distances between taxels
% Shows distribution of distances between taxels for each taxel or triangle
folder = 'NAOOO';
load(strcat('Results/',folder, '/info'));
load(strcat('Results/',folder, '/results.mat'));
rob.structure.DH = res_dh;
rob.structure.matrices = rob.structure.matricesBack;
getTaxelDistances(rob,dataset_params)

%% Activated taxels
% Shows activated taxels in the dataset
load('Results/NAOOO/info');
visualizeActivatedTaxels(dataset_params)