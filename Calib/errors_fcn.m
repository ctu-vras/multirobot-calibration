function [ error_vec ] = errors_fcn( opt_pars, dh_pars, robot, whitelist, dataset, optim, approach, paramValues)
    %ERRORS_FCN returns vector of vector of errors for all types of calibration
    %   INPUT - opt_pars - 1xN vector of optimized parameters
    %         - dh_pars - structure with kinematics parameters, where field names corresponding to names of
    %                     the 'groups' in robot. Each group is matrix.
    %         - robot - instance of @Robot class
    %         - whitelist - structure with 1/0, where field names corresponding to names of
    %                       the 'groups' in robot. Each group is matrix.
    %         - dataset - structure of dataset, where field names are {selftouch,
    %                     planes, external, projection} and and each field is 1xN cellArray
    %         - optim - structure of calibration settings
    %         - approach - structure of settings for each calibration approach
    %         - paramValues - 1xn array used for planes, external calibration,
    %                       - Default: []
    %   OUTPUT - error_vec - MxN array of distance;
    %                        M=1 if optim.useNorm, M=3 if ~optim.useNorm;
    %                        N is number of errors from all types of calib
    
    
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

    % Create matrices
    distances = [];
    plane_distances = [];
    dist_from_ext = [];
    proj_dist = [];
    usePxCoeffs = 0;
    refDist = 0;
    planeParams=[];
    extParams=[];
    % Add optimized parameters from solver back to dh_pars
    fnames = fieldnames(whitelist);
    count = 1;
    for field=1:length(fnames)
        % find indexes of params
        new_count = count + sum(sum(whitelist.(fnames{field})));
        a=dh_pars.(fnames{field})';
        % append pars to their place
        a(whitelist.(fnames{field})') = opt_pars(count:new_count-1)' + optim.optimizeDifferences * a(whitelist.(fnames{field})');
        % append back to dh_pars
        dh_pars.(fnames{field})=a';
        count = new_count;
    end
    if (count-1)~=length(opt_pars)
        index = 0;
        if approach.planes
            index = length(dataset.planes)*optim.planeParams-1;
            if(optim.optimizeDifferences)
                planeParams=opt_pars(count:index+count) + paramValues(1:index+1);
            else
                planeParams=opt_pars(count:index+count);
            end
            count=count+index+1;
        end
        if approach.external
            if(optim.optimizeDifferences)
                extParams=opt_pars(count:count+length(dataset.external)*optim.externalParams-1) + paramValues(index+1:end); 
            else
                extParams=opt_pars(count:count+length(dataset.external)*optim.externalParams-1);
            end
        end
    end
    %% Call appropriate functions if given approach is enabled
    if(approach.selftouch)
        distances = getDist(dh_pars, robot, dataset.selftouch, optim);
        refDist = dataset.selftouch{end}.refDist;
        usePxCoeffs = 1;
    end
    if(approach.planes)
        plane_distances = getPlaneDist(dh_pars, robot, dataset.planes, planeParams);
        usePxCoeffs = 1;
    end
    if(approach.external)
        dist_from_ext = getDistFromExt(dh_pars, robot, dataset.external, optim, extParams);
        usePxCoeffs = 1;
    end
    if(approach.projection)
        [proj_dist,coeffs] = getProjectionDist(dh_pars, robot, dataset.projection);
        if(optim.usePxCoef && usePxCoeffs)
            proj_dist = proj_dist .* coeffs;
        end
    end
    % concat all results into output variable, with right scalling
    error_vec = [reshape((distances - refDist)*approach.selftouch, 1, []), ...
        reshape(plane_distances*approach.planes, 1, []), reshape(dist_from_ext*approach.external, 1, []), ...
        reshape(proj_dist*approach.projection, 1, [])];
end

