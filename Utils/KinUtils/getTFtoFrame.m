function RTarm = getTFtoFrame(dh_pars,joint, joints, stopJoint)
%GETTF computes transformation from given joint to given joint
%INPUT - dh_pars - DH parameters 
%       - joint - given Joint object to start the transformation
%       - joints - joint angles
%       - stopJoint - at which joint the calculation will stop
%OUTPUT - RT - transformation from the joint to stopJoint
    if nargin<5
       stopJoint = 'base';
    end
    if ~isfield(dh_pars,'torso')
        dh_pars.torso=[0,0,0,0,nan,nan];
        joints.torso=[0];
    end
    [dh_pars, type] = padVectors(dh_pars);
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
        if ~type.(group)
            DH=DH(idx,:);
            %Add joint angles
            idx(idx>length(joints.(group)))=find(idx>length(joints.(group))); % skin can have index bigger than size of joints
            DH(:,6)=DH(:,6)+joints.(group)(idx)';
            %compute RT matrix
            RTarm=dhpars2tfmat(DH)*RTarm;
        elseif type.(group) == 1
            pars = dh_pars.(group)(idx,:);
            for i=size(pars,1):-1:1
                v = pars(i,4:6)';
                th=norm(v);
                if th>eps
                    v=v/th;
                end
                K=[0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
                R= cos(th)*[1,0,0;0,1,0;0,0,1] + (1-cos(th))*kron(v,v')+sin(th)*K;
                RTarm = [R,pars(i,1:3)';0,0,0,1] * RTarm;
            end
        else
            pars = dh_pars.(group)(idx,:);
            for line=size(pars,1):-1:1
               if any(isnan(pars(line,:)))
                   DH=pars(line,:);
                   DH(6)=DH(6)+joints.(group)(line);
                   RTarm = dhpars2tfmat(DH)*RTarm;
               else
                    v = pars(line,4:6)';
                    th=norm(v);
                    if th>eps
                        v=v/th;
                    end
                    K=[0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
                    R= cos(th)*[1,0,0;0,1,0;0,0,1] + (1-cos(th))*kron(v,v')+sin(th)*K;
                    RTarm = [R,pars(line,1:3)';0,0,0,1]*RTarm;
               end
            end
            
        end

        %If joint is base, end the computation
        if strcmp(joint.type,types.base)
           break;
        end
    end

end
