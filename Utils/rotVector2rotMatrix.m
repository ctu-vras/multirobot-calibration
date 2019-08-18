function R = rotVector2rotMatrix(v)
%ROTVEC2ROTMATRIX Convert a 3-D rotation vector into a rotation matrix
% Reconstruction of a  3D rotationMatrix from a rotationVector (axis-angle representation) using
% the Rodrigues formula.
%INPUT - rotationVector - 3x1 rotation vector representing the axis of rotation in 3D, and its 
% magnitude is the rotation angle in radians.
%OUTPUT -  rotMatrix - 3x3 3D rotation matrix
th=norm(v);
v=v/norm(v);
K=[0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
R= cos(th)*[1,0,0;0,1,0;0,0,1] + (1-cos(th))*kron(v,v')+sin(th)*K;
end

