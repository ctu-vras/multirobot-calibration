function showModel(r, angles, varargin)
    % angles - cell array, {[th_1_chain1,...,th_n_chain1],...,[]}
    % 'skin' - 1/0 for skin/markers, 'dual' - 1/0 for dual robot
    close all;
    p=inputParser;
    addRequired(p,'angles');
    addParameter(p,'skin',0,@isnumeric);
    addParameter(p,'dual',0,@isnumeric);
    addParameter(p,'dualDH',[]);
%     if  size(varargin,1)> 0
%         if strcmp(varargin{1},'skin')
%             MARKERS_ON=1;
%         else
%             MARKERS_ON=0;
%         end
%     else
%         MARKERS_ON=0;
%     end
    parse(p,angles,varargin{:});
    if p.Results.skin %Skin or Markers
        if strcmp(r.name,'nao')
            SKIN_ON=1;
            MARKERS_ON=0;
        else
            MARKERS_ON=1;
            SKIN_ON=0;
        end
    else
        SKIN_ON=0;
        MARKERS_ON=0;
    end
        
    % settings
    LINK_COLOR = [0.5 0.5 0.8]; % blueish
    LINK_COLOR_2 = [0.8 0.5 0.5]; % redish
    %MARKERS_ON = false;

    %% INIT AND PLOT BODY PARTS

    % Each body part has the same structure:
    %     name = the name of the body_part;
    %     H0   = is the roto-translation matrix in the origin of the chain (if the body part is attached
    %            to another one, typically the last reference frame of the previous body part goes here)
    %     DH   = it's the parameter matrix. Each row has 4 DH parameters (a, d, alpha, offset), thus each
    %            row completely describes a link. The more rows are added, the more links are attached.
    %     Th   = it's the joint values vector (as read from the encoders)
    %  Please note that everything is in SI units (i.e. meters and radians),
    %  unless the variables have the _deg suffix (the eventual conversions will be handled by
    %  the algorithm itself). However, the FwdKin.m works internally with
    %  mm and so the chains and transforms returned have translations in mm.

    % The plotting is done by the FwdKin function, which also outputs the chain
    % of the corresponding body part. This is needed as input to subsequent
    % chains (e.g. torso is needed for arm and head chains).

    figure('Position', [1436 30 1300 750]);
    axes  ('Position', [0 0 1 1]); hold on; grid on;
    xlabel('x (mm)'); ylabel('y (mm)'),zlabel('z (mm)');

    %% ROOT - plot the original root reference frame
    root = eye(4);
    DrawRefFrame(root,1,40,'hat','ROOT');

    %% TORSO
    robot.tor.name = 'torso';%'root_to_torso';
    robot.tor.H0 = r.structure.H0;
    if isfield(r.structure.DH,'torso')
        torso_dh=r.structure.DH.torso;
    else
       torso_dh=[0 0 0 0]; 
    end
%     index = 1;
%     joints=findJointByGroup(r,'torso');
%     for joint=1:size(joints,1)
%         j=joints(joint);
%         if(j{1}.type == types.joint)
%             torso_dh(index,:)=j{1}.DH;
%             index = index + 1;
%         end
%     end    
    robot.tor.DH = torso_dh;
    robot.tor.Th = zeros(1,size(torso_dh, 1)); % only first joint go here
    robot.tor.LinkColor = LINK_COLOR;
    robot.chain.rootToTorso = FwdKin(robot.tor,'noFrames',SKIN_ON); % we don't draw this chain common to all

    %% Other joints
    structure=r.structure.DH;
    fnames=fieldnames(structure);
    fnames(strcmp(fnames, 'torso')) = [];
    for i=1:length(fnames)
        name=fnames{i};
        jointNames = {};
        joints=findJointByGroup(r,name);
        %index = 1;
        for joint=1:size(joints,1)
            j=joints(joint);
            if strcmp(j{1}.type,types.joint) || strcmp(j{1}.type,types.eye)
                jointNames{end+1} = j{1}.name;
                %structure.(name)(index,:)=j{1}.DH;
                %index = index + 1;
            end
        end 
        robot.(name).jointNames = jointNames;
        robot.(name).name = name;
        if((strcmp(name, 'leftEye') || strcmp(name, 'rightEye')) && isfield(structure,'head'))
            robot.(name).H0 = robot.chain.head.RFFrame{end};
        else
            robot.(name).H0 = robot.chain.rootToTorso.RFFrame{end};
        end
        robot.(name).H0(1:3,4) = robot.(name).H0(1:3,4)./1000; % converting the translational part from mm back to m
        robot.(name).DH = structure.(name);
        robot.(name).Th = [angles{i}];   % TODO: vyresit nulu navic
        robot.(name).LinkColor = LINK_COLOR;
        robot.chain.(name) = FwdKin(robot.(name),SKIN_ON);
    end
    
    if p.Results.dual
        fnames=fieldnames(r.structure.DH);
        if size(p.Results.dualDH,1)==0
            structure=r.structure.DH;
        else
            for name=1:size(fnames,1)
               structure.(fnames{name})=p.Results.dualDH{name}; 
            end
        end
            
        for i=1:length(fnames)
            name=fnames{i};
            jointNames = {};
            joints=findJointByGroup(r,name);
            index = 1;
            for joint=1:size(joints,1)
                j=joints(joint);
                if strcmp(j{1}.type,types.joint) || strcmp(j{1}.type,types.eye)
                    jointNames{end+1} = j{1}.name;
                    structure.(name)(index,:)=j{1}.DH;
                    index = index + 1;
                end
            end 
            robot.(name).jointNames = jointNames;
            robot.(name).name = name;
            if(strcmp(name, 'leftEye') || strcmp(name, 'rightEye'))
                robot.(name).H0 = robot.chain.head.RFFrame{end};
            else
                robot.(name).H0 = robot.chain.rootToTorso.RFFrame{end};
            end
            robot.(name).H0(1:3,4) = robot.(name).H0(1:3,4)./1000; % converting the translational part from mm back to m
            robot.(name).DH = structure.(name);
            robot.(name).Th = [angles{i}];   % TODO: vyresit nulu navic
            robot.(name).LinkColor = LINK_COLOR_2;
            robot.chain.(name) = FwdKin(robot.(name),SKIN_ON);
        end
    end
    %% MARKERS
    if MARKERS_ON
        markers = r.structure.markers

        r_ee = robot.chain.rightArm.RFFrame{end};
        r_ee(1:3,4) = r_ee(1:3,4)./1000; % converting the translational part from mm back to m
        r_markers = markers2sphere(markers, r_ee, true);

        l_ee = robot.chain.leftArm.RFFrame{end};
        l_ee(1:3,4) = l_ee(1:3,4)./1000; % converting the translational part from mm back to m
        l_markers = markers2sphere(markers, l_ee, true);       
    end

    view([90,0]);
    axis equal;
    
    %if nargin > 7
    %    saveas(gcf, varargin{1});
    %end
end