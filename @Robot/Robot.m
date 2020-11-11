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
        function obj = Robot(name)
            % Constructor of robot creates the robot from loading function
            %   name...string name of loading function for given robot
            if nargin==1
                % add all framework to path
                addpath(genpath(pwd));
                % call loading function
                func=str2func(name);
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
                assert(isfield(structure, 'DH') && isfield(structure, 'WL') && isfield(structure, 'H0') ...
                     && isfield(structure, 'bounds'), ...
                    'Robot structure is incomplete, it must contains: DH, WL, H0 and bounds')
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
                       temp = obj.structure.DH.(fname{1});
                       temp(~isnan(temp)) = 1;
                       obj.structure.WL.(fname{1}) = temp;
                    end
                end
                obj.structure.DH = sortStruct(obj.structure.DH);
                obj.structure.WL = sortStruct(obj.structure.WL);
                obj.structure.bounds = orderfields(obj.structure.bounds);
                obj.structure.defaultDH = sortStruct(obj.structure.defaultDH);
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
        printTables(obj, tableType);
                 
        %% Show Matlab model
        showModel(robot, angles, varargin);
        
        %% Show graph model
        showGraphModel(robot, ax);
        
        %% Prepare DH, bounds and perts
        [init, lb, ub]=prepareDH(robot, pert, optim, funcname);
        
        %% Prepare datasets
        [training_set_indexes, testing_set_indexes, datasets, datasets_out]=prepareDataset(r,optim, chains, funcname, varargin)
        
        %% Prepare vector of parameters for optimization
        [opt_pars, lb_pars, up_pars, whitelist, start_dh] = createWhitelist(robot, dh_pars, lb_pars, ub_pars, optim, chains, jointTypes, funcname);
    
        %% Get result DH and its correction from the initial one
        [results, corrs] = getResultDH(robot, opt_pars, start_dh, whitelist, optim)
    end
    
end