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
folder = 'NAO_new';
plotCorrections(folder);

%%
% The function also supporst more arguments. For example, to use length in
% mm
folder = 'fingTorso3';
plotCorrections(folder,'units','mm');

%% Error boxplots
% Boxplots of errors work very similar, but you can pass more than one
% folder
folder = 'NAO_alt';
folder2 = 'leica-motoman';
plotErrorsBoxplots({folder,folder2});

%%
% Again, the function takes more optional arguments
% E.g. to change location of the legend and use logaritmic scale
folder = 'NAO_alt';
folder2 = 'NAO';
plotErrorsBoxplots({folder, folder2},'log',1,'location','northeast');


%% Error bars
% Errors can be also shown as bars
folder = 'NAO_alt';
folder2 = 'leica-motoman';
plotErrorBars({folder,folder2})

%% Error Residuals
% Shows residual errors using quiver plot
% We need two set of points, which can be computed for example like this

load('Results/leica-motoman/info'); %Load saved data
dataset = datasets.external{1};
extPoints=dataset.refPoints;
robPoints = getPoints(rob.structure.defaultDH, dataset, rob.structure.H0, false); % Transform all point to base frame
[R,T]=fitSets(extPoints,robPoints(1:3,:)'); % Fit sets from different origin
extPoints = R*extPoints' + T; % Use found transformation
%%
% And the function itself can be called
plotErrorResiduals(extPoints, robPoints(1:3,:))


%% Joint distribution
% Shows comparison of joint distributions
% Function takes 2 datasets, where both of them are cellArray of structs
close all
folder = 'NAO_alt';
load(['Results/',folder,'/info']);
% This example does not 'make sense', it just for demonstration of input.
% Argument with 'rightArm' determines which chain to show.
plotJointDistribution(rob, {datasets.selftouch{1},datasets.selftouch{2}},{datasets.selftouch{2}}, 'rightArm', '', '', 1);

%%
% Alternatively you can pass just one dataset
close all
folder = 'NAO_alt';
load(['Results/',folder,'/info']);
% This example shows also title and legend settings
plotJointDistribution(rob, {datasets.selftouch{1}},[], 'rightArm', 'myFig', {'myDataset'}, 1);

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
fodler = 'NAO_alt';
load(['Results/',folder,'/info']);
plotJacobian(rob, whitelist, jacobians)

%% Moveable model
% This model uses 'showModel' method of Robot and allows to change
% activations by 'left' and 'right' arrow keys.
% You need to have datasets from calibration, which can be easile loaded
load('Results/exampleNao/info');
activationsView(rob,{datasets.selftouch{:}})

%%
% For Nao robot it allows to show skin and info about activations
folder = 'alt_new';
load(strcat('Results/',folder, '/info'));
load(strcat('Results/',folder, '/results.mat'));
% rob=Robot('loadNAO');
rob.structure.DH = res_dh;
dataset_params{1}={'rightArm_torso', 'leftArm_torso', 'rightArm_head', 'leftArm_head'};
[~,~,datasets] = rob.prepareDataset(optim, chains, dataset_fcn,dataset_params);
activationsView(rob,{datasets.selftouch{:}},'info',1,'skin',1)


%% Robots equipped with skin
% Right now, the functions are developed for Nao and will probably not work
% on any other robot

%% Distances between taxels
% Shows distribution of distances between taxels for each taxel or triangle
folder = 'exampleNao';
load(strcat('Results/',folder, '/info'));
load(strcat('Results/',folder, '/results.mat'));
rob.structure.DH = res_dh;
rob.structure.matrices = rob.structure.matricesBack;
getTaxelDistances(rob,dataset_params)

%% Activated taxels
% Shows activated taxels in the dataset
load('Results/exampleNao/info');
visualizeActivatedTaxels(dataset_params)