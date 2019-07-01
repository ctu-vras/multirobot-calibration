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
        function [R,par]=computeRTMatrix(obj, DH, H0, angles, group)
            R=eye(4);
            par = nan;
            if obj.parent.type~=types.base && obj.parent.group == group
                [R, par]=obj.parent.computeRTMatrix(DH,H0, angles, group);
            elseif (obj.parent.type==types.base)
                R = R*H0;
            else
                par = obj.parent;
            end
            index = sprintf('%s',obj.group);
            curDH=DH.(index);
            R=R*evalDHMatrix(curDH(obj.DHindex,1),curDH(obj.DHindex,2),curDH(obj.DHindex,3),curDH(obj.DHindex,4)+angles.(index)(obj.DHindex));
        end
        
    end

end