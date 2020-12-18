function observability = computeObservability(J,PS)
    %computes different observability parameters
    %INPUT - J - jacobian obtained via optimization process
    %       - PS - number of poses in poses set
    %OUTPUT - observability - structure containing different observability
    %indices
    %based on ftp://ftp-sop.inria.fr/members/David.Daney/articles/ijrr05.pdf
    %and Handbook of robotics
    
    
    % Copyright (C) 2019-2021  Jakub Rozlivek, Lukas Rustler and Karla Stepanova
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
    
    
    [~,S,~] = svd (full(J'*J));
    SD = diag(S);
    %size of the hyperelipsoid
    %Borm and Menq [14.44,45], D - optimality
    if(nargin ==2)
        observability.Dopt = (prod(SD).^(1/length(SD)))/sqrt(PS);
    end
    %(sqrt(det(J'*J))).^(1/size(J,2))/sqrt(PS)
    %eccentricity of the hyperellipsoid
    observability.Ecc = SD(end)/SD(1);
    %maximizing the minimum singular value ?r - E-optimality
    observability.Min = SD(end);
    %Nahvi and Hollerbach [14.48] proposed the noise amplification index O4,which can be viewed as combining
    %the condition number Ecc with the minimum singular value Min:
    observability.O4 = SD(end)^2/SD(1);
end