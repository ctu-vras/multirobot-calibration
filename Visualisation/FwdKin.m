% Edited by Alessandro Roncone
% Genova Oct 2013
% changes Matej Hoffmann, July 2017
function [RFFrame] = FwdKin(robot, str, coef)
% This function computes and displays the forward kinematics of a body part
% INPUT
%   body_part (struct) - the body part under consideration. Each body part has the same structure:
%     name = the name of the body_part;
%     H0   = is the roto-translation matrix in the origin of the chain (if the body part is attached
%            to another one, typically the last reference frame of the previous body part goes here)
%     DH   = it's the parameter matrix. Each row has 4 DH parameters (a, d, alpha, offset), thus each
%            row completely describes a link. The more rows are added, the more links are attached.
%     Th   = it's the joint values vector (as read from the encoders)
%  This function is expecting input (translations in the H0 and lengths and angles in DH) in SI units (meters and radians).
%  However, the lengths are converted to mm here and for the drawing of reference frames.
%
%   varargin - "noFrames" = do not draw any frames
%
% OUTPUT
%   chain (struct) - the resulted chain with everything inside it. It's divided by body parts.

    %% MISC STUFF
        ljnt  = 0.007*coef;               % joint pic length
        rjnt  = 0.002*coef;               % joint pic radius
        linkratio = 1/15;        % link dimension ratio
        linkTransparency = 0.2;
        LinkColor = str.LinkColor;
        refFrameSize = str.refFrameSize;
        JntColor   = [.7 .7 .7];  % RGB color of the joints


    %% PARAMETERS
        DH = str.DH;
        link = str.link;
        jointNames = str.jointNames;
        theta = str.theta;
        refFrame = str.refFrame;
        H0 = robot.structure.H0;
        [DH, types] = padVectors(DH);
        %DH.(link)(:,1:2) = DH.(link)(:,1:2).*1000;
        %DH(:,1:2) = DH(:, 1:2).*1000;
%         if ~isempty(jointNames)
%             if ~strcmp(link, 'torso')
%                 joint = robot.findJoint(jointNames{1});
%                 joint = joint{1}.parent;
%                 if ~strcmp(joint.type, 'base')
%                     H0 = getTF(DH,joint,[],theta, H0);
%                 end
%                 stopGroup = joint.group;
%             else
%                 stopGroup = '';
%             end
%             
%         else
%             stopGroup = '';
%         end
        %%% THETAS
%         thetas = theta.(link)'
%         offs = DH.(link)(:,4)
%         thet = thetas + offs;
        try
            thetas = theta.(link)';
            offs = DH.(link)(:,4);
            thet = thetas + offs;
            theta.dummy = [0;0];
        catch ME
            msg = ['Body part: ', link, '\nActual number of joint angles: ', ...
                num2str(size(offs,1)), '\nNumber of joint angles inserted: ', ...
                num2str(size(theta.(link),2)), '\nInserted joint angles: ', num2str(theta.(link))] ;
            causeException = MException('MATLAB:myCode:dimensions',msg);
            ME = addCause(ME,causeException);
            rethrow(ME);
        end
        
        
        
        %%% CHAIN
        RFFrame  = cell(1,size(DH.(link)(:, 1), 1)+1);
        cyl      = cell(1,size(DH.(link)(:, 1), 1)+1);
        RFFrame{1} = H0;
        base = robot.findJointByType('base');
        base = base{1}.name;
        for i = size(DH.(link)(:, 1), 1):-1:1
            if isempty(jointNames)
              RFFrame{i+1} = eye(4);
            else
                joint = robot.findJoint(jointNames{i});
                joint = joint{1};
                % from root to i-th link
                %DH_.(body_part.name) = DH;
                %joints.(link)= theta';
                RFFrame{i+1} = getTFtoFrame(DH,joint, theta, H0, base);
            end
        end
        
        if ~strcmp(link, 'torso')
            joint = robot.findJoint(jointNames{1});
            joint = joint{1}.parent;
            if ~strcmp(joint.type, 'base')
                RFFrame{1} = getTFtoFrame(DH,joint, theta, H0, base);
            end
        end
                
        if str.naoSkin && any(ismember({'rightArmSkin', 'leftArmSkin', 'torsoSkin', 'headSkin'}, str.link))
            for point = length(RFFrame):-1:2
                p = RFFrame{point};
                scatter3(p(1, end), p(2, end), p(3, end), 'b');
            end
        else
            % Draw the stuff (joints, ref frames, links)
            for i = 1:length(RFFrame)
                DrawCylinder(ljnt, rjnt, RFFrame{i} * [1 0 0 0; 0 1 0 0; 0 0 1 -ljnt/2; 0 0 0 1], JntColor, 100, 0.8);
            end
            if ~refFrame
                DrawRefFrame(RFFrame{1},1,refFrameSize,'hat',link);
                if length(RFFrame) >=2
                    for i = 2:length(RFFrame)
                        joint = robot.findJoint(jointNames{i-1});
                        joint = joint{1};
                        if any(contains(str.specialGroup, joint.group))
                            DrawRefFrame(RFFrame{i},i,refFrameSize,'www');
                        else
                            DrawRefFrame(RFFrame{i},i,refFrameSize,'noh',jointNames{i-1});
                        end
                    end
                end  
            end
            for i = 1:length(RFFrame)-1
                if ~isempty(jointNames)
                    joint = robot.findJoint(jointNames{i});
                    joint = joint{1};
                    gr=joint.group;
                else
                    gr = '';
                end
                if ~any(contains(str.specialGroup, gr))
                    cyl{i} = DrawCylinderFromTo(RFFrame{i}(1:3,4),RFFrame{i+1}(1:3,4), LinkColor, 100, linkTransparency, linkratio);
                end
            end
        end
        view(3);

    
end