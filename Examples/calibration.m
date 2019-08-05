%% Calibration examples
% Few examples how to run calibration with different argument and different
% robots. Last example shows how to run with use of CSV files. The first
% example is full commented, the rest has only the 'new' parts commented.

%% motoman self touch calibration - only right arm
robot_fcn = 'loadMotoman'; % Name of the function with robot structure
config_fcn = 'motomanOptConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'rightArm'}; % Used chains, delimited by comma (,) 
dataset_fcn = 'loadDatasetMotoman'; % Name of the function for loading of the dataset
whitelist_fcn = 'loadMotomanWL'; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {[1,0,0,0]}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'self-touch-motoman'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = 1; % 1/0, determines whether to save results
loadDHfunc = ''; % name of function to load DH ('loadDHfromMat','loadDHfromTxt')
loadDHargs = ''; % arguments for the function above
loadDHfolder = ''; % folder from which to load DH

main(robot_fcn, config_fcn, approaches, chains, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% motoman leica calibration - only right arm using DH from self touch (with min rms errors) as initial
robot_fcn = 'loadMotomanLeica';
config_fcn = 'motomanOptConfig';
approaches = {'external'};
chains = {'rightArm'};
dataset_fcn = 'loadDatasetMotoman';
whitelist_fcn = 'loadMotomanWL';
bounds_fcn = '';
dataset_params = {'leica'};
folder = 'leica-motoman';
saveInfo = 1;
loadDHfunc = 'loadDHfromMat'; % Here load from '.mat' files is used
loadDHargs = {'type', 'min'}; % this means: load the DH params which has the lowest RMS error
loadDHfolder = 'self-touch-motoman'; %load DH from this file

main(robot_fcn, config_fcn, approaches, chains, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% motoman hand-eye calibration - right arm and right eye using DH from rep1 and pert1 of self touch as initial
robot_fcn = 'loadMotoman';
config_fcn = 'motomanOptConfig';
approaches = {'eyes'};
chains = {'rightArm', 'rightEye'};
dataset_fcn = 'loadDatasetMotoman';
whitelist_fcn = ''; %Whitelist does not have to be specified, the default will be used
bounds_fcn = '';
dataset_params = {[0,0,0,1]};
folder = 'projections-motoman';
saveInfo = 1;
loadDHfunc = 'loadDHfromTxt'; %load from txt files
loadDHargs = {'DH-rep1-pert1'}; % name of the file
loadDHfolder = '';
main(robot_fcn, config_fcn, approaches, chains, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% iCub selftouch calibration - only right arm, using first 100 point from dataset
robot_fcn = 'loadICUBv1';
config_fcn = 'motomanOptConfig';
approaches = {'selftouch'};
chains = {'rightArm'};
dataset_fcn = 'loadDatasetICub';
whitelist_fcn = '';
bounds_fcn = '';
dataset_params = {100};
folder = 'self-touch-icub';
saveInfo = 1;
loadDHfunc = '';
loadDHargs = '';
loadDHfolder = '';
main(robot_fcn, config_fcn, approaches, chains, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% load task from CSV
addpath(genpath('Utils')); % At first run, this folder needs to be loaded manually
loadTasksFromFile('tasks.csv'); % take 'tasks.csv' and run commands from there