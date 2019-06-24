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
    robot.tor.H0 = [1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];
    robot.tor.DH = [0.0, 0.0, 0.0, 0.0];
    robot.tor.Th = 0; % only first joint go here
    robot.tor.LinkColor = LINK_COLOR;
    robot.chain.rootToTorso = FwdKin(robot.tor,'noFrames',SKIN_ON); % we don't draw this chain common to all

    %% Other joints
    structure=r.structure;
    fnames=fieldnames(structure);
    for i=1:length(fnames)
        name=fnames{i};
        joints=findJointByGroup(r,name);
        for joint=1:size(joints,1)
            j=joints(joint);
            if j{1}.type==types.joint
                structure.(name)(joint,:)=j{1}.DH;
            end
        end 
        robot.(name).name = name;
        robot.(name).H0 = robot.chain.rootToTorso.RFFrame{end};
        robot.(name).H0(1:3,4) = robot.(name).H0(1:3,4)./1000; % converting the translational part from mm back to m
        robot.(name).DH = structure.(name);
        robot.(name).Th = [robot.tor.Th,angles{i}];
        robot.(name).LinkColor = LINK_COLOR;
        robot.chain.(name) = FwdKin(robot.(name),SKIN_ON);
    end
    
    if p.Results.dual
        fnames=fieldnames(r.structure);
        if size(p.Results.dualDH,1)==0
            structure=r.structure;
        else
            for name=1:size(fnames,1)
               structure.(fnames{name})=p.Results.dualDH{name}; 
            end
        end

        for i=1:length(fnames)
            name=fnames{i};
            robot.(name).name = name;
            robot.(name).H0 = robot.chain.rootToTorso.RFFrame{end};
            robot.(name).H0(1:3,4) = robot.(name).H0(1:3,4)./1000; % converting the translational part from mm back to m
            robot.(name).DH = structure.(name);
            robot.(name).Th = [robot.tor.Th,angles{i}];
            robot.(name).LinkColor = LINK_COLOR;
            robot.chain.(name) = FwdKin(robot.(name),SKIN_ON);
        end
    end
    %% MARKERS
    if MARKERS_ON
        tf_mk_01 = [-0.79466465  0.0         0.60704867  0.03200057;
         0.0         1.0         0.0         0.0;
        -0.60704867  0.0        -0.79466465 -0.04189075;
         0.0         0.0         0.0         1.0];
        tf_mk_02 = [ 0.82859264 -0.52748058  0.18761256  0.00989000;
        -0.52748058 -0.62324281  0.57734967  0.03043499;
        -0.18761256 -0.57734967 -0.79465016 -0.04188998;
         0.0         0.0         0.0         1.0        ];
        tf_mk_03 = [-0.17462117  0.85340379 -0.49113075 -0.02588996;
         0.85340379  0.37997199  0.35682385  0.01880997;
         0.49113075 -0.35682385 -0.79464918 -0.04188993;
         0.0         0.0         0.0         1.0        ];
        tf_mk_04 =[-0.17462117 -0.85340379 -0.49113075 -0.02588996;
        -0.85340379  0.37997199 -0.35682385 -0.01880997;
         0.49113075  0.35682385 -0.79464918 -0.04188993;
         0.0         0.0         0.0         1.0        ];
        tf_mk_05 = [ 0.82859264  0.52748058  0.18761256  0.00989000;
         0.52748058 -0.62324281 -0.57734967 -0.03043499;
        -0.18761256  0.57734967 -0.79465016 -0.04188998;
         0.0         0.0         0.0         1.0        ];
        tf_mk_06 =[-0.18760895  0.0          0.9822438  0.05177898;
         0.0         1.0         0.0         0.0;
        -0.98224380  0.0        -0.18760895 -0.00988981;
         0.0         0.0         0.0         1.0        ];
        tf_mk_07 =[ 0.88660172 -0.34901866  0.30351833  0.01599997;
        -0.34901866 -0.07421398  0.93417250  0.04924490;
        -0.30351833 -0.93417250 -0.18761227 -0.00988998;
         0.0         0.0         0.0         1.0        ];
        tf_mk_08 = [ 0.22269984  0.5647441  -0.79465016 -0.04188998;
         0.56474410  0.58968760  0.57734967  0.03043499;
         0.79465016 -0.57734967 -0.18761256 -0.00989000;
         0.0         0.0         0.0         1.0        ];
        tf_mk_09 = [ 0.22269984 -0.5647441  -0.79465016 -0.04188998;
        -0.56474410  0.58968760 -0.57734967 -0.03043499;
         0.79465016  0.57734967 -0.18761256 -0.00989000;
         0.0         0.0         0.0         1.0        ];
        tf_mk_10 = [ 0.88660172  0.34901866  0.30351833  0.01599997;
         0.34901866 -0.07421398 -0.93417250 -0.04924490;
        -0.30351833  0.93417250 -0.18761227 -0.00988998;
         0.0         0.0         0.0         1.0        ];
        tf_mk_11 = [ 0.46828713  0.38631371  0.79465016  0.04188998;
         0.38631371  0.71932543 -0.57734967 -0.03043499;
        -0.79465016  0.57734967  0.18761256  0.00989000;
         0.0         0.0         0.0         1.0        ];
        tf_mk_12 = [ 0.46828713 -0.38631371  0.79465016  0.04188998;
        -0.38631371  0.71932543  0.57734967  0.03043499;
        -0.79465016 -0.57734967  0.18761256  0.00989000;
         0.0         0.0         0.0         1.0        ];
        tf_mk_13 = [ 0.92242975  0.23874667 -0.30351833 -0.01599997;
         0.23874667  0.26518251  0.93417250  0.04924490;
         0.30351833 -0.93417250  0.18761227  0.00988998;
         0.0         0.0         0.0         1.0        ];
        tf_mk_14 = [ 0.18760895  0.0         -0.9822438 -0.05177898;
         0.0         1.0         0.0         0.0;
         0.98224380  0.0         0.18760895  0.00988981;
         0.0         0.0         0.0         1.0        ];
        tf_mk_15 = [ 0.92242975 -0.23874667 -0.30351833 -0.01599997;
        -0.23874667  0.26518251 -0.93417250 -0.04924490;
         0.30351833  0.9341725   0.18761227  0.00988998;
         0.0         0.0         0.0         1.0        ];
        tf_mk_16 = [ 0.86559523  0.09764982  0.49113075  0.02588996;
         0.09764982  0.92905396 -0.35682385 -0.01880997;
        -0.49113075  0.35682385  0.79464918  0.04188993;
         0.0         0.0         0.0         1.0       ];
        tf_mk_17 = [ 0.86559523 -0.09764982  0.49113075  0.02588996;
        -0.09764982  0.92905396  0.35682385  0.01880997;
        -0.49113075 -0.35682385  0.79464918  0.04188993;
         0.0         0.0         0.0         1.0        ];
        tf_mk_18 = [ 0.980387    0.06035608 -0.18761256 -0.00989000;
         0.06035608  0.81426316  0.57734967  0.03043499;
         0.18761256 -0.57734967  0.79465016  0.04188998;
         0.0         0.0         0.0         1.0        ];
        tf_mk_19 = [ 0.79466465  0.0        -0.60704867 -0.03200057;
         0.0         1.0         0.0         0.0;
         0.60704867  0.0         0.79466465  0.04189075;
         0.0         0.0         0.0         1.0        ];
        tf_mk_20 = [ 0.98038700 -0.06035608 -0.18761256 -0.00989000;
        -0.06035608  0.81426316 -0.57734967 -0.03043499;
         0.18761256  0.57734967  0.79465016  0.04188998;
         0.0         0.0         0.0         1.0        ];

        markers = {tf_mk_01, tf_mk_02, tf_mk_03, tf_mk_04, tf_mk_05, ...
            tf_mk_06, tf_mk_07, tf_mk_08, tf_mk_09, tf_mk_10, ...
            tf_mk_11, tf_mk_12, tf_mk_13, tf_mk_14, tf_mk_15, ...
            tf_mk_16, tf_mk_17, tf_mk_18, tf_mk_19, tf_mk_20};

        r_ee = robot.chain.right_arm.RFFrame{end};
        r_ee(1:3,4) = r_ee(1:3,4)./1000; % converting the translational part from mm back to m
        r_markers = markers2sphere(markers, r_ee, true);

        l_ee = robot.chain.left_arm.RFFrame{end};
        l_ee(1:3,4) = l_ee(1:3,4)./1000; % converting the translational part from mm back to m
        l_markers = markers2sphere(markers, l_ee, true);       
    end

    view([90,0]);
    axis equal;
    
    %if nargin > 7
    %    saveas(gcf, varargin{1});
    %end
end