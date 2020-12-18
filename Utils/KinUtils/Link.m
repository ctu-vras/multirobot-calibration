classdef Link < handle
    % LINK is the class for representing the links in a robot. Created
    % for use in the Robot class. 
    % See also: ROBOT
    %
    % LINK Properties:
    %   name - String name of the links
    %   parent - Pointer to parent
    %   parentId - Int id of parent
    %   DHindex - Int id in kinematics/WL/Bounds table for given 'group'
    %   type - 'type' of the links...see types.m
    %   group - 'group' of the link...see group.m
    %
    % LINK Methods:
    %   computeRTMatrix - iterates over the parents of the input link and 
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
        function obj = Link(name, type, parent, DHindex, group,  parentId)
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
            % COMPUTERTMATRIX iterates over parents of the input link and 
            % returns RT matrix
            %   DH...structure with DH
            %   angles...structure with link angles
            %   group...group of the input link
            %   R...4x4 RT matrix to input link
            %   par...link, parent of the last used link
            idx = nan(1,size(DH,1));
            id=1;
            % iterate while group of current link is the same as group of
            % input link and current link is not base
            while strcmp(obj.group,group) && ~strcmp(obj.type,types.base)
               idx(id)=obj.DHindex;
               id=id+1;
               obj=obj.parent;
            end
            %Get rid of nans
            idx(isnan(idx))=[];
            %Reverse order of the ids to get matrix to input link 
            DH=DH(idx(end:-1:1),:);
            %Add joint angles
            DH(:,6)=DH(:,6)+angles';
            %compute RT matrix
            R=dhpars2tfmat(DH);
            par=obj;
            %If link is base - no parent
            if strcmp(par.type,types.base)
                par=nan;
            end
            
        end
        
    end

end