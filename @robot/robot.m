classdef robot < handle
    
    properties
        name
        joints={}
        structure={}
    end
    
    
    methods
        %% Constructor
        function obj = robot(name)
            if nargin==1
                addpath(genpath(pwd));
                func=str2func(name);
                [name, structure, modelStructure]=func();
                joints=cell(size(structure,2));
                for jointId=1:size(structure,2)
                    curJoint=structure{jointId};
                    if ~isnan(curJoint{3})
                        parentName=curJoint{3};
                        [j,parentId]=obj.findJoint(parentName);
                        parentId=find(parentId);
                        if isempty(j)
                            error('Joint %s does not exist\n',parentName);
                        end
                        j=j{1};
                    else
                        j=nan;
                        parentId=0;
                    end
                    joints{jointId}=joint(curJoint{1},curJoint{2},j,curJoint{4},curJoint{5},curJoint{6},parentId);
                    obj.joints{end+1}=joints{jointId};
                end
                obj.name=name;
                obj.structure=modelStructure;                
            else
                error('Incorrect number of arguments inserted, expected 1, but got %d',nargin);
            end
        end
        
        %% Find joint by id
        function [joint,indexes]=findJointById(obj,id)
            %Returns instance of joints as cell array and coresponding indexes in robot.joints cell array
            objJoints = [obj.joints{:}];
            indexes = find([objJoints.DHindex]==id);
            joint = {obj.joints{indexes}};
        end
        
        %% Find joint by name
        function [joint,indexes]=findJoint(obj,name)
            %Returns instance of joints as cell array and coresponding indexes in robot.joints cell array
            objJoints = [obj.joints{:}];
            indexes = strcmp({objJoints.name}, name);
            joint = {obj.joints{indexes}};
        end
       
        %% Find joint by type
        function [joint,indexes]=findJointByType(obj,type)
            %Returns instance of joints as cell array and corresponding indexes in robot.joints cell array
            objJoints = [obj.joints{:}];
            indexes = strcmp({objJoints.type}, type);
            joint = {obj.joints{indexes}};
        end
        
        %% Print tables with description
        printTables(obj, tableType);
        
        %% Find joint by group
        function [joint,indexes]=findJointByGroup(obj,group)
            %Returns instance of joints as cell array and corresponding indexes in robot.joints cell array
            objJoints = [obj.joints{:}];
            indexes = strcmp({objJoints.group}, group);
            joint = {obj.joints{indexes}};
        end
        
        %% Function to print joints in format (name, index in cell array)
        function print(obj)
            % Type is 'joint' for joints/ 'ee' for end-effectors
            cellArray=obj.joints;
            for jointId=1:size(cellArray,2)
                fprintf('%s %d\n',cellArray{jointId}.name,jointId);
            end
        end
        
        %% Change given parametr of joint, selected by name or type
        function changeJoint(obj,type, name, parameter, newValue) 
            %type - str name/type
            %name - str name of the joint,type or string it contains
            %parameter - string of name of the parameter to ne changed
            %newValue - cell array of values, {a} for the same value a to
            %be changed to all found joints or {a,b...len(joints)} to
            %different value for each joint
            if strcmp(type,'name')
                [joint, ~] = findJoint(obj,name);
            elseif strcmp(type,'type')
                [joint, ~] = findJointByType(obj,name);
            end
            len=size(joint,1);
            for i=1:len
                if size(newValue,1)==len
                    joint{i}.(parameter)=newValue{i};
                else
                    joint{i}.(parameter)=newValue{1};
                end
            end
            fprintf('Changed %d joints\n',len);
        end
        
        %% Visualize configurations
        visualizeConf(robot);
        
        %% Nao specific visualizations
        visualizeNAO(robot,type,name);
        
        %% Show Matlab model
        showModel(robot, angles, varargin);
        
        %% Show graph model
        showGraphModel(robot);
        
        %% Prepare DH, bounds and perts
        [init, lb, ub]=prepareDH(robot, pert, optim, funcname);
        
        %% Prepare datasets
        [training_set_indexes, testing_set_indexes, datasets]=prepareDataset(r,optim, funcname, varargin)
        
        %% Prepare vector of parameters for optimization
        [opt_pars, lb_pars, up_pars, whitelist, start_dh] = createWhitelist(robot, dh_pars, lb_pars, ub_pars, optim, funcname);
    end
    
end