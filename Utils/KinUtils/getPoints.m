function [ arm1, arm2 ] = getPoints(robot, dh_pars, dataset, compute_arm2)
    %GETPOINTS Compute points coordinates to base.
    %INPUT - dh_pars - structure with kinematics parameters, where field names corresponding to names of
    %                      the 'groups' in robot. Each group is matrix.
    %      - dataset - dataset structure in common format
    %      - compute_arm2 - whether compute second end effector or use
    %      refPoints
    %OUTPUT - arm1 - points coordinates of first end effector
    %       - arm2 - points coordinates of second end effector


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
    
    
    frames = dataset.frame;  
    joints = dataset.joints;
    points = dataset.point;
    arm1 = zeros(4, size(joints, 1));
    if(compute_arm2) 
        arm2 = zeros(4, size(joints, 1)); 
        frames2 = dataset.frame2;
    else
        arm2 = [];
    end
    if(~isempty(joints))
        for i = 1:size(joints, 1)      
            if (isobject(frames(i)))
                arm1(:,i) =  getTFtoFrame(dh_pars,frames(i),joints(i)) *[points(i,1:3),1]';
            else
                f=robot.findLink(frames{i});
                arm1(:,i) =  getTFtoFrame(dh_pars,f{1},joints(i)) *[points(i,1:3),1]';
            end
            
            if compute_arm2
                if (isobject(frames2(i)))
                    arm2(:,i) =  getTFtoFrame(dh_pars,frames2(i), joints(i)) *[points(i,4:6),1]';
                else
                    f=robot.findLink(frames2{i});
                    arm2(:,i) =  getTFtoFrame(dh_pars,f{1}, joints(i)) *[points(i,4:6),1]';
                end
            end
            
        end
    end