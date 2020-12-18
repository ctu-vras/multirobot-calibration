function [options, chains, approach, linkTypes, optim, pert] = loadConfig(config, approaches, inputChains, linkType)
    %LOADCONFIG Loading Config file function
    %INPUT - config - Config function name
    %       - inputChains - chains to calibrate
    %       - approaches - calibration approaches
    %       - linkType -link types to calibrate
    %OUTPUT - options - lsqnonlin solver options
    %       - chains - chains to calibrate
    %       - approach - calibration approaches
    %       - linkTypes -link types to calibrate
    %       - optim - calibration settings
    %       - pert - perturbation levels
    
    
    % Copyright (C) 2019-2021  Jakub Rozlivek and Lukas Rustler
    % Department of Cybernetics, Faculty of Electrical Engineering, 
    % Czech Technical University in Prague
    %
    % This file is part of Multisensorial robot calibration toolbox (MRC).
    % 
    % MRC is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Lesser General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % MRC is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Lesser General Public License for more details.
    % 
    % You should have received a copy of the GNU Leser General Public License
    % along with MRC.  If not, see <http://www.gnu.org/licenses/>.
    
    
    if ischar(config) || isstring(config)
        func=str2func(config);
        if nargin>1
            [options, chains, approach, linkTypes, userOptim, pert]=func(approaches, inputChains, linkType);
        else
            [options, chains, approach, linkTypes, userOptim, pert]=func();
        end
    else
        options = config.options;
        chains = config.chains;
        approach = config.approach;
        linkTypes = config.linkTypes;
        userOptim = config.optim;
        pert = config.pert;
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
    
    if ~isempty(linkType{1})
        for i = 1:length(linkType)
            if (linkTypes.(linkType{i}) == 0)
                linkTypes.(linkType{i}) = 1;
            end
        end
    end
    
    chains_ = struct2cell(chains);
    linkTypes_ = struct2cell(linkTypes);
    assert(sum([chains_{:}]) && sum([linkTypes_{:}]), 'Nothing to calibrate chains or linkTypes do not contain fields with non-zero value')
    assert(all(ismember(fieldnames(approach), {'selftouch', 'planes', 'external', 'projection'})), 'Invalid approach used');
    assert(all(cellfun(@(x) isprop(types, x) | strcmp(x,'onlyOffsets'), fieldnames(linkTypes))), 'Invalid linkTypes, use only types from class types and/or ''onlyOffsets'' option');
    
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

