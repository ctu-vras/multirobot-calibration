# Contents
 - [How to run](#how-to-run)
 - [Robot](#Robot)
 - [Joint](#Joint)
 - [Datasets](#Datasets)
 - [Confings](#Configs)
 - [Robots](#Robots)
 - [Calib](#Calib)
 - [Utils](#Utils)
 - [Visualization](#Visualization)
 - [Schema](#schema)

# Robot
Found in the [@Robot](#@Robot) folder. This directory includes the main class file for the robots [Robot.m](#@Robot/Robot.m).
This file includes the constructor, which calls robot-specific functions (see [Robots](#Robots)) to set up the robot.
## Properties
    - _name_ - String name of the robot 
    - _joints_ - Cell array of [Joint](#Joint) classes
    - _structure_ - Structure containing DH, WL and bounds
## Methods
 - findJoint - Returns instance of joints with given name
 - findJointById - Returns instance of joints with given Id
 - findJointByType - Returns instance of joints with given type
 - findJointByGroup - Returns instance of joints with given group
 - print - Displays Robot.joints as 'jointName jointId'
 - [printTables](#@Robot/printTables) - Displays tables from Robot.structure as 'a, d, alpha, theta jointName'
 - [showModel](#@Robot/showModel.m) - Shows virtual model of the robot based on input joint angles.
 - [showGraphModel](#@Robot/showGraphModel.m) - Shows tree-based graph of given robot
 - [prepareDH](#@Robot/prepareDH.m) - Returns DH tables with/without perturbations and tables with bounds
 - [prepareDataset](#@Robot/prepareDataset.m) - Returns datasets in universal format, together with training/testing indexes
 - [getResultDH](#@Robot/getResultedDH.m) - Returns final DH parameters and correction of each run
 - [createWhitelist](#@Robot/createWhitelist.m) - Selects whitelist and returns selected parameters based on the whitelist, together with lower/upper bounds for the parameters.

# Joint
Found in the [@Joint](#@Joint) folder. This directory includes the main class file for the joints [Joint.m](#@Joint/Joint.m).
## Properties
 - name - String name of the joints
 - parent - Pointer to parent
 - parentId - Int id of parent
 - DHindex - Int id in DH/WL/Bounds table for given 'group'
 - type - 'type' of the joints...see [types.m](#Utils/types.m)
 - endEffector - true/false if joint is endEffector
 - group - 'group' of the joint...see [group.m](#Utils/group.m)
## Methods
 - computeRTMatrix - iterates over the parents of the input Joint and returns RT matrix

# Configs
 - [optimizationConfig.m](#Configs/optimizationConfig.m) - settings for the calibration

# Calib
Folder with functions designed for calibration
## Files
 - [errors_fcn.m](#Calib/errors_fcn.m) - returns vector of vector of errors for all types of calibration
 - [getDist.m](#Calib/getDist.m) - returns errors from selftouch configurations
 - [getDistFromExt.m](#Calib/getDistFromExt.m) - returns errors from configurations with external camera
 - [getPlaneDist.m](#Calib/getPlaneDist.m) - returns errors from selftouch configurations
 - [getProjectionDist.m](#Calib/getProjectionDist.m) - returns errors from projections

# Visualization
Folder with functions designed for visualization of the results
## Files
 - [plotCorrections.m](#Visualisation/plotCorrections.m) - shows two plots for each 'group'. One with length (a,d) and one with angles (alpha, theta) of corrections from given folder
 - [plotErrorBars.m](#Visualisation/plotErrorBars.m) - plots rms errors bars
 - [plotErrorResidual.m](#Visualisation/plotErrorResidual.m) - plots error residuals
 - [plotErrorsBoxplots.m](#Visualisation/plotErrorsBoxplots.m) - shows boxplots with RMS errors from given folders
 - [plotJacobian.m](#Visualisation/plotJacobian.m) - plots jacobians
 - [plotJointDistribution.m](#Visualisation/plotJointDistribution.m) - plots joint distribution
 - [plotProjections.m](#Visualisation/plotProjections.m) - plots projections
 - [visualizeActivatedTaxels.m](#Visualisation/visualizeActivatedTaxels.m) - shows activated taxels on all chains and number of actiated taxels/triangles for given datasets
 - [activationsView.m](#Visualisation/activationsView.m) - shows moving model of the robot with option to show statistics and skin. Shows one fig for each dataset
 - [getTaxelsDistances.m](#Visualisation/getTaxelDistances.m) - shows distribution of distances between taxels/triangles

# Utils
Folder with functions designed for repetitive tasks.
## Files
 - [computeObservability.m](#Utils/computeObservability.m) - computes different observability parameters
 - [dhpars2tfmat.m](#Utils/dhpars2tfmat.m) - computes a transformation given by Denavit-Hartenberg parameters
 - [ezwraptopi.m](#Utils/ezwraptopi.m) - easily wrap a vector or matrix of angles to [-pi; pi]
 - [fitSets.m](#Utils/fitSets.m) - finds tranformation between two sets of points
 - [getDatasetPart.m](#Utils/getDatasetPart.m) - slices a dataset depends on the given pose numbers
 - [getPlane.m](#Utils/getPlane.m) - computes a plane fitted to set of given points using svd
 - [getPoints.](#Utils/getPoints.m) - computes a plane fitted to set of given points using svd
 - [getTF.m](#Utils/getTF.m) - computes transformation from given joint to base 
 - [group.m](#Utils/group.m) - static class of enumerated type containing string names of all part of robot body and skin
 - [inversetf.m](#Utils/inversetf.m) - invers transformation matrix
 - [loadConfig.m](#Utils/loadConfig.m) - loads Config file function
 - [loadDHfromMat.m](#Utils/loadDHfromMat.m) - loads robot DH from mat file
 - [loadDHfromTxt.m](#Utils/loadDHfromTxt.m) - loads robot DH from a text file
 - [loadTaskFromFile.m](#Utils/loadTasksFromFile.m) - loads the calibration task from csv file
 - [projections.m](#Utils/projections.m) - projects points to the cameras
 - [rmsErrors.m](#Utils/rmsErrors.m) - computes rms errors
 - [saveResults.m](#Utils/saveResults.m) - saves results to mat files
 - [types.m](#Utils/types.m) - static class of enumerated type containing string names of all possible type of joints
 - [symlog.m](#Utils/symlog.m) - bi-symmetric logarithmic axes scaling
 - [weightParameters.m](#Utils/weightParameters.m) - changes the optimized parameters weight

# Robots
Folder with folders for different robots. Right now, these are available: [Nao](#Robots/Nao), [Motoman](#Robots/Motoman), [iCub](#Robots/iCub).
The folders usually includes Datasets for given robot, robot-specific funtions and robot-specific configuration files.
Mandatory are configs with structure of the robot (see [loadNAO.m](#Robots/Nao/loadNAO.m), [loadMotoman.m](#Robots/Nao/loadMotoman.m), [loadICUBv1.m](#Robots/Nao/loadICUBv1.m))
and function to change dataset to format, which uses the toolbox (see [Datasets](#Datasets) and [loadDatasetNao.m](#loadDatasetNao.m), [loadDatasetMotoman.m](#loadDatasetMotoman.m), [loadDatasetICub.m](#loadDatasetICub.m)).

# Schema
![Calibration diagram](calibAll.jpg)
![Structure](structure.jpg)
