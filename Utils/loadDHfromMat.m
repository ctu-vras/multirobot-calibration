function loadDHfromMat(robot,folder,varargin)
%LOADDHFROMMAT Summary of this function goes here
%   Detailed explanation goes here
    p=inputParser;
    addRequired(p,'robot');
    addRequired(p,'folder');
    addParameter(p,'rep',1,@isnumeric);
    addParameter(p,'pert',1,@isnumeric);
    addParameter(p,'type','');
    parse(p,robot,folder,varargin{:});
    
    res_dh=load(['results/',folder,'/results.mat']);
    res_dh=res_dh.res_dh;
    pert=p.Results.pert;
    if strcmp(p.Results.type,'')
        rep=p.Results.rep;
    else
        errors=load(['results/',folder,'/errors.mat']);
        info = load(['results/',folder,'/info.mat']);
        errors=errors.errors;
        optim = info.optim;
        dists = errors(13:16,(pert-1)*optim.repetitions+(1:optim.repetitions));
        dists(isnan(dists))=0;
        
        if strcmp(p.Results.type,'min')
            [~,rep]=min(optim.type.selftouch*dists(1,:)+optim.type.planes*dists(2,:)+optim.type.external*dists(3,:)+optim.type.eyes*dists(4,:));
        elseif strcmp(p.Results.type,'max')
            [~,rep]=max(optim.type.selftouch*dists(1,:)+optim.type.planes*dists(2,:)+optim.type.external*dists(3,:)+optim.type.eyes*dists(4,:));
        end
    end
    fnames=fieldnames(res_dh);
    for name=1:length(fnames)
        if strfind(fnames{name},'Skin')
            robot.structure.skinDH.(fnames{name})=res_dh.(fnames{name})(:,:,rep,pert);
        else
            robot.structure.DH.(fnames{name})=res_dh.(fnames{name})(:,:,rep,pert);
        end
    end
end
