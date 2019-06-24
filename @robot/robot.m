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
        function obj = robot(robotName)
            splittedHome=strsplit(obj.home,'/');            
%             if ~strcmp(splittedHome{end},'CalibAll')
%                 error('Please, create instance in GIT_FOLDER/MultiRobot folder');
%             end
            if nargin==1
                if ismember(robotName,{'nao','icub','motoman'})
                    obj.name=robotName;
                else
                    error('Not a valid robot name');
                end
                %addpath(genpath('../Opt'));
                %addpath(genpath('../MultiRobot'));
                %addpath(genpath('../Visualization'));
                addpath(genpath(pwd));
                setRobot(obj);
                
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
            fun=cellfun(@(x) strcmp(x.type,type), obj.joints);
            indexes=find(fun);
            joint=cell(size(indexes,2),1);
            for index=1:size(indexes,2)
                joint{index}=obj.joints{indexes(index)};
            end
        end
        
        %% Function to print joints/end-effectors in format (name, index in cell array)
        function print(obj,type)
            % Type is 'joint' for joints/ 'ee' for end-effectors
            if strcmp(type,'joint')
                cellArray=obj.joints;
            elseif strcmp(type,'ee')
                cellArray=obj.endEffectors;
            end
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
                [joint, ~] = findJointByNaType(obj,name);
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
        showModel(robot, structure, angles, varargin);
        
        %% Dataset divide
        [training,testing]=splitDataset(robot, len, repetitions, batchSize);
        
    end
    
end