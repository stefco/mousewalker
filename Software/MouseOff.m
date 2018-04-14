function handles = MouseOff(handles, Where)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = MouseOff(handles Where)
%
% (c) Imre Bartos, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% turn off body and legs at specified frames

  % if mouse is not loaded yet quit
    if ~isfield(handles,'v'), return; end;

% make parameters local
  p = handles.p;
  v = handles.v;
% read FrameNumber
  FrameNumber  = str2num(get(handles.frame_edit,'String'));
% get mouse # pointer from popup menu
  MouseIndex = get(handles.mousenumber_popupmenu, 'Value');
% find track index that corresponds to FrameNumber
  N = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameNumber)
  if isempty(N)
    disp('there is no mouse here with the defined number...');
    % make it the smallest or greatest value available, to ensure proper function
      MIN = min(v.MouseTrack.TrackIndex{MouseIndex});
      MAX = max(v.MouseTrack.TrackIndex{MouseIndex});
      if ~isempty(MIN) & ~isempty(MAX)
        if FrameNumber < MIN
          N = MIN;
        end;
        if FrameNumber > MAX
          N = MAX;
        end;        
      else
        N = -1;
      end;
  end;
    
    % select which indices to cut
    if strcmp(Where,'current')
      Indices = N;
    elseif strcmp(Where,'before')
      Indices = 1:N;
    elseif strcmp(Where,'after')
      Indices = N:MAX;
    else
      return;
    end;
    

% cut body and legs at Indices
  v.MouseTrack.TrackTime{MouseIndex}(Indices)           = -1;
  v.MouseTrack.TrackIndex{MouseIndex}(Indices)          = -1;
  v.MouseTrack.Nose{MouseIndex}(Indices,:)              = -1;
  v.MouseTrack.HeadContourX{MouseIndex}(Indices)        = {-1};
  v.MouseTrack.HeadContourY{MouseIndex}(Indices)        = {-1};
  v.MouseTrack.HeadCentroid{MouseIndex}(Indices,:)      = -1;
  v.MouseTrack.HeadOrientation{MouseIndex}(Indices)     = -1;
  v.MouseTrack.BodyCentroid{MouseIndex}(Indices,:)      = -1;
  v.MouseTrack.BodyOrientation{MouseIndex}(Indices)     = -1;
  v.MouseTrack.BodyBackCentroid{MouseIndex}(Indices,:)  = -1;
  v.MouseTrack.BodyBackOrientation{MouseIndex}(Indices) = -1;
  v.MouseTrack.TailContourX{MouseIndex}(Indices)        = {-1};
  v.MouseTrack.TailContourY{MouseIndex}(Indices)        = {-1};    
  v.MouseTrack.Tail1Centroid{MouseIndex}(Indices,1:2)   = -1;
  v.MouseTrack.Tail1Orientation{MouseIndex}(Indices)    = -1;
  v.MouseTrack.Tail2Centroid{MouseIndex}(Indices,1:2)   = -1;
  v.MouseTrack.Tail2Orientation{MouseIndex}(Indices)    = -1;
  v.MouseTrack.Tail3Centroid{MouseIndex}(Indices,1:2)   = -1;
  v.MouseTrack.Tail3Orientation{MouseIndex}(Indices)    = -1;
  v.MouseTrack.Tail{MouseIndex}(Indices,:)              = -1;
    
% save variables
  handles.v = v;
  
% draw new direction
  handles = PlotMouse(handles);
    
return;