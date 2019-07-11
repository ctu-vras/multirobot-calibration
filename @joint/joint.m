classdef joint < handle
    
    properties
        name char
        parent 
        parentId double
        DHindex double
        type 
        endEffector double 
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
            idx = nan(1,size(DH,1));
            id=1;
            while strcmp(obj.group,group) && ~strcmp(obj.type,types.base)
               idx(id)=obj.DHindex;
               id=id+1;
               obj=obj.parent;
            end
            idx(isnan(idx))=[];
            DH=DH(idx(end:-1:1),:);
            DH(:,4)=DH(:,4)+angles';
            R=dhpars2tfmat(DH);
            par=obj;
            if strcmp(par.type,types.base)
                par=nan;
                R=H0*R;
            end
            
        end
        
    end

end