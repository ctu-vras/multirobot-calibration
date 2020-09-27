function [options, chains, approach, jointTypes, optim, pert] = loadConfig(funcname, approaches, inputChains, jointType)
%LOADCONFIG Loading Config file function
%INPUT - funcname - Config function name
%       - inputChains - chains to calibrate
%       - approaches - calibration approaches
%       - jointType -joint types to calibrate
%OUTPUT - options - lsqnonlin solver options
%       - chains - chains to calibrate
%       - approach - calibration approaches
%       - jointTypes -joint types to calibrate
%       - optim - calibration settings
%       - pert - perturbation levels

    func=str2func(funcname);
    if nargin>1
        [options, chains, approach, jointTypes, userOptim, pert]=func(approaches, inputChains, jointType);
    else
        [options, chains, approach, jointTypes, userOptim, pert]=func();
    end
    
    if ~isempty(inputChains{1})
        for i = 1:length(inputChains)
            if (chains.(inputChains{i}) == 0)
                chains.(inputChains{i}) = 1;
            end
        end
    end
    
    if ~isempty(approaches{1})
        for i = 1:length(approaches)
            if (approach.(approaches{i}) == 0)
                approach.(approaches{i}) = 1;
            end
        end
    end
    
    if ~isempty(jointType{1})
        for i = 1:length(jointType)
            if (jointTypes.(jointType{i}) == 0)
                jointTypes.(jointType{i}) = 1;
            end
        end
    end
    
    chains_ = struct2cell(chains);
    jointTypes_ = struct2cell(jointTypes);
    assert(sum([chains_{:}]) && sum([jointTypes_{:}]), 'Nothing to calibrate chains or jointTypes do not contain fields with non-zero value')
    assert(all(ismember(fieldnames(approach), {'selftouch', 'planes', 'external', 'projection'})), 'Invalid approach used');
    assert(all(cellfun(@(x) isprop(types, x) | strcmp(x,'onlyOffsets'), fieldnames(jointTypes))), 'Invalid jointTypes, use only types from class types and/or ''onlyOffsets'' option');
    
    weightFields = {'body', 'skin', 'external', 'planes'};
    p = inputParser;
    addParameter(p,'bounds',0, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p,'repetitions',1, @(x) isnumeric(x) && isscalar(x) && mod(x, 1) == 0 && (x > 0));
    addParameter(p, 'pert', [0,0,0], @(x) isnumeric(x) && all(ismember(x,[0,1])));
    addParameter(p,'units','mm', @(x) any(validatestring(x,{'m','mm'})));
    addParameter(p,'splitPoint',0.7, @(x) isnumeric(x) && x > 0 && x <= 1);
    addParameter(p,'refPoints',0, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p, 'useNorm', 1, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p, 'parametersWeights', struct('body', [1,1], 'skin', [1,1], 'external', [1,1], 'planes', 1), ...
        @(x) isstruct(x) && all(ismember(fieldnames(x), weightFields))  ...
        && all(structfun(@(y) all(isnumeric(y)) & all(y >= 0) & (length(y) >= 1) & (length(y) <= 2), x)));
    addParameter(p, 'skipNoPert', 0, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p, 'optimizeDifferences', 0, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p, 'usePxCoef', 0, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p, 'distribution', 'uniform', @(x) any(validatestring(x,{'uniform','normal'})));
    addParameter(p,'boundsFromDefault',1, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p,'optimizeInitialGuess',1, @(x) isnumeric(x) && isscalar(x) && ismember(x,[0,1]));
    addParameter(p, 'rotationType', 'vector', @(x) any(validatestring(x,{'vector','quat'})));
    
    params = {};
    optimDefaultFields = {'bounds','repetitions','pert','units','splitPoint','refPoints', 'useNorm','parametersWeights',...
        'skipNoPert','optimizeDifferences', 'usePxCoef', 'rotationType', 'distribution', 'boundsFromDefault', 'optimizeInitialGuess'};
    for index = 1:length(optimDefaultFields)
       if(isfield(userOptim, optimDefaultFields{index}))
           params{end+1} = optimDefaultFields{index};
           params{end+1} = userOptim.(optimDefaultFields{index});
       end
    end
    
    parse(p,params{:});
    optim = p.Results;
    for f = {'body','skin'}
        f = f{1};
        if(isfield(optim.parametersWeights, f) && length(optim.parametersWeights.body) < 2)
            optim.parametersWeights.(f) = [optim.parametersWeights.(f),optim.parametersWeights.(f)];
        end
    end
    if(approach.planes && optim.optimizeInitialGuess)
        optim.planeParams = 3; % how many plane parameters should be optimized
        if(isfield(optim.parametersWeights, 'planes'))
            optim.parametersWeights.planes = optim.parametersWeights.planes(1);
        else
            optim.parametersWeights.planes=1; % set to scale parameters - plane parameters
        end
    end
    if(approach.external && optim.optimizeInitialGuess)
        if(strcmp(optim.rotationType, 'quat')) % quaternion
            optim.externalParams = 7; % how many plane parameters should be optimized
        else % rotation vector
            optim.externalParams = 6; % how many plane parameters should be optimized
        end
        if(isfield(optim.parametersWeights, 'external'))
            if(length(optim.parametersWeights.external) < 2)
                optim.parametersWeights.external = [optim.parametersWeights.external,optim.parametersWeights.external];
            end
        else
            optim.parametersWeights.external=[1,1]; % set to scale parameters - external transformation parameters   
        end
    end
    
    if(strcmp(optim.units,'mm'))
        optim.unitsCoef = 1000;
    else
        optim.unitsCoef = 1;
    end
    
    optim.pert_levels = 1+sum(optim.pert);    
end

