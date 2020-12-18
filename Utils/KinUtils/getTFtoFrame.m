function RTarm = getTFtoFrame(dh_pars,link, joints, stopLink)
%GETTF computes transformation from given link to given link
%INPUT - dh_pars - kinematics parameters 
%       - link - given link object to start the transformation
%       - joints - joint angles
%       - stopLink - at which link the calculation will stop
%OUTPUT - RT - transformation from the link to stopLink
    if nargin<4
       stopLink = 'base';
    end
    if ~isfield(dh_pars,'torso')
        dh_pars.torso=[0,0,0,0,nan,nan];
        joints.torso=[0];
    end
    [dh_pars, type] = padVectors(dh_pars);
    RTarm=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
    while ~strcmp(link.name,stopLink)
        group=link.group;
        DH=dh_pars.(group);
        idx = nan(1,size(DH,1));
        id=1;
        % iterate while group of current link is the same as group of
        % input link and current link is not base
        while strcmp(link.group,group) && ~strcmp(link.type,types.base)
            idx(id)=link.DHindex;
            id=id+1;
            link=link.parent;
            if strcmp(link.name,stopLink)
                break;
            end
        end
        %Get rid of nans
        idx(isnan(idx))=[];
        %Reverse order of the ids to get matrix to input link 
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

        %If link is base, end the computation
        if strcmp(link.type,types.base)
           break;
        end
    end

end
