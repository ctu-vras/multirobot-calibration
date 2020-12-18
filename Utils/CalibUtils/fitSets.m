function [R,T] = fitSets(set1,set2)
    %FITSETS 
    % INPUT - set1,set2 ... Nx3 matrices with corresponding 3D points
    % set2 = R*set1 + T
    % OUTPUT - R ... 3x3 rotation matrix
    %        - T ... 3x1 translation vector
    %
    % This is done according to the paper:
    % "Least-Squares Fitting of Two 3-D Point Sets"
    % by K.S. Arun, T. S. Huang and S. D. Blostein
    
    
    % Copyright (C) 2019-2021  Jakub Rozlivek and Lukas Rustler
    % Department of Cybernetics, Faculty of Electrical Engineering, 
    % Czech Technical University in Prague
    %
    % This file is part of Multisensorial robot calibration toolbox (MRC).
    % 
    % MRC is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Lesser General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % MRC is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Lesser General Public License for more details.
    % 
    % You should have received a copy of the GNU Leser General Public License
    % along with MRC.  If not, see <http://www.gnu.org/licenses/>.
    
    
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

