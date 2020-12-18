classdef group
% group is static class of enumerated type containing string names of all part of robot body and skin
    properties(Constant)
        leftArm = 'leftArm';
        rightArm = 'rightArm';
        head = 'head';
        torso = 'torso';
        leftEye = 'leftEye';
        rightEye = 'rightEye';
        leftArmSkin = 'leftArmSkin'; 
        rightArmSkin = 'rightArmSkin';
        headSkin = 'headSkin';
        torsoSkin = 'torsoSkin';
        leftLeg = 'leftLeg';
        rightLeg = 'rightLeg';
        rightMarkers = 'rightMarkers';
        leftMarkers = 'leftMarkers';
        leftIndex = 'leftIndex';
        rightIndex = 'rightIndex';
        leftThumb = 'leftThumb';
        rightThumb = 'rightThumb';
        leftMiddle = 'leftMiddle';
        rightMiddle = 'rightMiddle';
        leftFinger = 'leftFinger';
        rightFinger = 'rightFinger';
        dummy = 'dummy';
    end
    
    methods(Static)
        function newStruct = sort(oldStruct)
            % SORT - sort structure in given order
            %
            %     INTPUT - structure to be sorted
            %     OUTPUT - sorted structure
            
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
            
            
             order = {'torso', 'leftArm', 'rightArm', 'head', 'leftLeg', 'rightLeg',...
            'leftEye', 'rightEye', 'leftFinger', 'rightFinger', 'leftIndex', ...
            'rightIndex', 'leftThumb', 'rightThumb', 'leftMiddle', 'rightMiddle',...
            'leftMarkers', 'rightMarkers', 'torsoSkin', 'leftArmSkin', 'rightArmSkin', ...
            'headSkin',  'dummy'};
            fnames = fieldnames(oldStruct);
            newStruct = {};
            for f=order
                f = f{1};
                if any(ismember(fnames, f))
                    newStruct.(f) = oldStruct.(f);
                end
            end
        end
    end
end