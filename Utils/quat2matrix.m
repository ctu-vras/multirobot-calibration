function [mat] = quat2matrix(quat)
%QUAT2MATRIX Convert the quaternion into rotation matrix.
%INPUT - quat - quaternion vector [w,x,y,z]
%OUTPUT - mat - rotation matrix
quat = quat ./ sqrt(sum(quat.^2));

mat = [1 - 2*quat(3)^2 - 2*quat(4)^2, 2*quat(2)*quat(3) - 2*quat(4)*quat(1), 2*quat(2)*quat(4) + 2*quat(3)*quat(1); ...
       2*quat(2)*quat(3) + 2*quat(4)*quat(1), 1 - 2*quat(2)^2 - 2*quat(4)^2, 2*quat(3)*quat(4) - 2*quat(2)*quat(1); ...
       2*quat(2)*quat(4) - 2*quat(3)*quat(1), 2*quat(3)*quat(4) + 2*quat(2)*quat(1), 1 - 2*quat(2)^2 - 2*quat(3)^2];
end
