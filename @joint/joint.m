classdef joint < handle
    
    properties
        name
        parent
        DH
        type
        %optimize
        perturbedDH
        optimizedPars
        endEffector
        lowerBounds
        upperBounds
    end
    
    methods
        %% Constructor
        function obj = joint(name, type, parent, DH, optimizedPars, perturbedDH, endEffector, lowerBounds, upperBounds)
            if nargin==9
               obj.type=type;
               obj.name=name;
               obj.parent=parent;
               obj.DH=DH;
               %obj.optimize=optimize;
               obj.optimizedPars=optimizedPars;
               obj.perturbedDH=perturbedDH;
               obj.endEffector=endEffector;
               obj.lowerBounds=lowerBounds;
               obj.upperBounds=upperBounds;
            else
                error(sprintf('Incorrect number of arguments inserted,expected 9, but got %d',nargin));
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