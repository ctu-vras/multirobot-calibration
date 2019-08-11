function [RTarm] = getTF(dh_pars,joint,rtMat, joints, H0, stopGroup)
%GETTF computes transformation from given joint to base 
%INPUT - dh_pars - DH parameters 
%       - joint - given Joint object to start the transformation
%       - rtMat - precomputed matrices
%       - joints - joint angles
%       - H0 - H0 transformation (from base to torso)
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
        if ~isobject(joint) || strcmp(stopGroup,joint.group)
            break;
        end
    end
end