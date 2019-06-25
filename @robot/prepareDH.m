function prepareDH(r, pert, distribution, optim)
    if ~any(optim.pert)
        for joint=r.joints
           joint{1}.perturbedDH=zeros(optim.repetitions,4);
           if optim.bounds && joint{1}.type~=types.base
              bounds=r.structure.bounds.(sprintf('%s', joint{1}.type));
              joint{1}.lowerBounds=repmat(joint{1}.DH - bounds,optim.repetitions,1); 
              joint{1}.upperBounds=repmat(joint{1}.DH + bounds,optim.repetitions,1); 
           end
        end
    end
end

