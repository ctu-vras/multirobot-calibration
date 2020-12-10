function fig = showModel(r, varargin)
    % SHOWMODEL shows virtual model of the robot based on input joint
    %           angles.
    %   INPUT - angles - cellarray of 1xN arrays joint in order corresponding
    %                    to order of 'groups' in Robot.structure.DH, 
    %                    where each array contains joint angles in the same 
    %                    order as joints in given DH fields. If there are
    %                    less arrays than joint 'group', only the same number
    %                    of 'groups' will be shown.
    %                    E.g. {[th_1_chain1,...,th_n_chain1],...,[]}
    %         - varargin - Uses MATLABs argument parser, with these pairs:
    %                       - 'skin' - 1/0 to visualize skin/markers
    %                                - Default: 0
    %                       - 'dual' - 1/0 to visualize dual robot
    %                                - Default: 0
    %                       - 'dualDH' - structure in same format as
    %                                    Robot.structure.DH with DH for
    %                                    second robot
    %                                  - Default: []
    %                       - 'figName' - string name of the figure
    %                                   - Default: ''
    
    % argument parser
    p=inputParser;
    if ~isfield(r.structure, 'defaultJoints')
        r.structure.defaultJoints = {};
    end
    addOptional(p,'angles',  r.structure.defaultJoints);
    addParameter(p,'specialGroup','');
    addParameter(p,'dual',0,@isnumeric);
    addParameter(p,'dualDH',[]);
    addParameter(p,'units','m', @(x) any(validatestring(x,{'m','mm'})));
    addParameter(p,'figName','');
    addParameter(p, 'naoSkin', 0);
    addParameter(p, 'showText', 1);
    parse(p, varargin{:});
    angles = p.Results.angles;
    units = p.Results.units;
    showText = p.Results.showText;
    if strcmp(units,'m')
        coef = 1;
    else
        coef = 1000;
    end
    % Color settings
    LINK_COLORS = [[0.5 0.5 0.8];[0.8 0.5 0.5]]; % blueish and redish
    SKIN_COLORS = {'b', 'r'};

    %% INIT AND PLOT BODY PARTS

    % Each body part has the same structure:
    %     name = the name of the body_part;
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
    
    % Try to find opened figure with given name
    fig = findobj( 'Type', 'Figure', 'Name', p.Results.figName);
    %If found, set as current fig
    if length(fig)>0
        set(0, 'CurrentFigure', fig);
    %else create new fig
    else
        fig=figure('Name',p.Results.figName,'Position', [1436 30 1300 750]);
    end
    
    
    %axes  ('Position', [0 0 1 1]); 
    %setAxes(fig.CurrentAxes);
    hold on; grid on;
    xlabel(['x (',units,')']); ylabel(['y (',units,')']),zlabel(['z (',units,')']);
    hold on
    
    %% ROOT - plot the original root reference frame
    root = eye(4);
    DrawRefFrame(root,1,0.04*coef, 1, 'hat','ROOT');

    %% Draw
    for robots=1+p.Results.dual:-1:1
        fnames=fieldnames(r.structure.DH);
        angles_ = angles;
        if robots==1
            DH_ = r.structure.DH;
        else
            str = struct();
            if size(p.Results.dualDH,1)==0
                DH_=r.structure.defaultDH;
             %else use input DH
            else
                for name=1:size(fnames,1)
                   DH_.(fnames{name})=p.Results.dualDH.(fnames{name}); 
                end
            end
        end
        fnames(contains(fnames,'Skin') |...
              contains(fnames,'Middle')...
            | contains(fnames,'Index') | contains(fnames,'Thumb') | contains(fnames,'Markers') )= [];
        
        fnames = fnames(1:(size(angles,2)+isfield(DH_, 'torso')));
        if ~isfield(DH_,'torso')
            DH_.torso=[0 0 0 0]; 
        end
        angles_ = {zeros(1,size(DH_.torso, 1)),angles{:}};
        [DH, types_] = padVectors(DH_);
        if ~strcmp(fnames{1},'torso') && strcmp(fnames{end},'torso')
            fnames={'torso', fnames{1:end-1}}';
        elseif ~strcmp(fnames{1},'torso') && ~strcmp(fnames{end},'torso')
            fnames={'torso', fnames{1:end}}';
        end

        
        %contains(fnames, 'Finger') |
        % iterate over minimum from all groups or legth of 'angles'
        
        if ~strcmp(p.Results.specialGroup, '')
            fnames = {fnames{:}, p.Results.specialGroup{:}}';
            for gr=p.Results.specialGroup
                gr = gr{1};
                joints = r.findJointByGroup(gr);
                angles_ = {angles_{:}, zeros(1,size(joints, 2))};
            end
            
           
        end
        str.specialGroup = p.Results.specialGroup;
        for i=1:length(fnames)
            name=fnames{i};
            DH.(name)(:,1:3) = DH.(name)(:,1:3).*coef;
            if strcmp(name, 'torso')
                str.refFrame = 1;
            else
                str.refFrame = 0;
            end
            jointNames = {};
            % find joint from given group to save their names
            joints=findJointByGroup(r,name);
            for joint=1:size(joints,2)
                j=joints(joint);
                %if strcmp(j{1}.type,types.joint) || strcmp(j{1}.type,types.eye)...
                %        || strcmp(j{1}.type,types.finger || strcmp(j{1}.type,types.)
                jointNames{end+1} = j{1}.name;
                %end
            end 
            theta.(name) = reshape([angles_{i}], 1, []);
            str.link = name;
            str.DH = DH;
            str.theta = theta;
            str.jointNames = jointNames;
            str.LinkColor = LINK_COLORS(robots,:);
            str.refFrameSize = 0.01*coef;
            str.types=types_;
            str.naoSkin = p.Results.naoSkin;
            FwdKin(r, str, coef, showText);
        end
        fnames = {'rightArmSkin', 'leftArmSkin', 'torsoSkin', 'headSkin'};
        if p.Results.naoSkin
            for i=1:length(fnames)
                name=fnames{i};
                DH.(name)(:,1:3) = DH.(name)(:,1:3).*coef;
                if strcmp(name, 'torso')
                    str.refFrame = 1;
                else
                    str.refFrame = 0;
                end
                jointNames = {};
                % find joint from given group to save their names
                joints=findJointByGroup(r,name);
                for joint=1:size(joints,2)
                    j=joints(joint);
                    %if strcmp(j{1}.type,types.joint) || strcmp(j{1}.type,types.eye)...
                    %        || strcmp(j{1}.type,types.finger || strcmp(j{1}.type,types.)
                    jointNames{end+1} = j{1}.name;
                    %end
                end  
                theta.(name) = zeros(1,size(joints, 2));
    %             theta.(name) = reshape([angles_{i}], 1, []);
                str.link = name;
                str.DH = DH;
                str.theta = theta;
                str.jointNames = jointNames;
                str.LinkColor = LINK_COLORS(robots,:);
                str.SkinColor = SKIN_COLORS{robots};
                str.refFrameSize = 0.01*coef;
                str.types=types_;
                str.naoSkin = p.Results.naoSkin;
                FwdKin(r, str, coef, showText);
            end
        end
    end

    view([90,0]);
    axis equal;
    axis tight;
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
    %if nargin > 7
    %    saveas(gcf, varargin{1});
    %end
end