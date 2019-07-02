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
        function [R,par]=computeRTMatrix(obj, DH, H0, angles, group, R)
%             R=eye(4);
            par = nan;
            paren = obj.parent;
            if ~strcmp(paren.type,types.base) && strcmp(paren.group,group)
                [R, par]=paren.computeRTMatrix(DH,H0, angles, group, R);
            elseif strcmp(paren.type,types.base)
                R = R*H0;
            else
                par = paren;
            end
            index=obj.DHindex;
            
            M=evalDHMatrix(DH(index,1),DH(index,2),DH(index,3),DH(index,4)+angles(index));
            R = R * M;
        end
        
    end

end