function [params, typicalX] = initialGuess(rob, datasets, dh_pars, approaches, optim)

    names.planes='plane';
    names.external='ext';
    params=[];
    typicalX = [];
    for i = {'planes','external'}
        if approaches.(i{1})
            for dataset = datasets.(names.(i{1}))
                dataset = dataset{1};
                robPoints = getPoints(dh_pars, dataset, rob.structure.H0, false);
                if strcmp(i,'planes')
                    newParams = getPlane(robPoints);
                else
                    extPoints = dataset.refPoints;
                    [R,T] = fitSets(extPoints,robPoints(1:3,:)');
                    if(optim.externalParams == 6)
                        newParams = [rotMatrix2rotVector(R)',T'];
                    else
                        newParams = [matrix2quat(R),T'];
                    end
                end
                typicalX = [typicalX,optim.parametersWeights.(i{1})];
                params = [params, newParams];
            end
        end
    end

end

