%% Example calibration
robot_fcn = 'loadExampleRobot'; % Name of the function with robot structure
config_fcn = 'optimizationConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'rightArm'}; % Used chains, delimited by comma (,) 
linkTypes={'joint'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' link is set by default
dataset_fcn = 'loadExampleDataset'; % Name of the function for loading of the dataset
whitelist_fcn = ''; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {'LREye'}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'example'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = [1, 1, 1]; % 1/0, determines whether to save results
loadKinfunc = ''; % name of function to load Kin ('loadKinfromMat','loadKinfromTxt')
loadKinargs = {}; % arguments for the functio above
loadKinfolder = ''; % folder from which to load Kin

runCalibration(robot_fcn, config_fcn, approaches, chains, linkTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadKinfunc, loadKinargs, loadKinfolder);