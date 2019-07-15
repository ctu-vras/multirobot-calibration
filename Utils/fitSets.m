function [R,T] = fitSets(set1,set2)
%FITSETS 
% set1,set2 ... Nx3 matrices with corresponding 3D points
%
% set2 = R*set1 + T
% R ... 3x3 rotation matrix
% T ... 3x1 translation vector
%
% This is done according to the paper:
% "Least-Squares Fitting of Two 3-D Point Sets"
% by K.S. Arun, T. S. Huang and S. D. Blostein

%set1,set2 řádka - leica, robot
    set1=set1';
    set2=set2';
    meanSet1=mean(set1,2);
    meanSet2=mean(set2,2);
    q1=set1-meanSet1;
    q2=set2-meanSet2;
    H=q1*q2';
    [U,~,V]=svd(H);
    X=V*U';
    R=X;
    T=meanSet2-R*meanSet1;
end

