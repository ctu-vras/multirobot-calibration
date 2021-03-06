function [options, chains, approach, linkTypes, optim, pert]=motomanOptConfig(approaches, ~, ~)
    %% Solver options
    options = optimoptions('lsqnonlin');
    options.Algorithm = 'trust-region-reflective';
    options.Algorithm = 'levenberg-marquardt';
    options.Display = 'iter';
    options.TolFun =  5e-15;
    options.TolX = 1e-25;
    options.MaxIter = 20;
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=49999;    
    options.UseParallel=false;
    %options.SpecifyObjectiveGradient=true
    %options.ScaleProblem='jacobian';
    
    %% Chains
    chains.rightArm=0;
    chains.leftArm=0;
    chains.torso=0;
    chains.head=0;
    chains.leftEye=0;
    chains.rightEye=0;
    chains.leftLeg=0;
    chains.rightLeg=0;
    chains.leftIndex=0;
    chains.rightIndex=0;
    chains.leftThumb=0;
    chains.rightThumb=0;
    chains.leftMiddle=0;
    chains.rightMiddle=0;
    
    %% Calibration approaches
    approach.projection=0;
    approach.selftouch=0;
    approach.planes=0;
    approach.external=0;
    if ~isempty(approaches{1})
        for i = 1:length(approaches)
            approach.(approaches{i}) = 1;
        end
    end
    if(approach.projection)
        approach.selftouch=approach.selftouch*20;
        approach.planes=approach.planes*10;
        approach.external=approach.external*10;
    end
    
    %% Calibration link types
    linkTypes.onlyOffsets=0;
    linkTypes.joint=0;
    linkTypes.eye=0;
    linkTypes.patch=0;
    linkTypes.triangle=0;
    linkTypes.mount=0;
    linkTypes.finger=0;
    linkTypes.taxel=0;
    
    %% Calibration settings
    optim.bounds=0;
    optim.repetitions=1;
    optim.pert=[0,0,0];
    optim.distribution = 'uniform';
    optim.units = 'm';
    optim.splitPoint=0.7;
    optim.refPoints=0;
    optim.useNorm=1;
    optim.parametersWeights.body=[1,1]; % set to scale parameters - [body lengths, body angles]
    optim.parametersWeights.skin=[1,1]; % set to scale parameters - [skin lengths, skin angles]
    optim.parametersWeights.external=[1,1]; % set to scale parameters - [rotation, translation]
    optim.parametersWeights.planes=1; % set to scale parameters
    optim.boundsFromDefault=0; % set to compute bounds from default values
    optim.optimizeInitialGuess=0; % set to include plane or external transformation parameters into optimized parameters
    optim.rotationType = 'vector'; % how the external calib works with rotation (quat - quaternion; vector - rotation vector)
    optim.skipNoPert = 0;
    optim.optimizeDifferences = 0;
    optim.usePxCoef = 1;
    %% Perturbations   
    pert = {[0.01,0.01,0.01,0.01,0.01,0.01], [0.03,0.03,0.03,0.03,0.03,0.03], [0.05,0.1,0.5,0.1,]};
end