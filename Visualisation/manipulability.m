function manipulability(r, limb, varargin)
    % MANIPULABILITY computes Jacobian, Yoshikawa's manipulability index 
    %                 and shows the manipulability ellipsoid.
    %   INPUT 
    %         - r - instance of @Robot class
    %         - limb - Name of the robot body part for which 
    %                   the manipulability will be computed.  
    %         - angles - Contains Limb angles in the same 
    %                    order as links in given kinematics fields. 
    %         - varargin - Uses MATLABs argument parser, with these pairs:
    %                       - 'scale' -  Ellipsoid visualisation scale
    %                                - Default: 5
    %                       - 'step' - angle value increment
    %                                - Default: pi/8
    %                       - 'type' - tran/rot, translation (tran) or 
    %                                  rotation (rot) Jacobian
    %                                 - Default: 'tran'
    %                       - 'useWholeChain' - 0/1, if Jacobian will 
    %                                           be computed for all links  
    %                                           between base and
    %                                           end-effector or just limb
    %                                         - Default: 1
    
    
    % Copyright (C) 2019-2022  Jakub Rozlivek and Lukas Rustler
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
    
    p=inputParser;
    addOptional(p,'angles',  r.structure.defaultJoints{group.getSortedIndex(limb)-1});
    addParameter(p,'scale',5,@isnumeric);
    addParameter(p,'step',pi/8,@isnumeric);
    addParameter(p,'type','tran', @(x) any(validatestring(x,{'tran','rot'})));
    addParameter(p, 'useWholeChain', 1);
    parse(p, varargin{:});
    data.useWholeChain = p.Results.useWholeChain;
    data.scale = p.Results.scale;
    data.step = p.Results.step;
    data.limbJoints =  p.Results.angles;
    data.type = p.Results.type;
    data.limb = limb;
    data.robot = r;
    data.activeJ = 0;
    
    gr = data.limb;
    links = data.robot.findLinkByGroup(gr);
    link = links{end};
    data.parents = {};
    while isobject(link) 
        while strcmp(link.group,gr) && ~strcmp(link.type,types.base)
           link=link.parent;
        end
        if ~strcmp(link.type,types.base)
            data.parents{end+1} = link.group;
        end
        gr = link.group;
        link=link.parent; 
    end
    f = findobj( 'Type', 'Figure', 'Name', 'Manip');
    close(f);
    fig=figure('Name','Manip','Position', [1436 30 1300 750]);
    title(['Active joint ', num2str(data.activeJ)])
    guidata(fig,data)
    set(fig,'KeyPressFcn',{@key_press});
    plot_manip()
end

function plot_manip()
    f = findobj( 'Type', 'Figure', 'Name', 'Manip');
    data = guidata(f);
    joints = data.robot.structure.defaultJoints;
    joints{group.getSortedIndex(data.limb)-1} = data.limbJoints;
    [~, tfs] = data.robot.showModel(joints,'showText', 0, 'figName','Manip');
    [Jac, PN] = computeJac(tfs, data.limb, data.robot.name, data.useWholeChain, data.parents);
    r = rank(Jac);
    mu = sqrt(det(Jac*Jac'));
    trJ = Jac(1:3,:);
    rotJ = Jac(4:6,:);
    hold on
    N = 10;
    if (strcmp(data.type, 'tran'))
        [~, D, V] = svd(trJ*trJ');
        [~, D2, ~] = svd(rotJ*rotJ');
        ddiag = diag(D);
        ddiag2 = diag(D2);
    else
        [~, D, V] = svd(rotJ*rotJ');
        [~, D2, ~] = svd(trJ*trJ');
        ddiag2 = diag(D);
        ddiag = diag(D2);
    end
 
    a = sqrt(D(1,1))/data.scale;
    b = sqrt(D(2,2))/data.scale;
    c = sqrt(D(3,3))/data.scale;
    [X,Y,Z] = ellipsoid(0,0,0,a,b,c,N);
    points = [X(:), Y(:), Z(:)]*V' + PN(1:3, 4)';
    points = reshape(points, N+1, N+1,3);    
    surf(gca, points(:,:,1), points(:,:,2), points(:,:,3));
    axis equal
    view([260,0]);
    
    str = {['Arm joint positions: ' sprintf([repmat('%8.2f',1,size(data.limbJoints,2)) '\n'],data.limbJoints)], ['Manipulabity is ', num2str(round(mu,3)), newline, 'Jacobian rank is ', num2str(r)], ...
        ['Singular values tran: ' sprintf('%12.4f %12.4f %12.4f',ddiag)],...
        ['Singular values rot:   ' sprintf('%12.4f %12.4f %12.4f',ddiag2)],...
        [newline, 'Jacobian is: '], sprintf([repmat('%9.3f',1,size(Jac,2)) '\n'],Jac')};
    annotation('textbox', [0.55, 0.4, 0.1, 0.1], 'String',str)
    title(['Active joint ', num2str(data.activeJ)])
end

function [Jac, PN] = computeJac(tfs, limb, name, useWholeChain, parents)
    PN = tfs.(limb){end};
    if (useWholeChain)
        offset = 0;
        if (strcmp(name, 'iCub'))
            offset = 2;
        end
        Jac = zeros(6,length(tfs.(limb))-offset);
        idxs = 0;
        for p = parents     
            p = p{1};
            for i = 1+offset:length(tfs.(p))
                Z = tfs.(p){i};
                A = PN-Z;
                w = cross(Z(1:3,3), A(1:3,4));
                Jac(:,i-offset) = [w(1:3); Z(1:3,3)];
                idxs = i-offset;
            end
        end
        for i = 1:length(tfs.(limb))-1
            Z = tfs.(limb){i};
            A = PN-Z;
            w = cross(Z(1:3,3), A(1:3,4));
            Jac(:,i+idxs) = [w(1:3); Z(1:3,3)];
        end
    else 
        n = length(tfs.(limb))-1;
        offset = 0;
        if (strcmp(name, 'iCub'))
            offset = 1;
        end
        Jac = zeros(6,n-offset);
        for i = 1+offset:n
            Z = tfs.(limb){i};
            A = PN-Z;
            w = cross(Z(1:3,3), A(1:3,4));
            Jac(:,i-offset) = [w(1:3); Z(1:3,3)];
        end
    end   
end

%% Key pressing
function key_press(~,event)
    k=event.Key;
    kvalue = k - '0';
    f = findobj( 'Type', 'Figure', 'Name', 'Manip');
    data = guidata(f);
    if strcmp(k,'rightarrow') && data.activeJ > 0
        data.limbJoints(data.activeJ) = ezwraptopi(data.limbJoints(data.activeJ) + data.step);
        clf(f)
        guidata(f,data)
        plot_manip();
    elseif strcmp(k,'leftarrow') && data.activeJ > 0
        data.limbJoints(data.activeJ) = ezwraptopi(data.limbJoints(data.activeJ) - data.step);
        clf(f)
        guidata(f,data)
        plot_manip(); 
    elseif kvalue > 0 && kvalue < length(data.limbJoints)
        data.activeJ = kvalue;
        guidata(f,data);
        ax = findall(f, 'type', 'axes');
        title(ax,['Active joint ', num2str(kvalue)])
    end
end