%% Examples of visualization
%%
% Most of the functions support optional arguments. To see the options try
% to view the help for the function, e.g.
help plotCorrections;

%% Corrections
% To show corrections, you just need to provide folder with results
plotCorrections('exampleNao');

%%
% The function also supporst more arguments. For example, to use length in
% mm
plotCorrections('exampleNao','units','mm');

%% Error boxplots
% Boxplots of errors work very similar, but you can pass more than one
% folder
plotErrorsBoxplots({'exampleNao','exampleNao2'});

%%
% Again, the function takes more optional arguments
% E.g. to change location of the legend and use logaritmic scale
plotErrorsBoxplots({'exampleNao','exampleNao2'},'log',1,'location','northeast');


%% Error bars
% Errors can be also shown as bars
plotErrorBars({'exampleNao','exampleNao2'})

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
load('Results/exampleNao3/info');
% This example does not 'make sense', it just for demonstration of input.
% Argument with 'rightArm' determines which chain to show.
plotJointDistribution(rob, {datasets.selftouch{1},datasets.selftouch{2}},{datasets.selftouch{2}}, 'rightArm', '', '', 1);

%%
% Alternatively you can pass just one dataset
close all
load('Results/exampleNao3/info');
% This example shows also title and legend settings
plotJointDistribution(rob, {datasets.selftouch{1}},[], 'leftArm', 'myFig', {'myDataset'}, 1);

%% Projections

%% Jacobian
% Shows Jacobians computed in each repetition of calibration. All the
% mandatory arguments can be loaded from results
load('Results/exampleNao2/info');
plotJacobian(rob, whitelist, jacobians)

%% Moveable model
% This model uses 'showModel' method of Robot and allows to change
% activations by 'left' and 'right' arrow keys.
% You need to have datasets from calibration, which can be easile loaded
load('Results/exampleNao2/info');
activationsView(rob,{datasets.selftouch{:}})

%%
% For Nao robot it allows to show skin and info about activations
load('Results/exampleNao2/info');
activationsView(rob,{datasets.selftouch{:}},'info',1,'skin',1)


%% Robots equipped with skin
% Right now, the functions are developed for Nao and will probably not work
% on any other robot

%% Distances between taxels
% Shows distribution of distances between taxels for each taxel or triangle
load('Results/exampleNao2/info');
getTaxelDistances(rob,{'rightArm_torso'})

%% Activated taxels
% Shows activated taxels in the dataset
load('Results/exampleNao2/info');
visualizeActivatedTaxels({'rightArm_torso'})