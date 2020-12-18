function loadKinfromMat(robot,folder,varargin)
%LOADKINFROMMAT Loading robot kinematics from mat file
%   Function for loading robot kinematics from mat file saved in a subfolder in
%   folder Results
%INPUT - robot - Robot object to store kinematics 
%      - folder - folder with required kinematics mat file
%      - varargin - rep - selects kinematics of the given repetititon
%      - varargin - pert - selects only kinematics of the given perturbation 
%      - varargin - type - selects kinematics with {min,max,median} testing rms error
    p=inputParser;
    addRequired(p,'robot');
    addRequired(p,'folder');
    addParameter(p,'rep',1);
    addParameter(p,'pert',0);
    addParameter(p,'type','');
    parse(p,robot,folder,varargin{:});
    
    res_dh=load(['Results/',folder,'/results.mat']);
    res_dh=res_dh.res_dh; % load result kinematics
    %% pert level is +1 (indexing from 1)
    if ischar(p.Results.pert)
        pert=str2double(p.Results.pert)+1;
    else
        pert=p.Results.pert+1;
    end
    %% if type is not used, use given repetition
    if strcmp(p.Results.type,'')
        if ischar(p.Results.rep)
            rep=str2double(p.Results.rep);
        else
            rep=p.Results.rep;
        end
    else 
        %% loading testing rms errors
        errors=load(['Results/',folder,'/errors.mat']);
        info = load(['Results/',folder,'/info.mat']);
        errors=errors.errors;
        optim = info.optim;
        approach=info.approach;
        dists = errors(13:16,(pert-1)*optim.repetitions+(1:optim.repetitions));
        dists(isnan(dists))=0;
        
        %% finding the {min,max,median} argument
        if strcmp(p.Results.type,'min')
            [~,rep]=min(approach.selftouch*dists(1,:)+approach.planes*dists(2,:)+approach.external*dists(3,:)+approach.projection*dists(4,:));
        elseif strcmp(p.Results.type,'max')
            [~,rep]=max(approach.selftouch*dists(1,:)+approach.planes*dists(2,:)+approach.external*dists(3,:)+approach.projection*dists(4,:));
        elseif strcmp(p.Results.type,'median')
            values = approach.selftouch*dists(1,:)+approach.planes*dists(2,:)+approach.external*dists(3,:)+approach.projection*dists(4,:);
            sortedValues = sort(values);
            rep = find(sortedValues(ceil(length(sortedValues)/2)) == values);
        end
    end
    %% selecting the desired kinematics
    fnames=fieldnames(res_dh);
    for name=1:length(fnames)
        robot.structure.kinematics.(fnames{name})=res_dh.(fnames{name})(:,:,rep,pert);
    end
end
