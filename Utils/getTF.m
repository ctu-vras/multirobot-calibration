function [RTarm] = getTF(dh_pars,joint,rtMat, joints, stopGroup)
%GETTF computes transformation from given joint to base 
%INPUT - dh_pars - DH parameters 
%       - joint - given Joint object to start the transformation
%       - rtMat - precomputed matrices
%       - joints - joint angles
%       - stopGroup - group at which the algorithm will stop, optional
%OUTPUT - RTarm - transformation from the joint to base
    if nargin<6
        stopGroup='';
    end
    
    RTarm=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]; 
    while isobject(joint)
        gr = joint.group;
        if ~isfield(rtMat, gr)
            % returns RT for the group and the first ancestor of another group
            %~isfield(robot,'matrices') || ~contains(gr, 'Skin')
            if ~isfield(rtMat,[gr,'Mats'])  
                [RT,joint] = joint.computeRTMatrix(dh_pars.(gr), joints.(gr), gr);
            else
                idx = [];
                id=1;
                while strcmp(joint.group,gr) && ~strcmp(joint.type,types.base) % save indexes into DH table for all joints of the group
                   idx(id)=joint.DHindex;
                   id=id+1;
                   joint=joint.parent;
                end
                idxs=num2cell(idx(end:-1:1));
                RT=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
                mat=rtMat.([gr,'Mats']);
                for id=1:size(idxs,2)
                    idx=idxs{id};
                    RT=RT*mat(:,:,idx);
                    DH=dh_pars.(gr)(idx,:);
                    %idx(idx>length(joints.(gr)))=find(idx>length(joints.(gr)));
                    DH(:,4)=DH(:,4)+joints.(gr)(id)';
                    RT=RT*dhpars2tfmat(DH);
                end
            end
        else % we have precomputed matrix for joint group
            RT=rtMat.(gr);
            while isobject(joint) && strcmp(joint.group,gr) % skip to first joint of another group
               joint=joint.parent; 
            end
            if(isobject(joint) && strcmp(joint.type, types.base)) % if the joint is base, end the computation
                RTarm = RT*RTarm;
                break;
            end
        end  
        RTarm=RT*RTarm;
        if ~isobject(joint) || strcmp(stopGroup,joint.group)
            break;
        end
    end
end