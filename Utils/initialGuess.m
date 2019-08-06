function params = initialGuess(rob, datasets, dh_pars, approaches)

    names.planes='plane';
    names.external='ext';
    params=[];
    for i={'planes','external'}
        if approaches.(i{1})
            for dataset=datasets.(names.(i{1}))
                dataset=dataset{1};
                robPoints=getPoints(dh_pars, dataset, rob.structure.H0, false);
                if strcmp(i,'planes')
                    newParams = getPlane(robPoints);
                else
                    extPoints=dataset.refPoints;
                    [R,T]=fitSets(extPoints,robPoints(1:3,:)');
                    newParams=[rotationMatrixToVector(R),T'];
                end
                params=[params, newParams];
            end
        end
    end

end

