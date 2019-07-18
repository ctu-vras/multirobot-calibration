function options= weightParameters(whitelist, options, paramsLength, optim)
%WEIGHTPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    options.TypicalX=ones(1,paramsLength);
    paramNumber=1;
    fnames=fieldnames(whitelist);
    for name=1:length(fnames)
        if any(any(whitelist.(fnames{name})))
            if strfind(fnames{name},'Skin')
                skin=1;
            else
                skin=0;
            end
            idx=find(whitelist.(fnames{name})')-1;
            params=mod(idx,4)+1;  
            for i=1:size(params,1)
               if params(i)==1 || params(i)==2
                    id=1;
               else
                    id=2;
               end
               if skin
                   id=id+2;
               end
               options.TypicalX(paramNumber)=options.TypicalX(paramNumber)*optim.parametersWeights(id);
               paramNumber=paramNumber+1;
            end
        end
end

