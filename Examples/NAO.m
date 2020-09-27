%% NAO example - right arm mount from rightArm - torso touch
% with already precomputed values
robot_fcn = 'loadNAO'; % Name of the function with robot structure
config_fcn = 'optimizationConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'rightArm'}; % Used chains, delimited by comma (,) 
jointTypes={'mount'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' joint is set by default
dataset_fcn = 'loadDatasetNao'; % Name of the function for loading of the dataset
whitelist_fcn = ''; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {'rightArm_torso'}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'new'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = [1, 1, 1]; % 1/0, determines whether to save results
loadDHfunc = ''; % name of function to load DH ('loadDHfromMat','loadDHfromTxt')
loadDHargs = {}; % arguments for the function above
loadDHfolder = ''; % folder from which to load DH

runCalibration(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% NAO example - head from leftArm-head and rightArm-head
% with already precomputed values
robot_fcn = 'loadNAO'; % Name of the function with robot structure
config_fcn = 'optimizationConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'head'}; % Used chains, delimited by comma (,) 
jointTypes={'mount'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' joint is set by default
dataset_fcn = 'loadDatasetNao'; % Name of the function for loading of the dataset
whitelist_fcn = ''; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {'rightArm_head', 'leftArm_head'}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'new_calib'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo =[1, 1, 1]; % 1/0, determines whether to save results
loadDHfunc = 'loadDHfromMat'; % name of function to load DH ('loadDHfromMat','loadDHfromTxt')
loadDHargs = {}; % arguments for the function above
loadDHfolder = 'NAO_new'; % folder from which to load DH

runCalibration(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% NAO example - right arm mount from rightArm - torso touch
% with already precomputed values
% use of alternative mode - points defined in mount frame
robot_fcn = 'loadNAOAlt'; % Name of the function with robot structure
config_fcn = 'optimizationConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'rightArm'}; % Used chains, delimited by comma (,) 
jointTypes={'mount'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' joint is set by default
dataset_fcn = 'loadDatasetNao'; % Name of the function for loading of the dataset
whitelist_fcn = ''; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {{'rightArm_torso'}, 'Alt'}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'new_calib'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = [1, 1, 1]; % 1/0, determines whether to save results
loadDHfunc = 'loadDHfromMat'; % name of function to load DH ('loadDHfromMat','loadDHfromTxt')
loadDHargs = {}; % arguments for the function above
loadDHfolder = 'NAO_alt'; % folder from which to load DH

runCalibration(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% NAO example - rightFinger from rightFinger - torso
% with already precomputed values, with use of RT matrices
robot_fcn = 'loadNAO'; % Name of the function with robot structure
config_fcn = 'optimizationConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'torso'}; % Used chains, delimited by comma (,) 
jointTypes={'mount'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' joint is set by default
dataset_fcn = 'loadDatasetNao'; % Name of the function for loading of the dataset
whitelist_fcn = ''; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {'torso_rightFinger'}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'boh2'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = [1, 1, 1]; % 1/0, determines whether to save results
loadDHfunc = 'loadDHfromMat'; % name of function to load DH ('loadDHfromMat','loadDHfromTxt')
loadDHargs = {}; % arguments for the function above
loadDHfolder = 'boh'; % folder from which to load DH

runCalibration(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% Visualisation of result
%% Best one is probably this - shows robot with skin and activation
% Big taxels are COPs touching
folder = 'new';
load(strcat('Results/',folder,'/info'));
load(strcat('Results/',folder, '/results.mat'));
loadDHfromMat(rob, folder, 'type' ,'min');
%Change following line to change which datasets will be displayed
% dataset_params={'rightArm_torso', 'leftArm_torso', 'rightArm_head', 'leftArm_head'};
% dataset_params={'rightArm_torso'};
[~,~,datasets] = rob.prepareDataset(optim, chains, dataset_fcn,dataset_params);
activationsView(rob,{datasets.selftouch{:}},'info',1,'skin',1, 'finger', 1)

%% Distances between taxels
%Good to check if all point getting better equally
% Shows distribution of distances between taxels for each taxel or triangle
folder = 'boh2';
load(strcat('Results/',folder, '/info'));
load(strcat('Results/',folder, '/results.mat'));
loadDHfromMat(rob, folder, 'type' ,'min');
%Change following line to change which datasets will be displayed
%dataset_params{1}={'rightArm_torso', 'leftArm_torso', 'rightArm_head', 'leftArm_head'};
%taxelStruct = loadDatasetNao(rob, optim, chains, dataset_params);
getTaxelDistances(rob,chains, dataset_params)