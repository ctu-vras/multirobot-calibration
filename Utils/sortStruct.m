function newStruct =  sortStruct(oldStruct)
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