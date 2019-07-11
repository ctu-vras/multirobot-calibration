function [options, chains, optim, pert]=optimizationConfig
    %% Solver options
    options = optimoptions('lsqnonlin');
    options.Algorithm = 'trust-region-reflective';
    %options.Algorithm = 'levenberg-marquardt';
    options.Display = 'iter-detailed';
    options.TolFun = 1e-10;
    options.TolX = 1e-12;
    options.MaxIter = 300;
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=4999;    
    options.UseParallel=1;
    options.ScaleProblem='jacobian';
    
    
    %% Chains
    chains.rightArm=1;
    chains.leftArm=0;
    chains.torso=0;
    chains.head=0;
    chains.leftEye=0;
    chains.rightEye=0;
    optim.chains=chains;
    
    %% Calibration principle
    optim.type.eyes=0;%1;
    optim.type.selftouch=1;
    optim.type.planes=0;%40000;
    optim.type.external=0;%40000;
    optim.onlyOffsets=0;
    optim.jointTypes.joint=0;
    optim.jointTypes.eye=0;
    optim.jointTypes.torso=0;
    optim.jointTypes.patch=0;
    optim.jointTypes.triangle=0;
    optim.jointTypes.mount=1;
    optim.jointTypes.finger=0;
    optim.bounds=1;
    optim.repetitions=2;
    optim.pert=[0,0,0];
    optim.multi_pose = 1;
    optim.distribution = 'uniform';
    optim.pert_levels = 1+sum(optim.pert);
    optim.splitPoint=0.7;
    
    %% Perturbations   
    pert.mild.DH=[0.01,0.01,0.01,0.1];
    
    pert.mild.camera=[0.05,0.05,0.05,0.05];
    
    pert.fair.DH=[0.03,0.03,0.03,0.3];
    
    pert.fair.camera=[0.03,0.03,0.03,0.03];
    
    pert.stormy.DH=[0.1,0.1,0.1,1];
    
    pert.stormy.camera=[0.1,0.1,0.1,0.1];
end