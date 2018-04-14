function varargout = MouseWalker(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOUSEWALKER MATLAB code for MouseWalker.fig
%
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% make Software directory available
  addpath(['./Software/']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MouseWalker_OpeningFcn, ...
                   'gui_OutputFcn',  @MouseWalker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before MouseWalker is made visible.
function MouseWalker_OpeningFcn(hObject, eventdata, handles, varargin)
  
%whenever any key is pressed, myFunction is called
set(handles.figure1,                                    'KeyPressFcn',@KeyPressFunction);
set(handles.BrowseInputDirectory_pushbutton,            'KeyPressFcn',@KeyPressFunction);
set(handles.BrowseOutputDirectory_pushbutton,           'KeyPressFcn',@KeyPressFunction);
set(handles.LoadData_pushbutton,                        'KeyPressFcn',@KeyPressFunction);
set(handles.start_pushbutton,                           'KeyPressFcn',@KeyPressFunction);
set(handles.minus_pushbutton,                           'KeyPressFcn',@KeyPressFunction);
set(handles.select_pushbutton,                          'KeyPressFcn',@KeyPressFunction);
set(handles.plus_pushbutton,                            'KeyPressFcn',@KeyPressFunction);
set(handles.toend_pushbutton,                           'KeyPressFcn',@KeyPressFunction);
set(handles.frame_slider,                               'KeyPressFcn',@KeyPressFunction);
set(handles.cut_out_pushbutton,                         'KeyPressFcn',@KeyPressFunction);
set(handles.ruler_pushbutton,                           'KeyPressFcn',@KeyPressFunction);
set(handles.restore_pushbutton,                         'KeyPressFcn',@KeyPressFunction);
set(handles.save_pushbutton,                            'KeyPressFcn',@KeyPressFunction);
set(handles.evaluate_togglebutton,                      'KeyPressFcn',@KeyPressFunction);
set(handles.picture_togglebutton,                       'KeyPressFcn',@KeyPressFunction);
set(handles.auto_togglebutton,                          'KeyPressFcn',@KeyPressFunction);
set(handles.LF_togglebutton,                            'KeyPressFcn',@KeyPressFunction);
set(handles.RF_togglebutton,                            'KeyPressFcn',@KeyPressFunction);
set(handles.LH_togglebutton,                            'KeyPressFcn',@KeyPressFunction);
set(handles.RH_togglebutton,                            'KeyPressFcn',@KeyPressFunction);
set(handles.tailend_togglebutton,                       'KeyPressFcn',@KeyPressFunction);
set(handles.tail1_togglebutton,                         'KeyPressFcn',@KeyPressFunction);
set(handles.tail2_togglebutton,                         'KeyPressFcn',@KeyPressFunction);
set(handles.tail3_togglebutton,                         'KeyPressFcn',@KeyPressFunction);
set(handles.bodyback_togglebutton,                      'KeyPressFcn',@KeyPressFunction);
set(handles.bodycenter_togglebutton,                    'KeyPressFcn',@KeyPressFunction);
set(handles.headcenter_togglebutton,                    'KeyPressFcn',@KeyPressFunction);
set(handles.nose_togglebutton,                          'KeyPressFcn',@KeyPressFunction);
set(handles.mouseoff_pushbutton,                        'KeyPressFcn',@KeyPressFunction);
set(handles.mousebeforeoff_pushbutton,                  'KeyPressFcn',@KeyPressFunction);
set(handles.mouseafteroff_pushbutton,                   'KeyPressFcn',@KeyPressFunction);
set(handles.brightness_minus_pushbutton,                'KeyPressFcn',@KeyPressFunction);
set(handles.brightness_tail_minus_pushbutton,           'KeyPressFcn',@KeyPressFunction);
set(handles.brightness_tail_minus_pushbutton,           'KeyPressFcn',@KeyPressFunction);
set(handles.brightness_tail_plus_pushbutton,            'KeyPressFcn',@KeyPressFunction);
set(handles.brightness_foot_minus_pushbutton,           'KeyPressFcn',@KeyPressFunction);
set(handles.brightness_foot_plus_pushbutton,            'KeyPressFcn',@KeyPressFunction);
set(handles.brightness_measure_pushbutton,              'KeyPressFcn',@KeyPressFunction);
set(handles.position_measure_pushbutton,                'KeyPressFcn',@KeyPressFunction);
set(handles.BrowseInputDirectory_pushbutton,            'KeyPressFcn',@KeyPressFunction);
set(handles.BrowseOutputDirectory_pushbutton,           'KeyPressFcn',@KeyPressFunction);
set(handles.LoadData_pushbutton,                        'KeyPressFcn',@KeyPressFunction);
% set(handles.InputDirectory_edit,                        'KeyPressFcn',@KeyPressFunction);
% set(handles.OutputDirectory_edit,                       'KeyPressFcn',@KeyPressFunction);
set(handles.mousenumber_popupmenu,                      'KeyPressFcn',@KeyPressFunction);
set(handles.refitbody_togglebutton,                     'KeyPressFcn',@KeyPressFunction);



% Assign the GUI a name to appear in the window title.
%   set(gcf,'Name','FootPrintAnalysis');


% Choose default command line output for MouseWalker
handles.output = hObject;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define whatever value we want global here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % read in parameters file if it exists, otherwise use predefined
  % parameters
    if exist('ParametersDefault.mat')
      load('ParametersDefault.mat');
      handles.p = p;
    else
      handles.p = MouseParameters();
    end;
  % setup input folder for faster start
    set(handles.InputDirectory_edit,'String',handles.p.inputFolderName);

% store handle for FootPrintAnalysis in the root
  setappdata(0, 'hMouseTracker', gcf);
  
%========================================================================

% Update handles structure
  guidata(hObject, handles);

% UIWAIT makes MouseWalker wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Outputs from this function are returned to the command line.
function varargout = MouseWalker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KEY PRESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function KeyPressFunction(src,evnt)
% react to pressed keys

%this line brings the handles structures into the local workspace
%now we can use handles.cats in this subfunction!
handles = guidata(src);
eventdata = [];

% disp(int16(evnt.Character))
hObject = handles.output;
int16(evnt.Character); 
% evntmodifier = evnt.Modifier

% toggle between different plot styles
if int16(evnt.Character) >= 49 & int16(evnt.Character) <= 57
  handles.p.WhatToPlot = int16(evnt.Character) - 48;
  handles = PlotMouse(handles);
  % Update handles structure
    guidata(hObject, handles);
end;
% jump to the beginning (<<)
if evnt.Character == 'v' 
    start_pushbutton_Callback(hObject, eventdata, handles);
end;
% decrease frame number
if int16(evnt.Character) == 28 | evnt.Character == 'z' % left arrow
    minus_pushbutton_Callback(hObject, eventdata, handles);
end;
% Select
if int16(evnt.Character) == 31  | evnt.Character == 'x' % down arrow
    select_pushbutton_Callback(hObject, eventdata, handles);
end;
% increase frame number
if int16(evnt.Character) == 29  | evnt.Character == 'c' % right arrow
    plus_pushbutton_Callback(hObject, eventdata, handles);
end;
% jump to the end (>>)
if evnt.Character == 'b' 
    toend_pushbutton_Callback(hObject, eventdata, handles);
end;
% RF
if evnt.Character == 'e'
    handles.RF_togglebuttonStatus = get(handles.RF_togglebutton,'Value');
    set(handles.RF_togglebutton,'Value',1-handles.RF_togglebuttonStatus);
    RF_togglebutton_Callback(hObject, eventdata, handles);
end;
% LF
if evnt.Character == 'd'
    handles.LF_togglebuttonStatus = get(handles.LF_togglebutton,'Value');
    set(handles.LF_togglebutton,'Value',1-handles.LF_togglebuttonStatus);
    LF_togglebutton_Callback(hObject, eventdata, handles);
end;
% RH
if evnt.Character == 'q'
    handles.RH_togglebuttonStatus = get(handles.RH_togglebutton,'Value');
    set(handles.RH_togglebutton,'Value',1-handles.RH_togglebuttonStatus);
    RH_togglebutton_Callback(hObject, eventdata, handles);
end;
% LH
if evnt.Character == 'a'
    handles.LH_togglebuttonStatus = get(handles.LH_togglebutton,'Value');
    set(handles.LH_togglebutton,'Value',1-handles.LH_togglebuttonStatus);
    LH_togglebutton_Callback(hObject, eventdata, handles);
end;
% CENTER OF BODY
if evnt.Character == 'r'
    bodycenter_togglebutton_Callback(hObject, eventdata, handles);
end;
% FRONT OF BODY
if evnt.Character == 'f'
    headcenter_togglebutton_Callback(hObject, eventdata, handles);
end;
% NOSE
if evnt.Character == 'n' | int16(evnt.Character) == 30
    set(handles.nose_togglebutton,'Value',1);
    nose_togglebutton_Callback(hObject, eventdata, handles);
end;
% TAIL END
if evnt.Character == 'm'
    tailend_togglebutton_Callback(hObject, eventdata, handles);
end;
% CUT OUT
if evnt.Character == 't'
    cut_out_pushbutton_Callback(hObject, eventdata, handles);
end;
% RULER
if evnt.Character == 'g'
    ruler_pushbutton_Callback(hObject, eventdata, handles);
end;
% SET FOOTPRINT TO THE SAME AS NEXT
% RF
if evnt.Character == 'E'
  % determine which direction to take neighbor. If Control is pressed, take it from next frame, otherwise previous frame
    Neighbor = -1; % previous frame
    for i = 1 : length(evnt.Modifier)
      if strcmp(evnt.Modifier(i),'alt')
        Neighbor = 1; % next frame
      end;
    end;
  % Change leg status
    handles = ChangeLegStatus(handles,'RF',Neighbor);
  % Update handles structure
    guidata(hObject, handles);
end;
% LF
if evnt.Character == 'D'
  % determine which direction to take neighbor. If Control is pressed, take it from next frame, otherwise previous frame
    Neighbor = -1; % previous frame
    for i = 1 : length(evnt.Modifier)
      if strcmp(evnt.Modifier(i),'alt')
        Neighbor = 1; % next frame
      end;
    end;  
  % Change leg status
    handles = ChangeLegStatus(handles,'LF',Neighbor);
  % Update handles structure
    guidata(hObject, handles);
end;
% RH
if evnt.Character == 'Q'
  % determine which direction to take neighbor. If Control is pressed, take it from next frame, otherwise previous frame
    Neighbor = -1; % previous frame
    for i = 1 : length(evnt.Modifier)
      if strcmp(evnt.Modifier(i),'alt')
        Neighbor = 1; % next frame
      end;
    end;
  % Change leg status
    handles = ChangeLegStatus(handles,'RH',Neighbor);
  % Update handles structure
    guidata(hObject, handles);
end;
% LH
if evnt.Character == 'A'
  % determine which direction to take neighbor. If Control is pressed, take it from next frame, otherwise previous frame
    Neighbor = -1; % previous frame
    for i = 1 : length(evnt.Modifier)
      if strcmp(evnt.Modifier(i),'alt')
        Neighbor = 1; % next frame
      end;
    end;
  % Change leg status
    handles = ChangeLegStatus(handles,'LH',Neighbor);
  % Update handles structure
    guidata(hObject, handles);
end;

%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BROWSE INPUT DATA FOLDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in BrowseInputDirectory_pushbutton.
function BrowseInputDirectory_pushbutton_Callback(hObject, eventdata, handles)

  % start browsing from current folder in InputDirectory_edit
    old_folder_name = get(handles.InputDirectory_edit,'String');
    handles.p.start_path = old_folder_name;
  % if start_path doesn't exist make it to the matlab directory
    if exist(handles.p.start_path) ~= 7
        if exist(handles.p.inputFolderName) == 7
            handles.p.start_path = handles.p.inputFolderName;
        else
            handles.p.start_path = pwd;
        end
    end;
    folder_name = uigetdir(handles.p.start_path,'Select input directory path');
    if folder_name == 0
        folder_name = old_folder_name;
    end
    set(handles.InputDirectory_edit,'String',folder_name);
  % set start_path to loaded directory
    handles.p.start_path = folder_name;
  % Update handles structure
    guidata(hObject, handles);
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BROWSE OUTPUT DATA FOLDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in BrowseOutputDirectory_pushbutton.
function BrowseOutputDirectory_pushbutton_Callback(hObject, eventdata, handles)

  % start browsing from current folder in OutputDirectory_edit
    old_folder_name = get(handles.OutputDirectory_edit,'String');
    handles.p.results_folder = old_folder_name;
  % if start_path doesn't exist make it to the matlab directory
    if exist(handles.p.results_folder) ~= 7
        if exist(handles.p.outputFolderName) == 7
            handles.p.results_folder = handles.p.inputFolderName;
        else
            handles.p.results_folder = '<default>';
        end
    end;
    track_folder_name = uigetdir(handles.p.results_folder,'Select input directory path');
    if track_folder_name == 0
        track_folder_name = old_folder_name;
    end
    set(handles.OutputDirectory_edit,'String',track_folder_name);
  % set start_path to loaded directory
    handles.p.results_folder = track_folder_name;
  % Update handles structure
    guidata(hObject, handles);
%==========================================================================
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BROWSE OUTPUT DATA FOLDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in defaultresultsfolder_pushbutton.    
function defaultresultsfolder_pushbutton_Callback(hObject, eventdata, handles)
    
  % make current output folder in OutputDirectory_edit <default>
    set(handles.OutputDirectory_edit,'String','<default>');
  % set start_path to loaded directory
    handles.p.results_folder = '<default>';  
  % Update handles structure
    guidata(hObject, handles);  
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data from input folder
% --- Executes on button press in LoadData_pushbutton.
function LoadData_pushbutton_Callback(hObject, eventdata, handles)

  % load data
    handles = LoadData(handles);

  % resize image_axes to preserve ratio of image
    image_panel_ResizeFcn(hObject, eventdata, handles);

  % Update handles structure
    guidata(hObject, handles);
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <<
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function start_pushbutton_Callback(hObject, eventdata, handles)

  % Advance frame number with one
    FrameNumber  = str2num(get(handles.frame_edit,'String'));
    if FrameNumber ~= 1
        FrameNumber = 1;
        set(handles.frame_edit,'String',num2str(FrameNumber));
        guidata(hObject, handles);
        select_pushbutton_Callback(hObject, eventdata, handles);
    end
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in minus_pushbutton.
function minus_pushbutton_Callback(hObject, eventdata, handles)

  % Decrease frame number with one
    FrameNumber  = str2num(get(handles.frame_edit,'String'));
    FrameNumber = FrameNumber - 1;
    if FrameNumber >= 1
        set(handles.frame_edit,'String',num2str(FrameNumber));
        guidata(hObject, handles);
        select_pushbutton_Callback(hObject, eventdata, handles);
    end
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in select_pushbutton.
function select_pushbutton_Callback(hObject, eventdata, handles)
  
  handles = PlotMouse(handles);
  

  % Update handles structure
    guidata(hObject, handles);
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% >
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in plus_pushbutton.
function plus_pushbutton_Callback(hObject, eventdata, handles)

  % execute only if data was loaded
    if isfield(handles.p,'FileList')
      % Advance frame number with one
        handles.p.inputFolderName = get(handles.InputDirectory_edit,'String');
        handles.p.inputFolderName = AddSlash(handles.p.inputFolderName);
        Length = length(handles.p.FileList);
        FrameNumber  = str2num(get(handles.frame_edit,'String'));
        FrameNumber = FrameNumber + 1;
        if FrameNumber <= Length
            set(handles.frame_edit,'String',num2str(FrameNumber));
            guidata(hObject, handles);
            select_pushbutton_Callback(hObject, eventdata, handles);
        end
    end;
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% >>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in toend_pushbutton.
function toend_pushbutton_Callback(hObject, eventdata, handles)
  % execute only if data was loaded
    if isfield(handles.p,'FileList')
      % go to the end of the frames
        handles.p.inputFolderName = get(handles.InputDirectory_edit,'String');
        handles.p.inputFolderName = AddSlash(handles.p.inputFolderName);
        Length = length(handles.p.FileList);
        FrameNumber = Length;
        set(handles.frame_edit,'String',num2str(FrameNumber));
        guidata(hObject, handles);
        select_pushbutton_Callback(hObject, eventdata, handles);
    end;
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FRAME SLIDER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on slider movement.
function frame_slider_Callback(hObject, eventdata, handles)

  % determine which frame to plot with slider
    FrameNumber = round(get(handles.frame_slider,'Value'));
    set(handles.frame_edit,'String',num2str(FrameNumber));
  % plot 
    select_pushbutton_Callback(hObject, eventdata, handles);




%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CUT OUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cut_out_pushbutton_Callback(hObject, eventdata, handles)
% let the user define a rectangle by pointing at its two corners. Cut the
% rectangle out such that it wont be analyzed any longer.

  % determine picture size
    if isfield(handles,'v')
      if isfield(handles.v, 'pic')
        picsize = size(handles.v.pic.R);
      else, return; end;
    else return; end;
  % let user place the first corner manually
    [x,y] = myginput(1,'crosshair');
  % continue only if the placement is within the frame
    if x > 0 & x < picsize(2) & y > 0 & y < picsize(1)
        % mark the first corner
        plot(x,y,'bo');
        % let user place the second corner manually
          [x2,y2] = myginput(1,'crosshair');
        % continue only if the placement is within the frame
          if x2 > 0 & x2 < picsize(2) & y2 > 0 & y2 < picsize(1)
              % round values and choose which corner is smaller and which is
              % bigger
                DPMsize = size(handles.p.DPM.R);
                minx = max(1,round(min(x,x2)));
                maxx = min(DPMsize(2),round(max(x,x2)));
                miny = max(1, round(min(y,y2)));
                maxy = min(DPMsize(1), round(max(y,y2)));
              % cut out rectangle from frames by making mask include
              % rectangle
                handles.p.DPM.R(miny:maxy,minx:maxx) = 255;
                handles.p.DPM.G(miny:maxy,minx:maxx) = 255;
                handles.p.DPM.B(miny:maxy,minx:maxx) = 255;
              % replot screen
                handles = PlotMouse(handles);    
              % mark the four corners
                plot([minx minx maxx maxx minx],[miny maxy maxy miny miny],'b:', 'MarkerFaceColor',[0 0 1]);
              % Update handles structure
                guidata(hObject, handles);  
          end;
    end;
%==========================================================================  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RULER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Measures the distance between two points the user defines
function ruler_pushbutton_Callback(hObject, eventdata, handles)

  % determine picture size
    if isfield(handles,'v')
      if isfield(handles.v, 'pic')
        picsize = size(handles.v.pic.R);
      else, return; end;
    else return; end;
  % let user place the first point manually
    [x,y] = myginput(1,'crosshair');
  % continue only if the placement is within the frame
    if x > 0 & x < picsize(2) & y > 0 & y < picsize(1)
        % mark the first point
          plot(x,y,'bo')
        % let user place the second point manually
          [x2,y2] = myginput(1,'crosshair');
        % continue only if the placement is within the frame
          if x2 > 0 & x2 <picsize(2) & y2 > 0 & y2 < picsize(1)

                % measure distance between points
                  DIST_in_pixel = sqrt((x - x2)^2 + (y - y2)^2);
                  DIST_in_mm    = DIST_in_pixel / handles.p.mm2pix;
                % replot screen
                  handles = PlotMouse(handles);    
              % mark the distance between the two ends
                plot([x x2],[y y2],'b',  'MarkerFaceColor',[0 0 1], 'LineWidth',2);
                plot([x x2],[y y2],'bx', 'MarkerFaceColor',[0 0 1], 'LineWidth',2);

              % write distance on screen
              TEXT = [num2str(round(DIST_in_pixel)) ' pixels'];
              text(picsize(1)/20+5,picsize(2)/20+10,TEXT,'Color','b','FontSize',20)
              TEXT = [num2str(round(DIST_in_mm)) ' mm'];
              text(picsize(1)/20+5,picsize(2)/20+50,TEXT,'Color','b','FontSize',20)
              % Update handles structure
                guidata(hObject, handles);  
          end;
    end;
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes when image_panel is resized.
function image_panel_ResizeFcn(hObject, eventdata, handles)

  % Figure Units are fixed as 'pixels';
    Figure_Size = get(handles.figure1,'Position');

  % set size of imagebox_uipanel such that it is always proportional to picture size
  if isfield(handles,'v')
      if isfield(handles.v,'pic')
          % get picture size
            PicSize = size(handles.v.pic.R);
            Pic_x = PicSize(2);
            Pic_y = PicSize(1);

          % get window coordinates in points
            set(handles.figure1,'Units','Points');              % Was normalized
            window_size   = get(handles.figure1,'Position');    % Now in points
            window_width  = window_size(3);
            window_height = window_size(4);
            set(handles.figure1,'Units','normalized');          % Now normalized again

          % get coordinates in points
            set(handles.image_axes,'Units','Points');    
            image_panel_position = get(handles.image_axes,'Position');
            image_x      = image_panel_position(1);
            image_y      = image_panel_position(2);
            image_width  = image_panel_position(3);
            image_height = image_panel_position(4);

          % resize the size that is the smaller one compared to what it is supposed to be
            image_height = window_height * 0.785;
            image_width  = image_height * Pic_x / Pic_y;
          % make sure image doesn't extend beyond window
            if image_width > window_width - 2 * image_x
                image_width  = window_width - 2 * image_x;
                image_height = image_width * Pic_y / Pic_x;
            end;

          % shift bottom of imagebox such that it touches the buttons
            image_y = window_height * 0.785 - image_height;

          % update sizes
            set(handles.image_axes,'Position',[image_x image_y image_width image_height]);

          % switch back to normalized more
            set(handles.image_axes,'Units','Normalized');    

      end;
  end;
%   Figure_Size = get(handles.figure1,'Position');
%   imagebox_uipanel_position = get(handles.image_axes,'Position');
%   image_axes_position = get(handles.image_panel,'Position');

%   LoadData_panel_ResizeFcn(hObject, eventdata, handles)

% % --- Executes when LoadData_panel is resized.
% function LoadData_panel_ResizeFcn(hObject, eventdata, handles)
% 
%           % get window coordinates in points
%             set(handles.figure1,'Units','Points');              % Was normalized
%             window_size   = get(handles.figure1,'Position');    % Now in points
%             window_width  = window_size(3);
%             window_height = window_size(4);
%             set(handles.figure1,'Units','normalized');          % Now normalized again
% 
%           % get coordinates in points
%             set(handles.LoadData_panel,'Units','Points');    
%             LoadData_panel_position = get(handles.LoadData_panel,'Position');
%             LoadData_x      = LoadData_panel_position(1);
%             LoadData_y      = LoadData_panel_position(2);
%             LoadData_width  = LoadData_panel_position(3);
%             LoadData_height = LoadData_panel_position(4);
%             
%            % move LoadData_panel so it's distance from top remains the same
%             LoadData_y = window_height - LoadData_height-10;
%             
%           % update sizes
%             set(handles.LoadData_panel,'Position',[LoadData_x LoadData_y LoadData_width LoadData_height]);
% 
%           % switch back to normalized more
%             set(handles.LoadData_panel,'Units','Normalized');             
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESTORE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function restore_pushbutton_Callback(hObject, eventdata, handles)

  % if no data was loaded then quit
    if isfield(handles,'pbackup')
    % restore backup values saved previously using 'save' button
      handles.p = handles.pbackup;
      handles.v = handles.vbackup;

    % replot frame with restored parameters
      handles = PlotMouse(handles);

    % Update handles structure
      guidata(hObject, handles);
    end;
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_pushbutton_Callback(hObject, eventdata, handles)
% save information
  % if no data was loaded then quit
    if isfield(handles,'v')
      % define variables in the format they will be saved
        p = handles.p;
        v = handles.v;
      save(handles.p.resultsFileName, 'p', 'v');

      text(220,100,'Data saved...','BackgroundColor', [1 1 1],'FontSize',22)

      % Back up data that can be restored using 'restore' button
        handles.pbackup = handles.p;
        handles.vbackup = handles.v;
      % Update handles structure
        guidata(hObject, handles);
    end;
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVALUATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run EvaluateFlyTable
function evaluate_togglebutton_Callback(hObject, eventdata, handles)

  % if no data was loaded then quit
    if isfield(handles,'v') & get(handles.evaluate_togglebutton,'Value') == 1

      % cange button name to indicate that function is running
        set(handles.evaluate_togglebutton,'string','cancel','BackgroundColor',[240 200 200]/255);

      % statistically evaluate results
        MouseEvaluate(handles);

      % cange button name to indicate that function is running
        set(handles.evaluate_togglebutton,'string','evaluate','BackgroundColor', [240 240 240]/255);
      % put button back to normal
        set(handles.evaluate_togglebutton,'Value', 0);
      
      % signal end of run
        disp('Evaluation finished. ----------------')  
        load train.mat;
        sound(y);
        
      % Update handles structure
        guidata(hObject, handles);    
    end;
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE PICTURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function picture_togglebutton_Callback(hObject, eventdata, handles)
  
  handles = SavePictures(handles);
  
  % Update handles structure
    guidata(hObject, handles);
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTO ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function auto_togglebutton_Callback(hObject, eventdata, handles)
  % runs MouseAutoAnalysis
  % run only if data is loaded
    if isfield(handles,'v')
      ButtonStatus = get(handles.auto_togglebutton,'Value');
      % run only if button is pressed down
      if ButtonStatus == 1    
          % cange button name to indicate that function is running
            set(handles.auto_togglebutton,'string','cancel', 'FontSize', 7,'BackgroundColor',[240 200 200]/255);
          % determine frame number
            handles.FrameNumber  = str2num(get(handles.frame_edit,'String'));
          % run fly tracking
            handles = AutoMouseAnalysis(handles);
          % set up mousenumber_popupmenu to have the number of mice available
            set(handles.mousenumber_popupmenu, 'String', num2cell(1:handles.v.MouseTrack.NumberOfMice));        
          % save results
            SaveResults(handles.v,handles.p);
          % plot results
            handles = PlotMouse(handles);
      end;
    end;
  % make sure that after the analysis the toggle button is up and has the right text
    set(handles.auto_togglebutton,'Value',0);
    set(handles.auto_togglebutton,'string','auto', 'FontSize', 10,'BackgroundColor', [240 240 240]/255);

  % Update handles structure
  guidata(hObject, handles);
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LEG TOGGLEBUTTONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LF_togglebutton_Callback(hObject, eventdata, handles)
    % Change leg status according to button status
      handles = ChangeLegStatus(handles,'LF',0);
    % Update handles structure
      guidata(hObject, handles);
function RF_togglebutton_Callback(hObject, eventdata, handles)
    % Change leg status according to button status
      handles = ChangeLegStatus(handles,'RF',0);
    % Update handles structure
      guidata(hObject, handles);
function LH_togglebutton_Callback(hObject, eventdata, handles)
    % Change leg status according to button status
      handles = ChangeLegStatus(handles,'LH',0);
    % Update handles structure
      guidata(hObject, handles);
function RH_togglebutton_Callback(hObject, eventdata, handles)
    % Change leg status according to button status
      handles = ChangeLegStatus(handles,'RH',0);
    % Update handles structure
      guidata(hObject, handles);
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BODY/TAIL/HEAD TOGGLEBUTTONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tailend_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'tailend');
    % Update handles structure
      guidata(hObject, handles);
function tail1_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'tail1');
    % Update handles structure
      guidata(hObject, handles);
function tail2_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'tail2');
    % Update handles structure
      guidata(hObject, handles);
function tail3_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'tail3');
    % Update handles structure
      guidata(hObject, handles);
function bodyback_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'bodyback');
    % Update handles structure
      guidata(hObject, handles);
function bodycenter_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'bodycenter');
    % Update handles structure
      guidata(hObject, handles);
function headcenter_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'headcenter');
    % Update handles structure
      guidata(hObject, handles);
function nose_togglebutton_Callback(hObject, eventdata, handles)
    % Change status according to button status
      handles = ChangeBodyStatus(handles,'nose');
    % Update handles structure
      guidata(hObject, handles);
%==========================================================================  
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REFIT BODY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refitbody_togglebutton_Callback(hObject, eventdata, handles)

    % Refit body based on currently defined nose and tail
      handles = RefitBody(handles);
    % Update handles structure
      guidata(hObject, handles);
  
%==========================================================================  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MOUSE OFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mouseoff_pushbutton_Callback(hObject, eventdata, handles)
% turn mouse off at actual frame (the one defined by mouse #)

    handles = MouseOff(handles, 'current');
    
    % Update handles structure
    guidata(hObject, handles);

function mousebeforeoff_pushbutton_Callback(hObject, eventdata, handles)
% turn body off at frames at and before actual frame (the one defined by mouse #)

    handles = MouseOff(handles, 'before');
    
    % Update handles structure
    guidata(hObject, handles);

function mouseafteroff_pushbutton_Callback(hObject, eventdata, handles)
% turn body off at frames at and after actual frame (the one defined by mouse #)

    handles = MouseOff(handles, 'after');
    
    % Update handles structure
    guidata(hObject, handles);
%==========================================================================  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRIGHTNESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function brightness_minus_pushbutton_Callback(hObject, eventdata, handles)
    % decrease brightness
    handles.p.bodybrightness = handles.p.bodybrightness / 1.2;
    handles = PlotMouse(handles);
    % Update handles structure
    guidata(hObject, handles);

function brightness_plus_pushbutton_Callback(hObject, eventdata, handles)
    % increase brightness
    handles.p.bodybrightness = handles.p.bodybrightness * 1.2;
    handles = PlotMouse(handles);
    % Update handles structure
    guidata(hObject, handles);
    
function brightness_tail_minus_pushbutton_Callback(hObject, eventdata, handles)
    % decrease brightness
    handles.p.tailbrightness = handles.p.tailbrightness / 1.2;
    handles = PlotMouse(handles);
    % Update handles structure
    guidata(hObject, handles);


function brightness_tail_plus_pushbutton_Callback(hObject, eventdata, handles)
    % increase brightness
    handles.p.tailbrightness = handles.p.tailbrightness * 1.2;
    handles = PlotMouse(handles);
    % Update handles structure
    guidata(hObject, handles);
    
    
function brightness_foot_minus_pushbutton_Callback(hObject, eventdata, handles)
    % decrease brightness
    handles.p.footbrightness = handles.p.footbrightness / 1.2;
    handles = PlotMouse(handles);
    % Update handles structure
    guidata(hObject, handles);

function brightness_foot_plus_pushbutton_Callback(hObject, eventdata, handles)
    % increase brightness
    handles.p.footbrightness = handles.p.footbrightness * 1.2;
    handles = PlotMouse(handles);
    % Update handles structure
    guidata(hObject, handles);
%==========================================================================  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MENU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function file_menu_Callback(hObject, eventdata, handles)
  function exit_menu_option_Callback(hObject, eventdata, handles)
    % exit
      close(gcf);


function settings_menu_Callback(hObject, eventdata, handles)
    % write current parameters to the desktop
      % get gui handle
        hMouseTracker = getappdata(0,'hMouseTracker');
        
      % save current background frame number value used for mask
        handles.p.currentBGframenum = handles.p.BGlength;
        
      % save current output folder
        handles.p.currentoutputFolderName = handles.p.outputFolderName;
        
      % store handle for MouseWalker in the root
        setappdata(0, 'handles', handles);

      % write data into gui handle that will be readable by the other file
        setappdata(0,'handlesp',handles.p);

        
      % run parameter edit script
        SetupTracking();
        waitfor(SetupTracking);
        
      % retrieve data  
        handles.p = getappdata(0,'handlesp');    

      % recalculate mask as it may have changed
        if handles.p.BGlength ~= handles.p.currentBGframenum & isfield(handles,'v')
          % calculate background for filter
            [handles.p.DPM, handles.p.picMedian] = Masks(handles.p); 
        end;
        
      % update input/output directories
        set(handles.InputDirectory_edit,'String', handles.p.inputFolderName);
        % only update if there was any change (to make sure that default stays)
          if ~strcmp(handles.p.outputFolderName,handles.p.currentoutputFolderName)
            set(handles.OutputDirectory_edit,'String', handles.p.outputFolderName);
          end;
      
      % replot screen if v is already present
        if isfield(handles,'v')
          handles = PlotMouse(handles);    
          % resize image_axes to preserve ratio of image
            image_panel_ResizeFcn(hObject, eventdata, handles);        
        end;
      % Update handles structure
        guidata(hObject, handles);         
  %========================================================================      
    
function help_menu_Callback(hObject, eventdata, handles)

  function about_menu_option_Callback(hObject, eventdata, handles)


    
    
%==========================================================================  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function brightness_measure_pushbutton_Callback(hObject, eventdata, handles)
  % let user choose a point on figure, measure its brightness and output it to screen
  % determine picture size
    if isfield(handles,'v')
      if isfield(handles.v, 'pic')
        picsize = size(handles.v.pic.R);
      else, return; end;
    else return; end;
  % let user place the first point manually
    [x,y] = myginput(1,'crosshair');
    x = round(x);
    y = round(y);
  % continue only if the placement is within the frame
    if x > 0 & x < picsize(2) & y > 0 & y < picsize(1)
      % replot screen
        handles = PlotMouse(handles);    
      % write distance on screen
        TEXT = ['[' num2str(handles.v.pic.R(y,x)) ', '  num2str(handles.v.pic.G(y,x)) ', '  num2str(handles.v.pic.B(y,x)) ']'];
        text(picsize(1)/20+5,picsize(2)/20+10,TEXT,'Color','b','FontSize',20)
      % Update handles structure
        guidata(hObject, handles);  
    end;  

function position_measure_pushbutton_Callback(hObject, eventdata, handles)
  % let user choose a point on figure, measure its position and output it to screen
  % determine picture size
    if isfield(handles,'v')
      if isfield(handles.v, 'pic')
        picsize = size(handles.v.pic.R);
      else, return; end;
    else return; end;
  % let user place the first point manually
    [x,y] = myginput(1,'crosshair');
    x = round(x);
    y = round(y);
  % continue only if the placement is within the frame
    if x > 0 & x < picsize(2) & y > 0 & y < picsize(1)
      % replot screen
        handles = PlotMouse(handles);    
      % write distance on screen
        TEXT = ['(' num2str(round(x)) ', ' num2str(round(y)) ')'];
        text(picsize(1)/20+5,picsize(2)/20+10,TEXT,'Color','b','FontSize',20)
      % Update handles structure
        guidata(hObject, handles);  
    end;  
%==========================================================================  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHERS WITH NO DIRECT ACTIVE FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function InputDirectory_edit_Callback(hObject, eventdata, handles)
  % Hints: get(hObject,'String') returns contents of InputDirectory_edit as text
  %        str2double(get(hObject,'String')) returns contents of InputDirectory_edit as a double

function InputDirectory_edit_CreateFcn(hObject, eventdata, handles)
  % Hint: edit controls usually have a white background on Windows.
  %       See ISPC and COMPUTER.
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function OutputDirectory_edit_Callback(hObject, eventdata, handles)
  % Hints: get(hObject,'String') returns contents of OutputDirectory_edit as text
  %        str2double(get(hObject,'String')) returns contents of OutputDirectory_edit as a double

function OutputDirectory_edit_CreateFcn(hObject, eventdata, handles)
  % Hint: edit controls usually have a white background on Windows.
  %       See ISPC and COMPUTER.
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function frame_edit_Callback(hObject, eventdata, handles)
  % Hints: get(hObject,'String') returns contents of frame_edit as text
  %        str2double(get(hObject,'String')) returns contents of frame_edit as a double

  function frame_edit_CreateFcn(hObject, eventdata, handles)
  % Hint: edit controls usually have a white background on Windows.
  %       See ISPC and COMPUTER.
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function frame_slider_CreateFcn(hObject, eventdata, handles)

  % Hint: slider controls usually have a light gray background.
  if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor',[.9 .9 .9]);
  end

% --- Executes during object creation, after setting all properties.
function mousenumber_popupmenu_CreateFcn(hObject, eventdata, handles)
  % Hint: popupmenu controls usually have a white background on Windows.
  %       See ISPC and COMPUTER.
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function mousenumber_popupmenu_Callback(hObject, eventdata, handles)
  
%==========================================================================
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%==========================================================================
