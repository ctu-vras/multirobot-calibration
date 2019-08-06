function v = matrixToRotationVector(R)
%MATRIXTOROTATIONVECTOR Summary of this function goes here
%   Detailed explanation goes here
NEFUNGUJE
R
[U,~,V]=svd(R);
R=U*V';
R
[v,d]=eig(R);
[dr, ~] = find( imag(d)==0 & real(d)~=0 );
v
v = v(:,dr);
end

