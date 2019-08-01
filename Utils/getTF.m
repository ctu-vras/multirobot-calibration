function [RTarm] = getTF(dh_pars,joint,rtMat,empty, joints, H0)
%GETTF computes transformation from given joint to base 
%INPUT - dh_pars - DH parameters 
%       - joint - given Joint object to start the transformation
%       - rtMat - precomputed matrices
%       - empty - is rtMat empty?
%       - joints - joint angles
%       - H0 - H0 transformation (from base to torso)
%OUTPUT - RTarm - transformation from the joint to base
    RTarm=eye(4);
    while isobject(joint)
        gr = joint.group;
        if empty ||  ~isfield(rtMat, gr)
            % returns RT for the group and the first ancestor of another group
            [RT,joint] = joint.computeRTMatrix(dh_pars.(gr), H0, joints.(gr), gr); 
        else % we have precomputed matrix for joint group
            RT=rtMat.(gr);
            while isobject(joint) && strcmp(joint.group,gr) % skip to first joint of another group
               joint=joint.parent; 
            end
            if(isobject(joint) && strcmp(joint.type, types.base)) % if the joint is base, end the computation
                RTarm = H0*RT*RTarm;
                break;
            end
        end  
        RTarm=RT*RTarm;
    end
end

