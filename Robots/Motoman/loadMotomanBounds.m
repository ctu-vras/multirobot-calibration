function bounds = loadMotomanBounds()
%LOADMOTOMANBOUNDS Summary of this function goes here
%   Detailed explanation goes here
    bounds.leftArm = [nan, nan, nan, nan;
                             nan, nan, nan, nan;
                             nan, nan, nan, nan;
                             nan, nan, nan, nan;
                             inf, nan, nan, nan;
                             nan, nan, nan, nan;
                             nan, nan, nan, nan;
                             nan, nan, nan, nan;
                             nan, nan, nan, nan];
       
    bounds.rightArm = [inf, inf, 0.05, 0.05;
                              inf, inf, 0.05, 0.05;
                              inf, inf, 0.05, 0.05;
                              inf, inf, 0.05, 0.05;
                              inf, inf, 0.05, 0.05;
                              inf, inf, 0.05, 0.05;
                              0.005, inf, 0.05, 0.05;
                              inf, inf, 0.05, 0.05;
                              inf, inf, 0.05, 0.05];
       
    bounds.leftEye = [nan, nan, nan, nan;
                             nan, nan, nan, nan];
        
    bounds.rightEye = [nan, nan, nan, nan;
                              nan, nan, nan, nan];
end

