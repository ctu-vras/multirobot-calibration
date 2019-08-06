function R = rotationVectorToM(v)
%ROTATIONVECTORTOMATRIX Summary of this function goes here
%   Detailed explanation goes here

th=norm(v);
v=v/norm(v);

K=[0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
R=eye(3)+sin(th)*K+(1-cos(th))*K^2;
R=R';
end

