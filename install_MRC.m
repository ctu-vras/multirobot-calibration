function install_MRC(varargin)
    %INSTALL_MRC Function to install MRC 
    %INPUT - varargin - Uses MATLABs argument parser, with these pairs:
    %                    - 'installPrefix' - str, path to the MRC
    %                                      - Default: current_folder/MRC

    % Copyright (C) 2019-2022  Jakub Rozlivek and Lukas Rustler
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


    % Install the MRC packages in a local directory
    p = inputParser;
    default_install_prefix = fullfile(pwd,'MRC');
    addOptional(p,'installPrefix', default_install_prefix);
    parse(p,varargin{:});

    % Build package installation directory
    install_prefix = p.Results.installPrefix;
    
    setup_script = fullfile(userpath, 'startup.m');

    if exist(install_prefix)
        fprintf('Directory %s already present.\n', install_prefix);
        fprintf('Please use it or delete to proceed with the install.\n');
        return;
    end

    fprintf('Installing MRC in %s\n', install_prefix);

    % The install url is created following
    mrc_url = 'https://github.com/ctu-vras/multirobot-calibration/releases/download/v1.2/MRC.mlappinstall';
    
    app_name = 'MRC.mlappinstall';
    fprintf('Downloading and installing MRC \n');
    websave(app_name, mrc_url);
    install_info = matlab.apputil.install(app_name);
    delete(app_name)

    user_files_url = 'https://github.com/ctu-vras/multirobot-calibration/releases/download/v1.2/UserData.zip';
    unzip(user_files_url, pwd);
    movefile('UserData', install_prefix);

    fprintf('Download of MRC completed\n');

    fprintf('Creating setup script in %s\n', setup_script);
    setupID = fopen(setup_script,'a');
    fprintf(setupID, '\n%%MRC start\n');
    fprintf(setupID, '%% MRC and UserData locations (hardcoded at generation time)\n');
    fprintf(setupID, 'UserData = "%s";\n', install_prefix);
    fprintf(setupID, 'MRC = "%s";\n', install_info.location);
    fprintf(setupID, '\n');
    fprintf(setupID, '%% Add directory to MATLAB path\n');
    fprintf(setupID, 'addpath(genpath(UserData));\n');
    fprintf(setupID, 'addpath(genpath(MRC));\n');
    fprintf(setupID, '%%MRC end\n\n');
    fclose(setupID);

    startup;

    fprintf('MRC packages are successfully installed!\n');
    fprintf('MRC added to path by code in %s\n',setup_script)
    fprintf('To uninstall these packages, just delete the folder %s',install_prefix);
    fprintf(' and delete everything from %%MRC start to %%MRC end in %s\n', setup_script);
end