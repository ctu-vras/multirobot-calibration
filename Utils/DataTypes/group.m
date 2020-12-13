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