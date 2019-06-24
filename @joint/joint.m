classdef joint < handle
    
    properties
        name
        parent
        DH
        type
        optimize
        perturbation
        optimizedPars
        endEffector
    end
    
    methods
        %% Constructor
        function obj = joint(name, type, parent, DH, optimize,optimizedPars, perturbation, endEffector)
            if nargin==8
               obj.type=type;
               obj.name=name;
               obj.parent=parent;
               obj.DH=DH;
               obj.optimize=optimize;
               obj.optimizedPars=optimizedPars;
               obj.perturbation=perturbation;
               obj.endEffector=endEffector;
            else
                error(sprintf('Incorrect number of arguments inserted,expected 8, but got %d',nargin));
            end
        end
        
        %% Computes RT matrix to base
        function R=computeRTMatrix(obj)
            parent=obj.parent;
            R=evalDHMatrix(obj.DH(1)*1000,obj.DH(2)*1000,obj.DH(3),obj.DH(4));
            while  ~strcmp(parent.type,'base')
                R=R*evalDHMatrix(parent.DH(1)*1000,parent.DH(2)*1000,parent.DH(3),parent.DH(4));
                parent=parent.parent;
            end
            R=R*evalDHMatrix(parent.DH(1)*1000,parent.DH(2)*1000,parent.DH(3),parent.DH(4));
            R=eye(4)\R;
        end
        
    end
    
end