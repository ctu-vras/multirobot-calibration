function [ opt_pars, min_pars, max_pars, whitelist ] = createWhitelist( robot, dh_pars, lb_pars, ub_pars, optim,  funcname )
%CREATEWHITELIST Summary of this function goes here
%   Detailed explanation goes here

if(nargin == 4)
   func=str2func(funcname);
   whitelist = func(); 
else
   whitelist = robot.structure.WL; 
end

names = fieldnames(dh_pars);

count = 0;
for index = 1:size(names,1)
    count = count + length(whitelist.(names{index})(whitelist.(names{index})==1));
end
if (isfield(robot.structure, 'skinDH'))
    skinNames = fieldnames(robot.structure.skinDH); 
    for index = 1:size(skinNames,1)
        count = count + length(whitelist.(skinNames{index})(whitelist.(skinNames{index})==1));
    end
end
opt_pars = inf(count, optim.repetitions, optim.pert_levels);
max_pars = inf(count, optim.repetitions, optim.pert_levels);
min_pars = inf(count, optim.repetitions, optim.pert_levels);

index = 1;
for name = 1:size(names,1)
    b = whitelist.(names{name});
    for pert = 1:(optim.pert_levels)
        for rep = 1:optim.repetitions
            a = dh_pars.(names{name})(:,:,rep,pert);
            lb = lb_pars.(names{name})(:,:,rep,pert);
            ub = ub_pars.(names{name})(:,:,rep,pert);
            new_index = index + length(a(b==1))-1;
            opt_pars(index:new_index,rep,pert) = a(b==1);
            min_pars(index:new_index,rep,pert) = lb(b==1);
            max_pars(index:new_index,rep,pert) = ub(b==1);
        end
    end
    index = new_index+1;
end

if (isfield(robot.structure, 'skinDH'))
    skinNames = fieldnames(robot.structure.skinDH); 
    for name = 1:size(skinNames,1)
        b = whitelist.(skinNames{name});
        for pert = 1:(optim.pert_levels)
            for rep = 1:optim.repetitions
                a = dh_pars.(skinNames{name})(:,:,rep,pert);
                lb = lb_pars.(skinNames{name})(:,:,rep,pert);
                ub = ub_pars.(skinNames{name})(:,:,rep,pert);
                new_index = index + length(a(b==1))-1;
                opt_pars(index:new_index,rep,pert) = a(b==1);
                min_pars(index:new_index,rep,pert) = lb(b==1);
                max_pars(index:new_index,rep,pert) = ub(b==1);
            end
        end
        index = new_index;
    end
end   
end

