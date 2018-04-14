function handles = PlotMouse(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = PlotMouse(handles)
%
% Plot mouse and the recovered parameters, as specified by settings.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set color of body lines if body is bright and if we are plotting original image
  if handles.p.body.threshold.low > 200 & handles.p.WhatToPlot == 1
    ColorBodyDirections = [0 0 0];
  else
    ColorBodyDirections = [0.999 0.999 0.999];
  end;
  
% if no data was loaded then quit
  if ~isfield(handles.p,'FileList'), return; end;

% exit if input folder doesn't exist
  if exist(handles.p.inputFolderName) ~= 7, return; end;

% get current frame number
  FrameIndex  = str2num(get(handles.frame_edit,'String'));

% set up slider to the right scale   
  set(handles.frame_slider,'Value', FrameIndex);
      
% if FrameIndex greater than number of frames, decrease frame number
  S = size(handles.p.FileList);
  if FrameIndex > S(1)
      FrameIndex = S(1);
      set(handles.frame_edit,'String',num2str(FrameIndex));
  end;

% % select file of current frame
%   FileName = handles.p.FileList(FrameIndex,:);

% allow parameters and variables to be used locally (for convenience)
  p = handles.p;
  if isfield(handles,'v')
    v = handles.v;  
  end;
  
% find mouse if there is already one
  if isfield(handles,'v') & v.MouseTrack.NumberOfMice > 0
    % set up togglebuttons for body and feet
      % get mouse # pointer from popup menu
        MouseIndex = get(handles.mousenumber_popupmenu,'Value');
      % find mouse track index that corresponds to current frame
        N = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameIndex);  
      if (v.MouseTrack.BodyCentroid{MouseIndex}(N,1)) ~= -1
          % LF
            if v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) ~= -1
              set(handles.LF_togglebutton,'Value',1);
            else
              set(handles.LF_togglebutton,'Value',0);
            end
          % RF
            if v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) ~= -1
              set(handles.RF_togglebutton,'Value',1);
            else
              set(handles.RF_togglebutton,'Value',0);
            end
          % LH
            if v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) ~= -1
              set(handles.LH_togglebutton,'Value',1);
            else
              set(handles.LH_togglebutton,'Value',0);
            end
          % RH
            if v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) ~= -1
              set(handles.RH_togglebutton,'Value',1);
            else
              set(handles.RH_togglebutton,'Value',0);
            end
      else
        set(handles.LF_togglebutton,'Value',0);
        set(handles.LH_togglebutton,'Value',0);
        set(handles.RF_togglebutton,'Value',0);
        set(handles.RH_togglebutton,'Value',0);     
      end;
  end;

% figure out whether PlotMouse was called by AutoMouseAnalysis
  AutoOn = get(handles.auto_togglebutton,'Value');

% we only need to read in image if it was not just done by auto
  if AutoOn ~= 1
    % read in mouse pic
      v.pic = PictureReader(FrameIndex, p);

    % subtract background
      % this is not needed if we only plot the original image
        if p.WhatToPlot ~= 1 & p.WhatToPlot ~= 9
          v = FilterImage(v,p);  
        end;

    % save loaded data
      handles.v = v;  
  end;  

%% Decide what to plot: original/body_only/foot_only based on p.WhatToPlot
% 1:'original', 2:'fixed scale', 3:'body + feet + tail', 4:'floating
% scale', 5:'body + tail', 6:'body only', 7:'feet only', 8:'tail only',
% 9:'all - no filter'

hold off;
 if p.WhatToPlot == 1
   % original
     % if no cut has been made we can just plot the original image to save time
       if p.cut.up ~= 0 | p.cut.down ~= 0 | p.cut.left ~= 0 | p.cut.right ~= 0
         PicRGB(:,:,1) = v.pic.R;
         PicRGB(:,:,2) = v.pic.G;
         PicRGB(:,:,3) = v.pic.B;
         image(PicRGB/256);
       else
         imshow(v.pic.rawpic);
       end;
   % assign current plot
 elseif p.WhatToPlot == 2
   % fixed scale
     PicRGB(:,:,1) = v.pic.filtered.R;
     PicRGB(:,:,2) = v.pic.filtered.G;
     PicRGB(:,:,3) = v.pic.filtered.B;
     image(PicRGB/256);
 elseif p.WhatToPlot == 3
   % body + feet + tail
     % clear pics of dirt
       CleanBodyPIC = v.pic.body;
       CleanTailPIC = v.pic.tail;
       CleanFootPIC = v.pic.foot;
     % make sure body trumps tail
       CleanTailPIC(CleanBodyPIC > 0) = 0;
     % combined pic - 0-125: body+tail; 126-255: feet
       v.pic.combined = min(125,max(CleanBodyPIC*p.bodybrightness,CleanTailPIC*p.tailbrightness));
       % add feet when they are not zero
         ind = find(CleanFootPIC ~= 0);
         maxfoot = max(CleanFootPIC(:));
         v.pic.combined(ind) = CleanFootPIC(ind)*p.footbrightness+127;
     imagesc(v.pic.combined, [0 255]);
%      image(v.pic.combined);
     colormap(p.color);      
 elseif p.WhatToPlot == 4
   % floating scale
     imagesc(v.pic.original);
     colormap(p.color);  
 elseif p.WhatToPlot == 5
   % body + tail
     % clear pics of dirt
       CleanBodyPIC = CleanPIC(v.pic.body, p.MinBodySize);
       CleanTailPIC = CleanPIC(v.pic.tail, p.MinTailSize);
     % make sure body trumps tail
       CleanTailPIC(CleanBodyPIC > 0) = 0;       
     imagesc(max(CleanBodyPIC*p.bodybrightness,CleanTailPIC*p.tailbrightness), [0 255]);
     colormap(p.color);
 elseif p.WhatToPlot == 6
   % body only
     % clear pics of dirt
       CleanBodyPIC = CleanPIC(v.pic.body, p.MinBodySize);
     imagesc(CleanBodyPIC*p.bodybrightness, [0 255]);
     colormap(p.color);
 elseif p.WhatToPlot == 7
   % feet only
     % clear pics of dirt
      CleanFootPIC = CleanPIC(v.pic.foot, p.MinFootSize);
     imagesc(CleanFootPIC*p.footbrightness, [0 255]);
     colormap(p.color);
 elseif p.WhatToPlot == 8
   % tail only
     % clear pics of dirt
       CleanBodyPIC = CleanPIC(v.pic.body, p.MinBodySize);
       CleanTailPIC = CleanPIC(v.pic.tail, p.MinTailSize);
     % make sure body trumps tail
       CleanTailPIC(CleanBodyPIC > 0) = 0;       
     imagesc(CleanTailPIC*p.tailbrightness, [0 255]);
     colormap(p.color);
 elseif p.WhatToPlot == 9
   % all - no filter
   % taken mostly from FilterImage but without finding the parts
     % make pixels that are within mask 0
      if p.invert == 0
        % find pixels that are within RED mask
          Rtemp = abs(v.pic.R - p.picMedian.R);
        % find pixels that are within GREEN mask
          Gtemp = abs(v.pic.G - p.picMedian.G);
        % find pixels that are within BLUE mask
          Btemp = abs(v.pic.B - p.picMedian.B);
      else
        % find pixels that are within RED mask
          Rtemp = abs(255 - v.pic.R - p.picMedian.R);
        % find pixels that are within GREEN mask
          Gtemp = abs(255 - v.pic.G - p.picMedian.G);
        % find pixels that are within BLUE mask
          Btemp = abs(255 - v.pic.B - p.picMedian.B);
      end;

      % make those pixels zero that are within the error bar of all three colors    
        FILTERind = find(Rtemp <= p.BGoffset.R & Gtemp <= p.BGoffset.G & Btemp <= p.BGoffset.B);

      % apply masks 
        v.pic.filtered.R = v.pic.R;
        v.pic.filtered.G = v.pic.G;
        v.pic.filtered.B = v.pic.B;
        v.pic.filtered.R(FILTERind) = 0;
        v.pic.filtered.G(FILTERind) = 0;
        v.pic.filtered.B(FILTERind) = 0;

      if (p.foot.inversion == 1 & strcmp(p.foot.color,'R')) | (p.body.inversion == 1 & strcmp(p.body.color,'R')) | (p.tail.inversion == 1 & strcmp(p.tail.color,'R'))
        v.pic.invfiltered.R = 255 - v.pic.R;
        v.pic.invfiltered.R(FILTERind) = 0;
      end;
      if (p.foot.inversion == 1 & strcmp(p.foot.color,'G')) | (p.body.inversion == 1 & strcmp(p.body.color,'G')) | (p.tail.inversion == 1 & strcmp(p.tail.color,'G'))
        v.pic.invfiltered.G = 255 - v.pic.G;
        v.pic.invfiltered.G(FILTERind) = 0;
      end;
      if (p.foot.inversion == 1 & strcmp(p.foot.color,'B')) | (p.body.inversion == 1 & strcmp(p.body.color,'B')) | (p.tail.inversion == 1 & strcmp(p.tail.color,'B'))
        v.pic.invfiltered.B = 255 - v.pic.B;
        v.pic.invfiltered.B(FILTERind) = 0;
      end;
    % identify picture in which the program should search for feet and body  
      if     strcmp(p.foot.color,'R') & p.foot.inversion == 0; v.pic.foot = v.pic.filtered.R - p.DPM.R;
      elseif strcmp(p.foot.color,'R') & p.foot.inversion == 1, v.pic.foot = v.pic.invfiltered.R - p.DPM.R; 
      elseif strcmp(p.foot.color,'G') & p.foot.inversion == 0, v.pic.foot = v.pic.filtered.G - p.DPM.G; 
      elseif strcmp(p.foot.color,'G') & p.foot.inversion == 1, v.pic.foot = v.pic.invfiltered.G - p.DPM.G; 
      elseif strcmp(p.foot.color,'B') & p.foot.inversion == 0, v.pic.foot = v.pic.filtered.B - p.DPM.B; 
      elseif strcmp(p.foot.color,'B') & p.foot.inversion == 1, v.pic.foot = v.pic.invfiltered.B - p.DPM.B; end;
      if     strcmp(p.body.color,'R') & p.body.inversion == 0, v.pic.body = v.pic.filtered.R - p.DPM.R; 
      elseif strcmp(p.body.color,'R') & p.body.inversion == 1, v.pic.body = v.pic.invfiltered.R - p.DPM.R; 
      elseif strcmp(p.body.color,'G') & p.body.inversion == 0, v.pic.body = v.pic.filtered.G - p.DPM.G; 
      elseif strcmp(p.body.color,'G') & p.body.inversion == 1, v.pic.body = v.pic.invfiltered.G - p.DPM.G; 
      elseif strcmp(p.body.color,'B') & p.body.inversion == 0, v.pic.body = v.pic.filtered.B - p.DPM.B; 
      elseif strcmp(p.body.color,'B') & p.body.inversion == 1, v.pic.body = v.pic.invfiltered.B - p.DPM.B; end;
      if     strcmp(p.tail.color,'R') & p.tail.inversion == 0, v.pic.tail = v.pic.filtered.R - p.DPM.R; 
      elseif strcmp(p.tail.color,'R') & p.tail.inversion == 1, v.pic.tail = v.pic.invfiltered.R - p.DPM.R; 
      elseif strcmp(p.tail.color,'G') & p.tail.inversion == 0, v.pic.tail = v.pic.filtered.G - p.DPM.G; 
      elseif strcmp(p.tail.color,'G') & p.tail.inversion == 1, v.pic.tail = v.pic.invfiltered.G - p.DPM.G; 
      elseif strcmp(p.tail.color,'B') & p.tail.inversion == 0, v.pic.tail = v.pic.filtered.B - p.DPM.B; 
      elseif strcmp(p.tail.color,'B') & p.tail.inversion == 1, v.pic.tail = v.pic.invfiltered.B - p.DPM.B; end;
    % filter out everything that is above or below the thresholds
      v.pic.foot(v.pic.foot < p.foot.threshold.low)  = 0;
      v.pic.foot(v.pic.foot > p.foot.threshold.high) = 0;
      v.pic.body(v.pic.body < p.body.threshold.low)  = 0;
      v.pic.body(v.pic.body > p.body.threshold.high) = 0;
      % only do tail if it is not disabled
        if p.tail.threshold.low >= 0 & p.tail.threshold.high >= 0
          v.pic.tail(v.pic.tail < p.tail.threshold.low)  = 0;
          v.pic.tail(v.pic.tail > p.tail.threshold.high) = 0;
        end; 
     % clear pics of dirt
       CleanBodyPIC = v.pic.body;
       CleanTailPIC = v.pic.tail;
       CleanFootPIC = v.pic.foot;
     % make sure body trumps tail
       CleanTailPIC(CleanBodyPIC > 0) = 0;
     % combined pic - 0-125: body+tail; 126-255: feet
       v.pic.combined = min(125,max(CleanBodyPIC*p.bodybrightness,CleanTailPIC*p.tailbrightness));
       % add feet when they are not zero
         ind = find(CleanFootPIC ~= 0);
         maxfoot = max(CleanFootPIC(:));
         v.pic.combined(ind) = CleanFootPIC(ind)*p.footbrightness+127;
     imagesc(v.pic.combined, [0 255]);
%      image(v.pic.combined);
     colormap(p.color);     
 end;   


% Initialize Mouse Popupmenu
  Text = {'(1)'};
  for i = 1:handles.v.MouseTrack.NumberOfMice
    Text(i) = {['(' num2str(i) ')']};
    % if mouse is completely erased, indicate it with different text
      if max(handles.v.MouseTrack.TrackTime{i}) <= 0
        Text(i) = {['-']};
      end;
  end;

hold on;
axis off;

%% PLOT MICE
if isfield(v,'MouseTrack')
  % loop over mice
    for MouseIndex = 1 : v.MouseTrack.NumberOfMice
      
      % note only bodies that are present 
        % find mouse track index that corresponds to current frame
          N = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameIndex);
        if ~isempty(N)%v.MouseTrack.TrackTime{MouseIndex}(v.MouseTrack.TrackLength{MouseIndex}) == v.time
          N = N(end);          
          % plot head center if set
            if p.PlotHeadCenter == 1, PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:), v.MouseTrack.HeadOrientation{MouseIndex}(N), p, ColorBodyDirections); end;
          % plot body center if set
            if p.PlotBodyCenter == 1, PlotCenterAndDirection(v.MouseTrack.BodyCentroid{MouseIndex}(N,:), v.MouseTrack.BodyOrientation{MouseIndex}(N), p, ColorBodyDirections); end;
          % plot body back center if set
            if p.PlotBodyBackCenter == 1, PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:), v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, ColorBodyDirections); end;
          % plot tail1-3 center if set
            if p.PlotTail1Center == 1, PlotCenterAndDirection(v.MouseTrack.Tail1Centroid{MouseIndex}(N,:), v.MouseTrack.Tail1Orientation{MouseIndex}(N), p, ColorBodyDirections); end;
            if p.PlotTail2Center == 1, PlotCenterAndDirection(v.MouseTrack.Tail2Centroid{MouseIndex}(N,:), v.MouseTrack.Tail2Orientation{MouseIndex}(N), p, ColorBodyDirections); end;
            if p.PlotTail3Center == 1, PlotCenterAndDirection(v.MouseTrack.Tail3Centroid{MouseIndex}(N,:), v.MouseTrack.Tail3Orientation{MouseIndex}(N), p, ColorBodyDirections); end;

          % plot head contour
            if p.PlotHeadContour == 1, plot([cell2mat(v.MouseTrack.HeadContourY{MouseIndex}(N))], [cell2mat(v.MouseTrack.HeadContourX{MouseIndex}(N))], 'b--', 'LineWidth', p.ContourLineWidth); end;
          % plot tail contour
            if p.PlotTailContour == 1, plot([cell2mat(v.MouseTrack.TailContourY{MouseIndex}(N))], [cell2mat(v.MouseTrack.TailContourX{MouseIndex}(N))], 'g--', 'LineWidth', p.ContourLineWidth); end;

          % plot feet
            if p.PlotFeet == 1
              PlotFeet(MouseIndex, N, v, p);
            end;
          % plot nose if set -- put to the end so it shows up on top
            if p.PlotNose == 1, plot(v.MouseTrack.Nose{MouseIndex}(N,2), v.MouseTrack.Nose{MouseIndex}(N,1), 'rd', 'LineWidth', 2); end;            
            
          % make mouse's number bold in mousenumber_popupmenu
            Text(MouseIndex) = {num2str(MouseIndex)};
            
          % CALCULATE FOOT BRIGHTNESS/SIZE/PRESSURE if doesn't exist yet
          % this happens if the user manually selects a foot but dues not go to all the frames affected by the manual selection. In this case the footprint brightness/etc data is stored as -1 and is only revisited once the given frame is loaded to save time, or during evaluation. 
            if v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) > 0 & v.MouseTrack.LegLF.FootSize{MouseIndex}(N) == -1
              % we will need the filtered image. If not done yet do it now
                if ~isfield(v.pic,'foot')
                  v = FilterImage(v,p);  
                end;
              % Set data to specified
                x = v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2);
                y = v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1);
              % Identify and save brightness - within handles.p.MaxFingerDistance
              % calculate edges of foot
                v.MouseTrack.LegLF.FootMinX{MouseIndex}(N) = max(y-p.MaxFingerDistance,1);
                v.MouseTrack.LegLF.FootMaxX{MouseIndex}(N) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
                v.MouseTrack.LegLF.FootMinY{MouseIndex}(N) = max(x-p.MaxFingerDistance,1);
                v.MouseTrack.LegLF.FootMaxY{MouseIndex}(N) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
              % sized rectangle (for simplicity)
                indX = round(v.MouseTrack.LegLF.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegLF.FootMaxX{MouseIndex}(N));
                indY = round(v.MouseTrack.LegLF.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegLF.FootMaxY{MouseIndex}(N));
                FootMatrix = v.pic.foot(indX,indY);
                indFoot = find(FootMatrix(:) > 0);
              % calculate total footsize
                v.MouseTrack.LegLF.FootSize{MouseIndex}(N) = length(indFoot);
              % calculate total brightness
                v.MouseTrack.LegLF.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
              % calcuate maximum brightness of foot
                v.MouseTrack.LegLF.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));            
            end;
            if v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) > 0 & v.MouseTrack.LegLH.FootSize{MouseIndex}(N) == -1
              % we will need the filtered image. If not done yet do it now
                if ~isfield(v.pic,'foot')
                  v = FilterImage(v,p);  
                end;
              % Set data to specified
                x = v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2);
                y = v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1);
              % Identify and save brightness - within handles.p.MaxFingerDistance
              % calculate edges of foot
                v.MouseTrack.LegLH.FootMinX{MouseIndex}(N) = max(y-p.MaxFingerDistance,1);
                v.MouseTrack.LegLH.FootMaxX{MouseIndex}(N) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
                v.MouseTrack.LegLH.FootMinY{MouseIndex}(N) = max(x-p.MaxFingerDistance,1);
                v.MouseTrack.LegLH.FootMaxY{MouseIndex}(N) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
              % sized rectangle (for simplicity)
                indX = round(v.MouseTrack.LegLH.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegLH.FootMaxX{MouseIndex}(N));
                indY = round(v.MouseTrack.LegLH.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegLH.FootMaxY{MouseIndex}(N));
                FootMatrix = v.pic.foot(indX,indY);
                indFoot = find(FootMatrix(:) > 0);
              % calculate total footsize
                v.MouseTrack.LegLH.FootSize{MouseIndex}(N) = length(indFoot);
              % calculate total brightness
                v.MouseTrack.LegLH.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
              % calcuate maximum brightness of foot
                v.MouseTrack.LegLH.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));            
            end;
            if v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) > 0 & v.MouseTrack.LegRF.FootSize{MouseIndex}(N) == -1
              % we will need the filtered image. If not done yet do it now
                if ~isfield(v.pic,'foot')
                  v = FilterImage(v,p);  
                end;
              % Set data to specified
                x = v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2);
                y = v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1);
              % Identify and save brightness - within handles.p.MaxFingerDistance
              % calculate edges of foot
                v.MouseTrack.LegRF.FootMinX{MouseIndex}(N) = max(y-p.MaxFingerDistance,1);
                v.MouseTrack.LegRF.FootMaxX{MouseIndex}(N) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
                v.MouseTrack.LegRF.FootMinY{MouseIndex}(N) = max(x-p.MaxFingerDistance,1);
                v.MouseTrack.LegRF.FootMaxY{MouseIndex}(N) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
              % sized rectangle (for simplicity)
                indX = round(v.MouseTrack.LegRF.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegRF.FootMaxX{MouseIndex}(N));
                indY = round(v.MouseTrack.LegRF.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegRF.FootMaxY{MouseIndex}(N));
                FootMatrix = v.pic.foot(indX,indY);
                indFoot = find(FootMatrix(:) > 0);
              % calculate total footsize
                v.MouseTrack.LegRF.FootSize{MouseIndex}(N) = length(indFoot);
              % calculate total brightness
                v.MouseTrack.LegRF.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
              % calcuate maximum brightness of foot
                v.MouseTrack.LegRF.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));            
            end;
            if v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) > 0 & v.MouseTrack.LegRH.FootSize{MouseIndex}(N) == -1
              % we will need the filtered image. If not done yet do it now
                if ~isfield(v.pic,'foot')
                  v = FilterImage(v,p);  
                end;
              % Set data to specified
                x = v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2);
                y = v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1);
              % Identify and save brightness - within handles.p.MaxFingerDistance
              % calculate edges of foot
                v.MouseTrack.LegRH.FootMinX{MouseIndex}(N) = max(y-p.MaxFingerDistance,1);
                v.MouseTrack.LegRH.FootMaxX{MouseIndex}(N) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
                v.MouseTrack.LegRH.FootMinY{MouseIndex}(N) = max(x-p.MaxFingerDistance,1);
                v.MouseTrack.LegRH.FootMaxY{MouseIndex}(N) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
              % sized rectangle (for simplicity)
                indX = round(v.MouseTrack.LegRH.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegRH.FootMaxX{MouseIndex}(N));
                indY = round(v.MouseTrack.LegRH.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegRH.FootMaxY{MouseIndex}(N));
                FootMatrix = v.pic.foot(indX,indY);
                indFoot = find(FootMatrix(:) > 0);
              % calculate total footsize
                v.MouseTrack.LegRH.FootSize{MouseIndex}(N) = length(indFoot);
              % calculate total brightness
                v.MouseTrack.LegRH.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
              % calcuate maximum brightness of foot
                v.MouseTrack.LegRH.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));            
            end;
        end;
    end;
end;

% update handles
  handles.v = v;  


%% Draw length bar

if p.lengthbar == 1
    SizePic = size(v.pic.R);

    % Change the position of the distance bar
    X = 0; % CESAR: you only need to change THIS
    Y = 0;  % CESAR: and this too

    P1 = patch([0 0 -1 -1].*p.mm2pix*10+SizePic(2)*0.95-1+X,SizePic(1)*[0.05 0.043 0.043 0.05]-Y,'w');
    % P2 = patch([0 0 -2 -2]+p.distcal/2-119+SizePic(2)-1,[28 35 35 28],'w');
    plot( [0 0] + SizePic(2)*0.95-1+1+X,SizePic(1)*[0.04 0.053]-Y,'Color',[1 1 0.9], 'LineWidth', 2)
    plot(-[1 1].*p.mm2pix*10+SizePic(2)*0.95-1+1+X,SizePic(1)*[0.04 0.053]-Y,'Color',[1 1 0.9], 'LineWidth', 2)
    % set(P1,'LineColor', 'w');
    % P = patch([1 1 -1 -1].*p.distcal/2-119+SizePic(2)-1,[30 33 33 30],'w');

    text(SizePic(2)*0.95-p.mm2pix*10*0.5-1+X, SizePic(1)*0.063-Y,'1 cm', 'Color',[0.8 0.8 0.8],'FontSize', 10,'HorizontalAlignment','center');
    
    
end;


%% make mouse's number bold in mousenumber_popupmenu
  set(handles.mousenumber_popupmenu, 'String', Text);


return;