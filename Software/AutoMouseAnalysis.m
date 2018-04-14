function handles = AutoMouseAnalysis(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = AutoMouseAnalysis(handles)
%
% automatically analyze mouse data. Called from MouseTracker.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if no data was loaded then quit
  if ~isfield(handles,'v'), return; end;

% initialize
  v = handles.v;
  p = handles.p;
  ButtonStatus = get(handles.auto_togglebutton,'Value');


% loop over frames, starting at current frame. Continue until files' end or until auto button is pressed again 
  i = handles.FrameNumber;
  while i <= length(p.FileList) & ButtonStatus == 1

  % Change frame number in window
    set(handles.frame_edit,'String',num2str(i));
    drawnow;
    
    % frameindex - index of file in the framelist
      p.FrameIndex = i;
    % increment time
      v.time = p.FrameIndex * 1/p.fps;
    % read in mouse pic
      v.pic = PictureReader(p.FrameIndex, p);

    % subtract background
      v = FilterImage(v,p);

    % Find feet  
      [v] = FindMouseFeet(v,p);

    % Find body
      [v] = FindMouseBody(v,p);

    % Connect body with feet
      [v] = TrackMice(v,p); 

    % draw current picture
      if p.drawwhileauto == 1
          handles.v = v;
          handles.p = p;
        handles = PlotMouse(handles);
      end;

    % get button status
      ButtonStatus = get(handles.auto_togglebutton,'Value');
    % increase i
      i = i + 1;

  end;


return;
