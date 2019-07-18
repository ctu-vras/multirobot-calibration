function [options, chains, approach, jointTypes, optim, pert]=optimizationConfig
    %% Solver options
    options = optimoptions('lsqnonlin');
    %options.Algorithm = 'trust-region-reflective';
    options.Algorithm = 'levenberg-marquardt';
    options.Display = 'iter';
    options.TolFun = 5e-7;
    options.TolX = 1e-12;
    options.MaxIter = 150;
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=49999;    
    options.UseParallel=0;
    %options.SpecifyObjectiveGradient=true
    %options.ScaleProblem='jacobian';
    
    
    %% Chains
    chains.rightArm=1;
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
    approach.eyes=0;%1;
    approach.selftouch=0;
    approach.planes=0;%40000;
    approach.external=1;%40000;
    
    %% Calibration joint types
    jointTypes.onlyOffsets=0;
    jointTypes.joint=1;
    jointTypes.eye=0;
    jointTypes.torso=0;
    jointTypes.patch=0;
    jointTypes.triangle=0;
    jointTypes.mount=0;
    jointTypes.finger=0;
    
    %% Calibration settings
    optim.bounds=0;
    optim.repetitions=1;
    optim.pert=[0,0,0];
    optim.distribution = 'normal';
    optim.pert_levels = 1+sum(optim.pert);
    optim.splitPoint=0.7;
    optim.refPoints=0;
    optim.useNorm=1;
    
    %% Perturbations   
    pert.mild.DH=[0.01,0.01,0.01,0.1];
    
    pert.mild.camera=[0.05,0.05,0.05,0.05];
    
    pert.fair.DH=[0.03,0.03,0.03,0.3];
    
    pert.fair.camera=[0.03,0.03,0.03,0.03];
    
    pert.stormy.DH=[0.1,0.1,0.1,1];
    
    pert.stormy.camera=[0.1,0.1,0.1,0.1];
end