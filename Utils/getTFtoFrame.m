function RTarm = getTFtoFrame(dh_pars,joint, joints, H0, stopJoint, rtMat)
%GETTF computes transformation from given joint to given joint
%INPUT - dh_pars - DH parameters 
%       - joint - given Joint object to start the transformation
%       - joints - joint angles
%       - H0 - H0 transformation (from base to torso)
%       - stopJoint - at which joint the calculation will stop
%OUTPUT - RT - transformation from the joint to stopJoint
    if nargin<6
       rtMat=[]; 
    end
    if ~isfield(dh_pars,'torso')
        dh_pars.torso=[0,0,0,0];
        joints.torso=[0];
    end
    RTarm=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
    while ~strcmp(joint.name,stopJoint)
        group=joint.group;
        DH=dh_pars.(group);
        idx = nan(1,size(DH,1));
        id=1;
        % iterate while group of current joint is the same as group of
        % input joint and current joint is not base
        while strcmp(joint.group,group) && ~strcmp(joint.type,types.base)
            idx(id)=joint.DHindex;
            id=id+1;
            joint=joint.parent;
            if strcmp(joint.name,stopJoint)
                break;
            end
        end
        %Get rid of nans
        idx(isnan(idx))=[];
        %Reverse order of the ids to get matrix to input joint 
        idx=idx(end:-1:1);
        if ~isfield(rtMat, [group,'Mats'])
            DH=DH(idx,:);
            %Add joint angles
            idx(idx>length(joints.(group)))=find(idx>length(joints.(group))); % skin can have index bigger than size of joints
            DH(:,4)=DH(:,4)+joints.(group)(idx)';
            %compute RT matrix
            RTarm=dhpars2tfmat(DH)*RTarm;
        else
            RT=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
            mat=rtMat.([group,'Mats']);
            idxs=num2cell(idx);
            for id=1:size(idxs,2)
                idx=idxs{id};
                RT=RT*mat(:,:,idx);
                DH=dh_pars.(group)(idx,:);
                %idx(idx>length(joints.(gr)))=find(idx>length(joints.(gr)));
                DH(:,4)=DH(:,4)+joints.(group)(id)';
                RT=RT*dhpars2tfmat(DH);
            end
            RTarm=RT*RTarm;
        end

        %If joint is base, multiply with H0 matrix
        if strcmp(joint.type,types.base)
            RTarm=H0*RTarm;
        end
    end

end
