function [init, lb, ub]=prepareKinematics(r, pert, optim, funcname)
    % PREPAREKINEMATICS returns kinematics tables with/without perturbations and tables
    %           with bounds.
    %   INPUT - pert - structure with perturation ranges
    %         - optim - structure of calibration settings
    %         - funcname - name of the robot-specific function
    %   OUTPUT - init - structure with all 'groups' used in the robot. Each
    %                   field is 4D array with kinematics parameters of given group
    %                   for each repetition and perturation range
    %          - lb - same strcuture as 'init', but values are lower bounds
    %                 of each kinematics parameter
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
    [r.structure.kinematics, r.structure.type] = padVectors(r.structure.kinematics);
    [r.structure.defaultKinematics, ~] = padVectors(r.structure.defaultKinematics);

    %% Perturbation
    % allocate array
    perms=zeros(length(r.links),6,optim.repetitions,optim.pert_levels-1);
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
                perms(:,:,:,index)=(rand(length(r.links),6, optim.repetitions)*2-1).*[pert_temp(1:3)*optim.unitsCoef, pert_temp(4:6)];
            elseif strcmp(optim.distribution,'normal')
                % if 'normal' distribution - just use randn function
                perms(:,:,:,index)=randn(length(r.links),6, optim.repetitions).*[pert_temp(1:3)*optim.unitsCoef, pert_temp(4:6)];
            end
            index=index+1;
        end
    end
    
    %% Matrices preallocation
    fnames=fieldnames(r.structure.kinematics);
    % allocate default values to every field of matrices 
    % (named as 'groups' of robot's kinematics)
    for fname=1:size(fnames,1)
       lines=size(r.structure.kinematics.(fnames{fname}),1);
       % 4D matrix - number of lines of kinematics of given 'group'
       %           - 4 - 4/6 kinematics params for each line
       %           - number of repetitions
       %           - number of perturations levels (1 for no pert)
       init.(fnames{fname})=zeros(lines,6,optim.repetitions,optim.pert_levels); 
       lb.(fnames{fname})=-inf(lines,6,optim.repetitions,optim.pert_levels); 
       ub.(fnames{fname})=inf(lines,6,optim.repetitions,optim.pert_levels);    
    end
        
    %% Fill with right values
    % for every robot's links
    for linkId=1:length(r.links)
        link=r.links{linkId};
        % Skip base
        if strcmp(link.type,types.base)
            continue 
        end
        % copy non-perturbed parameters for each repetition to preallocated matrix  
        init.(link.group)(link.DHindex,:,:,1)=repmat([r.structure.kinematics.(link.group)(link.DHindex,1:3)*optim.unitsCoef,r.structure.kinematics.(link.group)(link.DHindex,4:6)],1,1,optim.repetitions); 
        % add perturbations to the kinematics parameters and copy them to
        % preallocated matrices
        for i=1:optim.pert_levels-1
            % no need for 'repmat' here, as we already have the default kinematics
            % parameters from previous step
            init.(link.group)(link.DHindex,:,:,i+1)=init.(link.group)(link.DHindex,:,:,1)+perms(linkId,:,:,i);
        end
        if optim.bounds          
            % if custom function to load bounds was used
            if ~(isempty(bounds))
                % get the right line of bounds 
                linkBounds=bounds.(link.group)(link.DHindex,:);
                %replace NaNs with default bounds
                linkBounds(isnan(linkBounds))=r.structure.bounds.(link.type)(isnan(linkBounds));
            else
                % else use default bounds
                linkBounds=r.structure.bounds.(link.type);
            end
            if optim.boundsFromDefault
                type='defaultKinematics';
            else
                type='kinematics';
            end
            % create bounds by add/substract them to kinematics pars and copy them
            % to right indexes in prealocated matrices
            lb.(link.group)(link.DHindex,:,:,1)=repmat([(r.structure.(type).(link.group)(link.DHindex,1:3)-linkBounds(1:3))*optim.unitsCoef, r.structure.(type).(link.group)(link.DHindex,4:6)-linkBounds(4:6)],1,1,optim.repetitions); 
            ub.(link.group)(link.DHindex,:,:,1)=repmat([(r.structure.(type).(link.group)(link.DHindex,1:3)+linkBounds(1:3))*optim.unitsCoef, r.structure.(type).(link.group)(link.DHindex,4:6)+linkBounds(4:6)],1,1,optim.repetitions);
        end
    end
    
    for f=1:size(fnames,1)
        for i=1:optim.pert_levels-1
            % if kinematics parameters are lesser/bigger than bounds, use them as
            % bounds
            lb.(fnames{f})(:,:,:,1+i)=min(lb.(fnames{f})(:,:,:,1),init.(fnames{f})(:,:,:,1+i));
            ub.(fnames{f})(:,:,:,1+i)=max(ub.(fnames{f})(:,:,:,1),init.(fnames{f})(:,:,:,1+i)); 
            % print warning if any bound was changed
            for j = 1:size(lb.(fnames{f}),1)
                if(any(any(lb.(fnames{f})(j,:,:,1+i)==init.(fnames{f})(j,:,:,1+i),3),2))
                    warning('Perturbed kinematics parameters from line %d in field %s for perturbation level %d are outside the bounds!', j ,fnames{f}, i);
                end
            end
        end 
    end  
end
