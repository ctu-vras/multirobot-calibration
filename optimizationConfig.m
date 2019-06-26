function [options, chains, optim, pert]=optimizationConfig
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

    %% Calibration principle
    optim.type.eyes=0;
    optim.type.selftouch=0;
    optim.type.planes=0;
    optim.type.external=0;
    optim.onlyOffsets=0;
    optim.skin=0;
    optim.bounds=0;
    optim.repetitions=10;
    optim.pert=[0,0,0];
    %% Perturbations   
    pert.mild.DH=[0.01,0.01,0.01,0.1];
    
    pert.mild.camera=[0.05,0.05,0.05,0.05];
    
    pert.fair.DH=[0.03,0.03,0.03,0.3];
    
    pert.fair.camera=[0.03,0.03,0.03,0.03];
    
    pert.stormy.DH=[0.1,0.1,0.1,1];
    
    pert.stormy.camera=[0.1,0.1,0.1,0.1];
end