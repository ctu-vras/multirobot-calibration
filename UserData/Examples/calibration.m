%% Calibration examples
%
% Few examples how to run calibration with different argument and different
% robots. Last example shows how to run with use of CSV files. The first
% example is full commented, the rest has only the 'new' parts commented.

%% NAO example - right arm mount from rightArm - torso touch
robot_fcn = 'loadNAO'; % Name of the function with robot structure
config_fcn = 'optimizationConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'rightArm'}; % Used chains, delimited by comma (,) 
linkTypes={'mount'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' link is set by default
dataset_fcn = 'loadDatasetNao'; % Name of the function for loading of the dataset
whitelist_fcn = ''; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {'rightArm_torso'}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'nao-right-arm'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = [1, 1, 1]; % 1/0, determines whether to save results
loadKinfunc = ''; % name of function to load kinematics ('loadKinfromMat','loadKinfromTxt')
loadKinargs = {}; % arguments for the functio above
loadKinfolder = ''; % folder from which to load kinematics

runCalibration(robot_fcn, config_fcn, approaches, chains, linkTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadKinfunc, loadKinargs, loadKinfolder);
%% motoman self touch calibration - only right arm
robot_fcn = 'loadMotoman'; % Name of the function with robot structure
config_fcn = 'motomanOptConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'rightArm'}; % Used chains, delimited by comma (,) 
linkTypes={'joint'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' link is set by default
dataset_fcn = 'loadDatasetMotoman'; % Name of the function for loading of the dataset
whitelist_fcn = 'loadMotomanWL'; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {[1,0,0,0]}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'self-touch-motoman'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = [1, 1, 1]; % 1/0, determines whether to save results
loadKinfunc = ''; % name of function to load kinematics ('loadKinfromMat','loadKinfromTxt')
loadKinargs = ''; % arguments for the function above
loadKinfolder = ''; % folder from which to load kinematics

runCalibration(robot_fcn, config_fcn, approaches, chains, linkTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadKinfunc, loadKinargs, loadKinfolder);

%% motoman leica calibration - only right arm using kinematics from self touch (with min rms errors) as initial
robot_fcn = 'loadMotomanLeica';
config_fcn = 'motomanOptConfig';
approaches = {'external'};
chains = {'rightArm'};
linkTypes={'joint'}; 
dataset_fcn = 'multirobot_leica_dataset.mat'; % mat file with containing datasets and indexes structures
whitelist_fcn = 'loadMotomanWL';
bounds_fcn = '';
dataset_params = {};
folder = 'leica-motoman';
saveInfo = [1, 1, 1];
loadKinfunc = 'loadKinfromMat'; % Here load from '.mat' files is used
loadKinargs = {'type', 'min'}; % this means: load the kinematics params which has the lowest RMS error
loadKinfolder = 'self-touch-motoman'; %load kinematics from this file
runCalibration(robot_fcn, config_fcn, approaches, chains, linkTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadKinfunc, loadKinargs, loadKinfolder);

%% motoman hand-eye calibration - right arm and right eye using kinematics from rep1 and pert1 of self touch as initial
robot_fcn = 'loadMotoman';
config_fcn = 'motomanOptConfig';
approaches = {'projection'};
chains = {'rightArm', 'rightEye'};
linkTypes={'joint','eye'}; 
dataset_fcn = 'loadDatasetMotoman';
whitelist_fcn = ''; %Whitelist does not have to be specified, the default will be used
bounds_fcn = '';
dataset_params = {[0,0,0,1]};
folder = 'projections-motoman';
saveInfo = [1, 1, 1];
loadKinfunc = 'loadKinfromTxt'; %load from txt files
loadKinargs = {'kin-rep1-pert1'}; % name of the file
loadKinfolder = '';
runCalibration(robot_fcn, config_fcn, approaches, chains, linkTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadKinfunc, loadKinargs, loadKinfolder);

%% iCub selftouch calibration - only right arm, using first 100 point from dataset
robot_fcn = 'loadICUBv1';
config_fcn = 'motomanOptConfig';
approaches = {'selftouch'};
chains = {'rightArm', 'leftMiddle'};
linkTypes={'joint', 'finger'}; 
dataset_fcn = 'loadDatasetICub';
whitelist_fcn = '';
bounds_fcn = '';
dataset_params = {100};
folder = 'self-touch-icub';
saveInfo = [1, 1, 1];
loadKinfunc = '';
loadKinargs = '';
loadKinfolder = '';
runCalibration(robot_fcn, config_fcn, approaches, chains, linkTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadKinfunc, loadKinargs, loadKinfolder);

%% load task from CSV
addpath(genpath('Utils')); % At first run, this folder needs to be loaded manually
loadTasksFromFile('tasks.csv'); % take 'tasks.csv' and run commands from there