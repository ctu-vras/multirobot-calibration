classdef robot < handle
    
    properties
        name
        optProperties
        endEffectors={}
        joints={}
        structure={}
        home=pwd;
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
                        j=joints{curJoint{3}};
                    else
                        j=nan;
                    end
                    joints{jointId}=joint(curJoint{1},curJoint{2},j,curJoint{4},curJoint{5},curJoint{6},curJoint{3});
                    obj.joints{end+1}=joints{jointId};
                end
                obj.name=name;
                obj.optProperties=[];
                obj.structure=modelStructure;                
            else
                error(sprintf('Incorrect number of arguments inserted, expected 1, but got %d',nargin));
            end
        end
        
        %% load default paramaters and set joint etc.
        setRobot(robot);   
        
        %% Run optimization
        runOptimization(robot);
        
        %% Find joint by name
        function [joint,indexes]=findJoint(obj,name)
            %Returns instance of joints as cell array and coresponding indexes in robot.joints cell array
            fun=cellfun(@(x) isvector(strfind(x.name,name)), obj.joints);
            indexes=find(fun);
            joint=cell(size(indexes,2),1);
            for index=1:size(indexes,2)
                joint{index}=obj.joints{indexes(index)};
            end
        end
       
        %% Find joint by type
        function [joint,indexes]=findJointByType(obj,type)
            %Returns instance of joints as cell array and corresponding indexes in robot.joints cell array
            fun=cellfun(@(x) x.type==types.(type), obj.joints);
            indexes=find(fun);
            joint=cell(size(indexes,2),1);
            for index=1:size(indexes,2)
                joint{index}=obj.joints{indexes(index)};
            end
        end
        
        %% Find joint by group
        function [joint,indexes]=findJointByGroup(obj,type)
            %Returns instance of joints as cell array and corresponding indexes in robot.joints cell array
            fun=cellfun(@(x) x.group==group.(type), obj.joints);
            indexes=find(fun);
            joint=cell(size(indexes,2),1);
            for index=1:size(indexes,2)
                joint{index}=obj.joints{indexes(index)};
            end
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
        [init, lb, ub]=prepareDH(r, pert, distribution, optim);
        
        %% Prepare datasets
        [training_set_indexes, testing_set_indexes, dataset]=prepareDataset(robot, optim, funcname, varargin);
        
        
    end
    
end