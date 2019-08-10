function [ q ] = matrix2quat( matrix )
%MATRIX2QUAT Summary of this function goes here
%   Detailed explanation goes here
    tr = trace(matrix);
    if (tr > 0) 
        S = sqrt(tr+1.0) * 2; 
        qw = 0.25 * S;
        qx = (matrix(3,2) - matrix(2,3)) / S;
        qy = (matrix(1,3) - matrix(3,1)) / S; 
        qz = (matrix(2,1) - matrix(1,2)) / S; 
    elseif ((matrix(1,1) > matrix(2,2))&&(matrix(1,1) > matrix(3,3)))
        S = sqrt(1.0 + matrix(1,1) - matrix(2,2) - matrix(3,3)) * 2; 
        qw = (matrix(3,2) - matrix(2,3)) / S;
        qx = 0.25 * S;
        qy = (matrix(1,2) + matrix(2,1)) / S; 
        qz = (matrix(1,3) + matrix(3,1)) / S; 
    elseif (matrix(2,2) > matrix(3,3)) 
        S = sqrt(1.0 + matrix(2,2) - matrix(1,1) - matrix(3,3)) * 2; 
        qw = (matrix(1,3) - matrix(3,1)) / S;
        qx = (matrix(1,2) + matrix(2,1)) / S; 
        qy = 0.25 * S;
        qz = (matrix(2,3) + matrix(3,2)) / S; 
    else 
        S = sqrt(1.0 + matrix(3,3) - matrix(1,1) - matrix(2,2)) * 2; 
        qw = (matrix(2,1) - matrix(1,2)) / S;
        qx = (matrix(1,3) + matrix(3,1)) / S;
        qy = (matrix(2,3) + matrix(3,2)) / S;
        qz = 0.25 * S;
    end
    q = [qw,qx,qy,qz];
end

