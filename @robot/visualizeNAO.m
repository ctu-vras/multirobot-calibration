function visualizeNAO(robot,type,name)
    if nargin==2
        name='';
    end
    if strcmp(type,'statistics')
        statistics(robot,name); 
    elseif strcmp(type,'distances')
        getGraphs(robot,name);
    elseif strcmp(type,'activations')
        getActivations(robot,name);
    end
end