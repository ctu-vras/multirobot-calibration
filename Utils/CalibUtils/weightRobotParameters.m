function options= weightRobotParameters(whitelist, options, paramsLength, optim)
    %WEIGHTPARAMETERS Change the optimized parameters weight
    %   Change the optimized parameters weight for the calibration
    %INPUT - whitelist - whitelist structure
    %      - options - lsqnonlin settings
    %      - paramsLength - number of optimized parameters 
    %      - optim - structure of calibration settings
    %OUTPUT - options - lsqnonlin settings with updated TypicalX (weights)
    
    
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
            params=mod(idx,6)+1;  
            % parametersWeights is structure -.body (lengths, angles); .skin (skinLengths, skinAngles);
            for i=1:size(params,1)
                if skin
                    options.TypicalX(paramNumber)=options.TypicalX(paramNumber)*optim.parametersWeights.skin(1+(params(i)>3)); % if params(i) is 3 or 4 -> index is 2, else index is 1
                else
                    options.TypicalX(paramNumber)=options.TypicalX(paramNumber)*optim.parametersWeights.body(1+(params(i)>3)); % if params(i) is 3 or 4 -> index is 2, else index is 1
                end
                paramNumber=paramNumber+1;
            end
        end
    end
end

