function rotationVector = rotMatrix2rotVector(rotMatrix)
%ROTMATRIX2ROTVEC Convert a 3D rotation matrix into a rotation vector.
% Computation of a rotation vector (axis-angle representation) corresponding to a 3D 
% rotation matrix using the Rodrigues formula.
%INPUT - rotMatrix - 3x3 3D rotation matrix
%OUTPUT - rotationVector - 3x1 rotation vector representing the axis of rotation in 3D, and its 
% magnitude is the rotation angle in radians.
[U, ~, V] = svd(rotMatrix);
rotMatrix = U * V';
t = trace(rotMatrix);
[v,~] = eig(rotMatrix);
% theta = real(acos((t - 1) / 2))
r = [rotMatrix(3,2) - rotMatrix(2,3); ...
     rotMatrix(1,3) - rotMatrix(3,1); ...
     rotMatrix(2,1) - rotMatrix(1,2)];
theta = atan2(v(:,3)'*r,t-1);
if sin(theta) >= 1e-7
    % theta is not close to 0 or pi
    rotationVector = theta / (2 * sin(theta)) * r;
elseif t-1 > 0
    % theta is close to 0 -> series expansion around t=3
    rotationVector = (0.5 - (t - 3) / 12) * r;
else
    % theta is close to pi -> from rotation matrix to vector over quaternion
    v = matrix2quat(rotMatrix);
    rotationVector = theta * v(2:4) / norm(v(2:4));
end



