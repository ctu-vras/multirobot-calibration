function options= weightRobotParameters(whitelist, options, paramsLength, optim)
%WEIGHTPARAMETERS Change the optimized parameters weight
%   Change the optimized parameters weight for the calibration
%INPUT - whitelist - whitelist structure
%      - options - lsqnonlin settings
%      - paramsLength - number of optimized parameters 
%      - optim - structure of calibration settings
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
            % parametersWeights is structure -.body (lengths, angles); .skin (skinLengths, skinAngles);
            for i=1:size(params,1)
                if skin
                    options.TypicalX(paramNumber)=options.TypicalX(paramNumber)*optim.parametersWeights.skin(1+(params(i)>2)); % if params(i) is 3 or 4 -> index is 2, else index is 1
                else
                    options.TypicalX(paramNumber)=options.TypicalX(paramNumber)*optim.parametersWeights.body(1+(params(i)>2)); % if params(i) is 3 or 4 -> index is 2, else index is 1
                end
                paramNumber=paramNumber+1;
            end
        end
    end
end

