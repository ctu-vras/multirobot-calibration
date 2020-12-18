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
        ljnt  = 0.007*coef;               % link pic length
        rjnt  = 0.002*coef;               % link pic radius
        linkratio = 1/15;        % link dimension ratio
        linkTransparency = 0.2;
        LinkColor = str.LinkColor;
        refFrameSize = str.refFrameSize;
        JntColor   = [.7 .7 .7];  % RGB color of the links


    %% PARAMETERS
        kinematics = str.kinematics;
        name = str.name;
        linkNames = str.linkNames;
        theta = str.theta;
        refFrame = str.refFrame;
        H0 = eye(4);
        [kinematics, types] = padVectors(kinematics);
        try
            thetas = theta.(name)';
            offs = kinematics.(name)(:,6);
            thet = thetas + offs;
            theta.dummy = [0;0];
        catch ME
            msg = ['Body part: ', name, '\nActual number of joint angles: ', ...
                num2str(size(offs,1)), '\nNumber of joint angles inserted: ', ...
                num2str(size(theta.(name),2)), '\nInserted joint angles: ', num2str(theta.(name))] ;
            causeException = MException('MATLAB:myCode:dimensions',msg);
            ME = addCause(ME,causeException);
            rethrow(ME);
        end
        
        
        
        %%% CHAIN
        RFFrame  = cell(1,size(kinematics.(name)(:, 1), 1)+1);
        cyl      = cell(1,size(kinematics.(name)(:, 1), 1)+1);
        RFFrame{1} = H0;
        base = robot.findLinkByType('base');
        base = base{1}.name;
        for i = size(kinematics.(name)(:, 1), 1):-1:1
            if isempty(linkNames)
              RFFrame{i+1} = eye(4);
            else
                link = robot.findLink(linkNames{i});
                link = link{1};
                % from root to i-th link
                RFFrame{i+1} = getTFtoFrame(kinematics,link, theta, base);
            end
        end
        
        if ~strcmp(name, 'torso')
            link = robot.findLink(linkNames{1});
            link = link{1}.parent;
            if ~strcmp(link.type, 'base')
                RFFrame{1} = getTFtoFrame(kinematics,link, theta, base);
            end
        end
                
        if str.naoSkin && any(ismember({'rightArmSkin', 'leftArmSkin', 'torsoSkin', 'headSkin'}, str.name))
            points = zeros(length(RFFrame)-1,3);
            for point = 2:length(RFFrame)
                if contains(linkNames{point-1}, 'Taxel')
                    p = RFFrame{point};
                    points(point, :) = [p(1, end), p(2, end), p(3, end)];
                end
            end
            points(~any(points,2), :) = [];
            scatter3(points(:,1),points(:,2),points(:,3),str.SkinColor, 'filled', 'MarkerFaceAlpha', 0.7,'MarkerEdgeColor','k');
        else
            % Draw the stuff (links, ref frames, links)
            for i = 1:length(RFFrame)
                DrawCylinder(ljnt, rjnt, RFFrame{i} * [1 0 0 0; 0 1 0 0; 0 0 1 -ljnt/2; 0 0 0 1], JntColor, 100, 0.8);
            end
            if ~refFrame
                DrawRefFrame(RFFrame{1},1,refFrameSize, showText, 'hat',name);
                if length(RFFrame) >=2
                    for i = 2:length(RFFrame)
                        link = robot.findLink(linkNames{i-1});
                        link = link{1};
                        if any(contains(str.specialGroup, link.group))
                            DrawRefFrame(RFFrame{i},i,refFrameSize,showText,'www');
                        else
                            DrawRefFrame(RFFrame{i},i,refFrameSize,showText,'noh',linkNames{i-1});
                        end
                    end
                end  
            end
            for i = 1:length(RFFrame)-1
                if ~isempty(linkNames)
                    link = robot.findLink(linkNames{i});
                    link = link{1};
                    gr=link.group;
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