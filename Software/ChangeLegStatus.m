function handles = ChangeLegStatus(handles,Leg,Neighbor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = ChangeLegStatus(handles,Leg,Neighbor)
%
% Change leg status following Footprint status toggle button actions by the
% user. OR if Neighbor ~= 0, change current leg status to what it is on the
% next frame (Neighbor=-1) or last frame (Neighbor=1).
%
% (c) Imre Bartos, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if no data was loaded then quit
  if ~isfield(handles,'v')
    set(handles.LF_togglebutton,'Value',0); 
    set(handles.LH_togglebutton,'Value',0); 
    set(handles.RF_togglebutton,'Value',0); 
    set(handles.RH_togglebutton,'Value',0); 
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
% find track index that corresponds to FrameNumber
  N = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameNumber);
  if isempty(N)
    disp('there is no mouse here with the defined number...');
    return;
  end;

% LF ----------------------------------------------------------------------
if strcmp(Leg,'LF')
    % retrieve new button position after toggle
      handles.LF_togglebuttonStatus = get(handles.LF_togglebutton,'Value');
    if handles.LF_togglebuttonStatus == 1 ...% this means it just got pressed down
       | Neighbor ~= 0 % this means that we are not pressing anything, we just look for the next footprint  
        % if this is placing the current footprint
          if Neighbor == 0
            % let user place footprint manually
              [x,y] = myginput(1,'crosshair');
          else
            % make xy equal to the next footprint
              % find track index that corresponds to the next/previous frame of FrameNumber
                Nneighbor = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameNumber-Neighbor);  
                if isempty(Nneighbor)
                  disp('there is no mouse on the next/past frame...');
                  return;
                end;
              % quit if mouse leg track is not long enough
                if Nneighbor > length(v.MouseTrack.LegLF.Centroid{MouseIndex}(:,1))
                  disp('not enought leg data...');
                  return;
                end;
              % retrieve leg position on next frame
                x = v.MouseTrack.LegLF.Centroid{MouseIndex}(Nneighbor,2);
                y = v.MouseTrack.LegLF.Centroid{MouseIndex}(Nneighbor,1); 
          end;
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.LF_togglebutton,'Value',0);
        else
            % Set data to specified
              v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2) = x;
              v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) = y;
              plot(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
              text(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2)+p.MaxFingerDistance,v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'LF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
            % Identify and save brightness - within handles.p.MaxFingerDistance
            % calculate edges of foot
              v.MouseTrack.LegLF.FootMinX{MouseIndex}(N) = max(y-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegLF.FootMaxX{MouseIndex}(N) = min(y+handles.p.MaxFingerDistance,length(handles.v.pic.foot(:,1)));
              v.MouseTrack.LegLF.FootMinY{MouseIndex}(N) = max(x-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegLF.FootMaxY{MouseIndex}(N) = min(x+handles.p.MaxFingerDistance,length(handles.v.pic.foot(1,:)));    
            % sized rectangle (for simplicity)
              indX = round(v.MouseTrack.LegLF.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegLF.FootMaxX{MouseIndex}(N));
              indY = round(v.MouseTrack.LegLF.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegLF.FootMaxY{MouseIndex}(N));
              FootMatrix = handles.v.pic.foot(indX,indY);
              indFoot = find(FootMatrix(:) > 0);
            % calculate total footsize
              v.MouseTrack.LegLF.FootSize{MouseIndex}(N) = length(indFoot);
            % calculate total brightness
              v.MouseTrack.LegLF.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
            % calcuate maximum brightness of foot
              v.MouseTrack.LegLF.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));
            % Place footprint where the user placed it for all the frames until 1 before the next placement of the same foot.
              i = N;            
              while i ~= -1
                % exit if next footprint is already on otherwise go till the end of the set of frames
                  if i < v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
                    % if next footprint is on, quit now
                      if v.MouseTrack.LegLF.Centroid{MouseIndex}(i+1,1) > 0
                        i = -1;
                    % if next footprint is not present, update 'i'th one with selection    
                      else
                        % Set data to specified
                          v.MouseTrack.LegLF.Centroid{MouseIndex}(i,2) = x;
                          v.MouseTrack.LegLF.Centroid{MouseIndex}(i,1) = y;
                        % calculate total footsize
                          v.MouseTrack.LegLF.FootSize{MouseIndex}(i) = -1;
                        % calculate total brightness
                          v.MouseTrack.LegLF.FootTotalBrightness{MouseIndex}(i) = -1;
                        % calcuate maximum brightness of foot
                          v.MouseTrack.LegLF.FootMaxBrightness{MouseIndex}(i) = -1;
                        % increase i
                          i = i + 1;                          
                      end;
                % if there is no more data, set up current one and then quit      
                  else
                    i = -1;
                  end;
              end;
          % if everything went well then button should be pressed. Make sure this is the case 
            set(handles.LF_togglebutton,'Value',1);
        end
    else
        % overplot existing leg, but only if it exists (it should as otherwise the togglebutton wouldn't have been down)
          if v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) > 0
            plot(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorFront/2, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
            text(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2)+p.MaxFingerDistance,v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'LF', 'Color', p.colorFront/2, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
          end
        % Turn footprint off till as long as the current footprint is placed (i.e. until there is a gap).
          i = N;
        while i ~= -1
            if i <= v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
              % exit if current footprint is off
                if v.MouseTrack.LegLF.Centroid{MouseIndex}(i,1) == -1
                    i = -1;
                else
                    % Erase data
                      v.MouseTrack.LegLF.Centroid{MouseIndex}(i,1) = -1;
                      v.MouseTrack.LegLF.Centroid{MouseIndex}(i,2) = -1;
                      v.MouseTrack.LegLF.FootSize{MouseIndex}(i) = 0;
                      v.MouseTrack.LegLF.FootTotalBrightness{MouseIndex}(i) = 0;
                      v.MouseTrack.LegLF.FootMaxBrightness{MouseIndex}(i) = 0;                      
                    i = i + 1;
                end;
            else
                i = -1;                
            end;
        end;
    end;
end
% RF ----------------------------------------------------------------------
if strcmp(Leg,'RF')
    % retrieve new button position after toggle
      handles.RF_togglebuttonStatus = get(handles.RF_togglebutton,'Value');
    if handles.RF_togglebuttonStatus == 1 ... % this means it just got pressed down
       | Neighbor ~= 0 % this means that we are not pressing anything, we just look for the next footprint  
        % if this is placing the current footprint
          if Neighbor == 0
            % let user place footprint manually
              [x,y] = myginput(1,'crosshair');
          else
            % make xy equal to the next footprint
              % find track index that corresponds to the next frame FrameNumber
                Nneighbor = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameNumber-Neighbor);  
                if isempty(Nneighbor)
                  disp('there is no mouse on the next frame...');
                  return;
                end;
              % quit if mouse leg track is not long enough
                if Nneighbor > length(v.MouseTrack.LegRF.Centroid{MouseIndex}(:,1))
                  disp('not enought leg data...');
                  return;
                end;
              % retrieve leg position on next frame
                x = v.MouseTrack.LegRF.Centroid{MouseIndex}(Nneighbor,2);
                y = v.MouseTrack.LegRF.Centroid{MouseIndex}(Nneighbor,1); 
          end;
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.RF_togglebutton,'Value',0);
        else
            % Set data to specified
              v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2) = x;
              v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) = y;
              plot(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
              text(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2)+p.MaxFingerDistance,v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'RF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
            % Identify and save brightness - within handles.p.MaxFingerDistance
            % calculate edges of foot
              v.MouseTrack.LegRF.FootMinX{MouseIndex}(N) = max(y-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegRF.FootMaxX{MouseIndex}(N) = min(y+handles.p.MaxFingerDistance,length(handles.v.pic.foot(:,1)));
              v.MouseTrack.LegRF.FootMinY{MouseIndex}(N) = max(x-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegRF.FootMaxY{MouseIndex}(N) = min(x+handles.p.MaxFingerDistance,length(handles.v.pic.foot(1,:)));    
            % sized rectangle (for simplicity)
              indX = round(v.MouseTrack.LegRF.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegRF.FootMaxX{MouseIndex}(N));
              indY = round(v.MouseTrack.LegRF.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegRF.FootMaxY{MouseIndex}(N));
              FootMatrix = handles.v.pic.foot(indX,indY);
              indFoot = find(FootMatrix(:) > 0);
            % calculate total footsize
              v.MouseTrack.LegRF.FootSize{MouseIndex}(N) = length(indFoot);
            % calculate total brightness
              v.MouseTrack.LegRF.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
            % calcuate maximum brightness of foot
              v.MouseTrack.LegRF.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));              
            % Place footprint where the user placed it for all the frames until 1 before the next placement of the same foot.
              i = N;            
              while i ~= -1
                % exit if next footprint is already on otherwise go till the end of the set of frames
                  if i < v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
                    % if next footprint is on, quit now
                      if v.MouseTrack.LegRF.Centroid{MouseIndex}(i+1,1) > 0
                        i = -1;
                    % if next footprint is not present, update 'i'th one with selection    
                      else
                        % Set data to specified
                          v.MouseTrack.LegRF.Centroid{MouseIndex}(i,2) = x;
                          v.MouseTrack.LegRF.Centroid{MouseIndex}(i,1) = y;
                        % calculate total footsize
                          v.MouseTrack.LegRF.FootSize{MouseIndex}(i) = -1;
                        % calculate total brightness
                          v.MouseTrack.LegRF.FootTotalBrightness{MouseIndex}(i) = -1;
                        % calcuate maximum brightness of foot
                          v.MouseTrack.LegRF.FootMaxBrightness{MouseIndex}(i) = -1;
                        % increase i                          
                          i = i + 1;
                      end;
                % if there is no more data, set up current one and then quit      
                  else
                    i = -1;
                  end;
              end;
          % if everything went well then button should be pressed. Make sure this is the case 
            set(handles.RF_togglebutton,'Value',1);        
        end
    else
        % overplot existing leg, but only if it exists (it should as otherwise the togglebutton wouldn't have been down)
          if v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) > 0
            plot(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorFront/2, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
            text(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2)+p.MaxFingerDistance,v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'RF', 'Color', p.colorFront/2, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
          end
        % Turn footprint off till as long as the current footprint is placed (i.e. until there is a gap).
          i = N;
        while i ~= -1
            if i <= v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
              % exit if current footprint is off
                if v.MouseTrack.LegRF.Centroid{MouseIndex}(i,1) == -1
                    i = -1;
                else
                    % Erase data
                      v.MouseTrack.LegRF.Centroid{MouseIndex}(i,1) = -1;
                      v.MouseTrack.LegRF.Centroid{MouseIndex}(i,2) = -1;
                      v.MouseTrack.LegRF.FootSize{MouseIndex}(i) = 0;
                      v.MouseTrack.LegRF.FootTotalBrightness{MouseIndex}(i) = 0;
                      v.MouseTrack.LegRF.FootMaxBrightness{MouseIndex}(i) = 0;                                            
                    i = i + 1;
                end;
            else
                i = -1;                
            end;
        end;
    end;
end
% LH ----------------------------------------------------------------------
if strcmp(Leg,'LH')
    % retrieve new button position after toggle
      handles.LH_togglebuttonStatus = get(handles.LH_togglebutton,'Value');
    if handles.LH_togglebuttonStatus == 1 ...% this means it just got pressed down
       | Neighbor ~= 0 % this means that we are not pressing anything, we just look for the next footprint  
        % if this is placing the current footprint
          if Neighbor == 0
            % let user place footprint manually
              [x,y] = myginput(1,'crosshair');
          else
            % make xy equal to the next footprint
              % find track index that corresponds to the next frame FrameNumber
                Nneighbor = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameNumber-Neighbor);  
                if isempty(Nneighbor)
                  disp('there is no mouse on the next frame...');
                  return;
                end;
              % quit if mouse leg track is not long enough
                if Nneighbor > length(v.MouseTrack.LegLH.Centroid{MouseIndex}(:,1))
                  disp('not enought leg data...');
                  return;
                end;
              % retrieve leg position on next frame
                x = v.MouseTrack.LegLH.Centroid{MouseIndex}(Nneighbor,2);
                y = v.MouseTrack.LegLH.Centroid{MouseIndex}(Nneighbor,1); 
          end;
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.LH_togglebutton,'Value',0);
        else
            % Set data to specified
              v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2) = x;
              v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) = y;
              plot(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
              text(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2)-p.MaxFingerDistance,v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'LH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
            % Identify and save brightness - within handles.p.MaxFingerDistance
            % calculate edges of foot
              v.MouseTrack.LegLH.FootMinX{MouseIndex}(N) = max(y-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegLH.FootMaxX{MouseIndex}(N) = min(y+handles.p.MaxFingerDistance,length(handles.v.pic.foot(:,1)));
              v.MouseTrack.LegLH.FootMinY{MouseIndex}(N) = max(x-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegLH.FootMaxY{MouseIndex}(N) = min(x+handles.p.MaxFingerDistance,length(handles.v.pic.foot(1,:)));    
            % sized rectangle (for simplicity)
              indX = round(v.MouseTrack.LegLH.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegLH.FootMaxX{MouseIndex}(N));
              indY = round(v.MouseTrack.LegLH.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegLH.FootMaxY{MouseIndex}(N));
              FootMatrix = handles.v.pic.foot(indX,indY);
              indFoot = find(FootMatrix(:) > 0);
            % calculate total footsize
              v.MouseTrack.LegLH.FootSize{MouseIndex}(N) = length(indFoot);
            % calculate total brightness
              v.MouseTrack.LegLH.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
            % calcuate maximum brightness of foot
              v.MouseTrack.LegLH.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));              
            % Place footprint where the user placed it for all the frames until 1 before the next placement of the same foot.
              i = N;            
              while i ~= -1
                % exit if next footprint is already on otherwise go till the end of the set of frames
                  if i < v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
                    % if next footprint is on, quit now
                      if v.MouseTrack.LegLH.Centroid{MouseIndex}(i+1,1) > 0
                        i = -1;
                    % if next footprint is not present, update 'i'th one with selection    
                      else
                        % Set data to specified
                          v.MouseTrack.LegLH.Centroid{MouseIndex}(i,2) = x;
                          v.MouseTrack.LegLH.Centroid{MouseIndex}(i,1) = y;
                        % calculate total footsize
                          v.MouseTrack.LegLH.FootSize{MouseIndex}(i) = -1;
                        % calculate total brightness
                          v.MouseTrack.LegLH.FootTotalBrightness{MouseIndex}(i) = -1;
                        % calcuate maximum brightness of foot
                          v.MouseTrack.LegLH.FootMaxBrightness{MouseIndex}(i) = -1;
                        % increase i                          
                          i = i + 1;
                      end;
                % if there is no more data, set up current one and then quit      
                  else
                    i = -1;
                  end;
              end;
          % if everything went well then button should be pressed. Make sure this is the case 
            set(handles.LH_togglebutton,'Value',1);
        end
    else
        % overplot existing leg, but only if it exists (it should as otherwise the togglebutton wouldn't have been down)
          if v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) > 0
            plot(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorHind/2, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
            text(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2)-p.MaxFingerDistance,v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'LH', 'Color', p.colorHind/2, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
          end
        % Turn footprint off till as long as the current footprint is placed (i.e. until there is a gap).
          i = N;
        while i ~= -1
            if i <= v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
              % exit if current footprint is off
                if v.MouseTrack.LegLH.Centroid{MouseIndex}(i,1) == -1
                    i = -1;
                else
                    % Erase data
                      v.MouseTrack.LegLH.Centroid{MouseIndex}(i,1) = -1;
                      v.MouseTrack.LegLH.Centroid{MouseIndex}(i,2) = -1;
                      v.MouseTrack.LegLH.FootSize{MouseIndex}(i) = 0;
                      v.MouseTrack.LegLH.FootTotalBrightness{MouseIndex}(i) = 0;
                      v.MouseTrack.LegLH.FootMaxBrightness{MouseIndex}(i) = 0;                      
                    i = i + 1;
                end;
            else
                i = -1;                
            end;
        end;
    end;
end
% RH ----------------------------------------------------------------------
if strcmp(Leg,'RH')
    % retrieve new button position after toggle
      handles.RH_togglebuttonStatus = get(handles.RH_togglebutton,'Value');
    if handles.RH_togglebuttonStatus == 1 ...% this means it just got pressed down
       | Neighbor ~= 0 % this means that we are not pressing anything, we just look for the next footprint  
        % if this is placing the current footprint
          if Neighbor == 0
            % let user place footprint manually
              [x,y] = myginput(1,'crosshair');
          else
            % make xy equal to the next footprint
              % find track index that corresponds to the next frame FrameNumber
                Nneighbor = find(v.MouseTrack.TrackIndex{MouseIndex} == FrameNumber-Neighbor);  
                if isempty(Nneighbor)
                  disp('there is no mouse on the next frame...');
                  return;
                end;
              % quit if mouse leg track is not long enough
                if Nneighbor > length(v.MouseTrack.LegRH.Centroid{MouseIndex}(:,1))
                  disp('not enought leg data...');
                  return;
                end;
              % retrieve leg position on next frame
                x = v.MouseTrack.LegRH.Centroid{MouseIndex}(Nneighbor,2);
                y = v.MouseTrack.LegRH.Centroid{MouseIndex}(Nneighbor,1); 
          end;
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.RH_togglebutton,'Value',0);
        else
            % Set data to specified
              v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2) = x;
              v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) = y;
              plot(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
              text(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2)-p.MaxFingerDistance,v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'RH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
            % Identify and save brightness - within handles.p.MaxFingerDistance
            % calculate edges of foot
              v.MouseTrack.LegRH.FootMinX{MouseIndex}(N) = max(y-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegRH.FootMaxX{MouseIndex}(N) = min(y+handles.p.MaxFingerDistance,length(handles.v.pic.foot(:,1)));
              v.MouseTrack.LegRH.FootMinY{MouseIndex}(N) = max(x-handles.p.MaxFingerDistance,1);
              v.MouseTrack.LegRH.FootMaxY{MouseIndex}(N) = min(x+handles.p.MaxFingerDistance,length(handles.v.pic.foot(1,:)));    
            % sized rectangle (for simplicity)
              indX = round(v.MouseTrack.LegRH.FootMinX{MouseIndex}(N)) : round(v.MouseTrack.LegRH.FootMaxX{MouseIndex}(N));
              indY = round(v.MouseTrack.LegRH.FootMinY{MouseIndex}(N)) : round(v.MouseTrack.LegRH.FootMaxY{MouseIndex}(N));
              FootMatrix = handles.v.pic.foot(indX,indY);
              indFoot = find(FootMatrix(:) > 0);
            % calculate total footsize
              v.MouseTrack.LegRH.FootSize{MouseIndex}(N) = length(indFoot);
            % calculate total brightness
              v.MouseTrack.LegRH.FootTotalBrightness{MouseIndex}(N) = sum(sum(FootMatrix));
            % calcuate maximum brightness of foot
              v.MouseTrack.LegRH.FootMaxBrightness{MouseIndex}(N) = max(max(FootMatrix));              
            % Place footprint where the user placed it for all the frames until 1 before the next placement of the same foot.
              i = N;            
              while i ~= -1
                % exit if next footprint is already on otherwise go till the end of the set of frames
                  if i < v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
                    % if next footprint is on, quit now
                      if v.MouseTrack.LegRH.Centroid{MouseIndex}(i+1,1) > 0
                        i = -1;
                    % if next footprint is not present, update 'i'th one with selection    
                      else
                        % Set data to specified
                          v.MouseTrack.LegRH.Centroid{MouseIndex}(i,2) = x;
                          v.MouseTrack.LegRH.Centroid{MouseIndex}(i,1) = y;
                        % calculate total footsize
                          v.MouseTrack.LegRH.FootSize{MouseIndex}(i) = -1;
                        % calculate total brightness
                          v.MouseTrack.LegRH.FootTotalBrightness{MouseIndex}(i) = -1;
                        % calcuate maximum brightness of foot
                          v.MouseTrack.LegRH.FootMaxBrightness{MouseIndex}(i) = -1;
                        % increase i                          
                          i = i + 1;
                      end;
                % if there is no more data, set up current one and then quit      
                  else
                    i = -1;
                  end;
              end;
          % if everything went well then button should be pressed. Make sure this is the case 
            set(handles.RH_togglebutton,'Value',1);        
        end
    else
        % overplot existing leg, but only if it exists (it should as otherwise the togglebutton wouldn't have been down)
          if v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) > 0
            plot(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorHind/2, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
            text(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2)-p.MaxFingerDistance,v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'RH', 'Color', p.colorHind/2, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
          end
        % Turn footprint off till as long as the current footprint is placed (i.e. until there is a gap).
          i = N;
        while i ~= -1
            if i <= v.MouseTrack.TrackLength{MouseIndex} % length(handles.p.FileList) > i & 
              % exit if current footprint is off
                if v.MouseTrack.LegRH.Centroid{MouseIndex}(i,1) == -1
                    i = -1;
                else
                    % Erase data
                      v.MouseTrack.LegRH.Centroid{MouseIndex}(i,1) = -1;
                      v.MouseTrack.LegRH.Centroid{MouseIndex}(i,2) = -1;
                      v.MouseTrack.LegRH.FootSize{MouseIndex}(i) = 0;
                      v.MouseTrack.LegRH.FootTotalBrightness{MouseIndex}(i) = 0;
                      v.MouseTrack.LegRH.FootMaxBrightness{MouseIndex}(i) = 0;                      
                    i = i + 1;
                end;
            else
                i = -1;                
            end;
        end;
    end;
end


% save data;
  handles.v = v;






return;