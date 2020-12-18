function dataset  = initDataset(all)
    %INITDATASET Create empty dataset structure 
    %INPUT - all - if true create fields not needed for calibration
    %OUTPUT - dataset - empty dataset structure
    
    
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
    
    
    dataset.frame = {};
    dataset.frame2 = {};
    dataset.cameras = [];
    dataset.pose = [];
    dataset.joints = struct();
    dataset.refPoints = [];
    dataset.point = [];
    if (all) 
        dataset.refDist = 0; 
        dataset.rtMat = [];  
        dataset.name = '';
        dataset.id = -1;

    end
end

