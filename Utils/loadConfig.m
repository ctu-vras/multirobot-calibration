function [options, chains, approach, jointTypes, optim, pert] = loadConfig(funcname,varargin)
%LOADCONFIG Loading Config file function
%INPUT - funcname - Config function name
%       - varargin - additional arguments for the config file
%OUTPUT - options - lsqnonlin solver options
%       - chains - chains to calibrate
%       - approach - calibration approaches
%       - jointTypes -joint types to calibrate
%       - optim - calibration settings
%       - pert - perturbation levels

    func=str2func(funcname);
    if nargin>1
        [options, chains, approach, jointTypes, optim, pert]=func((varargin{:}));
    else
        [options, chains, approach, jointTypes, optim, pert]=func();
    end
end

