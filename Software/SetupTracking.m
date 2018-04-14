function varargout = SetupTracking(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function varargout = SetupTracking(varargin)
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SetupTracking_OpeningFcn, ...
                   'gui_OutputFcn',  @SetupTracking_OutputFcn, ...
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
% --- Executes just before SetupTracking is made visible.
function SetupTracking_OpeningFcn(hObject, eventdata, handles, varargin)

  % update window title
    set(gcf,'Name','MouseTracker - Settings');

  % get handles from MouseTracker
    MThandles = getappdata(0,'handles');          
  % if data was loaded to MouseTracker, plot current frame here too
    if isfield(MThandles,'v')    
      % plot results
        MThandles = PlotMouse(MThandles);
      % save doutput of PlotMouse
        setappdata(0,'handles',MThandles);      
      % resize image_axes to preserve ratio of image
        image_panel_ResizeFcn(hObject, eventdata, handles);
    end
    
  % set up default categories for Image Style popupmenu
    set(handles.image_style_popupmenu, 'String', {'original', ...          % 1 
                                                  'fixed scale', ...       % 2 
                                                  'body + feet + tail', ...% 3 
                                                  'floating scale', ...    % 4
                                                  'body + tail', ...       % 5
                                                  'body only', ...         % 6
                                                  'feet only', ...         % 7
                                                  'tail only', ...         % 8
                                                  'all - no filter'});     % 9

  % set up default categories for Body Color popupmenu
    set(handles.body_color_popupmenu, 'String', {'R', 'G', 'B'});  

  % set up default categories for Tail Color popupmenu
    set(handles.tail_color_popupmenu, 'String', {'R', 'G', 'B'});  

  % set up default categories for Foot Color popupmenu
    set(handles.foot_color_popupmenu, 'String', {'R', 'G', 'B'});  

  % set up default categories for Force Direction popupmenu
    set(handles.force_direction_popupmenu, 'String', {'N/A', 'up', 'down', 'left', 'right', 'previous'});  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Initialize
    set(handles.image_style_popupmenu,              'Value',  MThandles.p.WhatToPlot);
    set(handles.force_direction_popupmenu,          'Value',  MThandles.p.ForceDirection);
    set(handles.invert_image_checkbox,              'Value',  MThandles.p.invert);
    set(handles.lengthbar_checkbox,                 'Value',  MThandles.p.lengthbar);
    set(handles.invert_body_checkbox,               'Value',  MThandles.p.body.inversion);
    set(handles.invert_tail_checkbox,               'Value',  MThandles.p.tail.inversion);
    set(handles.invert_foot_checkbox,               'Value',  MThandles.p.foot.inversion);
    set(handles.body_color_popupmenu,               'Value',  findstr('RGB', MThandles.p.body.color));
    set(handles.tail_color_popupmenu,               'Value',  findstr('RGB', MThandles.p.tail.color));
    set(handles.foot_color_popupmenu,               'Value',  findstr('RGB', MThandles.p.foot.color));
    set(handles.BG_frame_num_edit,                  'String', num2str(MThandles.p.BGlength));
    set(handles.top_boundary_edit,                  'String', num2str(MThandles.p.cut.up));
    set(handles.bottom_boundary_edit,               'String', num2str(MThandles.p.cut.down));
    set(handles.left_boundary_edit,                 'String', num2str(MThandles.p.cut.left));
    set(handles.right_boundary_edit,                'String', num2str(MThandles.p.cut.right));
    set(handles.nose_plot_checkbox,                 'Value',  MThandles.p.PlotNose);
    set(handles.head_center_plot_checkbox,          'Value',  MThandles.p.PlotHeadCenter);      
    set(handles.head_contour_plot_checkbox,         'Value',  MThandles.p.PlotHeadContour);      
    set(handles.body_center_plot_checkbox,          'Value',  MThandles.p.PlotBodyCenter);      
    set(handles.body_back_plot_checkbox,            'Value',  MThandles.p.PlotBodyBackCenter);      
    set(handles.tail1_plot_checkbox,                'Value',  MThandles.p.PlotTail1Center);      
    set(handles.tail2_plot_checkbox,                'Value',  MThandles.p.PlotTail2Center);     
    set(handles.tail3_plot_checkbox,                'Value',  MThandles.p.PlotTail3Center);      
    set(handles.tail_contour_plot_checkbox,         'Value',  MThandles.p.PlotTailContour);
    set(handles.feet_plot_checkbox,                 'Value',  MThandles.p.PlotFeet);          
    set(handles.contourlinewidth_edit,              'String', num2str(MThandles.p.ContourLineWidth));
    set(handles.foot_marker_size_edit,              'String', num2str(MThandles.p.FootMarkerSize));
    set(handles.foot_font_size_edit,                'String', num2str(MThandles.p.FootFontSize));
    set(handles.direction_bar_length_edit,          'String', num2str(MThandles.p.DirectionBarLength));
    set(handles.direction_bar_width_edit,           'String', num2str(MThandles.p.DirectionBarWidth));
    set(handles.centroid_size_edit,                 'String', num2str(MThandles.p.CentroidMarkerSize));
    set(handles.body_brightness_edit,               'String', num2str(round(100*MThandles.p.bodybrightness)/100));
    set(handles.tail_brightness_edit,               'String', num2str(round(100*MThandles.p.tailbrightness)/100));
    set(handles.foot_brightness_edit,               'String', num2str(round(100*MThandles.p.footbrightness)/100));    
    set(handles.auto_plot_checkbox,                 'Value',  MThandles.p.drawwhileauto);          
    set(handles.body_min_edit,                      'String', num2str(MThandles.p.body.threshold.low));
    set(handles.body_max_edit,                      'String', num2str(MThandles.p.body.threshold.high));
    set(handles.tail_min_edit,                      'String', num2str(MThandles.p.tail.threshold.low));
    set(handles.tail_max_edit,                      'String', num2str(MThandles.p.tail.threshold.high));
    set(handles.foot_min_edit,                      'String', num2str(MThandles.p.foot.threshold.low));
    set(handles.foot_max_edit,                      'String', num2str(MThandles.p.foot.threshold.high));
    set(handles.min_body_size_edit,                 'String', num2str(MThandles.p.MinBodySize));
    set(handles.min_tail_size_edit,                 'String', num2str(MThandles.p.MinTailSize));
    set(handles.min_foot_size_edit,                 'String', num2str(MThandles.p.MinFootSize));
    set(handles.min_finger_size_edit,               'String', num2str(MThandles.p.MinFingerSize));
    set(handles.max_finger_size_edit,               'String', num2str(MThandles.p.MaxFingerSize));
    set(handles.max_finger_distance_edit,           'String', num2str(MThandles.p.MaxFingerDistance));
    set(handles.max_tail_thickness_edit,            'String', num2str(MThandles.p.MouseTailMaxThickness));
    set(handles.head_side_length_edit,              'String', num2str(MThandles.p.HeadSideLength));
    set(handles.max_body_step_edit,                 'String', num2str(MThandles.p.maxBodyStep));
    set(handles.max_foot_step_edit,                 'String', num2str(MThandles.p.maxFootStep));
    set(handles.fps_edit,                           'String', num2str(MThandles.p.fps));
    set(handles.pixpercm_edit,                      'String', num2str(MThandles.p.mm2pix*10));
    set(handles.input_folder_default_edit,          'String', num2str(MThandles.p.inputFolderName));
    set(handles.output_folder_default_edit,         'String', num2str(MThandles.p.outputFolderName));
    set(handles.R_filter_edit,                      'String', num2str(MThandles.p.BGoffset.R));
    set(handles.G_filter_edit,                      'String', num2str(MThandles.p.BGoffset.G));
    set(handles.B_filter_edit,                      'String', num2str(MThandles.p.BGoffset.B));
    set(handles.fixed_body_length_edit,             'String', num2str(MThandles.p.FixedBodyLength));
   
  %========================================================================

    
  % Choose default command line output for SetupTracking
    handles.output = hObject;

  % Update handles structure
    guidata(hObject, handles);

  % UIWAIT makes SetupTracking wait for user response (see UIRESUME)
  % uiwait(handles.figure1);
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT STYLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function image_style_popupmenu_Callback(hObject, eventdata, handles)
  % change p.WhatToPlot
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.WhatToPlot = get(handles.image_style_popupmenu,'Value');
    % save data
      setappdata(0,'handles',MThandles);
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes when image_panel is resized.
function image_panel_ResizeFcn(hObject, eventdata, handles)

  % get handles from MouseTracker
    MThandles = getappdata(0,'handles');

  % Figure Units are fixed as 'pixels';
    Figure_Size = get(handles.figure1,'Position');

  % set size of imagebox_uipanel such that it is always proportional to picture size
  if isfield(MThandles,'v')
      if isfield(MThandles.v,'pic')
          % get picture size
            PicSize = size(MThandles.v.pic.R);
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
            image_height = window_height * 0.57;
            image_width  = image_height * Pic_x / Pic_y;
          % make sure image doesn't extend beyond window
            if image_width > window_width - 2 * image_x
                image_width  = window_width - 2 * image_x;
                image_height = image_width * Pic_y / Pic_x;
            end;

          % shift bottom of imagebox such that it touches the buttons
            image_y = window_height * 0.57 - image_height;

          % update sizes
            set(handles.image_axes,'Position',[image_x image_y image_width image_height]);

          % switch back to normalized more
            set(handles.image_axes,'Units','Normalized');    

      end;
  end;  
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INVERSIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function invert_image_checkbox_Callback(hObject, eventdata, handles)
  % change image inversion accordingly
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.invert = get(handles.invert_image_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
    
function invert_body_checkbox_Callback(hObject, eventdata, handles)
  % change body inversion accordingly
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.body.inversion = get(handles.invert_body_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);

function invert_tail_checkbox_Callback(hObject, eventdata, handles)
  % change tail inversion accordingly
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.tail.inversion = get(handles.invert_tail_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      

function invert_foot_checkbox_Callback(hObject, eventdata, handles)
  % change foot inversion accordingly
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.foot.inversion = get(handles.invert_foot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);  
%==========================================================================  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LENGTH BAR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lengthbar_checkbox_Callback(hObject, eventdata, handles)
  % show/not show length bar
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve length bar setting
      MThandles.p.lengthbar = get(handles.lengthbar_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COLORS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function body_color_popupmenu_Callback(hObject, eventdata, handles)
  % change p.body.color
      % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      Color = get(handles.body_color_popupmenu,'Value');
      if     Color == 1, MThandles.p.body.color = 'R';
      elseif Color == 2, MThandles.p.body.color = 'G';
      elseif Color == 3, MThandles.p.body.color = 'B'; end;
    % save data
      setappdata(0,'handles',MThandles);
          
function tail_color_popupmenu_Callback(hObject, eventdata, handles)
% change p.tail.color
      % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      Color = get(handles.tail_color_popupmenu,'Value');
      if     Color == 1, MThandles.p.tail.color = 'R';
      elseif Color == 2, MThandles.p.tail.color = 'G';
      elseif Color == 3, MThandles.p.tail.color = 'B'; end;
    % save data
      setappdata(0,'handles',MThandles);
  
function foot_color_popupmenu_Callback(hObject, eventdata, handles)
  % change p.foot.color
      % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      Color = get(handles.foot_color_popupmenu,'Value');
      if     Color == 1, MThandles.p.foot.color = 'R';
      elseif Color == 2, MThandles.p.foot.color = 'G';
      elseif Color == 3, MThandles.p.foot.color = 'B'; end;
    % save data
      setappdata(0,'handles',MThandles);
%==========================================================================  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function save_pushbutton_Callback(hObject, eventdata, handles)
  % save settings
    % retrieve information from edits
      Retrieve_Callback(hObject, eventdata, handles);        
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % save data
      setappdata(0,'handlesp',MThandles.p);
    % exit
      delete(gcf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAVE AS DEFAULT SETTINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function default_pushbutton_Callback(hObject, eventdata, handles)
  % save data in default parameter file
    % retrieve information from edits
      Retrieve_Callback(hObject, eventdata, handles);      
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles');    
    % save data
      p = MThandles.p;
      save('./Software/ParametersDefault.mat','p');
      disp('Saved parameters as default in ./Software/ParametersDefault.mat');
  % save data for current setup as well and quit.
    save_pushbutton_Callback(hObject, eventdata, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CANCEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cancel_pushbutton_Callback(hObject, eventdata, handles)
  % cancel editing settings
    % exit
      delete(gcf);
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREVIEW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function preview_pushbutton_Callback(hObject, eventdata, handles)
  % plot preview image with current parameters
    % retrieve information from edits
      Retrieve_Callback(hObject, eventdata, handles);      
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles');  
    % recalculate mask as it may have changed
      if MThandles.p.BGlength ~= MThandles.p.currentBGframenum & isfield(MThandles,'v')
        % calculate background for filter
          [MThandles.p.DPM, MThandles.p.picMedian] = Masks(MThandles.p); 
      end;      
    % if hide is pressed don't show tracks
      if get(handles.hide_plot_togglebutton,'Value')
        MThandles.p.PlotNose            = 0;
        MThandles.p.PlotHeadCenter      = 0;   
        MThandles.p.PlotHeadContour     = 0;    
        MThandles.p.PlotBodyCenter      = 0;     
        MThandles.p.PlotBodyBackCenter  = 0; 
        MThandles.p.PlotTail1Center     = 0;     
        MThandles.p.PlotTail2Center     = 0;     
        MThandles.p.PlotTail3Center     = 0;      
        MThandles.p.PlotTailContour     = 0;
        MThandles.p.PlotFeet            = 0;
      end;
    % plot results
      if isfield(MThandles,'v')    
        WhattoPlot = MThandles.p.WhatToPlot
        MThandles = PlotMouse(MThandles);
        % resize image_axes to preserve ratio of image
          image_panel_ResizeFcn(hObject, eventdata, handles);    
      end;
  
%==========================================================================  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETRIEVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Retrieve_Callback(hObject, eventdata, handles)
% retrieve additional parameters from edits that are not read in
% automatically
  % get handles from MouseTracker
    MThandles = getappdata(0,'handles');   
  % temporalily store old variables
    p = MThandles.p;
  % retrieve parameters
    MThandles.p.BGlength              = str2num(get(handles.BG_frame_num_edit,'String'));
    MThandles.p.cut.up                = str2num(get(handles.top_boundary_edit,'String'));
    MThandles.p.cut.down              = str2num(get(handles.bottom_boundary_edit,'String'));
    MThandles.p.cut.left              = str2num(get(handles.left_boundary_edit,'String'));
    MThandles.p.cut.right             = str2num(get(handles.right_boundary_edit,'String'));
    MThandles.p.ContourLineWidth      = str2num(get(handles.contourlinewidth_edit,'String'));
    MThandles.p.FootMarkerSize        = str2num(get(handles.foot_marker_size_edit,'String'));
    MThandles.p.FootFontSize          = str2num(get(handles.foot_font_size_edit,'String'));
    MThandles.p.DirectionBarLength    = str2num(get(handles.direction_bar_length_edit,'String'));
    MThandles.p.DirectionBarWidth     = str2num(get(handles.direction_bar_width_edit,'String'));
    MThandles.p.CentroidMarkerSize    = str2num(get(handles.centroid_size_edit,'String'));
    MThandles.p.bodybrightness        = str2num(get(handles.body_brightness_edit,'String'));
    MThandles.p.footbrightness        = str2num(get(handles.foot_brightness_edit,'String'));
    MThandles.p.body.threshold.low    = str2num(get(handles.body_min_edit,'String'));
    MThandles.p.body.threshold.high   = str2num(get(handles.body_max_edit,'String'));
    MThandles.p.tail.threshold.low    = str2num(get(handles.tail_min_edit,'String'));
    MThandles.p.tail.threshold.high   = str2num(get(handles.tail_max_edit,'String'));
    MThandles.p.foot.threshold.low    = str2num(get(handles.foot_min_edit,'String'));
    MThandles.p.foot.threshold.high   = str2num(get(handles.foot_max_edit,'String'));
    MThandles.p.MinBodySize           = str2num(get(handles.min_body_size_edit,'String'));
    MThandles.p.MinTailSize           = str2num(get(handles.min_tail_size_edit,'String'));
    MThandles.p.MinFootSize           = str2num(get(handles.min_foot_size_edit,'String'));
    MThandles.p.MinFingerSize         = str2num(get(handles.min_finger_size_edit,'String'));
    MThandles.p.MaxFingerSize         = str2num(get(handles.max_finger_size_edit,'String'));
    MThandles.p.MaxFingerDistance     = str2num(get(handles.max_finger_distance_edit,'String'));
    MThandles.p.MouseTailMaxThickness = str2num(get(handles.max_tail_thickness_edit,'String'));
    MThandles.p.HeadSideLength        = str2num(get(handles.head_side_length_edit,'String'));
    MThandles.p.maxBodyStep           = str2num(get(handles.max_body_step_edit,'String'));
    MThandles.p.maxFootStep           = str2num(get(handles.max_foot_step_edit,'String'));
    MThandles.p.fps                   = str2num(get(handles.fps_edit,'String'));
    MThandles.p.mm2pix                = str2num(get(handles.pixpercm_edit,'String'))/10;
    MThandles.p.inputFolderName       = get(handles.input_folder_default_edit,'String');
    MThandles.p.outputFolderName      = get(handles.output_folder_default_edit,'String');
    MThandles.p.BGoffset.R            = str2num(get(handles.R_filter_edit,'String'));
    MThandles.p.BGoffset.G            = str2num(get(handles.G_filter_edit,'String'));
    MThandles.p.BGoffset.B            = str2num(get(handles.B_filter_edit,'String'));
    MThandles.p.WhatToPlot            = get(handles.image_style_popupmenu,'Value');
    
  % if any of the boundaries changed, recalculate filter
    if (MThandles.p.cut.up ~= p.cut.up | MThandles.p.cut.down ~= p.cut.down | MThandles.p.cut.left ~= p.cut.left | MThandles.p.cut.right ~= p.cut.right) & isfield(MThandles,'v')
      % calculate background for filter
        [MThandles.p.DPM, MThandles.p.picMedian] = Masks(MThandles.p); 
    end;
  % save data
    setappdata(0,'handles',MThandles);      
    
%==========================================================================  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRACK PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nose_plot_checkbox_Callback(hObject, eventdata, handles)
  % nose on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotNose = get(handles.nose_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function head_center_plot_checkbox_Callback(hObject, eventdata, handles)
  % head center on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotHeadCenter = get(handles.head_center_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function head_contour_plot_checkbox_Callback(hObject, eventdata, handles)
  % head contour on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotHeadContour = get(handles.head_contour_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function body_center_plot_checkbox_Callback(hObject, eventdata, handles)
  % body center on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotBodyCenter = get(handles.body_center_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function body_back_plot_checkbox_Callback(hObject, eventdata, handles)
  % body back on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotBodyBackCenter = get(handles.body_back_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);

function tail1_plot_checkbox_Callback(hObject, eventdata, handles)
  % tail1 on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotTail1Center = get(handles.tail1_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function tail2_plot_checkbox_Callback(hObject, eventdata, handles)
  % tail2 on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotTail2Center = get(handles.tail2_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function tail3_plot_checkbox_Callback(hObject, eventdata, handles)
  % tail3 on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotTail3Center = get(handles.tail3_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function tail_contour_plot_checkbox_Callback(hObject, eventdata, handles)
  % tail contour on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotTailContour = get(handles.tail_contour_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function feet_plot_checkbox_Callback(hObject, eventdata, handles)
  % feet on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.PlotFeet = get(handles.feet_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);
      
function auto_plot_checkbox_Callback(hObject, eventdata, handles)
  % plot while auto on/off
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.drawwhileauto = get(handles.auto_plot_checkbox,'Value');
    % save data
      setappdata(0,'handles',MThandles);      
      
%==========================================================================  



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SELECT DEFAULT DIRECTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function input_default_browse_pushbutton_Callback(hObject, eventdata, handles)
  % get handles from MouseTracker
    MThandles = getappdata(0,'handles'); 
  % start browsing from current folder in InputDirectory_edit
    old_folder_name = get(handles.input_folder_default_edit,'String')
  % if old_folder_name doesn't exist make it to the matlab directory
    start_path = old_folder_name;
    if exist(old_folder_name) ~= 7
        if exist(MThandles.p.inputFolderName) == 7
            start_path = MThandles.p.inputFolderName;
        else
            start_path = pwd;
        end
    end;
    folder_name = uigetdir(start_path,'Select input directory path')
    if folder_name == 0
        folder_name = old_folder_name;
    end
    set(handles.input_folder_default_edit,'String',folder_name);


function output_default_browse_pushbutton_Callback(hObject, eventdata, handles)
  % get handles from MouseTracker
    MThandles = getappdata(0,'handles'); 
  % start browsing from current folder in InputDirectory_edit
    old_folder_name = get(handles.output_folder_default_edit,'String');
  % if start_path doesn't exist make it to the matlab directory
    results_folder = old_folder_name;  
    if exist(old_folder_name) ~= 7
        if exist(MThandles.p.outputFolderName) == 7
            results_folder = MThandles.p.outputFolderName;
        else
            results_folder = '<default>';
        end
    end;
    track_folder_name = uigetdir(results_folder,'Select input directory path');
    if track_folder_name == 0
        track_folder_name = old_folder_name;
    end
    set(handles.output_folder_default_edit,'String',track_folder_name);
    
%========================================================================== 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FORCE BODY DIRECTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function force_direction_popupmenu_Callback(hObject, eventdata, handles)
  % change p.ForceDirection
    % get handles from MouseTracker
      MThandles = getappdata(0,'handles'); 
    % retrieve image style
      MThandles.p.ForceDirection = get(handles.force_direction_popupmenu,'Value');
    % save data
      setappdata(0,'handles',MThandles);
%========================================================================== 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHERS WITH NO DIRECT ACTIVE FUNCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = SetupTracking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function image_style_popupmenu_CreateFcn(hObject, eventdata, handles)      
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function body_color_popupmenu_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  
function tail_color_popupmenu_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  

function foot_color_popupmenu_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function BG_frame_num_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function BG_frame_num_edit_Callback(hObject, eventdata, handles)

function top_boundary_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function bottom_boundary_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function left_boundary_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function right_boundary_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function top_boundary_edit_Callback(hObject, eventdata, handles)

function bottom_boundary_edit_Callback(hObject, eventdata, handles)

function left_boundary_edit_Callback(hObject, eventdata, handles)

function right_boundary_edit_Callback(hObject, eventdata, handles)

function hide_plot_togglebutton_Callback(hObject, eventdata, handles)

function contourlinewidth_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function foot_marker_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function foot_font_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function direction_bar_length_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function centroid_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function body_brightness_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  
function tail_brightness_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function foot_brightness_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function direction_bar_width_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
      
function contourlinewidth_edit_Callback(hObject, eventdata, handles)

function foot_marker_size_edit_Callback(hObject, eventdata, handles)

function foot_font_size_edit_Callback(hObject, eventdata, handles)

function direction_bar_length_edit_Callback(hObject, eventdata, handles)

function direction_bar_width_edit_Callback(hObject, eventdata, handles)

function centroid_size_edit_Callback(hObject, eventdata, handles)

function body_brightness_edit_Callback(hObject, eventdata, handles)

function tail_brightness_edit_Callback(hObject, eventdata, handles)

function foot_brightness_edit_Callback(hObject, eventdata, handles)    

function body_min_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  
function tail_min_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function body_max_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  
function tail_max_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function foot_min_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function foot_max_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function min_body_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end


function min_tail_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end


function min_foot_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function min_finger_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function max_finger_size_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function max_finger_distance_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function max_tail_thickness_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function head_side_length_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function max_body_step_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function max_foot_step_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function body_min_edit_Callback(hObject, eventdata, handles)

function body_max_edit_Callback(hObject, eventdata, handles)

function tail_min_edit_Callback(hObject, eventdata, handles)

function tail_max_edit_Callback(hObject, eventdata, handles)

function foot_min_edit_Callback(hObject, eventdata, handles)

function foot_max_edit_Callback(hObject, eventdata, handles)

function min_body_size_edit_Callback(hObject, eventdata, handles)

function min_tail_size_edit_Callback(hObject, eventdata, handles)
  
function min_foot_size_edit_Callback(hObject, eventdata, handles)

function min_finger_size_edit_Callback(hObject, eventdata, handles)

function max_finger_size_edit_Callback(hObject, eventdata, handles)

function max_finger_distance_edit_Callback(hObject, eventdata, handles)

function max_tail_thickness_edit_Callback(hObject, eventdata, handles)

function head_side_length_edit_Callback(hObject, eventdata, handles)

function max_body_step_edit_Callback(hObject, eventdata, handles)

function max_foot_step_edit_Callback(hObject, eventdata, handles)

function pixpercm_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function fps_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function fps_edit_Callback(hObject, eventdata, handles)

function pixpercm_edit_Callback(hObject, eventdata, handles)

function input_folder_default_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function output_folder_default_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function input_folder_default_edit_Callback(hObject, eventdata, handles)

function output_folder_default_edit_Callback(hObject, eventdata, handles)

function force_direction_popupmenu_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function R_filter_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function G_filter_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end
  
function B_filter_edit_CreateFcn(hObject, eventdata, handles)
  if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
      set(hObject,'BackgroundColor','white');
  end

function fixed_body_length_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end  
  
function R_filter_edit_Callback(hObject, eventdata, handles)

function G_filter_edit_Callback(hObject, eventdata, handles)

function B_filter_edit_Callback(hObject, eventdata, handles)

function fixed_body_length_edit_Callback(hObject, eventdata, handles)

  
%==========================================================================
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%==========================================================================
