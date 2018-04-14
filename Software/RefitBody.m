function handles = RefitBody(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = RefitBody(handles)
%
% Refit body parameters based on nose and tail:
%
% - head center
% - body center
% - body back
% - tail 1,2,3 points
%
% (c) Imre Bartos 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize
  % if no data was loaded then quit
    if ~isfield(handles,'v')
      set(handles.tailend_togglebutton,'Value',0); 
      set(handles.tail3_togglebutton,'Value',0);
      set(handles.tail2_togglebutton,'Value',0);
      set(handles.tail1_togglebutton,'Value',0);
      set(handles.bodyback_togglebutton,'Value',0);
      set(handles.bodycenter_togglebutton,'Value',0);
      set(handles.headcenter_togglebutton,'Value',0);
      set(handles.nose_togglebutton,'Value',0);
      return; 
    end;

  % if p.WhatToPlot is 1 or 9 then the image has not been filtered yet, lets do it now
    if ~isfield(handles.v.pic,'foot')
      handles.v = FilterImage(handles.v,handles.p);  
    end;
    
  % make parameters local
    p = handles.p;
    v = handles.v;
  % read FrameNumber
    FrameNumber  = str2num(get(handles.frame_edit,'String'));
  % get mouse # pointer from popup menu
    MouseIndex = get(handles.mousenumber_popupmenu, 'Value');
  % find trac index that corresponds to FrameNumber
    N = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameNumber);  
    if isempty(N)
      disp('there is no mouse here with the defined number...');
      return;
    end;
  % convert variables to format that's readable by autotrack commands
    Boundary{1}(:,1) = cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N));
    Boundary{1}(:,2) = cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N));
    indtail{1} = v.MouseTrack.indtail{MouseIndex}(N); 
    indnose{1} = v.MouseTrack.indNose{MouseIndex}(N);
    
  % find boundary of each body
    [TempBoundary, TempCC, NumberOfObjects, Tempbody_cleaned] = FindBodyBoundary(v.pic.body, p);
  % find the body that is the current mouse's body
    CurrentMouseIndex = 0;
    for i = 1:NumberOfObjects
      % find if there is any overlap
        ind = find(Boundary{1}(indtail{1},1) == TempBoundary{i}(:,1) & Boundary{1}(indtail{1},2) == TempBoundary{i}(:,2));
        if ~isempty(ind), CurrentMouseIndex = i; end;
    end;
    CC.PixelIdxList{1} = TempCC.PixelIdxList{CurrentMouseIndex};

% use nose and tail points to refine rest of body
  % find crosslines of body -- the lines connecting the closest points on the two sides
    [indOpposite] = FindBodyOppositeSide(1, Boundary, indnose, indtail, p);
  % find tail - find points that are on the sides of the tail  
    [indTail] = FindTail(1, Boundary, indOpposite, indnose, indtail, p);
  % tail properties - determine properties of tail
    [Tail1Centroid, Tail1Orientation, Tail1MajorAxisLength, Tail2Centroid, Tail2Orientation, Tail2MajorAxisLength, Tail3Centroid, Tail3Orientation, Tail3MajorAxisLength] ...
      = TailProperties(1, indTail, indtail, Boundary, indOpposite);
  % reassign variables
    v.MouseTrack.TailContourX{MouseIndex}(N) = {Boundary{1}(indTail{1},1)};
    v.MouseTrack.TailContourY{MouseIndex}(N) = {Boundary{1}(indTail{1},2)};
  % body properties - determine properties of the body
    [BodyCentroid, BodyOrientation, BodyBackCentroid, BodyBackOrientation, HeadSide, HeadCentroid, HeadOrientation, HeadMajorAxisLength] ...
      = BodyProperties(1, v.pic.body, CC, indTail, indnose, Boundary, p);
  % convert output to savable format
  v.MouseTrack.BodyCentroid{MouseIndex}(N,:)      = BodyCentroid{1}(:);
  v.MouseTrack.BodyOrientation{MouseIndex}(N)     = BodyOrientation{1};
  v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:)  = BodyBackCentroid{1}(:);
  v.MouseTrack.BodyBackOrientation{MouseIndex}(N) = BodyBackOrientation{1};
  v.MouseTrack.Tail1Centroid{MouseIndex}(N,:)     = Tail1Centroid{1}(:);
  v.MouseTrack.Tail1Orientation{MouseIndex}(N)    = Tail1Orientation{1};
  v.MouseTrack.Tail2Centroid{MouseIndex}(N,:)     = Tail2Centroid{1}(:);
  v.MouseTrack.Tail2Orientation{MouseIndex}(N)    = Tail2Orientation{1};
  v.MouseTrack.Tail3Centroid{MouseIndex}(N,:)     = Tail3Centroid{1}(:);
  v.MouseTrack.Tail3Orientation{MouseIndex}(N)    = Tail3Orientation{1};

% save results and plot    
  handles.v = v;
  handles.p = p;
  handles = PlotMouse(handles);


return;