function [ opt_pars ] = createWhitelist( robot, funcname )
%CREATEWHITELIST Summary of this function goes here
%   Detailed explanation goes here

if(nargin == 2)
   func=str2func(funcname);
   whitelist = func(); 
else
   whitelist = robot.structure.WL; 
end

names = fieldnames(robot.structure.DH);


opt_pars = [];

for index = 1:size(names,1)
   a = robot.structure.DH.(names{index});
   b = whitelist.(names{index});
   opt_pars = [opt_pars; a(b==1)];
end

if (isfield(robot.structure, 'skinDH'))
    skinNames = fieldnames(robot.structure.skinDH); 
    for index = 1:size(skinNames,1)
       a = robot.structure.skinDH.(skinNames{index});
       b = whitelist.(skinNames{index});
       opt_pars = [opt_pars; a(b==1)];
    end
end
end

