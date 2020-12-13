function [init, lb, ub]=prepareDH(r, pert, optim, funcname)
    % PREPAREDH returns DH tables with/without perturbations and tables
    %           with bounds.
    %   INPUT - pert - structure with perturation ranges
    %         - optim - structure of calibration settings
    %         - funcname - name of the robot-specific function
    %   OUTPUT - init - structure with all 'groups' used in the robot. Each
    %                   field is 4D array with DH parameters of given group
    %                   for each repetition and perturation range
    %          - lb - same strcuture as 'init', but values are lower bounds
    %                 of each DH parameter
    %          - ub - same as 'lb', but with upper bounds
    
%% Call appropriate function or select default
    if(nargin == 4)
       if ischar(funcname) || isstring(funcname)
           func=str2func(funcname);
           bounds = func();
       else
           bounds = funcname;
       end
    else
       bounds = [];
    end
    [bounds, ~] = padVectors(bounds);
    [r.structure.bounds, ~] = padVectors(r.structure.bounds);
%% Pad values and reshape
    [r.structure.DH, r.structure.type] = padVectors(r.structure.DH);
    [r.structure.defaultDH, ~] = padVectors(r.structure.defaultDH);

    %% Perturbation
    % allocate array
    perms=zeros(length(r.joints),6,optim.repetitions,optim.pert_levels-1);
    index=1; 
    for i=1:length(optim.pert)
        % if the given pert range is used
        if optim.pert(i)
            % generate random numbers with given distribution and multiply
            % them with perturbation ranges
            pert_temp = pert{i};
            if length(pert_temp) == 4
                warning('Only 4 parameters inserted for perturbation vector %d. If there is any 6D transformaton, the remaining parameters will be computed as a mean of the existing ones.', i);
                pert_temp = [pert_temp, mean(pert_temp(1:2)), mean(pert_temp(3:4))];
                pert_temp = pert_temp([1,2,5,3,6,4]);
            end
            if strcmp(optim.distribution,'uniform')
                % if 'uniform' distribution - use rand*2 - 1, to get values
                % from -1 to 1
                perms(:,:,:,index)=(rand(length(r.joints),6, optim.repetitions)*2-1).*[pert_temp(1:3)*optim.unitsCoef, pert_temp(4:6)];
            elseif strcmp(optim.distribution,'normal')
                % if 'normal' distribution - just use randn function
                perms(:,:,:,index)=randn(length(r.joints),6, optim.repetitions).*[pert_temp(1:3)*optim.unitsCoef, pert_temp(4:6)];
            end
            index=index+1;
        end
    end
    
    %% Matrices preallocation
    fnames=fieldnames(r.structure.DH);
    % allocate default values to every field of matrices 
    % (named as 'groups' of robot's DH)
    for fname=1:size(fnames,1)
       lines=size(r.structure.DH.(fnames{fname}),1);
       % 4D matrix - number of lines of DH of given 'group'
       %           - 4 - 4 DH params for each line
       %           - number of repetitions
       %           - number of perturations levels (1 for no pert)
       init.(fnames{fname})=zeros(lines,6,optim.repetitions,optim.pert_levels); 
       lb.(fnames{fname})=-inf(lines,6,optim.repetitions,optim.pert_levels); 
       ub.(fnames{fname})=inf(lines,6,optim.repetitions,optim.pert_levels);    
    end
        
    %% Fill with right values
    % for every robot's joints
    for jointId=1:length(r.joints)
        joint=r.joints{jointId};
        % Skip base
        if strcmp(joint.type,types.base)
            continue 
        end
        % copy non-perturbed parameters for each repetition to preallocated matrix  
        init.(joint.group)(joint.DHindex,:,:,1)=repmat([r.structure.DH.(joint.group)(joint.DHindex,1:3)*optim.unitsCoef,r.structure.DH.(joint.group)(joint.DHindex,4:6)],1,1,optim.repetitions); 
        % add perturbations to the DH parameters and copy them to
        % preallocated matrices
        for i=1:optim.pert_levels-1
            % no need for 'repmat' here, as we already have the default DH
            % parameters from previous step
            init.(joint.group)(joint.DHindex,:,:,i+1)=init.(joint.group)(joint.DHindex,:,:,1)+perms(jointId,:,:,i);
        end
        if optim.bounds          
            % if custom function to load bounds was used
            if ~(isempty(bounds))
                % get the right line of bounds 
                jointBounds=bounds.(joint.group)(joint.DHindex,:);
                %replace NaNs with default bounds
                jointBounds(isnan(jointBounds))=r.structure.bounds.(joint.type)(isnan(jointBounds));
            else
                % else use default bounds
                jointBounds=r.structure.bounds.(joint.type);
            end
            if optim.boundsFromDefault
                type='defaultDH';
            else
                type='DH';
            end
            % create bounds by add/substract them to DH pars and copy them
            % to right indexes in prealocated matrices
            lb.(joint.group)(joint.DHindex,:,:,1)=repmat([(r.structure.(type).(joint.group)(joint.DHindex,1:3)-jointBounds(1:3))*optim.unitsCoef, r.structure.(type).(joint.group)(joint.DHindex,4:6)-jointBounds(4:6)],1,1,optim.repetitions); 
            ub.(joint.group)(joint.DHindex,:,:,1)=repmat([(r.structure.(type).(joint.group)(joint.DHindex,1:3)+jointBounds(1:3))*optim.unitsCoef, r.structure.(type).(joint.group)(joint.DHindex,4:6)+jointBounds(4:6)],1,1,optim.repetitions);
        end
    end
    
    for f=1:size(fnames,1)
        for i=1:optim.pert_levels-1
            % if DH parameters are lesser/bigger than bounds, use them as
            % bounds
            lb.(fnames{f})(:,:,:,1+i)=min(lb.(fnames{f})(:,:,:,1),init.(fnames{f})(:,:,:,1+i));
            ub.(fnames{f})(:,:,:,1+i)=max(ub.(fnames{f})(:,:,:,1),init.(fnames{f})(:,:,:,1+i)); 
            % print warning if any bound was changed
            for j = 1:size(lb.(fnames{f}),1)
                if(any(any(lb.(fnames{f})(j,:,:,1+i)==init.(fnames{f})(j,:,:,1+i),3),2))
                    warning('Perturbed DH parameters from line %d in field %s for perturbation level %d are outside the bounds!', j ,fnames{f}, i);
                end
            end
        end 
    end  
end
