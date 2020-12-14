classdef Robot < handle
    % ROBOT is the main class for MultiRobot framework created in 2019.
    %   DOPSAT
    %
    % Robot Properties:
    %   name  - String name of the robot 
    %   joints - Cell array of Joint classes
    %   structure - Structure containing DH, WL and bounds
    % Robot Methods:
    %   findJoint - Returns instance of joints with given name
    %   findJointById - Returns instance of joints with given Id
    %   findJointByType - Returns instance of joints with given type
    %   findJointByGroup - Returns instance of joints with given group
    %   print - Displays Robot.joints as 'jointName jointId'
    %   printTables - Displays tables from Robot.structure as 
    %                 'a, d, alpha, theta jointName'
    %   showModel - Shows virtual model of the robot based on input joint
    %               angles.
    %   showGraphModel - Shows tree-based graph of given robot
    %   prepareDH - Returns DH tables with/without perturbations and tables
    %               with bounds
    %   prepareDataset - Returns datasets in universal format, together with
    %                    training/testing indexes
    %   getResultDH - Returns final DH parameters and correction of each
    %                 run
    %   createWhitelist - selects whitelist and returns selected parameters based 
    %                on the whitelist, together with lower/upper bounds for the
    %                parameters.
    properties
        name 
        joints={} 
        structure={} 
        jointsStructure=[];
    end
    
    
    methods
        %% Constructor
        function obj = Robot(funcname)
            % Constructor of robot creates the robot from loading function
            %   name...string name of loading function for given robot
            if nargin==1
                % add all framework to path
                addpath(genpath(pwd));
                % call loading function
                func=str2func(funcname);
                [name, jointsStructure, structure]=func();
                joints=cell(size(jointsStructure,2));
                % Create Joints from Robot.structure
                for jointId=1:size(jointsStructure,2)
                    curJoint=jointsStructure{jointId};
                    if ~isnan(curJoint{3})
                        parentName=curJoint{3};
                        % find parent by string Name
                        [j,parentId]=obj.findJoint(parentName);
                        parentId=find(parentId);
                        if isempty(j)
                            error('Joint %s does not exist\n',parentName);
                        end
                        j=j{1};
                    else
                        j=nan;
                        parentId=0;
                        assert(strcmp(curJoint{2}, types.base), 'Joint without parent must be of type: ''base''')
                    end
                    %Call Joint constructor
                    joints{jointId}=Joint(curJoint{1},curJoint{2},j,curJoint{4},curJoint{5},parentId);
                    %Add new joint to cellarray
                    obj.joints{end+1}=joints{jointId};
                end
                obj.name=name;
                for joint = 1:size(jointsStructure,2)
                obj.jointsStructure = [obj.jointsStructure, jointsStructure{joint}'];
                end
                obj.jointsStructure = obj.jointsStructure';
                % robot default DH (permanent)             
                structure.defaultDH = structure.DH;
                assert(isfield(structure, 'DH') && isfield(structure, 'WL') && isfield(structure, 'bounds'), ...
                    'Robot structure is incomplete, it must contains: DH, WL, and bounds')
                obj.structure=structure; 
                fnames = fieldnames(obj.structure.DH);
                WLfnames = fieldnames(obj.structure.WL);
                for fname=WLfnames'
                    if ~any(ismember(fnames, fname{1}))
                       obj.structure.WL = rmfield(obj.structure.WL, fname{1});
                    end
                end

                for fname=fnames'
                    if ~any(ismember(WLfnames, fname{1}))
                       obj.structure.WL.(fname{1}) = zeros(size(obj.structure.DH.(fname{1})));
                    end
                end
                obj.structure.DH = group.sort(obj.structure.DH);
                obj.structure.WL = group.sort(obj.structure.WL);
                obj.structure.bounds = orderfields(obj.structure.bounds);
                obj.structure.defaultDH = group.sort(obj.structure.defaultDH);
            else
                error('Incorrect number of arguments inserted, expected 1, but got %d',nargin);
            end
        end
        
        %% Find joint by id
        function [joint,indexes]=findJointById(obj,id)
            % FINDJOINTBYID returns instance of joints with given Id
            %   INPUT - id - int
            %   OUTPUT - joint - 1xN cellarray of Joints with given Id
            %          - indexes - 1xN array with corresponding indexes
            objJoints = [obj.joints{:}];
            indexes = find([objJoints.DHindex]==id);
            joint = {obj.joints{indexes}};
        end
        
        %% Find joint by name
        function [joint,indexes]=findJoint(obj,name)
            % FINDJOINT returns instance of joints with given name
            %   INPUT - name - string name of the joint
            %   OUTPUT - joint - 1xN cellarray of Joints with given name
            %          - indexes - 1xN array with corresponding indexes
            objJoints = [obj.joints{:}];
            indexes = strcmp({objJoints.name}, name);
            joint = {obj.joints{indexes}};
        end
       
        %% Find joint by type
        function [joint,indexes]=findJointByType(obj,type)
            % FINDJOINTBYTYPE returns instance of joints with given type
            %   INPUT - type - string type of the joint
            %   OUTPUT - joint - 1xN cellarray of Joints with given type
            %          - indexes - 1xN array with corresponding indexes
            objJoints = [obj.joints{:}];
            indexes = strcmp({objJoints.type}, type);
            joint = {obj.joints{indexes}};
        end
        
        %% Find joint by group
        function [joint,indexes]=findJointByGroup(obj,group)
            % FINDJOINTBYGROUP returns instance of joints with given group
            %   INPUT - type - string type of the group
            %   OUTPUT - joint - 1xN cellarray of Joints with given group
            %          - indexes - 1xN array with corresponding indexes
            objJoints = [obj.joints{:}];
            indexes = strcmp({objJoints.group}, group);
            joint = {obj.joints{indexes}};
        end
        %% Function to print joints in format (name, index in cell array)
        function print(obj)
            % PRINT displays Robot.joints as 'jointName jointId'
            cellArray=obj.joints;
            for jointId=1:size(cellArray,2)
                fprintf('%s %d\n',cellArray{jointId}.name,jointId);
            end
        end
        
        %% Print tables with description
        function printTables( robot, tableType )
        % PRINTTABLES displays tables from Robot.structure as 
        %             'a, d, alpha, theta jointName'
        %   INPUT - tableType - string 'DH'/'WL'

        %get all fieldnames
        fnames=fieldnames(robot.structure.(tableType));
        for fname=1:length(fnames)
            %Get right table
            table=robot.structure.(tableType).(fnames{fname});
            %disp group name
            fprintf('%s\n',(fnames{fname}));
            %find all joints in given group
            joints=robot.findJointByGroup(fnames{fname});
            %print in given format
            for j=1:size(table,1)
                fprintf('%-5.2f %-5.2f %-5.2f %-5.2f %-s\n',table(j,:),joints{j}.name);
            end
        end

        end
        
        %% Show graph model
        function showGraphModel(r, ax)
        % SHOWGRAPHMODEL shows tree-based graph of given robot
        %
        % INPUT - ax - matlab axes
            if(nargin < 2)
                ax = gca;
            end
            % init vector and to each index assing its parent
            treeVec=zeros(length(r.joints),1);
            count = 1;
            for joint=r.joints
               if ~isnan(joint{1}.parentId)  %parent of root is 0
                   treeVec(count)=joint{1}.parentId; %from Joint.parent
               end
               count = count + 1;
            end
            %Disp tree
            [x,y,~]=treelayout(treeVec);
            X = [x(2:end); x(treeVec(2:end))];
            Y = [y(2:end); y(treeVec(2:end))];
            plot (ax,x, y, 'ro', X, Y, 'r-');

            % Add names of each node
            for i=1:length(x)
                if ~strcmp(r.joints{i}.type,types.triangle) && ~strcmp(r.joints{i}.type,types.taxel) ...
                        && ~strcmp(r.joints{i}.group, group.leftMarkers) && ~strcmp(r.joints{i}.group, group.rightMarkers) %do not display for triangles, because there are too many of them
                    text(ax,x(i)+0.015,y(i),r.joints{i}.name);
                end
            end
            title(ax,sprintf('Structure of %s robot',r.name))
            xticks(ax,[])
            yticks(ax,[])
            set(findall(ax, '-property', 'FontSize'), 'FontSize', 16)
        end
        
        %% Show Matlab model
        fig = showModel(robot, varargin);
        
        %% Prepare DH, bounds and perts
        [init, lb, ub]=prepareDH(robot, pert, optim, funcname);
        
        %% Prepare datasets
        [training_set_indexes, testing_set_indexes, datasets, datasets_out]=prepareDataset(r,optim, chains, approaches, funcname, varargin)
        
        %% Prepare vector of parameters for optimization
        [opt_pars, lb_pars, up_pars, whitelist, start_dh] = createWhitelist(robot, dh_pars, lb_pars, ub_pars, optim, chains, jointTypes, funcname);
    
        %% Get result DH and its correction from the initial one
        [results, corrs, start_dh] = getResultDH(robot, opt_pars, start_dh, whitelist, optim)
    end
    
end