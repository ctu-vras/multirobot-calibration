function WL = loadMotomanWL()
%LOADMOTOMANWL Summary of this function goes here
%   Detailed explanation goes here

    WL.leftArm = [zeros(6,4);
                  0, 0, 0, 0;
                  0, 0, 0, 0];
       
    WL.rightArm = [zeros(7,4);
                   0, 0, 0, 0];
       
    WL.leftEye = zeros(2,4);
        
    WL.rightEye = zeros(2,4);

end

