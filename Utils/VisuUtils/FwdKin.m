% Edited by Alessandro Roncone
% Genova Oct 2013
% changes Matej Hoffmann, July 2017
function [RFFrame] = FwdKin(robot, str, coef, showText)
% FWDKIN - this function computes and displays the forward kinematics of a body part
% INPUT - robot - instance of @Robot class
%       - str - structure with robot settings
%       - coef - units of the plot
%       - showText - 0/1, show names of links
%                  - Default: 1
%   OUTPUT - chain (struct) - the resulted chain with everything inside it. It's divided by body parts.

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
        H0 = eye(4);
        [DH, types] = padVectors(DH);
        try
            thetas = theta.(link)';
            offs = DH.(link)(:,6);
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
                RFFrame{i+1} = getTFtoFrame(DH,joint, theta, base);
            end
        end
        
        if ~strcmp(link, 'torso')
            joint = robot.findJoint(jointNames{1});
            joint = joint{1}.parent;
            if ~strcmp(joint.type, 'base')
                RFFrame{1} = getTFtoFrame(DH,joint, theta, base);
            end
        end
                
        if str.naoSkin && any(ismember({'rightArmSkin', 'leftArmSkin', 'torsoSkin', 'headSkin'}, str.link))
            points = zeros(length(RFFrame)-1,3);
            for point = 2:length(RFFrame)
                if contains(jointNames{point-1}, 'Taxel')
                    p = RFFrame{point};
                    points(point, :) = [p(1, end), p(2, end), p(3, end)];
                end
            end
            points(~any(points,2), :) = [];
            scatter3(points(:,1),points(:,2),points(:,3),str.SkinColor, 'filled', 'MarkerFaceAlpha', 0.7,'MarkerEdgeColor','k');
        else
            % Draw the stuff (joints, ref frames, links)
            for i = 1:length(RFFrame)
                DrawCylinder(ljnt, rjnt, RFFrame{i} * [1 0 0 0; 0 1 0 0; 0 0 1 -ljnt/2; 0 0 0 1], JntColor, 100, 0.8);
            end
            if ~refFrame
                DrawRefFrame(RFFrame{1},1,refFrameSize, showText, 'hat',link);
                if length(RFFrame) >=2
                    for i = 2:length(RFFrame)
                        joint = robot.findJoint(jointNames{i-1});
                        joint = joint{1};
                        if any(contains(str.specialGroup, joint.group))
                            DrawRefFrame(RFFrame{i},i,refFrameSize,showText,'www');
                        else
                            DrawRefFrame(RFFrame{i},i,refFrameSize,showText,'noh',jointNames{i-1});
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