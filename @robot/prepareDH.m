function [init, lb, ub]=prepareDH(r, pert, distribution, optim)

    %% pert
    fnames=fieldnames(pert);
    perms=zeros(length(r.joints),4,length(optim.pert(optim.pert==1)));
    index=1;
    for i=1:3
        if optim.pert(i)
            perms(:,:,index)=(rand(length(r.joints),4)*2-1).*repmat(pert.(fnames{i}).DH,length(r.joints),1);
            index=index+1;
        end
    end
    
    %% Init
    fnames=fieldnames(r.structure.DH);
    
    for fname=1:size(fnames,1)
       lines=size(r.structure.DH.(fnames{fname}),1);
       init.(fnames{fname})=zeros(lines,4,optim.repetitions,1+length(optim.pert(optim.pert==1))); 
       lb.(fnames{fname})=-inf(lines,4,optim.repetitions,1+length(optim.pert(optim.pert==1))); 
       ub.(fnames{fname})=inf(lines,4,optim.repetitions,1+length(optim.pert(optim.pert==1)));    
    end
    
    if isfield(r.structure,'skinDH')
        fnamesSkin=fieldnames(r.structure.skinDH);
        for fname=1:size(fnamesSkin,1)
           lines=size(r.structure.skinDH.(fnamesSkin{fname}),1);
           init.(fnamesSkin{fname})=zeros(lines,4,optim.repetitions,1+length(optim.pert(optim.pert==1))); 
           lb.(fnamesSkin{fname})=-inf(lines,4,optim.repetitions,1+length(optim.pert(optim.pert==1))); 
           ub.(fnamesSkin{fname})=inf(lines,4,optim.repetitions,1+length(optim.pert(optim.pert==1))); 
        end
    end
    
    %% start pars and bounds
    for jointId=1:length(r.joints)
       joint=r.joints{jointId};
       if strcmp(joint.type,types.joint) || strcmp(joint.type,types.eye) 
          type='DH';
       elseif ~strcmp(joint.type,types.base)
          type='skinDH'; 
       else
           continue
       end
       init.(joint.group)(joint.DHindex,:,:,1)=repmat(r.structure.(type).(joint.group)(joint.DHindex,:),1,1,optim.repetitions); 
      for i=1:length(optim.pert(optim.pert==1))
           init.(joint.group)(joint.DHindex,:,:,i+1)=init.(joint.group)(joint.DHindex,:,:,1)+perms(jointId,:,i);
       end
       if optim.bounds
        lb.(joint.group)(joint.DHindex,:,:,1)=repmat(r.structure.(type).(joint.group)(joint.DHindex,:)-r.structure.bounds.(joint.type),1,1,optim.repetitions); 
        ub.(joint.group)(joint.DHindex,:,:,1)=repmat(r.structure.(type).(joint.group)(joint.DHindex,:)+r.structure.bounds.(joint.type),1,1,optim.repetitions);
       end
    end
    
    for f=1:size(fnames,1)
        for i=1:length(optim.pert(optim.pert==1))
           lb.(fnames{f})(:,:,:,1+i)=min(lb.(fnames{f})(:,:,:,1),init.(fnames{f})(:,:,:,1+i));
           ub.(fnames{f})(:,:,:,1+i)=max(ub.(fnames{f})(:,:,:,1),init.(fnames{f})(:,:,:,1+i));
        end 
    end

    
end
