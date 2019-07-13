function [RTarm] = getTF(dh_pars,obj,rtMat,empty, joints, H0)
%GETTF Summary of this function goes here
%   Detailed explanation goes here
    RTarm=eye(4);
    while isobject(obj)
        gr = obj.group;
        if empty ||  ~isfield(rtMat, gr)
            [RT,par] = obj.computeRTMatrix(dh_pars.(gr), H0, joints.(gr), gr);
            obj=par;
        else
            RT=rtMat.(gr);
            while isobject(obj) && strcmp(obj.group,gr)
               obj=obj.parent; 
            end
            if(strcmp(obj.type, types.base))
                RTarm = H0*RT*RTarm;
                break;
            end
        end  
        RTarm=RT*RTarm;
    end
end

