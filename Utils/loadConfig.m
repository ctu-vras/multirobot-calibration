function [options, chains, optim, pert] = loadConfig(funcname,varargin)
%LOADCONFIG Summary of this function goes here
%   Detailed explanation goes here
    if nargin>1
        func=str2func(funcname);
        [options, chains, optim, pert]=func((varargin{:}));
    else
        func=str2func(funcname);
        [options, chains, optim, pert]=func();
    end
end

