function WL = loadMotomanLeicaWL()
%LOADMOTOMANWL  Motoman whitelist configuration function
%   Custom function for robot whitelist configuration. Position in
%   whitelist logical matrix corresponds with the position in DH matrix. 
%   Value 1 means the parameter will be calibrated. 
%OUTPUT - WL - whitelist structure

    WL.leftArm = [zeros(6,4);
                  0, 0, 0, 0;
                  0, 0, 0, 0];
       
     WL.rightArm = [zeros(7,4);
                    1, 1, 0, 1];
    WL.rightArm = [0, 0, 0, 0;
                  0, 0, 0, 0;
                  1, 0, 1, 1;
                  1, 1, 1, 1;
                  1, 1, 1, 1;
                  1, 1, 1, 1;
                  0, 0, 0, 0;
                  1, 1, 0, 1];
       
       
    WL.leftEye = zeros(2,4);
        
    WL.rightEye = zeros(2,4);

end

