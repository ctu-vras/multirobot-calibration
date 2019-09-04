function [RTarm] = getTFIntern(dh_pars,joint,rtMat, joints, H0, indexes, parents, rtFields)
%GETTFIntern computes transformation from given joint to base 
%INPUT - dh_pars - DH parameters 
%       - joint - given Joint object to start the transformation
%       - rtMat - precomputed matrices
%       - joints - joint angles
%       - H0 - H0 transformation (from base to torso)
%       - indexes - row indexes into DH table 
%       - parents - structure of joint ancestors for each group)
%       - rtFields - fields in rtMat
%OUTPUT - RTarm - transformation from the joint to base
    RTarm= [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1]; 
    while isobject(joint)
        gr = joint.group;
        switch gr
            case rtFields
               RT=rtMat.(gr);
            otherwise       
                if ~iscell(indexes.(gr))
                    DH=dh_pars.(gr)(indexes.(gr),:);
                    DH(:,4)=DH(:,4)+joints.(gr)';
                    % returns RT for the group
                    RT=dhpars2tfmat(DH);
                else
                    RT=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
                    mat=rtMat.([gr,'Mats']);
                    for id=1:size(indexes.(gr),2)
                        idx=indexes.(gr){id};
                        RT=RT*mat(:,:,idx);
                        DH=dh_pars.(gr)(idx,:);
                        %idx(idx>length(joints.(gr)))=find(idx>length(joints.(gr)));
                        DH(:,4)=DH(:,4)+joints.(gr)(id)';
                        RT=RT*dhpars2tfmat(DH);
                    end
                end
        end
        joint = parents.(gr);
        RTarm = RT*RTarm;
        if(strcmp(joint.type, types.base)) % if the joint is base, multiply by H0 transformation and end the computation          
            RTarm = H0 * RTarm;
            break;
        end
    end
end

