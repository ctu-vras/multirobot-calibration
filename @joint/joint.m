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
            if ~strcmp(obj.parent.type,types.base) && strcmp(obj.parent.group,group)
                [R, par]=obj.parent.computeRTMatrix(DH,H0, angles, group);
            elseif strcmp(obj.parent.type,types.base)
                R = R*H0;
            else
                par = obj.parent;
            end
            curDH=DH.(obj.group);
            index=obj.DHindex;
            
            M=evalDHMatrix(curDH(index,1),curDH(index,2),curDH(index,3),curDH(index,4)+angles.(obj.group)(index));
            R = R * M;
        end
        
    end

end