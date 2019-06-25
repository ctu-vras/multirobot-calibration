classdef joint < handle
    
    properties
        name
        parent
        parentId
        DH
        type
        perturbedDH
        optimizedPars
        endEffector
        lowerBounds
        upperBounds
        group
    end
    
    methods
        %% Constructor
        function obj = joint(name, type, parent, DH, endEffector, group,  parentId, optimizedPars)
            
               obj.type=type;
               obj.name=name;
               obj.parent=parent;
               obj.DH=DH;
               obj.optimizedPars=ones(1,4);
               obj.perturbedDH=zeros(1,4);
               obj.endEffector=endEffector;
               obj.lowerBounds=-inf(1,4);
               obj.upperBounds=inf(1,4);
               obj.group=group;
               obj.parentId=parentId;
            if nargin==8
               obj.optimizedPars=optimizedPars;
            end
        end
        
        %% Computes RT matrix to base
        function R=computeRTMatrix(obj)
            par=obj.parent;
            R=evalDHMatrix(obj.DH(1)*1000,obj.DH(2)*1000,obj.DH(3),obj.DH(4));
            while ~par.type==types.base
                R=R*evalDHMatrix(par.DH(1)*1000,par.DH(2)*1000,par.DH(3),par.DH(4));
                par=par.parent;
            end
            R=R*evalDHMatrix(par.DH(1)*1000,par.DH(2)*1000,par.DH(3),par.DH(4));
            R=eye(4)\R;
        end
        
    end
    
end