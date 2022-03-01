classdef Robot < handle
    % ROBOT is the robot instance class for calibration
    
    % Robot Properties:
    %   name  - String name of the robot 
    %   links - Cell array of link classes
    %   structure - Structure containing kinematics, WL and bounds
    % Robot Methods:
    %   findLink - Returns instance of links with given name
    %   findLinkById - Returns instance of links with given Id
    %   findLinkByType - Returns instance of links with given type
    %   findLinkByGroup - Returns instance of links with given group
    %   print - Displays Robot.links as 'linkName linkId'
    %   printTables - Displays tables from Robot.structure as 
    %                 'a, d, alpha, theta linkName'
    %   showModel - Shows virtual model of the robot based on input link
    %               angles.
    %   showGraphModel - Shows tree-based graph of given robot
    %   prepareKinematics - Returns kinematics tables with/without perturbations and tables
    %               with bounds
    %   prepareDataset - Returns datasets in universal format, together with
    %                    training/testing indexes
    %   getResultKinematics - Returns final kinematics parameters and correction of each
    %                 run
    %   createWhitelist - selects whitelist and returns selected parameters based 
    %                on the whitelist, together with lower/upper bounds for the
    %                parameters.
    
    
    % Copyright (C) 2019-2021  Jakub Rozlivek and Lukas Rustler
    % Department of Cybernetics, Faculty of Electrical Engineering, 
    % Czech Technical University in Prague
    %
    % This file is part of Multisensorial robot calibration toolbox (MRC).
    % 
    % MRC is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Lesser General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % MRC is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Lesser General Public License for more details.
    % 
    % You should have received a copy of the GNU Leser General Public License
    % along with MRC.  If not, see <http://www.gnu.org/licenses/>.
    
    properties
        name 
        links={} 
        structure={} 
        linksStructure=[];
    end
    
    
    methods
        %% Constructor
        function obj = Robot(funcname)
            % Constructor of robot creates the robot from loading function
            %   name...string name of loading function for given robot
            if nargin==1
                % add all framework to path
                %addpath(genpath(pwd));
                % call loading function
                func=str2func(funcname);
                [name, linksStructure, structure]=func();
                links=cell(size(linksStructure,2));
                % Create links from Robot.structure
                for linkId=1:size(linksStructure,2)
                    curlink=linksStructure{linkId};
                    if ~isnan(curlink{3})
                        parentName=curlink{3};
                        % find parent by string Name
                        [j,parentId]=obj.findLink(parentName);
                        parentId=find(parentId);
                        if isempty(j)
                            error('Link %s does not exist\n',parentName);
                        end
                        j=j{1};
                    else
                        j=nan;
                        parentId=0;
                        assert(strcmp(curlink{2}, types.base), 'Link without parent must be of type: ''base''')
                    end
                    %Call link constructor
                    links{linkId}=Link(curlink{1},curlink{2},j,curlink{4},curlink{5},parentId);
                    %Add new link to cellarray
                    obj.links{end+1}=links{linkId};
                end
                obj.name=name;
                for link = 1:size(linksStructure,2)
                obj.linksStructure = [obj.linksStructure, linksStructure{link}'];
                end
                obj.linksStructure = obj.linksStructure';
                % robot default kinematics (permanent)             
                structure.defaultKinematics = structure.kinematics;
                assert(isfield(structure, 'kinematics') && isfield(structure, 'WL') && isfield(structure, 'bounds'), ...
                    'Robot structure is incomplete, it must contains: kinematics, WL, and bounds')
                obj.structure=structure; 
                fnames = fieldnames(obj.structure.kinematics);
                WLfnames = fieldnames(obj.structure.WL);
                for fname=WLfnames'
                    if ~any(ismember(fnames, fname{1}))
                       obj.structure.WL = rmfield(obj.structure.WL, fname{1});
                    end
                end

                for fname=fnames'
                    if ~any(ismember(WLfnames, fname{1}))
                       obj.structure.WL.(fname{1}) = zeros(size(obj.structure.kinematics.(fname{1})));
                    end
                end
                obj.structure.kinematics = group.sort(obj.structure.kinematics);
                obj.structure.WL = group.sort(obj.structure.WL);
                obj.structure.bounds = orderfields(obj.structure.bounds);
                obj.structure.defaultKinematics = group.sort(obj.structure.defaultKinematics);
            else
                error('Incorrect number of arguments inserted, expected 1, but got %d',nargin);
            end
        end
        
        %% Find link by id
        function [link,indexes]=findLinkById(obj,id)
            % FINDLINKBYID returns instance of links with given Id
            %   INPUT - id - int
            %   OUTPUT - link - 1xN cellarray of links with given Id
            %          - indexes - 1xN array with corresponding indexes
            objLinks = [obj.links{:}];
            indexes = find([objLinks.DHindex]==id);
            link = {obj.links{indexes}};
        end
        
        %% Find link by name
        function [link,indexes]=findLink(obj,name)
            % FINDLINK returns instance of links with given name
            %   INPUT - name - string name of the link
            %   OUTPUT - link - 1xN cellarray of links with given name
            %          - indexes - 1xN array with corresponding indexes
            objLinks = [obj.links{:}];
            indexes = strcmp({objLinks.name}, name);
            link = {obj.links{indexes}};
        end
       
        %% Find link by type
        function [link,indexes]=findLinkByType(obj,type)
            % FINDLINKBYTYPE returns instance of links with given type
            %   INPUT - type - string type of the link
            %   OUTPUT - link - 1xN cellarray of links with given type
            %          - indexes - 1xN array with corresponding indexes
            objLinks = [obj.links{:}];
            indexes = strcmp({objLinks.type}, type);
            link = {obj.links{indexes}};
        end
        
        %% Find link by group
        function [link,indexes]=findLinkByGroup(obj,group)
            % FINDLINKBYGROUP returns instance of links with given group
            %   INPUT - type - string type of the group
            %   OUTPUT - link - 1xN cellarray of links with given group
            %          - indexes - 1xN array with corresponding indexes
            objLinks = [obj.links{:}];
            indexes = strcmp({objLinks.group}, group);
            link = {obj.links{indexes}};
        end
        %% Function to print links in format (name, index in cell array)
        function print(obj)
            % PRINT displays Robot.links as 'linkName linkId'
            cellArray=obj.links;
            for linkId=1:size(cellArray,2)
                fprintf('%s %d\n',cellArray{linkId}.name,linkId);
            end
        end
        
        %% Print tables with description
        function printTables( robot, tableType )
        % PRINTTABLES displays tables from Robot.structure as 
        %             'a, d, alpha, theta linkName'
        %   INPUT - tableType - string 'kinematics'/'WL'

        %get all fieldnames
        fnames=fieldnames(robot.structure.(tableType));
        for fname=1:length(fnames)
            %Get right table
            table=robot.structure.(tableType).(fnames{fname});
            %disp group name
            fprintf('%s\n',(fnames{fname}));
            %find all links in given group
            links=robot.findLinkByGroup(fnames{fname});
            %print in given format
            for j=1:size(table,1)
                fprintf('%-5.2f %-5.2f %-5.2f %-5.2f %-s\n',table(j,:),links{j}.name);
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
            treeVec=zeros(length(r.links),1);
            count = 1;
            for link=r.links
               if ~isnan(link{1}.parentId)  %parent of root is 0
                   treeVec(count)=link{1}.parentId; %from link.parent
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
                if ~strcmp(r.links{i}.type,types.triangle) && ~strcmp(r.links{i}.type,types.taxel) ...
                        && ~strcmp(r.links{i}.group, group.leftMarkers) && ~strcmp(r.links{i}.group, group.rightMarkers) %do not display for triangles, because there are too many of them
                    text(ax,x(i)+0.015,y(i),r.links{i}.name);
                end
            end
            title(ax,sprintf('Structure of %s robot',r.name))
            xticks(ax,[])
            yticks(ax,[])
            set(findall(ax, '-property', 'FontSize'), 'FontSize', 16)
        end
        
        %% Show Matlab model
        fig = showModel(robot, varargin);
        
        %% Prepare kinematics, bounds and perts
        [init, lb, ub]=prepareKinematics(robot, pert, optim, funcname);
        
        %% Prepare datasets
        [training_set_indexes, testing_set_indexes, datasets, datasets_out]=prepareDataset(r,optim, chains, approaches, funcname, varargin)
        
        %% Prepare vector of parameters for optimization
        [opt_pars, lb_pars, up_pars, whitelist, start_dh] = createWhitelist(robot, dh_pars, lb_pars, ub_pars, optim, chains, linkTypes, funcname);
    
        %% Get result kinematics and its correction from the initial one
        [results, corrs, start_dh] = getResultKinematics(robot, opt_pars, start_dh, whitelist, optim)
    end
    
end