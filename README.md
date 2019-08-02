# Contents
 - [How to run](#how-to-run)
 - [Robot](#robot)
 - [Joint](#joint)
 - [Datasets](#datasets)
 - [Confings](#configs)
 - [Robots](#robots)
 - [Calib](#calib)
 - [Utils](#utils)
 - [Visualization](#visualization)
 - [Schema](#schema)

# How to run
Recommended steps (the order is optional):

 - prepare fuctions for your robot (or use one of the existing)
   - take a look at [Robots](#robots) section and [Robots folder](Robots) to see existing possibilities
   - mandatory are functions with robot structures and DH (see [loading functions](#loading-functions)) and 
     functions to prepare datasets (see [Datasets](#datasets) and functions for existing robots)
   - voluntary are whitelist (see [Whitelist](#whitelist)), bounds (see [bounds](#bounds)) functions
 - set up calibration config file (see [Calibration config](#calibration-config))
 - select config files, output folders and run calibration 
   - look at [Examples](example.m)
   - or use csv file as input (see [Loading from csv](#loading-from-csv))
 - visualize and evaluate results (see [Visualization](#visualization))

# Robot
Found in the [@Robot](@Robot) folder. This directory includes the main class file for the robots [Robot.m](@Robot/Robot.m).
This file includes the constructor, which calls robot-specific functions (see [Robots](Robots)) to set up the robot.

## Properties
 - name - String name of the robot 
 - joints - Cell array of [Joint](#joint) classes
 - structure - Structure containing DH, WL and bounds

## Methods
 - findJoint - Returns instance of joints with given name
 - findJointById - Returns instance of joints with given Id
 - findJointByType - Returns instance of joints with given type
 - findJointByGroup - Returns instance of joints with given group
 - print - Displays Robot.joints as 'jointName jointId'
 - [printTables](@Robot/printTables.m) - Displays tables from Robot.structure as 'a, d, alpha, theta jointName'
 - [showModel](@Robot/showModel.m) - Shows virtual model of the robot based on input joint angles.
 - [showGraphModel](@Robot/showGraphModel.m) - Shows tree-based graph of given robot
 - [prepareDH](@Robot/prepareDH.m) - Returns DH tables with/without perturbations and tables with bounds
 - [prepareDataset](@Robot/prepareDataset.m) - Returns datasets in universal format, together with training/testing indexes
 - [getResultDH](@Robot/getResultedDH.m) - Returns final DH parameters and correction of each run
 - [createWhitelist](@Robot/createWhitelist.m) - Selects whitelist and returns selected parameters based on the whitelist, together with lower/upper bounds for the parameters.

# Joint
Found in the [@Joint](@Joint) folder. This directory includes the main class file for the joints [Joint.m](@Joint/Joint.m).
## Properties
 - name - String name of the joints
 - parent - Pointer to parent
 - parentId - Int id of parent
 - DHindex - Int id in DH/WL/Bounds table for given 'group'
 - type - 'type' of the joints...see [types.m](Utils/types.m)
 - endEffector - true/false if joint is endEffector
 - group - 'group' of the joint...see [group.m](Utils/group.m)

## Methods
 - computeRTMatrix - iterates over the parents of the input Joint and returns RT matrix

# Datasets
All of the datasets must be structure with these fields (some of them may be voluntary):
(unless otherwise stated, all fields have N rows, where N represent number of training/testing values)
 - point - Each value represent point in 3D space(x,y,z) and the field can be:
   - Nx3 array of doubles
   - Nx6 array of double, when two points are used (x1,y2,z1,x2,y2,z2)
 - frame - Nx1 array of strings, where each value is name of the joint from which the TF matrix will be computed	
 - frame2 (voluntary) - Nx1 array of strings, where each value is name of the joint from which the TF matrix for second point will be computed
 - joints - Nx1 array of structures, where each structure include joint angles for each group  
   - each field of the inner structure is 1xM array of doubles
   - e.g. joints(1).leftArm=[...], joints(1).rightArmSkin=[...]
 - refPoints (voluntary) - Nx3 array of doubles, where each line represents point in 3D (x,y,z, which will be used as reference to point computed from optimized values
   - used for example in selftouch, when we calculate position of the finger, but we know where the finger was supposed to touch
 - rtMat (voluntary) - Nx1 array of structures, where each structure include RT matrices for each group
   - not all group must be included
   - used for example when we know, we want only calibrate the skin and so we can pre-compute RT matrix for arm to speed up
   - e.g. rmMat(1).leftArm=4x4 array
 - cameras (voluntary) - 
 - pose - Nx1 array of any (almost) type, used to assing points from one 'pose'
   - e.g. when camera has more photos of one touch 

# Configs

## Calibration config
 See [optimizationConfig.m](Configs/optimizationConfig.m) for default settings and examples 

### Description of parameters

 - solver options - mostly no parameter needs to be changed, but few important settings are:
   - Algorithm - if you want to use bounds, change to 'trust-region-reflective'
   - TolFun - if problem converges too soon, change to lower value (higher if it doest not converges)
   - MaxIter - if problem does not converges, set higher value (too high value may results into overfitting)
   - UseParallel - set to 1, if you want to use more cores of CPU
   - ScaleProblem - set to 'jacobian' if differences in calibrated parameters are too high (e.g. lengths in thousands of mm and angles in units of rad)
 - chains - set which chains will be calibrated
   - can be edited in the config file or passed in as an argument (e.g. {'rightArm','leftArm'}, see [Main example](example.m))
   - if chains is set to 0, it does not matter if there are any 1 in the whitelist in given chain (this is superior over whitelist)
 - approaches - set which approch will be used (see [Calibration approches](#calibration-approches)
   - more than one approches at a time can be used
   - value does not have to be 1/0, but any non-zero number will enable the approche and values from thsi approach will be scaled by given value
   - can be edited in the config file or passed in as an argument (e.g. {'selftouch','planes'}, see [Main example](example.m))
 - 
# Calib
Folder with functions designed for calibration

## Calibration approches

## Files
 - [errors_fcn.m](Calib/errors_fcn.m) - returns vector of vector of errors for all types of calibration
 - [getDist.m](Calib/getDist.m) - returns errors from selftouch configurations
 - [getDistFromExt.m](Calib/getDistFromExt.m) - returns errors from configurations with external camera
 - [getPlaneDist.m](Calib/getPlaneDist.m) - returns errors from selftouch configurations
 - [getProjectionDist.m](Calib/getProjectionDist.m) - returns errors from projections

# Visualization
Folder with functions designed for visualization of the results
## Files
 - [plotCorrections.m](Visualisation/plotCorrections.m) - shows two plots for each 'group'. One with length (a,d) and one with angles (alpha, theta) of corrections from given folder
 - [plotErrorBars.m](Visualisation/plotErrorBars.m) - plots rms errors bars
 - [plotErrorResidual.m](Visualisation/plotErrorResidual.m) - plots error residuals
 - [plotErrorsBoxplots.m](Visualisation/plotErrorsBoxplots.m) - shows boxplots with RMS errors from given folders
 - [plotJacobian.m](Visualisation/plotJacobian.m) - plots jacobians
 - [plotJointDistribution.m](Visualisation/plotJointDistribution.m) - plots joint distribution
 - [plotProjections.m](Visualisation/plotProjections.m) - plots projections
 - [visualizeActivatedTaxels.m](Visualisation/visualizeActivatedTaxels.m) - shows activated taxels on all chains and number of actiated taxels/triangles for given datasets
 - [activationsView.m](Visualisation/activationsView.m) - shows moving model of the robot with option to show statistics and skin. Shows one fig for each dataset
 - [getTaxelsDistances.m](Visualisation/getTaxelDistances.m) - shows distribution of distances between taxels/triangles

# Utils
Folder with functions designed for repetitive tasks.
## Files
 - [computeObservability.m](Utils/computeObservability.m) - computes different observability parameters
 - [dhpars2tfmat.m](Utils/dhpars2tfmat.m) - computes a transformation given by Denavit-Hartenberg parameters
 - [ezwraptopi.m](Utils/ezwraptopi.m) - easily wrap a vector or matrix of angles to [-pi; pi]
 - [fitSets.m](Utils/fitSets.m) - finds tranformation between two sets of points
 - [getDatasetPart.m](Utils/getDatasetPart.m) - slices a dataset depends on the given pose numbers
 - [getPlane.m](Utils/getPlane.m) - computes a plane fitted to set of given points using svd
 - [getPoints.](Utils/getPoints.m) - computes a plane fitted to set of given points using svd
 - [getTF.m](Utils/getTF.m) - computes transformation from given joint to base 
 - [group.m](Utils/group.m) - static class of enumerated type containing string names of all part of robot body and skin
 - [inversetf.m](Utils/inversetf.m) - invers transformation matrix
 - [loadConfig.m](Utils/loadConfig.m) - loads Config file function
 - [loadDHfromMat.m](Utils/loadDHfromMat.m) - loads robot DH from mat file
 - [loadDHfromTxt.m](Utils/loadDHfromTxt.m) - loads robot DH from a text file
 - [loadTaskFromFile.m](Utils/loadTasksFromFile.m) - loads the calibration task from csv file
 - [projections.m](Utils/projections.m) - projects points to the cameras
 - [rmsErrors.m](Utils/rmsErrors.m) - computes rms errors
 - [saveResults.m](Utils/saveResults.m) - saves results to mat files
 - [types.m](Utils/types.m) - static class of enumerated type containing string names of all possible type of joints
 - [symlog.m](Utils/symlog.m) - bi-symmetric logarithmic axes scaling
 - [weightParameters.m](Utils/weightParameters.m) - changes the optimized parameters weight

# Robots
Folder with folders for different robots. Right now, these robots are available: [Nao](Robots/Nao), [Motoman](Robots/Motoman), [iCub](Robots/iCub).
The folders usually includes Datasets for given robot, robot-specific funtions and robot-specific configuration files.  
Mandatory are configs with structure of the robot (see [loadNAO.m](Robots/Nao/loadNAO.m), [loadMotoman.m](Robots/Nao/loadMotoman.m), [loadICUBv1.m](Robots/Nao/loadICUBv1.m))
and function to change dataset to format, which uses the toolbox (see [Datasets](#datasets) and [loadDatasetNao.m](Robots/Nao/loadDatasetNao.m), [loadDatasetMotoman.m](Robots/Motoman/loadDatasetMotoman.m), [loadDatasetICub.m](Robots/iCub/loadDatasetICub.m)).

Voluntary configs are for load of whitelist (see [loadNaoWL.m](Robots/Nao/loadNaoWL.m), [loadMotomanWL.m](Robots/Nao/loadMotomanWL.m), [loadICUBWL.m](Robots/Nao/loadICUBWL.m))
and bounds (see [loadMotomanBounds.m](Robots/Nao/loadMotomanBounds.m)).


# Schema
![Calibration diagram](calibAll.jpg)
![Structure](structure.jpg)
