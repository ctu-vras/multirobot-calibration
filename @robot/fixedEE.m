classdef fixedEE
   
    properties 
        name
        parent
        transformation
    end
    
    methods
        function obj = fixedEE(name, parent, transformation)
           if nargin==3
              obj.name=name;
              obj.parent=parent;
              obj.transformation=transformation;
           else
               error(sprintf('Incorrect number of arguments inserted,expected 3, but got %d',nargin));
           end
        end
    end
    
end