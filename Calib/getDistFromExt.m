function [dist] = getDistFromExt(dh_pars, robot, datasets, optim)
    dist = [];
    H0 = robot.structure.H0;
    for dataset=datasets 
        dataset = dataset{1};
        extPoints=dataset.refPoints;
        robPoints = getPoints(dh_pars, dataset, H0, false);
        [R,T]=fitSets(extPoints,robPoints(1:3,:)'); 
        extPoints = R*extPoints' + T;
        if optim.useNorm
            distances = sqrt(sum((robPoints(1:3,:)-extPoints(1:3,:)).^2,1));
        else
            distances = robPoints(1:3,:)-extPoints(1:3,:);
        end     
        dist = [dist, distances];
    end
end
