function itfmat = inversetf(tfmat)
    %INVERSETF Invert transformation matrix
    %INPUT - tfmat - transformation matrix to be inverted
    %OUTPUT - itfmat - inverted transformation matrix
    
    
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
    
    
    size3 = size(tfmat,3);
    if(size3 == 1)
        itfmat = [tfmat(1:3,1:3)', -tfmat(1:3,1:3)'*tfmat(1:3,4); 0, 0, 0, 1];
    else
        itfmat = [permute(tfmat(1:3,1:3,:),[2,1,3]), -reshape(squeeze(sum(permute(tfmat(1:3,1:3,:),[2,1,3]).*reshape(tfmat(1:3,4,:),1,3,size3),2)),3,1,size3); zeros(1,3,size3), ones(1,1,size3)];
    end
end

