function Reply = CmdWinTool(Command, Data)
% Programmatic control of the the command window
% Reply = CmdWinTool(Command, Data)
% INPUT:
%   Command: String, not case-sensitive. Commands working at least under
%            Matlab6.5 to 2009a, 2011b:
%     lean, fat: Hide or show the menubar, toolbar and statusbar of the command
%            window. The lean desktop is useful for small screen of Netbooks.
%     title: The current title is replied. If a 2nd input is defined, the window
%            title is set to the string [Data].
%            See examples for setting the title from inside startup.m.
%     statusText: The current status text is replied. The 2nd input is written
%            to the status line as string. This text is cleared upon returning
%            to the Matlab prompt.
%     toFront: Move window to top. See Matlab's COMMANDWINDOW.
%     toBack:  Move window behind all other windows.
%     show, hide: Show and hide the command window.
%            NOTE: A hidden command window cannot be accessed manually!
%            Either your program re-enables the command window, or you kill the
%            Matlab-process in the TaskManager!
%     JPosition: Get the outer position relative to the virtual screen. If a 2nd
%            input is defined as [X, Y, Width, Height], the position is set.
%            Note: Java convention: Y measured from the top.
%     Position: Get/Set position as [X, Y, Width, Height] relative to current
%            monitor and Y measured from the bottom.
%            This needs WindowAPI, see notes.
%     maximize, minimize, restore: Maximize, minimize and restore the former
%            position of the window.
%     xmax, ymax: Maximize the command window vertically or horizontally.
%            This uses WindowAPI (FEX: #31437) under Windows, if installed.
%     getHWnd: Get window handle of the OS - no idea what this means under
%            Linux / MacOS.
%     toScreen: Move command window to visible area of current monitor.
%            Needs WindowAPI.
%     setFocus: Gain the keyboard focus to the command window.
%            Needs WindowAPI.
%     font:  Set and get current font. Changes appear directly. The font is
%            supplied either as struct with the fields 'Name' and 'Size' or as
%            java.awt.Font object.
%     background, foreground: Set and get the foreground and background colors.
%            Colors can be defined as RGB vector with values between 0 and 1, or
%            as java.awt.Color object.
%     isbusy: TRUE if Matlab is running a program. This fails, if e.g. a timer
%            callback sets the status text of the command window.
%   Working under 2008b and higher (perhaps Matlab >= 2006a, see NOTES):
%     top:   Set command window permanently on top of all other figures, if
%            [Data] is TRUE or the string 'on'. Otherwise the AlwaysOnTop
%            property is disabled. Without 2nd input the property is toggled.
%     getText: Get text of the command window as string.
%     setLayout: [Data] is either the name of a formerly saved layout, or:
%            'Default', 'Command Window Only', 'History and Command Window',
%            'All Tabbed', 'All but Command Window Minimized'
%
%   Data: Parameters for commands: Position, JPosition, Title, statusText, top.
%
% OUTPUT:
%   Reply:   For these commands values are replied, if an output argument is
%            used: getText, statusText, Position, JPosition, Title, getHWnd,
%            Foreground, Background, Font.
%            If a 2nd argument is used also to set the property, the former
%            value is replied.
%
% EXAMPLES:
% Hide the command window temporarily - do not forget to show it later:
%   CmdWinTool('hide');  pause(2);  CmdWinTool('show');
%
% Get the maximum a for the command window text:
%   CmdWinTool lean
%   CmdWinTool ymax
%
% Show a progress message in the command window's status bar:
%   for i = 0:10:100
%     CmdWinTool('setStatusText', sprintf('%d%%', i));
%     pause(0.1);
%   end
%
% Set the window title - use a timer if called from STARTUP.M, because this does
% not work in the first seconds after startup:
%   start(timer('TimerFcn', @SetCWTitle, 'ExecutionMode', 'SingleShot', ...
%               'StartDelay', 5));
%   function SetCWTitle(ObjH, EventData)  %#ok<INUSD>
%   CmdWinTool('Title', ['Matlab ', version('-release')]);
%   stop(ObjH); delete(ObjH);
%
% NOTES:            !!! CmdWinTool is EXPERIMENTAL !!!
% This function uses undocumented and unsupported features of Matlab. It is
% tested for Matlab  6.5, 2008b, 2009a, 2011b, WinXP and Win7 only. I *assume*
% that the new commands are working from Matlab 2006a to 2011b (and higher),
% Linux and MacOS, but please test this and adjust the source code on demand.
% Run uTest_CmdWinTool for a unit-test - you find further examples there also.
%
% Bug reports and suggestions for improvements are very appreciated.
%
% The commands Position, toScreen and setFocus needs the function WindowAPI:
%   http://www.mathworks.com/matlabcentral/fileexchange/31437
%
% All actions concern Matlab's main frame. Therefore they are most likely not
% useful if the command window is undocked.
%
% This function is inspired by Yair Altman's excellent investigations in the
% secrets of Matlab. See www.undocumentedmatlab.com for the numerous other
% Matlab features, which do not appear in the documentation.
%
% I have renamed this function to cwt for neater access from the command window.
%
% Tested: Matlab 7.7, 7.8, 7.13, 8.6, WinXP/32, Win7/64
% Author: Jan Simon, Heidelberg, (C) 2011-2015 matlab.2010(a)n(MINUS)simon.de
%
% See also COMMANDWINDOW.
% FEX:
% WindowAPI, Jan Simon:
%   http://www.mathworks.com/matlabcentral/fileexchange/31437

% $JRev: R-z V:026 Sum:ocpkl3naBaw8 Date:20-Dec-2015 23:17:13 $
% $License: BSD (use/copy/change/redistribute on own risk, mention the author) $
% $UnitTest: uTest_CmdWinTool $
% $File: Tools\GLMisc\CmdWinTool.m $
% History:
% 001: 26-May-2011 21:52, First version.
% 007: 22-Jun-2011 16:25, Call WindowAPI if available, getHWnd.
% 015: 21-Sep-2011 16:23, setLayout command.
% 016: 11-Oct-2011 23:28, Font, Foreground, Background. New set/get methods.
% 024: 13-Jun-2015 19:32, isBusy, statusText can reply the text.
% 025: 17-Dec-2015 23:57, Toggle the ToolStrip instead of JMenuBar on demand.

% Multi-monitor with Java:
% localGraphEnv = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment();
% devices = localGraphEnv.getScreenDevices();
% height = devices(MonitorIndex).getDisplayMode().getHeight();
% width = devices(MonitorIndex).getDisplayMode().getWidth();

% Initialize: ==================================================================
% Use WindowAPI if installed:
persistent hasWindowAPI
if isempty(hasWindowAPI)
   hasWindowAPI = ispc && not(isempty(which('WindowAPI')));
end

% Require Java to run:
if usejava('desktop') == 0
   fprintf('::: %s: Not working without java\n', mfilename);
   return;
end

% Matlab version as integer, consider different numbers for 7.1 and 7.10:
matlabV = [100, 1] * sscanf(version, '%d.', 2);

% Get main frame of command window:
% I'm not sure about the exact version number!
if matlabV >= 700      % [USER_ADJUST]
   desktop   = com.mathworks.mde.desk.MLDesktop.getInstance;
   mainFrame = desktop.getMainFrame;
elseif matlabV >= 605
   desktop   = com.mathworks.ide.desktop.MLDesktop.getMLDesktop;
   mainFrame = desktop.getMainFrame;
else
   warning(['### ', mfilename, ': Function needs Matlab > 6.5']);  %#ok<WNTAG>
   return;
end

% Do the work: =================================================================
processed = true;
Command   = lower(Command);

% Commands working in Matlab 6.5 to 2011b:
switch Command
   case 'title'   % Get and set the name in the title bar:
      if nargout  % Reply the current title, if an output is used:
         Reply = char(mainFrame.getTitle);
      end
      if nargin > 1  % Set a new title:
         if ischar(Data)
            mainFrame.setTitle(Data);
         else
            error(['JSimon:', mfilename, ':BadDataType'], ...
               '*** %s: Title command needs a string as 2nd input.', ...
               mfilename);
         end
      end
      
   case 'statustext'  % Get and set the status text on the bottom:
      if nargout
         try    % Working in R2009a and 2011b:
            Reply = char(mainFrame.getStatusBar.getText());
         catch  % Working in R2011b:
            Reply = char(mainFrame.getMatlabStatusText());
         end
      end
      if nargin > 1
         if ischar(Data)
            mainFrame.setStatusText(java.lang.String(Data));
         else
            error(['JSimon:', mfilename, ':BadDataType'], ...
               '*** %s: StatusText command needs a string as 2nd input.', ...
               mfilename);
         end
      end
      
   case 'tofront'  % Bring window to front:
      % Same as Matlab's COMMANDWINDOW!
      try    % Working in all versions I've tested:
         mainFrame.toFront;
      catch  % Working in Matlab R2015b:
         desktop.showCommandWindow;
      end
      
   case 'toback'   % Hide window behind all others:
      mainFrame.toBack;
      
   case {'show', 'hide'}  % Enable/disable visibility:
      mainFrame.setVisible(strcmpi(Command, 'show'));
      % See also: mainFrame.hide, mainFrame.hide
      
   case 'jposition'  % Get and set outer position in virtual screen coordinates:
      % Accepted: [1 x 4] DOUBLE vector
      if nargout
         % Position in Java-style from top:
         pos   = mainFrame.getBounds;
         Reply = [pos.getX, pos.getY, pos.getWidth, pos.getHeight];
      end
      
      if nargin > 1
         if isnumeric(Data) && (numel(Data) == 4)
            % Calculate position in Java-style from top:
            jPos = java.awt.Rectangle(Data(1), Data(2), Data(3), Data(4));
            mainFrame.setBounds(jPos);
         else
            error(['JSimon:', mfilename, ':BadData'], ...
               '*** %s: JPosition needs a [1 x 4] vector 2nd input.', ...
               mfilename);
         end
      end
               
   case {'maximize', 'max'}  % Maximize the window:
      mainFrame.setMaximized(1);
      
   case 'xmax'      % Maximize the window horizontally:
      % Get vertical position:
      Y      = mainFrame.getY;
      Height = mainFrame.getHeight;
      
      % Get maximized horizontal position:
      if hasWindowAPI
         HWnd = GetHWnd(desktop, mainFrame, matlabV);
         WindowAPI(HWnd, 'xmax');
      else  % Pure Java method for linux:
         mainFrame.setMaximized(1);
         X     = mainFrame.getX;
         Width = mainFrame.getWidth;
         mainFrame.setBounds(java.awt.Rectangle(X, Y, Width, Height));
      end
      
   case 'ymax'      % Maximize the window vertically:
      % Get horizontal position:
      X     = mainFrame.getX;
      Width = mainFrame.getWidth;
      
      % Get maximized vertical position:
      if hasWindowAPI
         HWnd = GetHWnd(desktop, mainFrame, matlabV);
         WindowAPI(HWnd, 'ymax');
      else  % Pure Java method for linux:
         mainFrame.setMaximized(1);
         Y      = mainFrame.getY;
         Height = mainFrame.getHeight;
         mainFrame.setBounds(java.awt.Rectangle(X, Y, Width, Height));
      end
      
   case {'minimize', 'min'}  % Minimize the window:
      mainFrame.setMinimized(1);
      
   case 'restore'   % Restore to not-minimized/not-maximized size:
      if mainFrame.isMaximized
         mainFrame.setMaximized(0);
      elseif mainFrame.isMinimized
         mainFrame.setMinimized(0);
      end
      % mainFrame.setBounds(mainFrame.getRestoredLocation);
      
   case 'gethwnd'  % Get window handle of the OS:
      % if ispc        % Perhaps this works under Linux / MacOS also ?!?
      Reply = GetHWnd(desktop, mainFrame, matlabV);
      % end
      
   case 'position'  % Get and set outer position relative to monitor:
      if ~hasWindowAPI
         WindowAPIMsg(Command);
         if nargout
            Reply = [];
         end
         return;
      end
      
      % Reply the current position:
      if nargout
         HWnd     = GetHWnd(desktop, mainFrame, matlabV);
         Location = WindowAPI(HWnd, 'OuterPosition');
         Reply    = Location.Position;
      end
      
      % Accepted: [1 x 4] DOUBLE vector, 'work', 'full'
      if nargin > 1
         try
            HWnd = GetHWnd(desktop, mainFrame, matlabV);
            WindowAPI(HWnd, 'OuterPosition', Data);
         catch ME
            error(['JSimon:', mfilename, ':BadData'], ...
               '*** %s: Bad position for Position command:\n%s', ...
               mfilename, MW.message);
         end
      end
      
   case 'toscreen'  % Move completely to visible area of current monitor:
      if ~hasWindowAPI
         WindowAPIMsg('toMonitor');
         return;
      end
      
      HWnd = GetHWnd(desktop, mainFrame, matlabV);
      WindowAPI(HWnd, 'ToMonitor');
      
   case 'setfocus'  % Gain keyboard focus:
      if ~hasWindowAPI
         WindowAPIMsg(Command);
         return;
      end
      
      HWnd = GetHWnd(desktop, mainFrame, matlabV);
      WindowAPI(HWnd, 'SetFocus');
      
   case 'isbusy'  % TRUE if Matlab is running a program
      % Matlab shows a status text while it is busy.
      statusText = CmdWinTool('statustext');
      Reply      = ~isempty(statusText);
      % Reply = strcmpi(statusText, 'Busy')
      
   case '$test'    % Dummy for testing purpose only
      
   otherwise  % The command cannot be performed by all platforms:
      % The platform specific code can be inserted here also, but this would
      % lead to a ugly deep indentation:
      processed = false;
end

% Return if the command could be performed already:
if processed
   return;
end

% Platform specific commands: --------------------------------------------------
processed = true;
if matlabV > 700
   switch Command
      case {'lean', 'fat'}  % Show/hide status bar, toolbar and menubar:
         % Safer to flush the event queue - sometimes Matlab 2009a freezes
         % without DRAWNOW:
         drawnow;
         % mainFrame.repaint;   % ???
         % mainFrame.validate;  % ???
         
         % Disable the statusbar:
         Value = strcmpi(Command, 'fat');
         mainFrame.setStatusBarVisible(Value);
         % Alternatively: mainFrame.getStatusBar.getParent.setVisible(Value);
         
         % Disable the toolbar - hide MJToolBar and ShortcutsToolbar:
         components = mainFrame.getContentPane.getComponents;
         for i = 1:length(components)
            if isa(components(i), ...
                  'com.mathworks.mwswing.desk.DTToolBarContainer')
               components(i).setVisible(Value);
               break;
            end
         end
         
         % Approach to hide the toolbars over components of the LayeredPane:
         %   components = mainFrame.getLayeredPane.getComponents;
         %   for i = 1:length(components)
         %      if isa(components(i), 'javax.swing.JPanel');
         %         components2 = components(i).getComponents;
         %         for j = 1:length(components2)
         %            if isa(components2(j), ...
         %                   'com.mathworks.mwswing.desk.DTToolBarContainer')
         %               components2(j).setVisible(Value);
         %               break;
         %            end
         %         end
         %         break;
         %      end
         %   end
         
         
         if matlabV >= 800  % Show or hide toolstrip menu:
            if Value
               mainFrame.getToolstrip.getContentPanel.show;
            else
               mainFrame.getToolstrip.getContentPanel.hide;
            end
         else               % Show/hide menubar:
            jMenuBar = mainFrame.getJMenuBar;
            if ~isempty(jMenuBar)
               jMenuBar.setVisible(Value);
            end
         end
         
         mainFrame.validate;
         
      case 'gettext'   % Get text from the command window:
         pause(0.02);  % Or DRAWNOW
         cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
         jString   = cmdWinDoc.getText(cmdWinDoc.getStartPosition.getOffset, ...
                                       cmdWinDoc.getLength);
         Reply     = char(jString);
         
         % Some ideas - which crashed Matlab in my tests:
         % insertString(int, java.lang.String,
         %              javax.swing.text.AttributeSet)
         % void replace(int, int, java.lang.String,
         %              javax.swing.text.AttributeSet)
         
         % Get commands typed in the command line as cell string:
         % X=com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory
         % cellstr(char(X))
         
      case 'top'  % Move window always on top of all others:
         % I do not know, when this might happen, but if a test is implemented,
         % it seems to be a good idea to run it:
         if not(mainFrame.isAlwaysOnTopSupported)
            fprintf('::: %s: AlwaysOnTop not supported\n', mfilename);
            return;
         end
         
         if nargin == 2
            if ischar(Data)
               Value = strcmpi(Data, 'on');
            else
               Value = any(Data);
            end
         else  % Toggle the AlwaysOnTop property:
            Value = not(mainFrame.isAlwaysOnTop);
         end
         mainFrame.setAlwaysOnTop(Value);

      case 'setlayout'  % Set layout of the MATLAB desktop:
         % Care for the correct upper/lower case:
         knownLayout = {'Default', 'Command Window Only', ...
            'History and Command Window', 'All Tabbed', ...
            'All but Command window Minimized'};
         knownIndex = strcmpi(Data, knownLayout);
         if any(knownIndex)
            Data = knownLayout(knownIndex);
         end
         
         try
            desktop.restoreLayout(Data);
            pause(0.1);  % This might take some time
         catch
            if ischar(Data)
               fprintf(2, '### %s: Unknown layout [%s] - case-sensitive!\n', ...
                  mfilename, Data);
            else
               fprintf(2, ['### %s: [setLayout] command needs a string, ', ...
                  'got a %s\n'], upper(class(Data)));
            end
         end
         
      case {'background', 'foreground'}  % Get or set text color:
         if nargin == 1
            Data = [];
         elseif isnumeric(Data)
            try
               switch numel(Data)
                  case {3, 4}   % Ignore the alpha channel!
                     Data = java.awt.Color(Data(1), Data(2), Data(3));
                  case 1
                     Data = java.awt.Color(Data);
                  otherwise
                     error(['JSimon:', mfilename, ':SetColor'], ...
                        '*** %s: Color must be scalar or [1 x 3]', mfilename);
               end
            catch ME
               error(['JSimon:', mfilename, ':SetColor'], ...
                  '*** %s: Cannot convert color: %s', mfilename, ME.message);
            end
         elseif isa(Data, 'java.awt.Color') == 0
            error(['JSimon:', mfilename, ':SetColor'], ...
               ['*** %s: Color must be defined numerically or as ', ...
               'java.awt.Color'], mfilename);
         end
         
         jTextArea = getjTextArea;
         if ~isempty(jTextArea)
            try
               if strcmpi(Command, 'background')
                  if nargout
                     Reply = jTextArea.getBackground;
                  end
                  if ~isempty(Data)
                     jTextArea.setBackground(Data);
                  end
               else
                  if nargout
                     Reply = jTextArea.getForeground;
                  end
                  if ~isempty(Data)
                     jTextArea.setForeground(Data);
                  end
               end
               pause(0.02);
            catch ME
               fprintf(2, '### %s[Color]: %s\n', mfilename, ME.message);
            end
         end
         
      case 'font'  % Get or set font:
         if nargin == 1
            Data = [];
         elseif ~isa(Data, 'java.awt.Font')
            try
               Data = java.awt.Font(Data.Name, java.awt.Font.PLAIN, Data.Size);
            catch
               error(['JSimon:', mfilename, ':SetColor'], ...
                  ['*** %s: [Font] must be a struct with fields [Name] ', ...
                  'and [Size].'], mfilename);
            end
         end
         
         jTextArea = getjTextArea;
         if ~isempty(jTextArea)
            try
               if nargout
                  Reply = jTextArea.getFont;
               end
               if ~isempty(Data)
                  jTextArea.setFont(Data);
               end
               pause(0.02);
            catch ME
               fprintf(2, '### %s[Font]: %s\n', mfilename, ME.message);
            end
         end
         
      otherwise
         processed = false;
   end
   
elseif matlabV >= 605  % -------------------------------------------------------
   switch lower(Command)
      case {'lean', 'fat'}  % Show/hide status bar, toolbar and menubar:
         Value = strcmpi(Command, 'fat');
         
         % Safer to flush the event queue - sometimes Matlab 2009a freezes
         % without DRAWNOW:
         drawnow;
         % mainFrame.repaint;   % ???
         % mainFrame.validate;  % ???
         
         mwPanel      = mainFrame.getComponent(0);
         mwComponents = mwPanel.getComponents;
         for i = 1:length(mwComponents)
            % Disable the statusbar:
            if isa(mwComponents(i), 'com.mathworks.mwt.MWPanel')
               mwComponents(i).setVisible(Value);
            end
            
            % Disable the toolbar:
            if isa(mwComponents(i), 'com.mathworks.mwt.MWToolbar')
               mwComponents(i).setVisible(Value);
            end
         end
                 
         % Hide menubar:
         % I did not find a reliable method yet...
         
         mainFrame.validate;
         % mainFrame.repaint;   % ???
         
      case {'font', 'foreground', 'background', 'gettext', 'top', 'setlayout'}
         if nargout
            Reply = [];
         end
         processed = false;
         
      otherwise
         processed = false;
   end
else
   processed = false;
end  % if matlabV > 700 or >= 605

if not(processed)
   fprintf(2, '### %s: [%s] not supported by this platform.\n', ...
      mfilename, Command);
end

% return;

% ******************************************************************************
function HWnd = GetHWnd(desktop, mainFrame, matlabV)
% Get Window's handle from operating system

if matlabV >= 7.13  % Matlab 2011b:
   HWnd = uint64(desktop.getCommandWindowHWND);
elseif matlabV >= 700      % [USER_ADJUST]
   HWnd = uint64(mainFrame.getPeer.getHWnd);
elseif matlabV >= 605
   HWnd = uint64(mainFrame.getDTContainer.getContainingFrame.getHWnd);
else
   fprintf(2, '### %s: [GetHWnd] is not supported by this platform.\n', ...
      mfilename);
   HWnd = [];
end

% return;

% ******************************************************************************
function WindowAPIMsg(Command)

fprintf(2, '### %s: Need WindowAPI for command [%s]\n', mfilename, Command);
URL = 'http://www.mathworks.com/matlabcentral/fileexchange/31437';
Msg = ['<a href="matlab:web(''', URL, ''', ''-browser'')">', URL, '</a>'];
fprintf('See: %s\n', Msg);

% return;

% ******************************************************************************
function jTextArea = getjTextArea()
% Find jTextArea in the list of listeners of the CmdWinDocument

matchClass     = 'javax.swing.JTextArea$AccessibleJTextArea';
cmdWinDoc      = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
cmdWinListener = cmdWinDoc.getDocumentListeners;
for iL = 1:length(cmdWinListener)
   if isa(cmdWinListener(iL), matchClass)
      jTextArea = cmdWinListener(iL);
      return;
   end
end

warning(['JSimon:', mfilename, ':getjTextArea'], ...
   'Cannot find jTextArea of the command window document.');
jTextArea = [];

% return;
