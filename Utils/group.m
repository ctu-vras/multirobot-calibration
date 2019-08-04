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
    end
end