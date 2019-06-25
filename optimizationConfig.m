function [options, chains, repetitions, optim, pert]=optimizationConfig
    %% Solver options
    options = optimoptions('lsqnonlin');
    %options.Algorithm = 'trust-region-reflective';
    options.Algorithm = 'levenberg-marquardt';
    options.Display = 'iter';
    options.TolFun = 1e-10;
    options.TolX = 1e-16;
    options.MaxIter = 100;
    options.InitDamping = 1000;
    options.MaxFunctionEvaluations=999;    
    
    %% Chains combinations
    chains.lare=0;
    chains.lale=0;
    chains.rale=0;
    chains.rare=0;
    chains.lator=0;
    chains.rator=0;
    chains.lahead=0;
    chains.rahead=0;
    
    %% Repetitions
    repetitions=10;
    
    %% Calibration principle
    optim.type.eyes=0;
    optim.type.selftouch=0;
    optim.type.planes=0;
    optim.type.external=0;
    optim.onlyOffsets=0;
    optim.skin=0;
    
    %% Perturbations
    pert.mild.a=0.01;
    pert.mild.d=0.01;
    pert.mild.alpha=0.01;
    pert.mild.theta=0.1;
    
    pert.mild.camera.a=0.05;
    pert.mild.camera.d=0.05;
    pert.mild.camera.alpha=0.05;
    pert.mild.camera.theta=0.05;
    
    pert.fair.a=0.03;
    pert.fair.d=0.03;
    pert.fair.alpha=0.03;
    pert.fair.theta=0.3;
    
    pert.fair.camera.a=0.03;
    pert.fair.camera.d=0.03;
    pert.fair.camera.alpha=0.03;
    pert.fair.camera.theta=0.03;
    
    pert.stormy.a=0.1;
    pert.stormy.d=0.1;
    pert.stormy.alpha=0.1;
    pert.stormy.theta=1;
    
    pert.stormy.camera.a=0.1;
    pert.stormy.camera.d=0.1;
    pert.stormy.camera.alpha=0.1;
    pert.stormy.camera.theta=0.1;
end