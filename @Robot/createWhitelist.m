function [ opt_pars, min_pars, max_pars, whitelist, dh_pars] = createWhitelist( robot, dh_pars, lb_pars, ub_pars, optim, chains, linkTypes,  funcname )
%CREATEWHITELIST selects whitelist and returns selected parameters based 
%                on the whitelist, together with lower/upper bounds for the
%                parameters.
%   INPUT - dh_pars - structure where fields are names of  'groups', each 
%                     field is 4D array with kinematics parameters
%         - lb_pars - structure where fields are names of  'groups', each 
%                     field is 4D array with lower bounds
%         - ub_pars - structure where fields are names of  'groups', each 
%                     field is 4D array with upper bounds
%         - optim - structure of calibration settings
%         - chains - structure of chain settings
%         - linkTypes - structure of 'types' settings
%         - funcname - name of the robot-specific function
%   OUTPUT - opt_pars - 3D matrix of optimized pars, with dimensions:
%                       - number of optimized pars
%                       - number of repetitions
%                       - number of perturbations (1 for no pert)
%          - min_pars - 3D matrix of lower bounds;
%                       same dimesions as opt_pars
%          - max_pars - 3D matrix of upper bounds;
%                       same dimesions as opt_pars
%          - whitelist - structure where fields are names of  'groups', each 
%                        field is 4D array with 1/0
%          - dh_pars - structure where fields are names of  'groups', each 
%                     field is 4D array with kinematics parameters

    %% Call appropriate function or select default
    if(nargin == 8)
       if ischar(funcname) || isstring(funcname)
           func=str2func(funcname);
           whitelist = func(); 
       else
           whitelist = funcname; 
       end
    else
       whitelist = robot.structure.WL; 
    end

    fnames = fieldnames(robot.structure.kinematics);
    WLfnames = fieldnames(whitelist);
    for fname=WLfnames'
        if ~any(ismember(fnames, fname{1}))
           whitelist = rmfield(whitelist, fname{1});
        end
    end

    for fname=fnames'
        if ~any(ismember(WLfnames, fname{1}))
           robot.structure.WL.(fname{1}) = zeros(size(robot.structure.kinematics.(fname{1})));
        end
    end
    whitelist = group.sort(whitelist);

    [whitelist, ~] = padVectors(whitelist, 1);
    %Edit each links
    for link=robot.links
       link=link{1};
       if ~strcmp(link.type,'base')
       % if calibrate only offsets - set all other params to zeros
           if linkTypes.onlyOffsets && isfield(whitelist, link.group)
                   whitelist.(link.group)(link.DHindex,1:5)=0;
           end
           % link is in non-calibrated 'type' or non-calibrated 'group' set
           % whitelist to zeros
           if (~linkTypes.(link.type) || ~chains.(strrep(link.group,'Skin',''))) && isfield(whitelist, link.group)
                whitelist.(link.group)(link.DHindex,:)=zeros(1,6);
           end
       end
    end

    %% Allocate matrices
    names = fieldnames(whitelist);
    count = 0;
    for index = 1:size(names,1)
        count = count + sum(sum(whitelist.(names{index})));
    end
    opt_pars = inf(count, optim.repetitions, optim.pert_levels);
    max_pars = inf(count, optim.repetitions, optim.pert_levels);
    min_pars = inf(count, optim.repetitions, optim.pert_levels);
    %% 
    index = 1;
    for name = 1:size(names,1)
        whitelist.(names{name}) = logical(whitelist.(names{name}));
        % get whitelist in right format
        b = whitelist.(names{name})';
        for pert = 1:(optim.pert_levels)
            for rep = 1:optim.repetitions
                % get params on given indexes
                a = dh_pars.(names{name})(:,:,rep,pert)';
                % get kinematics withou perturabtions
                c=dh_pars.(names{name})(:,:,1,1)';
                % replace non-optimized values with non-perturbed ones 
                a(~b)=c(~b);
                % copy back to dh_pars
                dh_pars.(names{name})(:,:,rep,pert)=a';
                lb = lb_pars.(names{name})(:,:,rep,pert)';
                ub = ub_pars.(names{name})(:,:,rep,pert)';
                new_index = index + length(a(b))-1;
                % Append to output variables
                opt_pars(index:new_index,rep,pert) = a(b);
                min_pars(index:new_index,rep,pert) = lb(b);
                max_pars(index:new_index,rep,pert) = ub(b);
            end
        end
        index = new_index+1;
    end
end
