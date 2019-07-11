function [ opt_pars, min_pars, max_pars, whitelist ] = createWhitelist( robot, dh_pars, lb_pars, ub_pars, optim,  funcname )
%CREATEWHITELIST Summary of this function goes here
%   Detailed explanation goes here

if(nargin == 6)
   func=str2func(funcname);
   whitelist = func(); 
else
   whitelist = robot.structure.WL; 
end

for joint=robot.joints
   joint=joint{1};
   if ~strcmp(joint.type,'base') && (~optim.jointTypes.(joint.type) || ~optim.chains.(strrep(joint.group,'Skin','')))
      whitelist.(joint.group)(joint.DHindex,:)=zeros(1,4); 
   end
end


names = fieldnames(dh_pars);
count = 0;
for index = 1:size(names,1)
    count = count + sum(sum(whitelist.(names{index})));
end
opt_pars = inf(count, optim.repetitions, optim.pert_levels);
max_pars = inf(count, optim.repetitions, optim.pert_levels);
min_pars = inf(count, optim.repetitions, optim.pert_levels);

index = 1;
for name = 1:size(names,1)
    whitelist.(names{name}) = logical(whitelist.(names{name}));
    b = whitelist.(names{name})';
    for pert = 1:(optim.pert_levels)
        for rep = 1:optim.repetitions
            a = dh_pars.(names{name})(:,:,rep,pert)';     
            lb = lb_pars.(names{name})(:,:,rep,pert)';
            ub = ub_pars.(names{name})(:,:,rep,pert)';
            new_index = index + length(a(b))-1;
            opt_pars(index:new_index,rep,pert) = a(b);
            min_pars(index:new_index,rep,pert) = lb(b);
            max_pars(index:new_index,rep,pert) = ub(b);
        end
    end
    index = new_index+1;
end
end
