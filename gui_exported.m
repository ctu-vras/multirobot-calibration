classdef gui_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Robot_toolboxUIFigure           matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        MainTab                         matlab.ui.container.Tab
        RobotjointconfigurationPanel    matlab.ui.container.Panel
        GroupDropDownLabel              matlab.ui.control.Label
        GroupDropDown                   matlab.ui.control.DropDown
        UITable                         matlab.ui.control.Table
        ResetJointsButton               matlab.ui.control.Button
        ShowRobotButton                 matlab.ui.control.Button
        dualrobotCheckBox               matlab.ui.control.CheckBox
        LoadfunctionsPanel              matlab.ui.container.Panel
        LoadRobotButton                 matlab.ui.control.Button
        LoadConfigButton                matlab.ui.control.Button
        LoadWhitelistButton             matlab.ui.control.Button
        LoadBoundsButton                matlab.ui.control.Button
        LoadrobotkinematicsPanel        matlab.ui.container.Panel
        TabGroup3                       matlab.ui.container.TabGroup
        TXTTab                          matlab.ui.container.Tab
        LoadKinematicsButton_2          matlab.ui.control.Button
        MATTab                          matlab.ui.container.Tab
        TypeButtonGroup                 matlab.ui.container.ButtonGroup
        NoneButton                      matlab.ui.control.RadioButton
        minButton                       matlab.ui.control.RadioButton
        maxButton                       matlab.ui.control.RadioButton
        medianButton                    matlab.ui.control.RadioButton
        PertSpinnerLabel                matlab.ui.control.Label
        PertSpinner                     matlab.ui.control.Spinner
        RepSpinnerLabel                 matlab.ui.control.Label
        RepSpinner                      matlab.ui.control.Spinner
        LoadKinematicsButton            matlab.ui.control.Button
        LoaddatasetPanel                matlab.ui.container.Panel
        DatasetparametersTextAreaLabel  matlab.ui.control.Label
        DatasetparametersTextArea       matlab.ui.control.TextArea
        LoadDatasetButton               matlab.ui.control.Button
        JointDistributionButton         matlab.ui.control.Button
        PosesviewButton                 matlab.ui.control.Button
        VisualisationPanel              matlab.ui.container.Panel
        CorrectionsButton               matlab.ui.control.Button
        RMSEBoxplotsButton              matlab.ui.control.Button
        RMSEBarsButton                  matlab.ui.control.Button
        JacobiansObsButton              matlab.ui.control.Button
        VisualisationfoldernameEditFieldLabel  matlab.ui.control.Label
        VisualisationfoldernameEditField  matlab.ui.control.EditField
        CalibrationoptionsPanel         matlab.ui.container.Panel
        ApproachListBoxLabel            matlab.ui.control.Label
        ApproachListBox                 matlab.ui.control.ListBox
        jointTypesLabel                 matlab.ui.control.Label
        jointTypesListBox               matlab.ui.control.ListBox
        ChainsListBoxLabel              matlab.ui.control.Label
        ChainsListBox                   matlab.ui.control.ListBox
        CalibrationsettingsPanel_4      matlab.ui.container.Panel
        RunCalibrationButton            matlab.ui.control.Button
        SavejacobiansCheckBox           matlab.ui.control.CheckBox
        SavedatasetCheckBox             matlab.ui.control.CheckBox
        SavevarsCheckBox                matlab.ui.control.CheckBox
        SavefoldernameEditFieldLabel    matlab.ui.control.Label
        SavefoldernameEditField         matlab.ui.control.EditField
        TextArea                        matlab.ui.control.TextArea
        ConfigTab                       matlab.ui.container.Tab
        CalibrationoptionsPanel_2       matlab.ui.container.Panel
        ApproachListBox_3Label          matlab.ui.control.Label
        ApproachListBox_3               matlab.ui.control.ListBox
        jointTypesListBox_3Label        matlab.ui.control.Label
        jointTypesListBox_3             matlab.ui.control.ListBox
        ChainsListBox_3Label            matlab.ui.control.Label
        ChainsListBox_3                 matlab.ui.control.ListBox
        Panel                           matlab.ui.container.Panel
        LoadConfigfileButton            matlab.ui.control.Button
        SaveConfigfileButton            matlab.ui.control.Button
        ReturntomainButton              matlab.ui.control.Button
        PerturbationoptionsPanel        matlab.ui.container.Panel
        UITable2_3                      matlab.ui.control.Table
        OptimoptionsPanel               matlab.ui.container.Panel
        UITable2                        matlab.ui.control.Table
        OptimizationoptionsPanel        matlab.ui.container.Panel
        UITable2_2                      matlab.ui.control.Table
        RobotTab                        matlab.ui.container.Tab
        TabGroup2                       matlab.ui.container.TabGroup
        JointsTab                       matlab.ui.container.Tab
        Panel_2                         matlab.ui.container.Panel
        LoadRobotfileButton             matlab.ui.control.Button
        SaveRobotfileButton             matlab.ui.control.Button
        ReturntomainButton_2            matlab.ui.control.Button
        NexttabButton                   matlab.ui.control.Button
        JointstructurePanel             matlab.ui.container.Panel
        UITable4                        matlab.ui.control.Table
        UIAxes2                         matlab.ui.control.UIAxes
        RobotnameEditFieldLabel         matlab.ui.control.Label
        RobotnameEditField              matlab.ui.control.EditField
        KinematicsTab                   matlab.ui.container.Tab
        KinematicsparametersPanel       matlab.ui.container.Panel
        UITable5                        matlab.ui.control.Table
        Panel_3                         matlab.ui.container.Panel
        LoadRobotfileButton_2           matlab.ui.control.Button
        SaveRobotfileButton_2           matlab.ui.control.Button
        ReturntomainButton_3            matlab.ui.control.Button
        NexttabButton_2                 matlab.ui.control.Button
        RobotdefaultconfigurationPanel  matlab.ui.container.Panel
        UITable_2                       matlab.ui.control.Table
        GroupDropDown_2Label            matlab.ui.control.Label
        GroupDropDown_2                 matlab.ui.control.DropDown
        WhitelistBoundsTab              matlab.ui.container.Tab
        Panel_4                         matlab.ui.container.Panel
        LoadRobotfileButton_3           matlab.ui.control.Button
        SaveRobotfileButton_3           matlab.ui.control.Button
        ReturntomainButton_4            matlab.ui.control.Button
        NexttabButton_3                 matlab.ui.control.Button
        GroupDropDown_3Label            matlab.ui.control.Label
        GroupDropDown_3                 matlab.ui.control.DropDown
        WhitelistPanel                  matlab.ui.container.Panel
        UITable5_2                      matlab.ui.control.Table
        SavewhitelistButton             matlab.ui.control.Button
        BoundsPanel                     matlab.ui.container.Panel
        UITable5_3                      matlab.ui.control.Table
        SaveboundsButton                matlab.ui.control.Button
        CameraseyesTab                  matlab.ui.container.Tab
        Panel_5                         matlab.ui.container.Panel
        LoadRobotfileButton_4           matlab.ui.control.Button
        SaveRobotfileButton_4           matlab.ui.control.Button
        ReturntomainButton_5            matlab.ui.control.Button
        NexttabButton_4                 matlab.ui.control.Button
        LefteyePanel                    matlab.ui.container.Panel
        DistortioncoefficientsPanel     matlab.ui.container.Panel
        tCoef1                          matlab.ui.control.Table
        tangentialLabel                 matlab.ui.control.Label
        radialLabel                     matlab.ui.control.Label
        rCoef1                          matlab.ui.control.Table
        CameramatrixPanel               matlab.ui.container.Panel
        camMatrix1                      matlab.ui.control.Table
        RighteyePanel                   matlab.ui.container.Panel
        DistortioncoefficientsPanel_2   matlab.ui.container.Panel
        tCoef2                          matlab.ui.control.Table
        tangentialLabel_2               matlab.ui.control.Label
        radialLabel_2                   matlab.ui.control.Label
        rCoef2                          matlab.ui.control.Table
        CameramatrixPanel_2             matlab.ui.container.Panel
        camMatrix2                      matlab.ui.control.Table
        AdditionaleyePanel              matlab.ui.container.Panel
        DistortioncoefficientsPanel_3   matlab.ui.container.Panel
        tCoef3                          matlab.ui.control.Table
        tangentialLabel_3               matlab.ui.control.Label
        radialLabel_3                   matlab.ui.control.Label
        rCoef3                          matlab.ui.control.Table
        CameramatrixPanel_3             matlab.ui.container.Panel
        camMatrix3                      matlab.ui.control.Table
        DatasetTab                      matlab.ui.container.Tab
        Panel_6                         matlab.ui.container.Panel
        LoadDatasetfileButton           matlab.ui.control.Button
        SaveDatasetfileButton           matlab.ui.control.Button
        ReturntomainButton_6            matlab.ui.control.Button
        DatasetinfoPanel                matlab.ui.container.Panel
        DatasetnameEditFieldLabel       matlab.ui.control.Label
        DatasetnameEditField            matlab.ui.control.EditField
        DatasettypeDropDownLabel        matlab.ui.control.Label
        DatasettypeDropDown             matlab.ui.control.DropDown
        DatasetIDDropDownLabel          matlab.ui.control.Label
        DatasetIDDropDown               matlab.ui.control.DropDown
        DataPanel                       matlab.ui.container.Panel
        DatasetData                     matlab.ui.control.Table
    end

    
    properties (Access = private)
        Robot % Description
        Config % Description
        jointTypesListBoxProp
        ChainsListBoxProp
        ApproachListBoxProp
        Whitelist
        Bounds
        Dataset
        SaveVars
        SaveFolder
        VisuFolder
        Configuration
        DefaultJoints
        RobotFile
        ConfigFile
        BoundsFile
        WLFile
        DatasetFile
        Timer
    end
    methods (Access = private)
        
        function setPromptFcn(app,jTextArea,eventData,newPrompt)
           % Prevent overlapping reentry due to prompt replacement
          persistent inProgress
          if isempty(inProgress)
            inProgress = 1;  %#ok unused
          else
            return;
          end
         
          try
            % *** Prompt modification code goes here ***
            cwText = char(jTextArea.getText);
            app.TextArea.Value = cwText;
            % force prompt-change callback to fizzle-out...
            pause(0.02);
          catch
            % Never mind - ignore errors...
          end
         
          % Enable new callbacks now that the prompt has been modified
          inProgress = [];
%           
         
        end  % setPromptFcn
    end
    methods (Access = public)
        function  changeListBox(app, field, toChange)
            for item=reshape(toChange, 1, [])
                app.(item{1}).Value = {};
            end
            for item=fieldnames(app.Config.(field))'
                item=item{1};
                if app.Config.(field).(item)
                     for item_=reshape(toChange, 1, [])
                        app.(item_{1}).Value{end+1} = item;
                     end
                end
            end
            for item=reshape(toChange, 1, [])
                pro = split(item{1}, '_');
                pro = pro{1};
                app.([pro, 'Prop']) = app.(item{1}).Value;
            end
        end
        function listBoxValueChanged(app, box, property)
            property = split(property, '_');
            property = property{1};
            box_ = box;
            box = split(box,'_');
            box = box{1};
            val = app.(box_).Value;
            if any(contains(app.(property), val))
                app.(property)(contains(app.(property), val))=[];
            else
                app.(property){end+1} = val{1};
            end
            for item={box, [box,'_3']}
                app.(item{1}).Value = app.(property);
            end
        end
        function configChangeTable(app, values, table)
            table.Data = [];
            temp = [];
            for item=fieldnames(values)'
                item=item{1};
                if strcmp(item, 'TypicalX')
                    continue;
                end
                if isstruct(values.(item))
                    for t=fieldnames(values.(item))'
                        t=t{1};
                        temp = [temp; {[item,'.',t], mat2str(values.(item).(t))}];
                    end
                elseif isstr(values.(item))
                    temp = [temp; {item, values.(item)}];
                else
                    temp = [temp; {item, mat2str(values.(item))}];
                end
            end
            table.Data = temp;
            
        end
        function changeDataset(app)
            id = str2double(app.DatasetIDDropDown.Value);
            type = app.DatasettypeDropDown.Value;
%             if length(app.Dataset.(type)) < id
%                 id=1;
%                 app.DatasetidEditField.Value = 1;
%             end
            dataset = app.Dataset.(type){id};
            app.DatasetnameEditField.Value = dataset.name;
            app.DatasetData.Data = [];
            temp = [];
%             point_length = length(dataset.point);
%             pose_length = length(dataset.pose);
%             frame_length = length(dataset.frame);
%             frame2_length = length(dataset.frame2);
%             refpoint_length = length(dataset.refPoints);
            fnames_ = fieldnames(dataset);
            allowedFnames = {'pose', 'frame', 'frame2', 'joints', 'point', 'cameras', 'refPoints'};
            fnames = {};
            for fname=allowedFnames
                fname = fname{1};
                if any(ismember(fnames_, fname))
                    fnames{end+1} = fname;
                end
            end
            fnames_joint = fieldnames(dataset.joints);
%             all_joints = app.DatasetData.ColumnName;
%             for id=1:length(dataset.point)
%                 temp_ = cell(1, 20);
%                 if length(dataset.pose)>=id
%                    temp_{1} = dataset.pose(id);
%                 end
%                 if length(dataset.frame)>=id
%                    temp_{2} = dataset.frame{id};
%                 end
%                 if isfield(dataset, 'frame2') && length(dataset.frame2)>=id
%                    temp_{3} = dataset.frame2{id};
%                 end
%                 if length(dataset.point)>=id
%                    temp_{4} = mat2str(dataset.point(id,:));
%                 end
%                 if isfield(dataset, 'refPoints') && length(dataset.refPoints)>=id
%                    temp_{5} = mat2str(dataset.refPoints(id,:));
%                 end
% %                 if any(contains(fnames, 'cameras')) && ~isempty(dataset.camera)
% %                    temp_{6} = mat2str(dataset.camera(id, :)); 
% %                 end
%                 for j=7:length(all_joints)
%                     j_ = split(all_joints{j}, ' ');
%                     j_ = j_{2};
%                     if any(contains(fnames_joint, j_))
%                         temp_{j} = mat2str(dataset.joints(id).(j_));
%                     end
%                 end
%                 temp = [temp; temp_];
%             end
            colNames = {};
            for fname=reshape(fnames, 1, [])
                fname = fname{1};
                if length(dataset.(fname)) > 1 && ~ischar(dataset.(fname)) && ~strcmp(fname, 'rtMat')
                    if ~strcmp(fname, 'joints')
                        if iscell(dataset.(fname))
                            temp = [temp, dataset.(fname)];
                        else
                            temp = [temp, num2cell(dataset.(fname))];
                        end
                        if(strcmp(fname, 'point'))
                            for k = 1:(1+(isfield(dataset, 'frame2') && ~isempty(dataset.frame2)))
                                for ll = {'x', 'y', 'z'}
                                    colNames{end+1} = ['point ', num2str(k), ' ', ll{1} ];
                                end
                            end
                            if(k == 1) 
                                temp = temp(:, 1:end-3);
                            end
                        elseif(strcmp(fname, 'cameras')) 
                            for ll = 1:size(dataset.cameras, 2)
                                colNames{end+1} = ['camera ', num2str(ll)];
                            end
                        elseif(strcmp(fname, 'refPoints')) 
                            if(strcmp(type, 'projection'))
                                for ll = 1:size(dataset.cameras, 2) 
                                    for kk = {'u', 'v'}
                                        colNames{end+1} = ['refPoints cam', num2str(ll), ' ', kk{1}];
                                    end
                                end
                            else
                                for ll = 1:size(dataset.refPoints, 2)/3 
                                    for kk = {'x', 'y', 'z'}
                                        colNames{end+1} = ['refPoints ', num2str(ll), ' ', kk{1}];
                                    end
                                end
                            end
                        else
                            colNames{end+1} = fname;
                        end
                    else
                        for joint_name = fnames_joint'
                            joint_name = joint_name{1};
                            temp = [temp,num2cell(reshape([dataset.joints(:).(joint_name)], length(dataset.joints(1).(joint_name)), [])')];
                            for jointId = 1:length(dataset.joints(1).(joint_name))
                                colNames{end+1} = [joint_name,' joint ', num2str(jointId)];
                            end
                        end
                    end
                end
            end
            app.DatasetData.ColumnName= colNames;
            app.DatasetData.Data = temp;
        end
        function configurationDropDown(app)
            if ~isempty(app.Configuration)
               colNames = {};
               for joint=1:length(app.Configuration.(app.GroupDropDown_2.Value))
                   colNames{end+1} = ['Joint ', num2str(joint)];
               end
               app.UITable_2.ColumnName = colNames;
               app.UITable_2.Data = app.DefaultJoints.(app.GroupDropDown_2.Value); 
               
               colNames = {};
               for joint=1:length(app.Configuration.(app.GroupDropDown.Value))
                   colNames{end+1} = ['Joint ', num2str(joint)];
               end
               app.UITable.ColumnName = colNames;
               app.UITable.Data = app.Configuration.(app.GroupDropDown.Value); 
            end
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            %addpath(genpath(pwd));
            %view(app.UIAxes,[-5 2 5]);
            clc;
            try
                jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
                jCmdWin = jDesktop.getClient('Command Window');
                jTextArea = jCmdWin.getComponent(0).getViewport.getView;
                set(jTextArea,'CaretUpdateCallback',@app.setPromptFcn)
            catch
                warndlg('fatal error');
            end
            function changeCW(obj, event)
                pause(0.001);
                cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
                jString   = cmdWinDoc.getText(cmdWinDoc.getStartPosition.getOffset, ...
                                       cmdWinDoc.getLength);
                app.TextArea.Value = char(jString);
                scroll(app.TextArea, 'bottom');
            end

            app.Timer = timer('TimerFcn',@(obj, event)changeCW, 'ExecutionMode','fixedRate', 'Period', 0.5, 'TasksToExecute', inf);
%             start(app.Timer);
            function closeme(obj, event)
                stop(app.Timer);
                delete(obj);
            end
            set(app.Robot_toolboxUIFigure, 'CloseRequestFcn', @closeme);
            
%             get(app.Timer, 'Running')
%             setPromptFcn(app,jTextArea);
            
            app.Config = struct('options',[], 'chains',[], 'approach',[], 'jointTypes',[], 'optim',[], 'pert', []);
            app.camMatrix1.Data = cell(3,3);
            app.camMatrix1.ColumnEditable = true;
            app.camMatrix1.ColumnWidth = {89,89,89,89};
            app.camMatrix2.Data = cell(3,3);
            app.camMatrix2.ColumnEditable = true;
            app.camMatrix2.ColumnWidth = {89,89,89,89};
            app.camMatrix3.Data = cell(3,3);
            app.camMatrix3.ColumnEditable = true;
            app.camMatrix3.ColumnWidth = {89,89,89,89};
            app.rCoef1.Data = cell(1,6);
            app.rCoef1.ColumnEditable = true;
            app.rCoef1.ColumnWidth = {40,40,40,40,40,40};
            app.tCoef1.Data = cell(1,2);
            app.tCoef1.ColumnEditable = true;
            app.tCoef1.ColumnWidth = {103,103};
            app.rCoef2.Data = cell(1,6);
            app.rCoef2.ColumnEditable = true;
            app.rCoef2.ColumnWidth = {40,40,40,40,40,40};
            app.tCoef2.Data = cell(1,2);
            app.tCoef2.ColumnEditable = true;
            app.tCoef2.ColumnWidth = {103,103};
            app.rCoef3.Data = cell(1,6);
            app.rCoef3.ColumnEditable = true;
            app.rCoef3.ColumnWidth = {40,40,40,40,40,40};
            app.tCoef3.Data = cell(1,2);
            app.tCoef3.ColumnEditable = true;
            app.tCoef3.ColumnWidth = {103,103};
            app.DatasetData.ColumnName = {'Pose','Frame','Frame2','Point','RefPoint','Camera','Joints rightArm', 'Joints leftArm', ...
            'Joints torso', 'Joints head', 'Joints leftEye', 'Joints rightEye', 'Joints leftLeg', 'Joints rightLeg', 'Joints leftIndex', ...
            'Joints rightIndex', 'Joints leftThumb', 'Joints rightThumb', 'Joints leftMiddle', 'Joints rightMiddle'};
            app.jointTypesListBoxProp = app.jointTypesListBox.Value;
            app.ChainsListBoxProp = app.ChainsListBox.Value;
            app.ApproachListBoxProp = app.ApproachListBox.Value;
            app.Whitelist = [];
            app.Bounds = [];
            app.Robot = [];
            app.SaveVars = [0,0,0];
            app.SaveFolder = '';
            app.VisuFolder = '';
%             app.RobotFunction.Value = 'loadMotoman';
%             app.EditField_2.Value = 'motomanOptConfig';
%             app.DatasetfunctionEditField.Value = 'loadDatasetMotoman';
            app.DatasetparametersTextArea.Value = ''; % mat2str([1,0,0,0]);
            app.Configuration = {};
            app.JointDistributionButton.Enable = 'off';
            app.PosesviewButton.Enable = 'off';
            app.LoadConfigButton.Enable = 'off';
            app.LoadWhitelistButton.Enable = 'off';
            app.LoadBoundsButton.Enable = 'off';
            %app.LoadRobotButton.Enable = 'off';
            app.LoadKinematicsButton.Enable = 'off';
            app.LoadKinematicsButton_2.Enable = 'off';
            app.LoadDatasetButton.Enable = 'off';
            app.RunCalibrationButton.Enable = 'off';
            app.JacobiansObsButton.Enable = 'off';
            app.CorrectionsButton.Enable = 'off';
            app.RMSEBarsButton.Enable = 'off';
            app.RMSEBoxplotsButton.Enable = 'off';
            app.ResetJointsButton.Enable = 'off';
            app.ShowRobotButton.Enable = 'off';
            app.SaveConfigfileButton.Enable = 'off';
            app.LoadConfigfileButton.Enable = 'off';
            app.LoadDatasetfileButton.Enable = 'off';
            app.SaveDatasetfileButton.Enable = 'off';
            app.SaveRobotfileButton.Enable = 'off';
            app.SaveRobotfileButton_2.Enable = 'off';
            app.SaveRobotfileButton_3.Enable = 'off';
            app.SaveRobotfileButton_4.Enable = 'off';
            app.TabGroup.SelectedTab = app.MainTab;
            app.TabGroup2.SelectedTab = app.JointsTab;
            app.Panel.Visible = 'off';
            app.Panel_2.Visible = 'off';
            app.Panel_3.Visible = 'off';
            app.Panel_4.Visible = 'off';
            app.Panel_5.Visible = 'off';
            app.Panel_6.Visible = 'off';
            app.SaveboundsButton.Visible = 'off';
            app.SavewhitelistButton.Visible = 'off';
            app.WLFile = '';
            app.RobotFile = '';
            app.BoundsFile = '';
            app.ConfigFile = '';
            app.DatasetFile = '';
            
            if verLessThan('matlab','9.5')
            else
                app.ResetJointsButton.Tooltip = {'Set joints configuration to default Joints from Robot M-function'};
                app.ShowRobotButton.Tooltip = {'Show robot model with given joints configuration'};
                app.dualrobotCheckBox.Tooltip = {'Show robot with default parameters and with the ones from Load Kinematics'};
                app.LoadRobotButton.Tooltip = {'Load Robot M-function'};
                app.LoadConfigButton.Tooltip = {'Load Config M-function (Approach, joint Types and Chains must be chosen)'};
                app.LoadWhitelistButton.Tooltip = {'Load Whitelist M-function (Robot must be loaded)'};
                app.LoadBoundsButton.Tooltip = {'Load Bounds M-function  (Robot must be loaded)'};
                app.LoadKinematicsButton_2.Tooltip = {'Select text file with Kinematics parameters'};
                app.TypeButtonGroup.Tooltip = {'Select Kinematics parameters with {max, min, median} rms errors for given perturbation level'};
                app.PertSpinner.Tooltip = {'Select Kinematics parameters with given Perturbation level (0- no perturbation, 0< perturbation level) '};
                app.RepSpinner.Tooltip = {'Select Kinematics parameters with given repetition index'};
                app.LoadKinematicsButton.Tooltip = {'Select mat file with Kinematics parameters (must be in Results/<folder>)  (Robot must be loaded)'};
                app.DatasetparametersTextArea.Tooltip = {'Additional parameters for dataset M-function (as varargin)'};
                app.LoadDatasetButton.Tooltip = {'Load Dataset M-function (Config and Robot must be loaded)'};
                app.JointDistributionButton.Tooltip = {'Show joint distribution, one figure for each dataset'};
                app.PosesviewButton.Tooltip = {'Show moving model of the robot, one figure for each dataset'};
                app.CorrectionsButton.Tooltip = {'Plot kinematics corrections (results-start)'};
                app.RMSEBoxplotsButton.Tooltip = {'Plot RMS errors boxplot'};
                app.RMSEBarsButton.Tooltip = {'Plot RMS errors with max and min over repetitions'};
                app.JacobiansObsButton.Tooltip = {'Plot Jacobians (identifiability) and Observation indexes (observability)'};
                app.VisualisationfoldernameEditField.Tooltip = {'Folder with calibration results used for Visualisations (default - same as Save folder, but can be changed)'};
                app.ApproachListBox.Tooltip = {'Choose calibration type (approach)'};
                app.jointTypesListBox.Tooltip = {'Choose joint types to calibrate'};
                app.ChainsListBox.Tooltip = {'Choose chains to calibrate'};
                app.RunCalibrationButton.Tooltip = {'Run calibration (Robot, Config and Dataset must be loaded and save folder name set)'};
                app.SavejacobiansCheckBox.Tooltip = {'Save jacobians to mat file'};
                app.SavedatasetCheckBox.Tooltip = {'Save dataset to mat file'};
                app.SavevarsCheckBox.Tooltip = {'Save additional variables to info.mat (more info in Readme)'};
                app.SavefoldernameEditField.Tooltip = {'Folder where the calibration results will be saved (Results/<folder name>)'};
                app.ApproachListBox_3.Tooltip = {'Choose calibration type (approach)'};
                app.jointTypesListBox_3.Tooltip = {'Choose joint types to calibrate'};
                app.ChainsListBox_3.Tooltip = {'Choose chains to calibrate'};
                app.UITable2_3.Tooltip = {'Each row is one perturbation level - additive perturbation from interval (-value, value)  in [m]'};
                app.UITable2.Tooltip = {'calibration settings'};
                app.UITable2_2.Tooltip = {'lsqnonlin solver options'};
                app.UITable4.Tooltip = {'Robot joints (and skin etc) with their type, parent, group and index to kinematics table.'};
                app.RobotnameEditField.Tooltip = {'Robot name'};
                app.UITable5.Tooltip = {'DH or 6D kinematics parameters'};
                app.UITable5_2.Tooltip = {'Calibration whitelist - which parameters will be calibrated'};
                app.UITable5_3.Tooltip = {'Max and min value for each parameter (bounded calibration)'};
                app.tCoef1.Tooltip = {'r1 and r2 tangential distortion coefficients'};
                app.rCoef1.Tooltip = {'k1, k2 and r3 radial distortion coefficients'};
                app.camMatrix1.Tooltip = {'3x3 camera matrix'};
                app.tCoef2.Tooltip = {'r1 and r2 tangential distortion coefficients'};
                app.rCoef2.Tooltip = {'k1, k2 and r3 radial distortion coefficients'};
                app.camMatrix2.Tooltip = {'3x3 camera matrix'};
                app.tCoef3.Tooltip = {'r1 and r2 tangential distortion coefficients'};
                app.rCoef3.Tooltip = {'k1, k2 and r3 radial distortion coefficients'};
                app.camMatrix3.Tooltip = {'3x3 camera matrix'};
                app.DatasetnameEditField.Tooltip = {'Dataset name (used for visualisation)'};
                app.DatasettypeDropDown.Tooltip = {'Show dataset with given dataset type'};
                app.DatasetIDDropDown.Tooltip = {'Show dataset with given ID'};
                app.DatasetData.Tooltip = {'Dataset overview'};
                app.UITable.Tooltip = {'Robot joints configuration'};
                app.UITable2.Tooltip = {'Robot default joints configuration'};
            end
        end

        % Button pushed function: LoadRobotButton, 
        % LoadRobotfileButton, LoadRobotfileButton_2, 
        % LoadRobotfileButton_3, LoadRobotfileButton_4
        function LoadRobotButtonPushed(app, event)
            [file, ~] = uigetfile('*.m');
            if length(file) == 1 && file == 0
                return
            end
            app.Bounds = struct();
            app.Robot = Robot(file(1:end-2));
            app.RobotnameEditField.Value = app.Robot.name;
            app.Robot.showGraphModel(app.UIAxes2);
            app.UITable4.Data = app.Robot.jointsStructure;
            [app.Robot.structure.DH, app.Robot.structure.type] = padVectors(app.Robot.structure.DH);
            [app.Robot.structure.WL, ~] = padVectors(app.Robot.structure.WL, 1);
            [app.Robot.structure.bounds, ~] = padVectors(app.Robot.structure.bounds);
            boundsNames = fieldnames(app.Robot.structure.bounds);
            WLNames = fieldnames(app.Robot.structure.WL);
            for f = fieldnames(app.Robot.structure.DH)'
                joints = app.Robot.findJointByGroup(f{1});
                temp = [];
                for joint=joints
                    joint=joint{1};
                    if ~any(ismember(boundsNames, joint.type))
                        temp = [temp;nan(1,6)];
                    elseif size(app.Robot.structure.bounds.(joint.type),2)==4
                        temp_ = nan(1,6);
                        temp_([1,2,4,6]) = app.Robot.structure.bounds.(joint.type);
                        temp = [temp; temp_];
                    else
                        temp = [temp;app.Robot.structure.bounds.(joint.type)];
                    end
                end
                app.Bounds.(f{1}) = temp;
                if ~any(ismember(WLNames, f{1}))
                   temp = nan(1,6);
%                 elseif size(app.Robot.structure.WL.(f{1}), 2) == 4
%                    temp = nan(size(app.Robot.structure.WL.(f{1}), 1),6);
%                    temp(:, [1,2,4,6]) = app.Robot.structure.WL.(f{1});
                else
                    temp = app.Robot.structure.WL.(f{1});
                end
                app.Whitelist.(f{1}) = temp;
            end
%             [app.Whitelist,~] = padVectors(app.Whitelist, 1);
%             [app.Bounds,~] = padVectors(app.Bounds);
            %app.Whitelist = app.Robot.structure.WL; 
            app.GroupDropDown_2ValueChanged(event);
            app.GroupDropDown_3ValueChanged(event);
            app.GroupDropDown_2.Items = fieldnames(app.Robot.structure.DH);
            app.GroupDropDown_3.Items = fieldnames(app.Robot.structure.DH);
            [DH, type] = padVectors(app.Robot.structure.DH);
            app.Robot.structure.DH = DH;
            app.Robot.structure.type = type;
            fnames = fieldnames(app.Robot.structure.DH);
            if strcmp(fnames{1}, 'torso')
                fnames = fnames(2:end);
                app.Configuration.torso = nan(size(app.Robot.structure.DH.torso));
            end
            for i=1:length(fnames)
                if i>length(app.Robot.structure.defaultJoints)
                    app.Configuration.(fnames{i}) = nan(size(app.Robot.structure.DH.(fnames{i})));
                else
                    app.Configuration.(fnames{i}) = app.Robot.structure.defaultJoints{i};
                end
            end
            app.DefaultJoints = app.Configuration;
            app.GroupDropDown.Items = fieldnames(app.Robot.structure.DH);
            app.ChainsListBox.Items = fieldnames(app.Robot.structure.DH);
            app.configurationDropDown();
%             axes(app.UIAxes);
%             app.Robot.showModel('figName', 'Robot_toolbox');
            app.ShowRobotButton.Enable = 'on';
            app.ResetJointsButton.Enable = 'on';
            app.CalibrationoptionsPanel.Enable = 'on';
            objJoints = [app.Robot.joints{:}];
            
            types = unique({objJoints.type});
            
            app.jointTypesListBox.Items = [types(~strcmp(types,'base')), {'onlyOffsets'}];
%             if ~isempty(app.jointTypesListBoxProp) && ~isempty(app.ChainsListBoxProp) && ~isempty(app.ApproachListBoxProp)
%                 app.LoadConfigButton.Enable = 'on';
%                 app.LoadConfigfileButton.Enable = 'on';
%             end
            app.LoadBoundsButton.Enable = 'on';
            app.LoadWhitelistButton.Enable = 'on';
            app.LoadKinematicsButton.Enable = 'on';
            app.LoadKinematicsButton_2.Enable = 'on';
            if ~strcmp(app.ConfigFile, '')
               app.LoadDatasetButton.Enable = 'on'; 
               app.LoadDatasetfileButton.Enable = 'on';
            end
%             app.ButtonGroupSelectionChanged([]);
            app.RobotFile = file(1:end-2);
            if isfield(app.Robot.structure, 'eyes')
                for cam = 1:size(app.Robot.structure.eyes.dist, 2)
                    app.(['tCoef', num2str(cam)]).Data = app.Robot.structure.eyes.tandist(cam, :);
                    app.(['rCoef', num2str(cam)]).Data = app.Robot.structure.eyes.dist(:,cam)';
                    app.(['camMatrix', num2str(cam)]).Data = app.Robot.structure.eyes.matrix(:,:,cam);
                end
                for cam = size(app.Robot.structure.eyes.dist, 2):3
                    app.(['tCoef', num2str(cam)]).ColumnEditable = false;
                    app.(['rCoef', num2str(cam)]).ColumnEditable = false;
                    app.(['camMatrix', num2str(cam)]).ColumnEditable = false;
                end
            end
        end

        % Value changed function: GroupDropDown_2
        function GroupDropDown_2ValueChanged(app, event)
            app.UITable5.Data = [];
            if size(app.Robot.structure.DH.(app.GroupDropDown_2.Value), 2) == 4
                app.UITable5.Data(:, [1,2,4,6]) = app.Robot.structure.DH.(app.GroupDropDown_2.Value);
            else
                app.UITable5.Data = app.Robot.structure.DH.(app.GroupDropDown_2.Value);
            end
            app.configurationDropDown();
            
        end

        % Value changed function: GroupDropDown_3
        function GroupDropDown_3ValueChanged(app, event)
            app.UITable5_2.Data = [];
            app.UITable5_3.Data = [];
%             if ~isempty(app.Whitelist)
%                 if size(app.Whitelist.(app.GroupDropDown_3.Value), 2) == 4
%                     app.UITable5_2.Data(:, [1,2,4,6]) = app.Whitelist.(app.GroupDropDown_3.Value);
%                 else
                    app.UITable5_2.Data = app.Whitelist.(app.GroupDropDown_3.Value);
%                 end
%             elseif ~isempty(app.Robot)
%                 if size(app.Robot.structure.WL.(app.GroupDropDown_3.Value), 2) == 4
%                     app.UITable5_2.Data(:, [1,2,4,6]) = app.Robot.structure.WL.(app.GroupDropDown_3.Value);
%                 else
%                     app.UITable5_2.Data = app.Robot.structure.WL.(app.GroupDropDown_3.Value);
%                 end
%             end
%             if ~isempty(app.Bounds)
%                 if size(app.Bounds.(app.GroupDropDown_3.Value), 2) == 4
%                     app.UITable5_3.Data(:, [1,2,4,6]) = app.Bounds.(app.GroupDropDown_3.Value);
%                 else
                    app.UITable5_3.Data = app.Bounds.(app.GroupDropDown_3.Value);
%                 end
%             elseif ~isempty(app.Robot)
%                 joints = app.Robot.findJointByGroup(app.GroupDropDown_3.Value);
%                 temp = [];
%                 for joint=joints
%                     joint=joint{1};
%                     if length(app.Robot.structure.bounds.(joint.type))==4
%                         temp_ = nan(1,6);
%                         temp_([1,2,4,6]) = app.Robot.structure.bounds.(joint.type);
%                         temp = [temp; temp_];
%                     else
%                         temp = [temp;app.Robot.structure.bounds.(joint.type)];
%                     end
%                 end
%                 app.UITable5_3.Data = temp;
%             end
            
        end

        % Button pushed function: LoadConfigButton
        function LoadConfigButtonPushed(app, event)
            [file, ~] = uigetfile('*.m');
            if length(file) == 1 && file == 0
                return
            end
            [app.Config.options, app.Config.chains, app.Config.approach, app.Config.jointTypes, app.Config.optim, app.Config.pert] = loadConfig(file(1:end-2), app.ApproachListBoxProp, app.ChainsListBoxProp, app.jointTypesListBoxProp);

            
            app.configChangeTable(app.Config.options, app.UITable2_2);
            app.configChangeTable(app.Config.optim, app.UITable2);
            app.UITable2_3.Data = [];
            temp = [];
            index = 1;
            for item=reshape(app.Config.pert, 1, [])
                item = item{1};
                if length(item) == 4
                    temp_ = nan(1,6);
                    temp_([1,2,4,6]) = item;
                    item = temp_;
                end
                app.Config.pert{index} = item;
                temp = [temp; item];
                index = index + 1;
            end
            app.UITable2_3.Data = temp;
            app.changeListBox('chains', {'ChainsListBox', 'ChainsListBox_3'});
            app.changeListBox('jointTypes', {'jointTypesListBox_3', 'jointTypesListBox'});
            app.changeListBox('approach', {'ApproachListBox', 'ApproachListBox_3'});
            if ~isempty(app.Robot)
                app.LoadDatasetButton.Enable = 'on';
                app.LoadDatasetfileButton.Enable = 'on';
            end
            app.ConfigFile = file(1:end-2);
        end

        % Value changed function: ApproachListBox, 
        % ApproachListBox_3, ChainsListBox, ChainsListBox_3, 
        % jointTypesListBox, jointTypesListBox_3
        function ListBoxValueChangedCallback(app, event)
            box = event.Source.Tag;
            box_ = split(box, '_');
            box_ = box_{1};
            app.listBoxValueChanged(box, [box_,'Prop']);
            if ~isempty(app.Robot) && ~isempty(app.jointTypesListBoxProp) && ~isempty(app.ChainsListBoxProp) && ~isempty(app.ApproachListBoxProp)
%             if ~isempty(app.jointTypesListBoxProp) && ~isempty(app.ChainsListBoxProp) && ~isempty(app.ApproachListBoxProp)
                app.LoadConfigButton.Enable = 'on';
                app.LoadConfigfileButton.Enable = 'on';
            else
                app.LoadConfigButton.Enable = 'off';
                app.LoadConfigfileButton.Enable = 'off';
            end
        end

        % Button pushed function: LoadWhitelistButton
        function LoadWhitelistButtonPushed(app, event)
            [file, ~] = uigetfile('*.m');
            if length(file) == 1 && file == 0
                return
            end
            func = str2func(file(1:end-2));
            app.Whitelist = func();
            app.GroupDropDown_3ValueChanged(event);
            app.GroupDropDown_3.Items = fieldnames(app.Robot.structure.DH);
            app.WLFile = file(1:end-2);
        end

        % Button pushed function: LoadBoundsButton
        function LoadBoundsButtonPushed(app, event)
            [file, ~] = uigetfile('*.m');
            if length(file) == 1 && file == 0
                return
            end
            func = str2func(file(1:end-2));
            app.Bounds = func();
            app.GroupDropDown_3ValueChanged(event);
            app.GroupDropDown_3.Items = fieldnames(app.Robot.structure.DH);
            app.BoundsFile = file(1:end-2);
        end

        % Button pushed function: LoadDatasetButton, 
        % LoadDatasetfileButton
        function LoadDatasetButtonPushed(app, event)
            [file, ~] = uigetfile('*.m');
            if length(file) == 1 && file == 0
                return
            end
            func = str2func(file(1:end-2));
            params = app.DatasetparametersTextArea.Value;
            if ~strcmp(get(app.Timer, 'Running'), 'on')
                start(app.Timer);
            end
            app.Dataset = func(app.Robot, app.Config.optim, app.Config.chains, reshape(params, 1, []));
            
            for appr=fieldnames(app.Config.approach)'
               assert(~(~isfield(app.Dataset, appr{1}) && app.Config.approach.(appr{1})), ['Dataset for ', appr{1}, ' is emtpy!'])
               if app.Config.approach.(appr{1}) && isfield(app.Dataset, appr{1})
                  for i=1:length(app.Dataset.(appr{1}))
                      assert(~isempty(app.Dataset.(appr{1}){i}.point), ['Dataset for ', appr{1}, ' is emtpy!'])
                  end
               end
               
            end
            items = {};
            for item = fieldnames(app.Dataset)'
                if ~isempty(app.Dataset.(item{1}))
                    items{end+1} = item{1};
                end
            end
            app.DatasettypeDropDown.Items = items;
            app.DatasetIDDropDown.Items = cellfun(@(x) num2str(x), num2cell(1:length(app.Dataset.(app.DatasettypeDropDown.Value))), 'UniformOutput', false);
            app.changeDataset();
            app.DatasetFile = file(1:end-2);
            if ~isempty(app.SavefoldernameEditField.Value)
                app.RunCalibrationButton.Enable = 'on';
            end
            app.JointDistributionButton.Enable = 'on';
            app.PosesviewButton.Enable = 'on';
            
            stop(app.Timer);
        end

        % Value changed function: DatasettypeDropDown
        function DatasettypeDropDownValueChanged(app, event)
            app.DatasetIDDropDown.Items = cellfun(@(x) num2str(x), num2cell(1:length(app.Dataset.(app.DatasettypeDropDown.Value))), 'UniformOutput', false);
            app.DatasetIDDropDown.Value = '1';
            app.changeDataset();
        end

        % Button pushed function: LoadKinematicsButton
        function LoadKinematicsButtonPushed(app, event)
%             if app.MATButton.Value
                [file, path] = uigetfile('*.mat');
                if length(file) == 1 && file == 0
                    return
                end
                path = split(path, '/');
                args = {};
                if ~app.NoneButton.Value
                    for t={'min', 'max', 'median'}
                        if app.([t{1}, 'Button']).Value
                            args{end+1} = 'type';
                            args{end+1} = t{1};
                            break;
                        end
                    end
                else
                    if app.PertSpinner.Value ~= -1
                        args{end+1} = 'pert';
                        args{end+1} = app.PertSpinner.Value;
                    end
                    if app.RepSpinner.Value ~= -1
                        args{end+1} = 'rep';
                        args{end+1} = app.RepSpinner.Value;
                    end
                end
                loadDHfromMat(app.Robot, path{end-1}, args{:});
                [app.Robot.structure.DH, app.Robot.structure.type] = padVectors(app.Robot.structure.DH);
                app.GroupDropDown_2ValueChanged(event);
%             elseif app.TXTButton.Value
%                 loadDHfromTxt(app.Robot, app.KinematicsfolderEditField.Value, app.KinematicsFilename);
%             end
                
        end

        % Value changed function: SavevarsCheckBox
        function SavevarsCheckBoxValueChanged(app, event)
            app.SaveVars(1) = app.SavevarsCheckBox.Value;
            
        end

        % Value changed function: SavejacobiansCheckBox
        function SavejacobiansCheckBoxValueChanged(app, event)
            app.SaveVars(2) = app.SavejacobiansCheckBox.Value;
            
        end

        % Button pushed function: RunCalibrationButton
        function RunCalibrationButtonPushed(app, event)
            [app.Config.options, app.Config.chains, app.Config.approach, app.Config.jointTypes, app.Config.optim, app.Config.pert] = loadConfig(app.Config, app.ApproachListBoxProp, app.ChainsListBoxProp, app.jointTypesListBoxProp);
            assert(~isempty(app.Config.optim), 'Opt config is empty!');

            if isempty(app.Bounds)
                [start_dh, lb_dh, ub_dh] = app.Robot.prepareDH(app.Config.pert, app.Config.optim);
            else
                [start_dh, lb_dh, ub_dh] = app.Robot.prepareDH(app.Config.pert, app.Config.optim, app.Bounds);
            end
            
            if isempty(app.Whitelist)
                [whpars.start_pars, whpars.min_pars, whpars.max_pars, whpars.whitelist, whpars.start_dh] = app.Robot.createWhitelist(start_dh, lb_dh, ub_dh, app.Config.optim, app.Config.chains, app.Config.jointTypes);
            else
                [whpars.start_pars, whpars.min_pars, whpars.max_pars, whpars.whitelist, whpars.start_dh] = app.Robot.createWhitelist(start_dh, lb_dh, ub_dh, app.Config.optim, app.Config.chains, app.Config.jointTypes, app.Whitelist);
            end
            
            assert(~isempty(app.Dataset), 'Dataset is empty!');
            [data.training_set_indexes, data.testing_set_indexes,data.datasets, datasets_out] = app.Robot.prepareDataset(app.Config.optim, app.Config.chains, app.Config.approach, app.Dataset);
            
            saveData.robot_fcn = app.RobotFile;
            saveData.config_fcn = app.ConfigFile;
            saveData.dataset_fcn =  app.DatasetFile;
            saveData.dataset_params = app.DatasetparametersTextArea.Value;
            if ~strcmp(get(app.Timer, 'Running'), 'on')
                start(app.Timer);
            end
            internalCalibration(app.Robot, app.Config, whpars, data, app.SaveFolder, app.SaveVars, saveData);
            if app.SaveVars(3)
               save(['Results/', app.SaveFolder,  '/datasets.mat'], 'datasets_out')
            end
            stop(app.Timer);
        end

        % Value changed function: SavedatasetCheckBox
        function SavedatasetCheckBoxValueChanged(app, event)
            app.SaveVars(3) = app.SavedatasetCheckBox.Value;
        end

        % Value changed function: SavefoldernameEditField
        function SavefoldernameEditFieldValueChanged(app, event)
            app.SaveFolder = app.SavefoldernameEditField.Value;
            app.VisualisationfoldernameEditField.Value = app.SavefoldernameEditField.Value;
            VisualisationfoldernameEditFieldValueChanged(app, event);
%             if ~isempty(app.Robot) && ~isempty(app.SavefoldernameEditField.Value)
%                 app.JacobiansObsButton.Enable = 'on';
%                 app.CorrectionsButton.Enable = 'on';
%                 app.RMSEBarsButton.Enable = 'on';
%                 app.RMSEBoxplotsButton.Enable = 'on';
%             else
%                 app.JacobiansObsButton.Enable = 'off';
%                 app.CorrectionsButton.Enable = 'off';
%                 app.RMSEBarsButton.Enable = 'off';
%                 app.RMSEBoxplotsButton.Enable = 'off';
%             end
            if ~isempty(app.Dataset) && ~isempty(app.SavefoldernameEditField)
                app.RunCalibrationButton.Enable = 'on';
            else
                app.RunCalibrationButton.Enable = 'off';
            end
        end

        % Button pushed function: CorrectionsButton
        function CorrectionsButtonPushed(app, event)
            plotCorrections(app.VisuFolder);
        end

        % Value changed function: GroupDropDown
        function GroupDropDownValueChanged(app, event)
            app.configurationDropDown();
            
        end

        % Button pushed function: ShowRobotButton
        function ShowRobotButtonPushed(app, event)
            joints = {};
            for fname=fieldnames(app.Robot.structure.DH)'
                if ~all(isnan(app.Configuration.(fname{1})))
                    joints{end+1} = app.Configuration.(fname{1});
                end
            end
            if app.dualrobotCheckBox.Value
                app.Robot.showModel(joints, 'dual', 1);
            else
                app.Robot.showModel(joints);
            end
            
        end

        % Button pushed function: JointDistributionButton
        function JointDistributionButtonPushed(app, event)
            for fname=fieldnames(app.Dataset)'
                for datasetId = 1:length(app.Dataset.(fname{1}))
                    plotJointDistribution(app.Robot, {app.Dataset.(fname{1}){datasetId}},[], app.GroupDropDown.Value, app.Dataset.(fname{1}){datasetId}.name, [], 1);
                end
            end
        end

        % Button pushed function: RMSEBarsButton
        function RMSEBarsButtonPushed(app, event)
            plotErrorBars({app.VisuFolder});
        end

        % Button pushed function: RMSEBoxplotsButton
        function RMSEBoxplotsButtonPushed(app, event)
            plotErrorsBoxplots({app.VisuFolder});
        end

        % Cell edit callback: UITable2
        function UITable2CellEdit(app, event)
            edited_var = app.UITable2.Data{event.Indices(1),1};
            data = event.NewData;
            temp = str2num(data);
            if isempty(temp) && ~strcmp(data, '[]')
                temp = data;
            end
            spl = split(edited_var, '.');
            if length(spl)>1
                app.Config.optim.(spl{1}).(spl{2}) = temp;
            else
                app.Config.optim.(edited_var) = temp;
            end
        end

        % Cell edit callback: UITable2_2
        function UITable2_2CellEdit(app, event)
            edited_var = app.UITable2_2.Data{event.Indices(1),1};
            data = event.NewData;
            temp = str2num(data);
            if isempty(temp) && ~strcmp(data, '[]')
                temp = data;
            end
            app.Config.options.(edited_var) = temp;      
        end

        % Cell edit callback: UITable2_3
        function UITable2_3CellEdit(app, event)
             app.Config.pert{event.Indices(1)}(event.Indices(1), event.Indices(2)) = event.NewData;
        end

        % Cell edit callback: UITable5
        function UITable5CellEdit(app, event)
            app.Robot.structure.DH.(app.GroupDropDown_2.Value)(event.Indices(1), event.Indices(2)) = event.NewData;     
        end

        % Cell edit callback: UITable_2
        function UITable_2CellEdit(app, event)
            app.DefaultJoints.(app.GroupDropDown_2.Value)(event.Indices(1), event.Indices(2)) = event.NewData;    
            app.configurationDropDown();
        end

        % Cell edit callback: UITable5_2
        function UITable5_2CellEdit(app, event)
            app.Whitelist.(app.GroupDropDown_3.Value)(event.Indices(1), event.Indices(2)) = event.NewData;              
        end

        % Cell edit callback: UITable5_3
        function UITable5_3CellEdit(app, event)
            app.Bounds.(app.GroupDropDown_3.Value)(event.Indices(1), event.Indices(2)) = event.NewData;                      
        end

        % Button pushed function: ResetJointsButton
        function ResetJointsButtonPushed(app, event)
%             fnames = fieldnames(app.Robot.structure.DH);
            app.Configuration = app.DefaultJoints;
%             for i=1:length(fnames)
%                 if i>length(app.Robot.structure.defaultJoints)
%                     app.Configuration.(fnames{i}) = nan(size(app.Robot.structure.DH.(fnames{i})));
%                 else
%                     app.Configuration.(fnames{i}) = app.Robot.structure.defaultJoints{i};
%                 end
%             end
            app.configurationDropDown();
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            app.Configuration.(app.GroupDropDown.Value)(event.Indices(2)) = event.NewData;    
            app.configurationDropDown();
        end

        % Callback function
        function DatasetidEditFieldValueChanged(app, event)
            app.changeDataset();
        end

        % Value changed function: DatasetnameEditField
        function DatasetnameEditFieldValueChanged(app, event)
            id = app.DatasetidEditField.Value;
            type = app.DatasettypeDropDown.Value;
            app.Dataset.(type){id}.name = app.DatasetnameEditField.Value; 
        end

        % Value changed function: RobotnameEditField
        function RobotnameEditFieldValueChanged(app, event)
            app.Robot.name = app.RobotnameEditField.Value;
        end

        % Cell edit callback: UITable4
        function UITable4CellEdit(app, event)
            app.Robot.jointsStructure{event.Indices(1), event.Indices(2)} = event.NewData;
            curJoint=app.Robot.jointsStructure(event.Indices(1), :);
            if ~isnan(curJoint{3})
                parentName=curJoint{3};
                % find parent by string Name
                [j,parentId]=app.Robot.findJoint(parentName);
                parentId=find(parentId);
                if isempty(j)
                    error('Joint %s does not exist\n',parentName);
                end
                j=j{1};
            else
                j=nan;
                parentId=0;
                assert(strcmp(curJoint{2}, types.base), 'Joint without parent must be of type: ''base''')
            end
            %Call Joint constructor
            app.Robot.joints{event.Indices(1)} = Joint(curJoint{1},curJoint{2},j,curJoint{4},curJoint{5},parentId);
            app.Robot.showGraphModel(app.UIAxes2);
        end

        % Button pushed function: ReturntomainButton, 
        % ReturntomainButton_2, ReturntomainButton_3, 
        % ReturntomainButton_4, ReturntomainButton_5, 
        % ReturntomainButton_6
        function ReturntomainButtonPushed(app, event)
            app.TabGroup.SelectedTab = app.MainTab;
        end

        % Button pushed function: NexttabButton
        function NexttabButtonPushed(app, event)
            app.TabGroup2.SelectedTab = app.KinematicsTab;
        end

        % Button pushed function: NexttabButton_3
        function NexttabButton_3Pushed(app, event)
            app.TabGroup2.SelectedTab = app.CameraseyesTab;
        end

        % Button pushed function: NexttabButton_2
        function NexttabButton_2Pushed(app, event)
            app.TabGroup2.SelectedTab = app.WhitelistBoundsTab;
        end

        % Button pushed function: LoadConfigfileButton
        function LoadConfigfileButtonPushed(app, event)
            [file,~] = uigetfile('*.m');
            app.UseConfigFile = file(1:end-2);
            app.LoadConfigButtonPushed(event);
            app.UseConfigFile = '';
        end

        % Button pushed function: LoadKinematicsButton_2
        function LoadKinematicsButton_2Pushed(app, event)
            [file, path] = uigetfile('.txt');
            if length(file) == 1 && file == 0
                return
            end
%             app.KinematicsFilename = file;
            loadDHfromTxt(app.Robot, [path,file]);
            [app.Robot.structure.DH, app.Robot.structure.type] = padVectors(app.Robot.structure.DH);
            app.GroupDropDown_2ValueChanged(event);
%             if ~isempty(app.Robot) && ~isempty(app.KinematicsfolderEditField.Value) && app.TXTButton.Value
%                 app.LoadKinematicsButton.Enable = 'on';
%             else
%                 app.LoadKinematicsButton.Enable = 'off';
%             end
        end

        % Cell edit callback: DatasetData
        function DatasetDataCellEdit(app, event)
            id = str2double(app.DatasetIDDropDown.Value);
            type = app.DatasettypeDropDown.Value;
            indices = event.Indices;
            col = app.DatasetData.ColumnName{indices(2)};
            col = split(col, ' ');
            if length(col) == 1
                try
                    app.Dataset.(type){id}.(col{1}){indices(1)} = event.NewData;
                catch
                    app.Dataset.(type){id}.(col{1})(indices(1)) = event.NewData;
                end
            elseif strcmp(col{2}, 'joint')
                app.Dataset.(type){id}.joints(indices(1)).(col{1})(str2num(col{3})) = event.NewData;
            elseif strcmp(col{1}, 'point')
                vars = {'x', 'y', 'z'};
                id_ = find(strcmp(vars, col{3}));
                if str2num(col{2}) == 2
                    id_ = id_ + 3;
                end
                app.Dataset.(type){id}.(col{1})(indices(1), id_) = event.NewData;
            elseif strcmp(col{1}, 'camera')
                app.Dataset.(type){id}.cameras(indices(1), str2num(col{2})) = event.NewData;
            elseif strcmp(col{1}, 'refPoints')
                vars1 = {'x', 'y', 'z'};
                vars2 = {'u', 'v'};
                if any(strcmp(vars1, col{3}))
                    id_ = find(strcmp(vars1, col{3}));
                    if str2num(col{2}(end)) == 2
                        id_ = id_ + 3;
                    end
                else
                    id_ = find(strcmp(vars2, col{3}));
                    if str2num(col{2}(end)) == 2
                        id_ = id_ + 2;
                    end
                end
                app.Dataset.(type){id}.(col{1})(indices(1), id_) = event.NewData;
            end
        end

        % Cell edit callback: camMatrix1
        function camMatrix1CellEdit(app, event)
            app.Robot.structure.eyes.matrix(event.Indices(1), event.Indices(2), 1) = event.NewData;
        end

        % Cell edit callback: camMatrix2
        function camMatrix2CellEdit(app, event)
            app.Robot.structure.eyes.matrix(event.Indices(1), event.Indices(2), 2) = event.NewData;
        end

        % Cell edit callback: camMatrix3
        function camMatrix3CellEdit(app, event)
            app.Robot.structure.eyes.matrix(event.Indices(1), event.Indices(2), 3) = event.NewData; 
        end

        % Cell edit callback: tCoef1
        function tCoef1CellEdit(app, event)
            app.Robot.structure.eyes.tandist(1, event.Indices(2)) = event.NewData;
        end

        % Cell edit callback: tCoef2
        function tCoef2CellEdit(app, event)
            app.Robot.structure.eyes.tandist(2, event.Indices(2)) = event.NewData;
        end

        % Cell edit callback: tCoef3
        function tCoef3CellEdit(app, event)
            app.Robot.structure.eyes.tandist(3, event.Indices(2)) = event.NewData;
        end

        % Cell edit callback: rCoef1
        function rCoef1CellEdit(app, event)
            app.Robot.structure.eyes.dist(event.Indices(2), 1) = event.NewData;
        end

        % Cell edit callback: rCoef2
        function rCoef2CellEdit(app, event)
            app.Robot.structure.eyes.dist(event.Indices(2), 2) = event.NewData;
        end

        % Cell edit callback: rCoef3
        function rCoef3CellEdit(app, event)
            app.Robot.structure.eyes.dist(event.Indices(2), 3) = event.NewData;
        end

        % Button pushed function: JacobiansObsButton
        function JacobiansObsButtonPushed(app, event)
            plotJacobian(app.VisuFolder);
            plotObserIndexes(app.VisuFolder);
        end

        % Button pushed function: PosesviewButton
        function PosesviewButtonPushed(app, event)
            dat = struct2cell(app.Dataset);
            activationsView(app.Robot,horzcat(dat{:}))
        end

        % Value changed function: VisualisationfoldernameEditField
        function VisualisationfoldernameEditFieldValueChanged(app, event)
            app.VisuFolder = app.VisualisationfoldernameEditField.Value;
            if  ~isempty(app.VisualisationfoldernameEditField.Value)
                app.JacobiansObsButton.Enable = 'on';
                app.CorrectionsButton.Enable = 'on';
                app.RMSEBarsButton.Enable = 'on';
                app.RMSEBoxplotsButton.Enable = 'on';
            else
                app.JacobiansObsButton.Enable = 'off';
                app.CorrectionsButton.Enable = 'off';
                app.RMSEBarsButton.Enable = 'off';
                app.RMSEBoxplotsButton.Enable = 'off';
            end
        end

        % Callback function
        function DatasetIDDropDownValueChanged(app, event)
            app.changeDataset();
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Robot_toolboxUIFigure and hide until all components are created
            app.Robot_toolboxUIFigure = uifigure('Visible', 'off');
            app.Robot_toolboxUIFigure.Position = [100 100 900 600];
            app.Robot_toolboxUIFigure.Name = 'Robot_toolbox';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.Robot_toolboxUIFigure);
            app.TabGroup.Position = [1 1 900 600];

            % Create MainTab
            app.MainTab = uitab(app.TabGroup);
            app.MainTab.Title = 'Main';

            % Create RobotjointconfigurationPanel
            app.RobotjointconfigurationPanel = uipanel(app.MainTab);
            app.RobotjointconfigurationPanel.Title = 'Robot joint configuration';
            app.RobotjointconfigurationPanel.Position = [430 93 460 134];

            % Create GroupDropDownLabel
            app.GroupDropDownLabel = uilabel(app.RobotjointconfigurationPanel);
            app.GroupDropDownLabel.HorizontalAlignment = 'center';
            app.GroupDropDownLabel.Position = [9 88 39 15];
            app.GroupDropDownLabel.Text = 'Group';

            % Create GroupDropDown
            app.GroupDropDown = uidropdown(app.RobotjointconfigurationPanel);
            app.GroupDropDown.Items = {'rightArm', 'leftArm', 'torso', 'head', 'leftEye', 'rightEye', 'leftLeg', 'rightLeg', 'leftIndex', 'rightIndex', 'leftThumb', 'rightThumb', 'leftMiddle', 'rightMiddle'};
            app.GroupDropDown.ValueChangedFcn = createCallbackFcn(app, @GroupDropDownValueChanged, true);
            app.GroupDropDown.Position = [55 83 118 25];
            app.GroupDropDown.Value = 'rightArm';

            % Create UITable
            app.UITable = uitable(app.RobotjointconfigurationPanel);
            app.UITable.ColumnName = {'Joint 1'; 'Joint 2'; 'Joint 3'; 'Joint 4'; 'Joint 5'; 'Joint 6'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = true;
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Position = [4 3 452 76];

            % Create ResetJointsButton
            app.ResetJointsButton = uibutton(app.RobotjointconfigurationPanel, 'push');
            app.ResetJointsButton.ButtonPushedFcn = createCallbackFcn(app, @ResetJointsButtonPushed, true);
            app.ResetJointsButton.Position = [176 82 100 30];
            app.ResetJointsButton.Text = 'Reset Joints';

            % Create ShowRobotButton
            app.ShowRobotButton = uibutton(app.RobotjointconfigurationPanel, 'push');
            app.ShowRobotButton.ButtonPushedFcn = createCallbackFcn(app, @ShowRobotButtonPushed, true);
            app.ShowRobotButton.Position = [280 82 100 30];
            app.ShowRobotButton.Text = 'Show Robot';

            % Create dualrobotCheckBox
            app.dualrobotCheckBox = uicheckbox(app.RobotjointconfigurationPanel);
            app.dualrobotCheckBox.Text = 'dual robot';
            app.dualrobotCheckBox.Position = [384 86 75 23];

            % Create LoadfunctionsPanel
            app.LoadfunctionsPanel = uipanel(app.MainTab);
            app.LoadfunctionsPanel.Title = 'Load functions';
            app.LoadfunctionsPanel.Position = [10 483 400 67];

            % Create LoadRobotButton
            app.LoadRobotButton = uibutton(app.LoadfunctionsPanel, 'push');
            app.LoadRobotButton.ButtonPushedFcn = createCallbackFcn(app, @LoadRobotButtonPushed, true);
            app.LoadRobotButton.Position = [1 10 98 30];
            app.LoadRobotButton.Text = 'Load Robot';

            % Create LoadConfigButton
            app.LoadConfigButton = uibutton(app.LoadfunctionsPanel, 'push');
            app.LoadConfigButton.ButtonPushedFcn = createCallbackFcn(app, @LoadConfigButtonPushed, true);
            app.LoadConfigButton.Position = [100 10 98 30];
            app.LoadConfigButton.Text = 'Load Config';

            % Create LoadWhitelistButton
            app.LoadWhitelistButton = uibutton(app.LoadfunctionsPanel, 'push');
            app.LoadWhitelistButton.ButtonPushedFcn = createCallbackFcn(app, @LoadWhitelistButtonPushed, true);
            app.LoadWhitelistButton.Position = [200 10 98 30];
            app.LoadWhitelistButton.Text = 'Load Whitelist';

            % Create LoadBoundsButton
            app.LoadBoundsButton = uibutton(app.LoadfunctionsPanel, 'push');
            app.LoadBoundsButton.ButtonPushedFcn = createCallbackFcn(app, @LoadBoundsButtonPushed, true);
            app.LoadBoundsButton.Position = [300 10 98 30];
            app.LoadBoundsButton.Text = 'Load Bounds';

            % Create LoadrobotkinematicsPanel
            app.LoadrobotkinematicsPanel = uipanel(app.MainTab);
            app.LoadrobotkinematicsPanel.Title = 'Load robot kinematics';
            app.LoadrobotkinematicsPanel.Position = [10 211 400 126];

            % Create TabGroup3
            app.TabGroup3 = uitabgroup(app.LoadrobotkinematicsPanel);
            app.TabGroup3.Position = [0 2 399 104];

            % Create TXTTab
            app.TXTTab = uitab(app.TabGroup3);
            app.TXTTab.Title = 'TXT';

            % Create LoadKinematicsButton_2
            app.LoadKinematicsButton_2 = uibutton(app.TXTTab, 'push');
            app.LoadKinematicsButton_2.ButtonPushedFcn = createCallbackFcn(app, @LoadKinematicsButton_2Pushed, true);
            app.LoadKinematicsButton_2.Position = [10 25 100 30];
            app.LoadKinematicsButton_2.Text = 'Load Kinematics';

            % Create MATTab
            app.MATTab = uitab(app.TabGroup3);
            app.MATTab.Title = 'MAT';

            % Create TypeButtonGroup
            app.TypeButtonGroup = uibuttongroup(app.MATTab);
            app.TypeButtonGroup.Title = 'Type';
            app.TypeButtonGroup.Position = [254 5 130 71];

            % Create NoneButton
            app.NoneButton = uiradiobutton(app.TypeButtonGroup);
            app.NoneButton.Text = 'None';
            app.NoneButton.Position = [11 25 58 22];
            app.NoneButton.Value = true;

            % Create minButton
            app.minButton = uiradiobutton(app.TypeButtonGroup);
            app.minButton.Text = 'Min';
            app.minButton.Position = [62 26 65 22];

            % Create maxButton
            app.maxButton = uiradiobutton(app.TypeButtonGroup);
            app.maxButton.Text = 'Max';
            app.maxButton.Position = [11 4 65 22];

            % Create medianButton
            app.medianButton = uiradiobutton(app.TypeButtonGroup);
            app.medianButton.Text = 'Median';
            app.medianButton.Position = [62 4 65 22];

            % Create PertSpinnerLabel
            app.PertSpinnerLabel = uilabel(app.MATTab);
            app.PertSpinnerLabel.HorizontalAlignment = 'right';
            app.PertSpinnerLabel.Position = [155 40 28 22];
            app.PertSpinnerLabel.Text = 'Pert';

            % Create PertSpinner
            app.PertSpinner = uispinner(app.MATTab);
            app.PertSpinner.Position = [190 42 44 22];
            app.PertSpinner.Value = -1;

            % Create RepSpinnerLabel
            app.RepSpinnerLabel = uilabel(app.MATTab);
            app.RepSpinnerLabel.HorizontalAlignment = 'right';
            app.RepSpinnerLabel.Position = [154 15 28 22];
            app.RepSpinnerLabel.Text = 'Rep';

            % Create RepSpinner
            app.RepSpinner = uispinner(app.MATTab);
            app.RepSpinner.Position = [190 15 44 22];
            app.RepSpinner.Value = -1;

            % Create LoadKinematicsButton
            app.LoadKinematicsButton = uibutton(app.MATTab, 'push');
            app.LoadKinematicsButton.ButtonPushedFcn = createCallbackFcn(app, @LoadKinematicsButtonPushed, true);
            app.LoadKinematicsButton.Position = [10 25 100 30];
            app.LoadKinematicsButton.Text = 'Load Kinematics';

            % Create LoaddatasetPanel
            app.LoaddatasetPanel = uipanel(app.MainTab);
            app.LoaddatasetPanel.Title = 'Load dataset';
            app.LoaddatasetPanel.Position = [10 95 400 104];

            % Create DatasetparametersTextAreaLabel
            app.DatasetparametersTextAreaLabel = uilabel(app.LoaddatasetPanel);
            app.DatasetparametersTextAreaLabel.HorizontalAlignment = 'center';
            app.DatasetparametersTextAreaLabel.Position = [27 45 82 28];
            app.DatasetparametersTextAreaLabel.Text = {'Dataset'; 'parameters'};

            % Create DatasetparametersTextArea
            app.DatasetparametersTextArea = uitextarea(app.LoaddatasetPanel);
            app.DatasetparametersTextArea.Position = [123 6 120 70];

            % Create LoadDatasetButton
            app.LoadDatasetButton = uibutton(app.LoaddatasetPanel, 'push');
            app.LoadDatasetButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDatasetButtonPushed, true);
            app.LoadDatasetButton.Position = [16 7 100 30];
            app.LoadDatasetButton.Text = 'Load Dataset';

            % Create JointDistributionButton
            app.JointDistributionButton = uibutton(app.LoaddatasetPanel, 'push');
            app.JointDistributionButton.ButtonPushedFcn = createCallbackFcn(app, @JointDistributionButtonPushed, true);
            app.JointDistributionButton.Position = [270 47 100 30];
            app.JointDistributionButton.Text = 'Joint Distribution';

            % Create PosesviewButton
            app.PosesviewButton = uibutton(app.LoaddatasetPanel, 'push');
            app.PosesviewButton.ButtonPushedFcn = createCallbackFcn(app, @PosesviewButtonPushed, true);
            app.PosesviewButton.Position = [270 9 100 30];
            app.PosesviewButton.Text = 'Poses view';

            % Create VisualisationPanel
            app.VisualisationPanel = uipanel(app.MainTab);
            app.VisualisationPanel.Title = 'Visualisation';
            app.VisualisationPanel.Position = [430 5 460 83];

            % Create CorrectionsButton
            app.CorrectionsButton = uibutton(app.VisualisationPanel, 'push');
            app.CorrectionsButton.ButtonPushedFcn = createCallbackFcn(app, @CorrectionsButtonPushed, true);
            app.CorrectionsButton.Position = [125 3 100 30];
            app.CorrectionsButton.Text = 'Corrections';

            % Create RMSEBoxplotsButton
            app.RMSEBoxplotsButton = uibutton(app.VisualisationPanel, 'push');
            app.RMSEBoxplotsButton.ButtonPushedFcn = createCallbackFcn(app, @RMSEBoxplotsButtonPushed, true);
            app.RMSEBoxplotsButton.Position = [235 3 100 30];
            app.RMSEBoxplotsButton.Text = 'RMSE Boxplots';

            % Create RMSEBarsButton
            app.RMSEBarsButton = uibutton(app.VisualisationPanel, 'push');
            app.RMSEBarsButton.ButtonPushedFcn = createCallbackFcn(app, @RMSEBarsButtonPushed, true);
            app.RMSEBarsButton.Position = [345 3 100 30];
            app.RMSEBarsButton.Text = 'RMSE Bars';

            % Create JacobiansObsButton
            app.JacobiansObsButton = uibutton(app.VisualisationPanel, 'push');
            app.JacobiansObsButton.ButtonPushedFcn = createCallbackFcn(app, @JacobiansObsButtonPushed, true);
            app.JacobiansObsButton.Position = [15 3 100 30];
            app.JacobiansObsButton.Text = 'Jacobians & Obs.';

            % Create VisualisationfoldernameEditFieldLabel
            app.VisualisationfoldernameEditFieldLabel = uilabel(app.VisualisationPanel);
            app.VisualisationfoldernameEditFieldLabel.HorizontalAlignment = 'right';
            app.VisualisationfoldernameEditFieldLabel.Position = [9 36 138 22];
            app.VisualisationfoldernameEditFieldLabel.Text = 'Visualisation folder name';

            % Create VisualisationfoldernameEditField
            app.VisualisationfoldernameEditField = uieditfield(app.VisualisationPanel, 'text');
            app.VisualisationfoldernameEditField.ValueChangedFcn = createCallbackFcn(app, @VisualisationfoldernameEditFieldValueChanged, true);
            app.VisualisationfoldernameEditField.Position = [153 38 135 20];

            % Create CalibrationoptionsPanel
            app.CalibrationoptionsPanel = uipanel(app.MainTab);
            app.CalibrationoptionsPanel.Enable = 'off';
            app.CalibrationoptionsPanel.Title = 'Calibration options';
            app.CalibrationoptionsPanel.Position = [10 350 400 115];

            % Create ApproachListBoxLabel
            app.ApproachListBoxLabel = uilabel(app.CalibrationoptionsPanel);
            app.ApproachListBoxLabel.HorizontalAlignment = 'right';
            app.ApproachListBoxLabel.Position = [38 67 57 22];
            app.ApproachListBoxLabel.Text = 'Approach';

            % Create ApproachListBox
            app.ApproachListBox = uilistbox(app.CalibrationoptionsPanel);
            app.ApproachListBox.Items = {'selftouch', 'planes', 'external', 'projection'};
            app.ApproachListBox.Multiselect = 'on';
            app.ApproachListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChangedCallback, true);
            app.ApproachListBox.Tag = 'ApproachListBox';
            app.ApproachListBox.Position = [10 9 115 60];
            app.ApproachListBox.Value = {};

            % Create jointTypesLabel
            app.jointTypesLabel = uilabel(app.CalibrationoptionsPanel);
            app.jointTypesLabel.HorizontalAlignment = 'right';
            app.jointTypesLabel.Position = [162 65 63 28];
            app.jointTypesLabel.Text = 'joint Types';

            % Create jointTypesListBox
            app.jointTypesListBox = uilistbox(app.CalibrationoptionsPanel);
            app.jointTypesListBox.Items = {'joint', 'eye', 'torso', 'patch', 'triangle', 'mount', 'finger', 'taxel', 'onlyOffsets'};
            app.jointTypesListBox.Multiselect = 'on';
            app.jointTypesListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChangedCallback, true);
            app.jointTypesListBox.Tag = 'jointTypesListBox';
            app.jointTypesListBox.Position = [140 9 115 60];
            app.jointTypesListBox.Value = {};

            % Create ChainsListBoxLabel
            app.ChainsListBoxLabel = uilabel(app.CalibrationoptionsPanel);
            app.ChainsListBoxLabel.HorizontalAlignment = 'right';
            app.ChainsListBoxLabel.Position = [301 69 43 22];
            app.ChainsListBoxLabel.Text = 'Chains';

            % Create ChainsListBox
            app.ChainsListBox = uilistbox(app.CalibrationoptionsPanel);
            app.ChainsListBox.Items = {'rightArm', 'leftArm', 'torso', 'head', 'leftEye', 'rightEye', 'leftLeg', 'rightLeg', 'leftIndex', 'rightIndex', 'leftThumb', 'rightThumb', 'leftMiddle', 'rightMiddle'};
            app.ChainsListBox.Multiselect = 'on';
            app.ChainsListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChangedCallback, true);
            app.ChainsListBox.Tag = 'ChainsListBox';
            app.ChainsListBox.Position = [270 9 115 60];
            app.ChainsListBox.Value = {};

            % Create CalibrationsettingsPanel_4
            app.CalibrationsettingsPanel_4 = uipanel(app.MainTab);
            app.CalibrationsettingsPanel_4.Title = 'Calibration settings';
            app.CalibrationsettingsPanel_4.Position = [10 7 400 78];

            % Create RunCalibrationButton
            app.RunCalibrationButton = uibutton(app.CalibrationsettingsPanel_4, 'push');
            app.RunCalibrationButton.ButtonPushedFcn = createCallbackFcn(app, @RunCalibrationButtonPushed, true);
            app.RunCalibrationButton.Position = [292 5 100 49];
            app.RunCalibrationButton.Text = 'Run Calibration';

            % Create SavejacobiansCheckBox
            app.SavejacobiansCheckBox = uicheckbox(app.CalibrationsettingsPanel_4);
            app.SavejacobiansCheckBox.ValueChangedFcn = createCallbackFcn(app, @SavejacobiansCheckBoxValueChanged, true);
            app.SavejacobiansCheckBox.Text = 'Save jacobians';
            app.SavejacobiansCheckBox.Position = [95 28 103 22];

            % Create SavedatasetCheckBox
            app.SavedatasetCheckBox = uicheckbox(app.CalibrationsettingsPanel_4);
            app.SavedatasetCheckBox.ValueChangedFcn = createCallbackFcn(app, @SavedatasetCheckBoxValueChanged, true);
            app.SavedatasetCheckBox.Text = 'Save dataset';
            app.SavedatasetCheckBox.Position = [200 28 92 22];

            % Create SavevarsCheckBox
            app.SavevarsCheckBox = uicheckbox(app.CalibrationsettingsPanel_4);
            app.SavevarsCheckBox.ValueChangedFcn = createCallbackFcn(app, @SavevarsCheckBoxValueChanged, true);
            app.SavevarsCheckBox.Text = 'Save vars';
            app.SavevarsCheckBox.Position = [14 28 75 22];

            % Create SavefoldernameEditFieldLabel
            app.SavefoldernameEditFieldLabel = uilabel(app.CalibrationsettingsPanel_4);
            app.SavefoldernameEditFieldLabel.HorizontalAlignment = 'right';
            app.SavefoldernameEditFieldLabel.Position = [13 4 100 22];
            app.SavefoldernameEditFieldLabel.Text = 'Save folder name';

            % Create SavefoldernameEditField
            app.SavefoldernameEditField = uieditfield(app.CalibrationsettingsPanel_4, 'text');
            app.SavefoldernameEditField.ValueChangedFcn = createCallbackFcn(app, @SavefoldernameEditFieldValueChanged, true);
            app.SavefoldernameEditField.Position = [128 4 155 22];

            % Create TextArea
            app.TextArea = uitextarea(app.MainTab);
            app.TextArea.Editable = 'off';
            app.TextArea.Position = [430 239 460 312];

            % Create ConfigTab
            app.ConfigTab = uitab(app.TabGroup);
            app.ConfigTab.Title = 'Config';

            % Create CalibrationoptionsPanel_2
            app.CalibrationoptionsPanel_2 = uipanel(app.ConfigTab);
            app.CalibrationoptionsPanel_2.Title = 'Calibration options';
            app.CalibrationoptionsPanel_2.Position = [478 87 393 115];

            % Create ApproachListBox_3Label
            app.ApproachListBox_3Label = uilabel(app.CalibrationoptionsPanel_2);
            app.ApproachListBox_3Label.HorizontalAlignment = 'right';
            app.ApproachListBox_3Label.Position = [38 67 57 22];
            app.ApproachListBox_3Label.Text = 'Approach';

            % Create ApproachListBox_3
            app.ApproachListBox_3 = uilistbox(app.CalibrationoptionsPanel_2);
            app.ApproachListBox_3.Items = {'selftouch', 'planes', 'external', 'projection'};
            app.ApproachListBox_3.Multiselect = 'on';
            app.ApproachListBox_3.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChangedCallback, true);
            app.ApproachListBox_3.Tag = 'ApproachListBox_3';
            app.ApproachListBox_3.Position = [10 9 115 60];
            app.ApproachListBox_3.Value = {};

            % Create jointTypesListBox_3Label
            app.jointTypesListBox_3Label = uilabel(app.CalibrationoptionsPanel_2);
            app.jointTypesListBox_3Label.HorizontalAlignment = 'right';
            app.jointTypesListBox_3Label.Position = [162 65 63 28];
            app.jointTypesListBox_3Label.Text = 'joint Types';

            % Create jointTypesListBox_3
            app.jointTypesListBox_3 = uilistbox(app.CalibrationoptionsPanel_2);
            app.jointTypesListBox_3.Items = {'joint', 'eye', 'torso', 'patch', 'triangle', 'mount', 'finger', 'taxel', 'onlyOffsets'};
            app.jointTypesListBox_3.Multiselect = 'on';
            app.jointTypesListBox_3.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChangedCallback, true);
            app.jointTypesListBox_3.Tag = 'jointTypesListBox_3';
            app.jointTypesListBox_3.Position = [138 9 115 60];
            app.jointTypesListBox_3.Value = {};

            % Create ChainsListBox_3Label
            app.ChainsListBox_3Label = uilabel(app.CalibrationoptionsPanel_2);
            app.ChainsListBox_3Label.HorizontalAlignment = 'right';
            app.ChainsListBox_3Label.Position = [301 69 43 22];
            app.ChainsListBox_3Label.Text = 'Chains';

            % Create ChainsListBox_3
            app.ChainsListBox_3 = uilistbox(app.CalibrationoptionsPanel_2);
            app.ChainsListBox_3.Items = {'rightArm', 'leftArm', 'torso', 'head', 'leftEye', 'rightEye', 'leftLeg', 'rightLeg', 'leftIndex', 'rightIndex', 'leftThumb', 'rightThumb', 'leftMiddle', 'rightMiddle'};
            app.ChainsListBox_3.Multiselect = 'on';
            app.ChainsListBox_3.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChangedCallback, true);
            app.ChainsListBox_3.Tag = 'ChainsListBox_3';
            app.ChainsListBox_3.Position = [268 9 115 60];
            app.ChainsListBox_3.Value = {};

            % Create Panel
            app.Panel = uipanel(app.ConfigTab);
            app.Panel.Position = [17 10 854 62];

            % Create LoadConfigfileButton
            app.LoadConfigfileButton = uibutton(app.Panel, 'push');
            app.LoadConfigfileButton.ButtonPushedFcn = createCallbackFcn(app, @LoadConfigfileButtonPushed, true);
            app.LoadConfigfileButton.Position = [19 12 250 40];
            app.LoadConfigfileButton.Text = 'Load Config file';

            % Create SaveConfigfileButton
            app.SaveConfigfileButton = uibutton(app.Panel, 'push');
            app.SaveConfigfileButton.Position = [302 12 250 40];
            app.SaveConfigfileButton.Text = 'Save Config file';

            % Create ReturntomainButton
            app.ReturntomainButton = uibutton(app.Panel, 'push');
            app.ReturntomainButton.ButtonPushedFcn = createCallbackFcn(app, @ReturntomainButtonPushed, true);
            app.ReturntomainButton.Position = [587 12 250 40];
            app.ReturntomainButton.Text = 'Return to main';

            % Create PerturbationoptionsPanel
            app.PerturbationoptionsPanel = uipanel(app.ConfigTab);
            app.PerturbationoptionsPanel.Title = 'Perturbation options';
            app.PerturbationoptionsPanel.Position = [478 212 393 110];

            % Create UITable2_3
            app.UITable2_3 = uitable(app.PerturbationoptionsPanel);
            app.UITable2_3.ColumnName = {'x/a'; 'y/d'; 'z'; 'Alpha'; 'Beta'; 'Theta'};
            app.UITable2_3.RowName = {};
            app.UITable2_3.ColumnEditable = true;
            app.UITable2_3.CellEditCallback = createCallbackFcn(app, @UITable2_3CellEdit, true);
            app.UITable2_3.Position = [1 0 393 87];

            % Create OptimoptionsPanel
            app.OptimoptionsPanel = uipanel(app.ConfigTab);
            app.OptimoptionsPanel.Title = 'Optim options';
            app.OptimoptionsPanel.Position = [19 87 406 453];

            % Create UITable2
            app.UITable2 = uitable(app.OptimoptionsPanel);
            app.UITable2.ColumnName = {'Name'; 'Value'};
            app.UITable2.RowName = {};
            app.UITable2.ColumnEditable = [false true];
            app.UITable2.CellEditCallback = createCallbackFcn(app, @UITable2CellEdit, true);
            app.UITable2.Position = [0 3 406 427];

            % Create OptimizationoptionsPanel
            app.OptimizationoptionsPanel = uipanel(app.ConfigTab);
            app.OptimizationoptionsPanel.Title = 'Optimization options';
            app.OptimizationoptionsPanel.Position = [478 337 393 203];

            % Create UITable2_2
            app.UITable2_2 = uitable(app.OptimizationoptionsPanel);
            app.UITable2_2.ColumnName = {'Name'; 'Value'};
            app.UITable2_2.RowName = {};
            app.UITable2_2.ColumnEditable = [false true];
            app.UITable2_2.CellEditCallback = createCallbackFcn(app, @UITable2_2CellEdit, true);
            app.UITable2_2.Position = [0 2 393 178];

            % Create RobotTab
            app.RobotTab = uitab(app.TabGroup);
            app.RobotTab.Title = 'Robot';

            % Create TabGroup2
            app.TabGroup2 = uitabgroup(app.RobotTab);
            app.TabGroup2.Position = [1 1 899 574];

            % Create JointsTab
            app.JointsTab = uitab(app.TabGroup2);
            app.JointsTab.Title = 'Joints';

            % Create Panel_2
            app.Panel_2 = uipanel(app.JointsTab);
            app.Panel_2.Position = [17 10 854 62];

            % Create LoadRobotfileButton
            app.LoadRobotfileButton = uibutton(app.Panel_2, 'push');
            app.LoadRobotfileButton.ButtonPushedFcn = createCallbackFcn(app, @LoadRobotButtonPushed, true);
            app.LoadRobotfileButton.Position = [19 12 150 40];
            app.LoadRobotfileButton.Text = 'Load Robot file';

            % Create SaveRobotfileButton
            app.SaveRobotfileButton = uibutton(app.Panel_2, 'push');
            app.SaveRobotfileButton.Position = [193 12 150 40];
            app.SaveRobotfileButton.Text = 'Save Robot file';

            % Create ReturntomainButton_2
            app.ReturntomainButton_2 = uibutton(app.Panel_2, 'push');
            app.ReturntomainButton_2.ButtonPushedFcn = createCallbackFcn(app, @ReturntomainButtonPushed, true);
            app.ReturntomainButton_2.Position = [684 12 150 40];
            app.ReturntomainButton_2.Text = 'Return to main';

            % Create NexttabButton
            app.NexttabButton = uibutton(app.Panel_2, 'push');
            app.NexttabButton.ButtonPushedFcn = createCallbackFcn(app, @NexttabButtonPushed, true);
            app.NexttabButton.Position = [500 11 150 40];
            app.NexttabButton.Text = 'Next tab';

            % Create JointstructurePanel
            app.JointstructurePanel = uipanel(app.JointsTab);
            app.JointstructurePanel.Title = 'Joint structure';
            app.JointstructurePanel.Position = [18 79 851 416];

            % Create UITable4
            app.UITable4 = uitable(app.JointstructurePanel);
            app.UITable4.ColumnName = {'Joint name'; 'Joint type'; 'Parent'; 'Table index'; 'Joint group'};
            app.UITable4.RowName = {};
            app.UITable4.ColumnEditable = true;
            app.UITable4.CellEditCallback = createCallbackFcn(app, @UITable4CellEdit, true);
            app.UITable4.Position = [1 3 429 393];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.JointstructurePanel);
            title(app.UIAxes2, {'Graph Model'; ''})
            app.UIAxes2.XTick = [];
            app.UIAxes2.YTick = [];
            app.UIAxes2.Position = [429 1 426 392];

            % Create RobotnameEditFieldLabel
            app.RobotnameEditFieldLabel = uilabel(app.JointsTab);
            app.RobotnameEditFieldLabel.HorizontalAlignment = 'right';
            app.RobotnameEditFieldLabel.Position = [348 510 71 22];
            app.RobotnameEditFieldLabel.Text = 'Robot name';

            % Create RobotnameEditField
            app.RobotnameEditField = uieditfield(app.JointsTab, 'text');
            app.RobotnameEditField.ValueChangedFcn = createCallbackFcn(app, @RobotnameEditFieldValueChanged, true);
            app.RobotnameEditField.Position = [433 505 85 30];

            % Create KinematicsTab
            app.KinematicsTab = uitab(app.TabGroup2);
            app.KinematicsTab.Title = 'Kinematics';

            % Create KinematicsparametersPanel
            app.KinematicsparametersPanel = uipanel(app.KinematicsTab);
            app.KinematicsparametersPanel.Title = 'Kinematics parameters';
            app.KinematicsparametersPanel.Position = [17 184 854 325];

            % Create UITable5
            app.UITable5 = uitable(app.KinematicsparametersPanel);
            app.UITable5.ColumnName = {'x/a'; 'y/d'; 'z'; 'Alpha'; 'Beta'; 'Theta'};
            app.UITable5.RowName = {};
            app.UITable5.ColumnEditable = true;
            app.UITable5.CellEditCallback = createCallbackFcn(app, @UITable5CellEdit, true);
            app.UITable5.Position = [6 16 837 287];

            % Create Panel_3
            app.Panel_3 = uipanel(app.KinematicsTab);
            app.Panel_3.Position = [17 10 854 62];

            % Create LoadRobotfileButton_2
            app.LoadRobotfileButton_2 = uibutton(app.Panel_3, 'push');
            app.LoadRobotfileButton_2.ButtonPushedFcn = createCallbackFcn(app, @LoadRobotButtonPushed, true);
            app.LoadRobotfileButton_2.Position = [19 12 150 40];
            app.LoadRobotfileButton_2.Text = 'Load Robot file';

            % Create SaveRobotfileButton_2
            app.SaveRobotfileButton_2 = uibutton(app.Panel_3, 'push');
            app.SaveRobotfileButton_2.Position = [193 12 150 40];
            app.SaveRobotfileButton_2.Text = 'Save Robot file';

            % Create ReturntomainButton_3
            app.ReturntomainButton_3 = uibutton(app.Panel_3, 'push');
            app.ReturntomainButton_3.ButtonPushedFcn = createCallbackFcn(app, @ReturntomainButtonPushed, true);
            app.ReturntomainButton_3.Position = [684 12 150 40];
            app.ReturntomainButton_3.Text = 'Return to main';

            % Create NexttabButton_2
            app.NexttabButton_2 = uibutton(app.Panel_3, 'push');
            app.NexttabButton_2.ButtonPushedFcn = createCallbackFcn(app, @NexttabButton_2Pushed, true);
            app.NexttabButton_2.Position = [500 11 150 40];
            app.NexttabButton_2.Text = 'Next tab';

            % Create RobotdefaultconfigurationPanel
            app.RobotdefaultconfigurationPanel = uipanel(app.KinematicsTab);
            app.RobotdefaultconfigurationPanel.Title = 'Robot default configuration';
            app.RobotdefaultconfigurationPanel.Position = [20 84 851 87];

            % Create UITable_2
            app.UITable_2 = uitable(app.RobotdefaultconfigurationPanel);
            app.UITable_2.ColumnName = {'Joint 1'; 'Joint 2'; 'Joint 3'; 'Joint 4'; 'Joint 5'; 'Joint 6'};
            app.UITable_2.RowName = {};
            app.UITable_2.ColumnEditable = true;
            app.UITable_2.CellEditCallback = createCallbackFcn(app, @UITable_2CellEdit, true);
            app.UITable_2.Position = [5 10 836 53];

            % Create GroupDropDown_2Label
            app.GroupDropDown_2Label = uilabel(app.KinematicsTab);
            app.GroupDropDown_2Label.HorizontalAlignment = 'center';
            app.GroupDropDown_2Label.Position = [20 520 39 15];
            app.GroupDropDown_2Label.Text = 'Group';

            % Create GroupDropDown_2
            app.GroupDropDown_2 = uidropdown(app.KinematicsTab);
            app.GroupDropDown_2.Items = {'rightArm', 'leftArm', 'torso', 'head', 'leftEye', 'rightEye', 'leftLeg', 'rightLeg', 'leftIndex', 'rightIndex', 'leftThumb', 'rightThumb', 'leftMiddle', 'rightMiddle'};
            app.GroupDropDown_2.ValueChangedFcn = createCallbackFcn(app, @GroupDropDown_2ValueChanged, true);
            app.GroupDropDown_2.Position = [66 515 150 25];
            app.GroupDropDown_2.Value = 'rightArm';

            % Create WhitelistBoundsTab
            app.WhitelistBoundsTab = uitab(app.TabGroup2);
            app.WhitelistBoundsTab.Title = 'Whitelist + Bounds';

            % Create Panel_4
            app.Panel_4 = uipanel(app.WhitelistBoundsTab);
            app.Panel_4.Position = [17 10 854 62];

            % Create LoadRobotfileButton_3
            app.LoadRobotfileButton_3 = uibutton(app.Panel_4, 'push');
            app.LoadRobotfileButton_3.ButtonPushedFcn = createCallbackFcn(app, @LoadRobotButtonPushed, true);
            app.LoadRobotfileButton_3.Position = [19 12 150 40];
            app.LoadRobotfileButton_3.Text = 'Load Robot file';

            % Create SaveRobotfileButton_3
            app.SaveRobotfileButton_3 = uibutton(app.Panel_4, 'push');
            app.SaveRobotfileButton_3.Position = [193 12 150 40];
            app.SaveRobotfileButton_3.Text = 'Save Robot file';

            % Create ReturntomainButton_4
            app.ReturntomainButton_4 = uibutton(app.Panel_4, 'push');
            app.ReturntomainButton_4.ButtonPushedFcn = createCallbackFcn(app, @ReturntomainButtonPushed, true);
            app.ReturntomainButton_4.Position = [684 12 150 40];
            app.ReturntomainButton_4.Text = 'Return to main';

            % Create NexttabButton_3
            app.NexttabButton_3 = uibutton(app.Panel_4, 'push');
            app.NexttabButton_3.ButtonPushedFcn = createCallbackFcn(app, @NexttabButton_3Pushed, true);
            app.NexttabButton_3.Position = [500 11 150 40];
            app.NexttabButton_3.Text = 'Next tab';

            % Create GroupDropDown_3Label
            app.GroupDropDown_3Label = uilabel(app.WhitelistBoundsTab);
            app.GroupDropDown_3Label.HorizontalAlignment = 'center';
            app.GroupDropDown_3Label.Position = [20 520 39 15];
            app.GroupDropDown_3Label.Text = 'Group';

            % Create GroupDropDown_3
            app.GroupDropDown_3 = uidropdown(app.WhitelistBoundsTab);
            app.GroupDropDown_3.Items = {'rightArm', 'leftArm', 'torso', 'head', 'leftEye', 'rightEye', 'leftLeg', 'rightLeg', 'leftIndex', 'rightIndex', 'leftThumb', 'rightThumb', 'leftMiddle', 'rightMiddle'};
            app.GroupDropDown_3.ValueChangedFcn = createCallbackFcn(app, @GroupDropDown_3ValueChanged, true);
            app.GroupDropDown_3.Position = [66 515 150 25];
            app.GroupDropDown_3.Value = 'rightArm';

            % Create WhitelistPanel
            app.WhitelistPanel = uipanel(app.WhitelistBoundsTab);
            app.WhitelistPanel.Title = 'Whitelist';
            app.WhitelistPanel.Position = [17 294 854 216];

            % Create UITable5_2
            app.UITable5_2 = uitable(app.WhitelistPanel);
            app.UITable5_2.ColumnName = {'x/a'; 'y/d'; 'z'; 'Alpha'; 'Beta'; 'Theta'};
            app.UITable5_2.RowName = {};
            app.UITable5_2.ColumnEditable = true;
            app.UITable5_2.CellEditCallback = createCallbackFcn(app, @UITable5_2CellEdit, true);
            app.UITable5_2.Position = [6 40 837 154];

            % Create SavewhitelistButton
            app.SavewhitelistButton = uibutton(app.WhitelistPanel, 'push');
            app.SavewhitelistButton.Position = [350 6 150 30];
            app.SavewhitelistButton.Text = 'Save whitelist';

            % Create BoundsPanel
            app.BoundsPanel = uipanel(app.WhitelistBoundsTab);
            app.BoundsPanel.Title = 'Bounds';
            app.BoundsPanel.Position = [17 73 854 216];

            % Create UITable5_3
            app.UITable5_3 = uitable(app.BoundsPanel);
            app.UITable5_3.ColumnName = {'x/a'; 'y/d'; 'z'; 'Alpha'; 'Beta'; 'Theta'};
            app.UITable5_3.RowName = {};
            app.UITable5_3.ColumnEditable = true;
            app.UITable5_3.CellEditCallback = createCallbackFcn(app, @UITable5_3CellEdit, true);
            app.UITable5_3.Position = [6 40 837 154];

            % Create SaveboundsButton
            app.SaveboundsButton = uibutton(app.BoundsPanel, 'push');
            app.SaveboundsButton.Position = [350 6 150 30];
            app.SaveboundsButton.Text = 'Save bounds';

            % Create CameraseyesTab
            app.CameraseyesTab = uitab(app.TabGroup2);
            app.CameraseyesTab.Title = 'Cameras / eyes';

            % Create Panel_5
            app.Panel_5 = uipanel(app.CameraseyesTab);
            app.Panel_5.Position = [17 10 854 62];

            % Create LoadRobotfileButton_4
            app.LoadRobotfileButton_4 = uibutton(app.Panel_5, 'push');
            app.LoadRobotfileButton_4.ButtonPushedFcn = createCallbackFcn(app, @LoadRobotButtonPushed, true);
            app.LoadRobotfileButton_4.Position = [19 12 150 40];
            app.LoadRobotfileButton_4.Text = 'Load Robot file';

            % Create SaveRobotfileButton_4
            app.SaveRobotfileButton_4 = uibutton(app.Panel_5, 'push');
            app.SaveRobotfileButton_4.Position = [193 12 150 40];
            app.SaveRobotfileButton_4.Text = 'Save Robot file';

            % Create ReturntomainButton_5
            app.ReturntomainButton_5 = uibutton(app.Panel_5, 'push');
            app.ReturntomainButton_5.ButtonPushedFcn = createCallbackFcn(app, @ReturntomainButtonPushed, true);
            app.ReturntomainButton_5.Position = [684 12 150 40];
            app.ReturntomainButton_5.Text = 'Return to main';

            % Create NexttabButton_4
            app.NexttabButton_4 = uibutton(app.Panel_5, 'push');
            app.NexttabButton_4.Position = [500 11 150 40];
            app.NexttabButton_4.Text = 'Next tab';

            % Create LefteyePanel
            app.LefteyePanel = uipanel(app.CameraseyesTab);
            app.LefteyePanel.Title = 'Left eye';
            app.LefteyePanel.Position = [19 117 280 400];

            % Create DistortioncoefficientsPanel
            app.DistortioncoefficientsPanel = uipanel(app.LefteyePanel);
            app.DistortioncoefficientsPanel.Title = 'Distortion coefficients';
            app.DistortioncoefficientsPanel.Position = [1 180 277 190];

            % Create tCoef1
            app.tCoef1 = uitable(app.DistortioncoefficientsPanel);
            app.tCoef1.ColumnName = {'r1'; 'r2'};
            app.tCoef1.RowName = {};
            app.tCoef1.ColumnEditable = true;
            app.tCoef1.CellEditCallback = createCallbackFcn(app, @tCoef1CellEdit, true);
            app.tCoef1.Position = [67 107 210 55];

            % Create tangentialLabel
            app.tangentialLabel = uilabel(app.DistortioncoefficientsPanel);
            app.tangentialLabel.Position = [3 122 58 22];
            app.tangentialLabel.Text = 'tangential';

            % Create radialLabel
            app.radialLabel = uilabel(app.DistortioncoefficientsPanel);
            app.radialLabel.Position = [14 34 35 22];
            app.radialLabel.Text = 'radial';

            % Create rCoef1
            app.rCoef1 = uitable(app.DistortioncoefficientsPanel);
            app.rCoef1.ColumnName = {'k1'; 'k2'; 'k3'; 'k4'; 'k5'; 'k6'};
            app.rCoef1.RowName = {};
            app.rCoef1.ColumnEditable = true;
            app.rCoef1.CellEditCallback = createCallbackFcn(app, @rCoef1CellEdit, true);
            app.rCoef1.Position = [67 14 210 70];

            % Create CameramatrixPanel
            app.CameramatrixPanel = uipanel(app.LefteyePanel);
            app.CameramatrixPanel.Title = 'Camera matrix';
            app.CameramatrixPanel.Position = [1 50 277 100];

            % Create camMatrix1
            app.camMatrix1 = uitable(app.CameramatrixPanel);
            app.camMatrix1.ColumnName = '';
            app.camMatrix1.RowName = {};
            app.camMatrix1.ColumnEditable = true;
            app.camMatrix1.CellEditCallback = createCallbackFcn(app, @camMatrix1CellEdit, true);
            app.camMatrix1.Position = [2 7 270 70];

            % Create RighteyePanel
            app.RighteyePanel = uipanel(app.CameraseyesTab);
            app.RighteyePanel.Title = 'Right eye';
            app.RighteyePanel.Position = [315 117 280 400];

            % Create DistortioncoefficientsPanel_2
            app.DistortioncoefficientsPanel_2 = uipanel(app.RighteyePanel);
            app.DistortioncoefficientsPanel_2.Title = 'Distortion coefficients';
            app.DistortioncoefficientsPanel_2.Position = [1 180 277 190];

            % Create tCoef2
            app.tCoef2 = uitable(app.DistortioncoefficientsPanel_2);
            app.tCoef2.ColumnName = {'r1'; 'r2'};
            app.tCoef2.RowName = {};
            app.tCoef2.ColumnEditable = true;
            app.tCoef2.CellEditCallback = createCallbackFcn(app, @tCoef2CellEdit, true);
            app.tCoef2.Position = [67 107 210 55];

            % Create tangentialLabel_2
            app.tangentialLabel_2 = uilabel(app.DistortioncoefficientsPanel_2);
            app.tangentialLabel_2.Position = [3 122 58 22];
            app.tangentialLabel_2.Text = 'tangential';

            % Create radialLabel_2
            app.radialLabel_2 = uilabel(app.DistortioncoefficientsPanel_2);
            app.radialLabel_2.Position = [14 34 35 22];
            app.radialLabel_2.Text = 'radial';

            % Create rCoef2
            app.rCoef2 = uitable(app.DistortioncoefficientsPanel_2);
            app.rCoef2.ColumnName = {'k1'; 'k2'; 'k3'; 'k4'; 'k5'; 'k6'};
            app.rCoef2.RowName = {};
            app.rCoef2.ColumnEditable = true;
            app.rCoef2.CellEditCallback = createCallbackFcn(app, @rCoef2CellEdit, true);
            app.rCoef2.Position = [67 14 210 70];

            % Create CameramatrixPanel_2
            app.CameramatrixPanel_2 = uipanel(app.RighteyePanel);
            app.CameramatrixPanel_2.Title = 'Camera matrix';
            app.CameramatrixPanel_2.Position = [1 50 277 100];

            % Create camMatrix2
            app.camMatrix2 = uitable(app.CameramatrixPanel_2);
            app.camMatrix2.ColumnName = '';
            app.camMatrix2.RowName = {};
            app.camMatrix2.ColumnEditable = true;
            app.camMatrix2.CellEditCallback = createCallbackFcn(app, @camMatrix2CellEdit, true);
            app.camMatrix2.Position = [2 7 270 70];

            % Create AdditionaleyePanel
            app.AdditionaleyePanel = uipanel(app.CameraseyesTab);
            app.AdditionaleyePanel.Title = 'Additional eye';
            app.AdditionaleyePanel.Position = [611 117 280 400];

            % Create DistortioncoefficientsPanel_3
            app.DistortioncoefficientsPanel_3 = uipanel(app.AdditionaleyePanel);
            app.DistortioncoefficientsPanel_3.Title = 'Distortion coefficients';
            app.DistortioncoefficientsPanel_3.Position = [1 180 277 190];

            % Create tCoef3
            app.tCoef3 = uitable(app.DistortioncoefficientsPanel_3);
            app.tCoef3.ColumnName = {'r1'; 'r2'};
            app.tCoef3.RowName = {};
            app.tCoef3.ColumnEditable = true;
            app.tCoef3.CellEditCallback = createCallbackFcn(app, @tCoef3CellEdit, true);
            app.tCoef3.Position = [67 107 210 55];

            % Create tangentialLabel_3
            app.tangentialLabel_3 = uilabel(app.DistortioncoefficientsPanel_3);
            app.tangentialLabel_3.Position = [3 122 58 22];
            app.tangentialLabel_3.Text = 'tangential';

            % Create radialLabel_3
            app.radialLabel_3 = uilabel(app.DistortioncoefficientsPanel_3);
            app.radialLabel_3.Position = [14 34 35 22];
            app.radialLabel_3.Text = 'radial';

            % Create rCoef3
            app.rCoef3 = uitable(app.DistortioncoefficientsPanel_3);
            app.rCoef3.ColumnName = {'k1'; 'k2'; 'k3'; 'k4'; 'k5'; 'k6'};
            app.rCoef3.RowName = {};
            app.rCoef3.ColumnEditable = true;
            app.rCoef3.CellEditCallback = createCallbackFcn(app, @rCoef3CellEdit, true);
            app.rCoef3.Position = [67 14 210 70];

            % Create CameramatrixPanel_3
            app.CameramatrixPanel_3 = uipanel(app.AdditionaleyePanel);
            app.CameramatrixPanel_3.Title = 'Camera matrix';
            app.CameramatrixPanel_3.Position = [1 50 277 100];

            % Create camMatrix3
            app.camMatrix3 = uitable(app.CameramatrixPanel_3);
            app.camMatrix3.ColumnName = '';
            app.camMatrix3.RowName = {};
            app.camMatrix3.ColumnEditable = true;
            app.camMatrix3.CellEditCallback = createCallbackFcn(app, @camMatrix3CellEdit, true);
            app.camMatrix3.Position = [2 7 270 70];

            % Create DatasetTab
            app.DatasetTab = uitab(app.TabGroup);
            app.DatasetTab.Title = 'Dataset';

            % Create Panel_6
            app.Panel_6 = uipanel(app.DatasetTab);
            app.Panel_6.Position = [17 10 854 62];

            % Create LoadDatasetfileButton
            app.LoadDatasetfileButton = uibutton(app.Panel_6, 'push');
            app.LoadDatasetfileButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDatasetButtonPushed, true);
            app.LoadDatasetfileButton.Position = [19 12 250 40];
            app.LoadDatasetfileButton.Text = 'Load Dataset file';

            % Create SaveDatasetfileButton
            app.SaveDatasetfileButton = uibutton(app.Panel_6, 'push');
            app.SaveDatasetfileButton.Position = [302 12 250 40];
            app.SaveDatasetfileButton.Text = 'Save Dataset file';

            % Create ReturntomainButton_6
            app.ReturntomainButton_6 = uibutton(app.Panel_6, 'push');
            app.ReturntomainButton_6.ButtonPushedFcn = createCallbackFcn(app, @ReturntomainButtonPushed, true);
            app.ReturntomainButton_6.Position = [587 12 250 40];
            app.ReturntomainButton_6.Text = 'Return to main';

            % Create DatasetinfoPanel
            app.DatasetinfoPanel = uipanel(app.DatasetTab);
            app.DatasetinfoPanel.Title = 'Dataset info';
            app.DatasetinfoPanel.Position = [17 481 854 84];

            % Create DatasetnameEditFieldLabel
            app.DatasetnameEditFieldLabel = uilabel(app.DatasetinfoPanel);
            app.DatasetnameEditFieldLabel.HorizontalAlignment = 'right';
            app.DatasetnameEditFieldLabel.Position = [5 13 80 22];
            app.DatasetnameEditFieldLabel.Text = 'Dataset name';

            % Create DatasetnameEditField
            app.DatasetnameEditField = uieditfield(app.DatasetinfoPanel, 'text');
            app.DatasetnameEditField.ValueChangedFcn = createCallbackFcn(app, @DatasetnameEditFieldValueChanged, true);
            app.DatasetnameEditField.Position = [91 8 85 30];

            % Create DatasettypeDropDownLabel
            app.DatasettypeDropDownLabel = uilabel(app.DatasetinfoPanel);
            app.DatasettypeDropDownLabel.HorizontalAlignment = 'right';
            app.DatasettypeDropDownLabel.Position = [661 12 73 22];
            app.DatasettypeDropDownLabel.Text = 'Dataset type';

            % Create DatasettypeDropDown
            app.DatasettypeDropDown = uidropdown(app.DatasetinfoPanel);
            app.DatasettypeDropDown.Items = {'selftouch', 'planes', 'external', 'projection', ''};
            app.DatasettypeDropDown.ValueChangedFcn = createCallbackFcn(app, @DatasettypeDropDownValueChanged, true);
            app.DatasettypeDropDown.Position = [748 8 100 30];
            app.DatasettypeDropDown.Value = 'selftouch';

            % Create DatasetIDDropDownLabel
            app.DatasetIDDropDownLabel = uilabel(app.DatasetinfoPanel);
            app.DatasetIDDropDownLabel.HorizontalAlignment = 'right';
            app.DatasetIDDropDownLabel.Position = [485 10 65 22];
            app.DatasetIDDropDownLabel.Text = 'Dataset ID';

            % Create DatasetIDDropDown
            app.DatasetIDDropDown = uidropdown(app.DatasetinfoPanel);
            app.DatasetIDDropDown.Items = {'1'};
            app.DatasetIDDropDown.Position = [565 8 73 30];
            app.DatasetIDDropDown.Value = '1';

            % Create DataPanel
            app.DataPanel = uipanel(app.DatasetTab);
            app.DataPanel.Title = 'Data';
            app.DataPanel.Position = [17 92 854 382];

            % Create DatasetData
            app.DatasetData = uitable(app.DataPanel);
            app.DatasetData.ColumnName = '';
            app.DatasetData.RowName = {};
            app.DatasetData.ColumnEditable = true;
            app.DatasetData.CellEditCallback = createCallbackFcn(app, @DatasetDataCellEdit, true);
            app.DatasetData.Position = [3 4 850 355];

            % Show the figure after all components are created
            app.Robot_toolboxUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Robot_toolboxUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Robot_toolboxUIFigure)
        end
    end
end