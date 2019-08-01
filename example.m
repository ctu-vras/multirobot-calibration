%% motoman self touch calibration - only right arm
robot_fcn = 'loadMotoman';
config_fcn = 'motomanOptConfig';
approaches = {'selftouch'};
chains = {'rightArm'};
dataset_fcn = 'loadDatasetMotoman';
whitelist_fcn = 'loadMotomanWL';
bounds_fcn = '';
dataset_params = {[1,0,0,0]};
folder = 'self-touch-motoman';
saveInfo = 1;
loadDHfunc = '';
loadDHargs = '';
loadDHfolder = '';

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
loadDHfunc = 'loadDHfromMat';
loadDHargs = {'type', 'min'};
loadDHfolder = 'self-touch-motoman';

main(robot_fcn, config_fcn, approaches, chains, dataset_fcn, whitelist_fcn, bounds_fcn, dataset_params, folder, saveInfo, loadDHfunc, loadDHargs, loadDHfolder);

%% motoman hand-eye calibration - right arm and right eye using DH from rep1 and pert1 of self touch as initial
robot_fcn = 'loadMotoman';
config_fcn = 'motomanOptConfig';
approaches = {'eyes'};
chains = {'rightArm', 'rightEye'};
dataset_fcn = 'loadDatasetMotoman';
whitelist_fcn = '';
bounds_fcn = '';
dataset_params = {[0,0,0,1]};
folder = 'projections-motoman';
saveInfo = 1;
loadDHfunc = 'loadDHfromTxt';
loadDHargs = {'DH-rep1-pert1'};
loadDHfolder = 'self-touch-motoman';
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

