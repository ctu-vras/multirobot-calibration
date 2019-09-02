function [options, chains, approach, jointTypes, optim, pert]=motomanOptConfig(approaches, inputChains, jointType)
    %% Solver options
    options = optimoptions('lsqnonlin');
    options.Algorithm = 'trust-region-reflective';
    options.Algorithm = 'levenberg-marquardt';
    options.Display = 'iter';
    options.TolFun =  5e-15;
    options.TolX = 1e-25;
    options.MaxIter = 200;
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=49999;    
    options.UseParallel=0;
    %options.SpecifyObjectiveGradient=true
%     options.ScaleProblem='jacobian';
    
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
    
    if ~isempty(inputChains{1})
        for i = 1:length(inputChains)
            chains.(inputChains{i}) = 1;
        end
    end
    
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
        approach.external=approach.planes*10;
    end
    
    %% Calibration joint types
    jointTypes.onlyOffsets=0;
    jointTypes.joint=0;
    jointTypes.eye=0;
    jointTypes.torso=0;
    jointTypes.patch=0;
    jointTypes.triangle=0;
    jointTypes.mount=0;
    jointTypes.finger=0;
    
    if ~isempty(jointType{1})
        for i = 1:length(jointType)
            jointTypes.(jointType{i}) = 1;
        end
    end
    
    %% Calibration settings
    optim.bounds=0;
    optim.repetitions=50;
    optim.pert=[0,0,1];
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
    optim.skipNoPert = 1;
    optim.optimizeDifferences = 0;
    optim.usePxCoef = 1;
    %% Perturbations   
    pert.mild.DH=[0.01,0.01,0.01,0.1];
    
    pert.mild.camera=[0.05,0.05,0.05,0.05];
    
    pert.fair.DH=[0.03,0.03,0.03,0.3];
    
    pert.fair.camera=[0.03,0.03,0.03,0.03];
    
    pert.stormy.DH=[0.1,0.1,0.1,1];
    
    pert.stormy.camera=[0.1,0.1,0.1,0.1];
end