function bounds = loadMotomanBounds()
%LOADMOTOMANBOUNDS Motoman kinematics parameters bounds configuration function
%   Custom function for bounds of individual kinematics parameter. Position in
%   bounds matrix corresponds with the position in kinematics matrix. The inf value
%   means the parameters in unbounded, the double value is a relative bound
%   for a parameter and parameters with nan use the initial bounds from
%   robot configuration function. 
%OUTPUT - bounds - structure of bounds for individual kinematics parameter
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

