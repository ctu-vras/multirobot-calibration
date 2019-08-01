function options= weightParameters(whitelist, options, paramsLength, optim)
%WEIGHTPARAMETERS Change the optimized parameters weight
%   Change the optimized parameters weight for the calibration
%INPUT - whitelist - whitelist structure
%      - options - lsqnonlin settings
%      - paramsLength - number of optimized parameters 
%      - optim - number of poses in poses set
%OUTPUT - options - lsqnonlin settings with updated TypicalX (weights)
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
            % parametersWeights is (1,4) vector - (lengths, angles, skinLengths, skinAngles)
            for i=1:size(params,1)
               if params(i)==1 || params(i)==2 % params(i) is a or d
                    id=1;
               else % params(i) is alpha or offset
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
end

