classdef Joint < handle
    % JOINT is the class for representing the joints in a robot. Created
    % for use in the Robot class. 
    % See also: ROBOT
    %
    % JOINT Properties:
    %   name - String name of the joints
    %   parent - Pointer to parent
    %   parentId - Int id of parent
    %   DHindex - Int id in DH/WL/Bounds table for given 'group'
    %   type - 'type' of the joints...see types.m
    %   endEffector - true/false if joint is endEffector
    %   group - 'group' of the joint...see group.m
    %
    % JOINT Methods:
    %   computeRTMatrix - iterates over the parents of the input Joint and 
    %                     returns RT matrix
    properties
        name char  
        parent  
        parentId double 
        DHindex double
        type 
        group 
    end
    
    methods
        %% Constructor
        function obj = Joint(name, type, parent, DHindex, group,  parentId)
            % Constructor assings variables to class properties
               if(nargin == 6)
                   obj.type=type;
                   obj.name=name;
                   obj.parent=parent;
                   obj.DHindex=DHindex;
                   obj.group=group;
                   obj.parentId=parentId;
               end
        end
        
        %% Computes RT matrix to base
        function [R,par]=computeRTMatrix(obj, DH, angles, group)
            % COMPUTERTMATRIX iterates over parents of the input Joint and 
            % returns RT matrix
            %   DH...structure with DH
            %   angles...structure with joint angles
            %   group...group of the input Joint
            %   R...4x4 RT matrix to input Joint
            %   par...Joint, parent of the last used joint
            idx = nan(1,size(DH,1));
            id=1;
            % iterate while group of current joint is the same as group of
            % input joint and current joint is not base
            while strcmp(obj.group,group) && ~strcmp(obj.type,types.base)
               idx(id)=obj.DHindex;
               id=id+1;
               obj=obj.parent;
            end
            %Get rid of nans
            idx(isnan(idx))=[];
            %Reverse order of the ids to get matrix to input joint 
            DH=DH(idx(end:-1:1),:);
            %Add joint angles
            DH(:,6)=DH(:,6)+angles';
            %compute RT matrix
            R=dhpars2tfmat(DH);
            par=obj;
            %If joint is base - no parent
            if strcmp(par.type,types.base)
                par=nan;
            end
            
        end
        
    end

end