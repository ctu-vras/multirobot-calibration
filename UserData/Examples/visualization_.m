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
folder = 'NAO_rightArm';
plotCorrections(folder);

%%
% The function also supporst more arguments. For example, to use length in
% mm
folder = 'NAO-rightArm';

plotCorrections(folder,'units','mm', 'noiseLevel', 0);

%% Error boxplots
% Boxplots of errors work very similar, but you can pass more than one
% folder
% folder = 'NAO_torso_skin_on_skin';
plotErrorsBoxplots({'NAO-rightArm'},'log',0, 'train', 0, 'errors', 'errorsAll');

%%
% Again, the function takes more optional arguments
% E.g. to change location of the legend and use logaritmic scale
folder = 'NAOOO';
folder2 = 'NAO';
plotErrorsBoxplots({folder, folder2},'log',1,'location','northeast');

%% histo
folder = 'NAO-rightArm';
plotErrorsHistogram(folder)

%% Error bars
% Errors can be also shown as bars
folder = 'NAOOO';
folder2 = 'leica-motoman';
plotErrorBars({'NAO-rightArm'}, 'log', 1, 'train', 0)

%% Error Residuals
% Shows residual errors using quiver plot
% We need two set of points, which can be computed for example like this

load('Results/NAO-rightArm/info'); %Load saved data
load('Results/NAO-rightArm/datasets'); %Load saved data
dataset = datasets_out.selftouch{1};
extPoints=dataset.refPoints';
robPoints = zeros(4, size(dataset.joints, 1));
for i = 1:size(dataset.joints,1) % Transform all point to base frame
    joint = rob.findJoint(dataset.frame{i});
    robPoints(:,i) =  getTFtoFrame(rob.structure.defaultDH, joint{1}, dataset.joints(i), rob.structure.H0) *[dataset.point(i,1:3),1]';
end
% And the function itself can be called
plotErrorResiduals(extPoints, robPoints(1:3,:))


%% Joint distribution
% Shows comparison of joint distributions
% Function takes 2 datasets, where both of them are cellArray of structs
close all
folder = 'NAO-rightArm';
load(['Results/',folder,'/info']);
load(['Results/',folder,'/datasets']);
% This example does not 'make sense', it just for demonstration of input.
% Argument with 'rightArm' determines which chain to show.
plotJointDistribution(rob, {datasets_out.selftouch{1}}, 'torso', '', '', 2);

%%
% Alternatively you can pass just one dataset
close all
folder = 'NAO-rightArm';
load(['Results/',folder,'/info']);
load(['Results/',folder,'/datasets']);
% This example shows also title and legend settings
plotJointDistribution(rob, {datasets_out.selftouch{1}},[], 'rightArm', '', {folder}, 1);

%% Joint-error plot
% shows mean errors for each joint value of given joints
close all
folder = 'NAO-rightArm';
load(['Results/',folder,'/info']);
load(['Results/',folder,'/errors']);
load(['Results/',folder,'/datasets']);
% errors must be for whole dataset (train + test together)
plotJointsError(rob, [errorsAll{1}{1}, errorsAll{9}{1}], datasets_out.selftouch, group.rightArmSkin, 'Joint-error plot', [1,8])


%% Projections

%% Jacobian
% Shows Jacobians computed in each repetition of calibration. All the
% mandatory arguments can be loaded from results
folder = 'NAO-rightArm';
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
folder = 'NAO-rightArm';
load(strcat('Results/',folder, '/info'));
load(strcat('Results/',folder, '/results.mat'));
rob.structure.DH = res_dh;
% rob.structure.matrices = rob.structure.matricesBack;
getTaxelDistances(rob,dataset_params)

%% Activated taxels
% Shows activated taxels in the dataset
load('Results/NAO-rightArm/info');
visualizeActivatedTaxels(dataset_params)