function [options, chains, approach, linkTypes, optim, pert]=exampleConfig(approaches, inputChains, linkType)
 %% Solver options
 % other parameters can be found in optimoptions or lsqnonlin documentation
    options = optimoptions('lsqnonlin');
    options.Algorithm = 'levenberg-marquardt';
    %options.Algorithm = 'trust-region-reflective'; %Use for bounds
    options.Display = 'iter';
    options.TolFun = 5e-18; %If problem does not converge, set lower values (and vice-versa)
    options.TolX = 1e-26;
    options.MaxIter = 200; %Set higher value if problem does not converge (but too big value can results in overfitting)
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=49999;    
    options.UseParallel=0; % set to use parallel computing on more cores
    
    %% Chains
    % set which chains will be calibrated
    % superior over whitelist
    % can be set by an argument into the function
    chains.rightArm=0;
    chains.leftArm=0;
    chains.torso=0;
    chains.head=0;
    chains.leftEye=0;
    chains.rightEye=0;
    
    %% Calibration approaches
    % set which approach will be used
    % value is used for scaling
    % see README for details
    approach.projection=0;
    approach.selftouch=0;
    approach.planes=0;
    approach.external=0;

    %% Calibration link types
    % set which parts of the body will be calibrated
    % superior over chains
    % can be set by an argument into the function
    % depends on each other - 'onlyOffsets' without anything else will do nothing
    linkTypes.onlyOffsets=0;
    linkTypes.joint=0;
    linkTypes.eye=0;

    linkTypes.patch=0;
    linkTypes.triangle=0;
    linkTypes.mount=0;
    linkTypes.finger=0;
    
    %% Calibration settings
    optim.bounds=0; % set to use bounds
    optim.repetitions=1; % number of training repetitions
    optim.pert=[0,0,0]; % elements correspond to elemnts in 'pert', vector can have any length depending on number of elements in 'pert'
    optim.distribution = 'uniform'; % or 'normal'
    optim.units = 'm'; % 'm' or 'mm' 
    optim.splitPoint=1; % training dataset ratio
    optim.refPoints=0; % set to use 'refPoints' field in dataset
    optim.useNorm=0; % set to compute errors as norm of two points
    optim.parametersWeights.body=[1,1]; % set to scale parameters - [body lengths, body angles]
    optim.parametersWeights.skin=[1,1]; % set to scale parameters - [skin lengths, skin angles]
    optim.parametersWeights.external=[1,1]; % set to scale parameters - [rotation, translation]
    optim.parametersWeights.planes=1; % set to scale parameters
    optim.boundsFromDefault=1; % set to compute bounds from default values
    optim.optimizeInitialGuess=1; % set to include plane or external transformation parameters into optimized parameters
    optim.rotationType = 'vector';   % how the external calib works with rotation (quat - quaternion; vector - rotation vector)
    optim.skipNoPert = 0; % skip calibration without perturbation
    optim.optimizeDifferences = 0; % calibration with the differences from the start values   
    optim.usePxCoef = 0; % enables comparison of projection and touch errors by converting pixels to m or mm
    %% Perturbations   
    %each element can have 4 or 6 elements, depending on your robot and the
    %order is a,d,alpha,theta or x,y,z,alpha,beta,gamma
    pert = {[0.01,0.01,0.01,0.01,0.01,0.01], [0.03,0.03,0.03,0.03,0.03,0.03], [0.05,0.1,0.5,0.1,]};
end