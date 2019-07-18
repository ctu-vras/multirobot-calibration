function [options, chains, approach, jointTypes, optim, pert] = loadConfig(funcname,varargin)
%LOADCONFIG Summary of this function goes here
%   Detailed explanation goes here
    if nargin>1
        func=str2func(funcname);
        [options, chains, approach, jointTypes, optim, pert]=func((varargin{:}));
    else
        func=str2func(funcname);
        [options, chains, approach, jointTypes, optim, pert]=func();
    end
end

