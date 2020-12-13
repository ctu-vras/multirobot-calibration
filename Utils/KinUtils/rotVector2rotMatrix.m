function R = rotVector2rotMatrix(v)
%ROTVEC2ROTMATRIX Convert a 3-D rotation vector into a rotation matrix
% Reconstruction of a  3D rotationMatrix from a rotationVector (axis-angle representation) using
% the Rodrigues formula.
%INPUT - rotationVector - 3x1 rotation vector representing the axis of rotation in 3D, and its 
% magnitude is the rotation angle in radians.
%OUTPUT -  rotMatrix - 3x3 3D rotation matrix

th=norm(v);
if th>eps
    v=v/th;
end
x=v(1);
y=v(2);
z=v(3);
R = [cos(th)+x^2*(1-cos(th)), x*y*(1-cos(th))-z*sin(th), x*z*(1-cos(th))+y*sin(th);
     y*x*(1-cos(th))+z*sin(th), cos(th)+y^2*(1-cos(th)), y*z*(1-cos(th))-x*sin(th);
     z*x*(1-cos(th))-y*sin(th), z*y*(1-cos(th))+x*sin(th), cos(th)+z^2*(1-cos(th))];
end

