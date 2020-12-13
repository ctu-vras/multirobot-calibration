%% Example calibration
robot_fcn = 'loadExampleRobot'; % Name of the function with robot structure
config_fcn = 'optimizationConfig'; % Name of the function with calibration config
approaches = {'selftouch'}; % Used approaches, delimited by comma (,)
chains = {'rightArm'}; % Used chains, delimited by comma (,) 
jointTypes={'joint'}; % Used body parts, delimited by comma (,), in 'motomanOptConfig' joint is set by default
dataset_fcn = 'loadExampleDataset'; % Name of the function for loading of the dataset
whitelist_fcn = ''; % Name of the function with custom whitelist
bounds_fcn = ''; % Name of the funtion with custom bounds
dataset_params = {'LREye'}; % Params of the 'dataset_fcn', delimited by comma (,)
folder = 'example'; % Folder where results will be saved (relatively to 'results' folder)
saveInfo = [1, 1, 1]; % 1/0, determines whether to save results
loadDHfunc = ''; % name of function to load DH ('loadDHfromMat','loadDHfromTxt')
loadDHargs = {}; % arguments for the functio above
loadDHfolder = ''; % folder from which to load DH

runCalibration(robot_fcn, config_fcn, approaches, chains, jointTypes, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);