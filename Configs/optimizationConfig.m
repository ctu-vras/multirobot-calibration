function [options, chains, approach, jointTypes, optim, pert]=optimizationConfig(approaches, inputChains, jointType)
    %% Solver options
    options = optimoptions('lsqnonlin');
    %options.Algorithm = 'trust-region-reflective'; %Use for bounds
    options.Algorithm = 'levenberg-marquardt';
    options.Display = 'iter';
    options.TolFun = 5e-7; %If problem does not converge, set lower values (and vice-versa)
    options.TolX = 1e-12;
    options.MaxIter = 150; %Set higher value if problem does not converge (but too big value can results in overfitting)
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=49999;    
    options.UseParallel=0; % set to use parallel computing on more cores
    %options.SpecifyObjectiveGradient=true
    %options.ScaleProblem='jacobian'; %Set if problem is badly scaled
    
    
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
    % set which approach will be used
    % value is used for scaling
    % see README for details
    approach.eyes=0;
    approach.selftouch=0;
    approach.planes=0;
    approach.external=0;
    if ~isempty(approaches{1})
        for i = 1:length(approaches)
            approach.(approaches{i}) = 1;
        end
    end
    if(approach.eyes)
        approach.selftouch=approach.selftouch*40000;
        approach.planes=approach.planes*40000;
        approach.external=approach.planes*40000;
    end
    
    %% Calibration joint types
    % set which parts of the body will be calibrated
    % superior over chains
    % can be set by an argument into the function
    % depends on each other - 'onlyOffsets' without anything else will do nothing
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
    optim.bounds=0; % set to use bounds
    optim.repetitions=5; % number of training repetitions
    optim.pert=[0,0,0]; % elements correspond to fields in 'pert', vector can have any length depending on fields in 'pert'
    optim.distribution = 'normal'; % or 'uniform'
    optim.pert_levels = 1+sum(optim.pert); % do not change!
    optim.splitPoint=0.7; % training dataset ratio
    optim.refPoints=0; % set to use 'refPoints' field in dataset
    optim.useNorm=0; % set to compute errors as norm of two points
    optim.parametersWeights=[1,1,1,1]; % set to scale parameters - [body lengths, body angles, skin lengths, skin angles]
    optim.boundsFromDefault=1; % set to compute bounds from default values
    
    %% Perturbations   
    pert.mild.DH=[0.01,0.01,0.01,0.1]; %[a,d,alpha,theta]
    
    pert.mild.camera=[0.05,0.05,0.05,0.05]; %camera is optional
    
    pert.fair.DH=[0.03,0.03,0.03,0.3];
    
    pert.fair.camera=[0.03,0.03,0.03,0.03];
    
    pert.stormy.DH=[0.1,0.1,0.1,1];
    
    pert.stormy.camera=[0.1,0.1,0.1,0.1];
end