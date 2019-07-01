classdef joint < handle
    
    properties
        name
        parent
        parentId
        DHindex
        type
        endEffector
        group
    end
    
    methods
        %% Constructor
        function obj = joint(name, type, parent, DHindex, endEffector, group,  parentId)
               if(nargin == 7)
                   obj.type=type;
                   obj.name=name;
                   obj.parent=parent;
                   obj.DHindex=DHindex;
                   obj.endEffector=endEffector;
                   obj.group=group;
                   obj.parentId=parentId;
               end
        end
        
        %% Computes RT matrix to base
        function R=computeRTMatrix(obj, DH, H0)
            R=eye(4);
            if obj.parent.type~=types.base
                R=obj.parent.computeRTMatrix(DH,H0);
            end
            curDH=DH.(sprintf('%s',obj.group));
            R=R*evalDHMatrix(curDH(obj.DHindex,1)*1000,curDH(obj.DHindex,2)*1000,curDH(obj.DHindex,3),curDH(obj.DHindex,4));
        end
        
    end

end