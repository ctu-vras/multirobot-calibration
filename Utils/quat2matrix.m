function [mat] = quat2matrix(q)
%QUAT2MATRIX Convert the quaternion into rotation matrix.

q = q ./ sqrt(sum(q.^2));

mat = [1 - 2*q(3)^2 - 2*q(4)^2, 2*q(2)*q(3) - 2*q(4)*q(1), 2*q(2)*q(4) + 2*q(3)*q(1); ...
       2*q(2)*q(3) + 2*q(4)*q(1), 1 - 2*q(2)^2 - 2*q(4)^2, 2*q(3)*q(4) - 2*q(2)*q(1); ...
       2*q(2)*q(4) - 2*q(3)*q(1), 2*q(3)*q(4) + 2*q(2)*q(1), 1 - 2*q(2)^2 - 2*q(3)^2];
end