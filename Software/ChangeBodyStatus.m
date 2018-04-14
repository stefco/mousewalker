function handles = ChangeBodyStatus(handles,Part)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = ChangeBodyStatus(handles,Part)
%
% Change status of a body part following body/head/tail status toggle
% button actions by the user.
%
% (c) Imre Bartos, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
  

%% TAIL END ------------------------------------------------------------------
if strcmp(Part,'tailend')
    % retrieve new button position after toggle
      handles.tailend_togglebuttonStatus = get(handles.tailend_togglebutton,'Value');
    if handles.tailend_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over old position
          if p.PlotTailContour == 1, plot([cell2mat(v.MouseTrack.TailContourY{MouseIndex}(N))], [cell2mat(v.MouseTrack.TailContourX{MouseIndex}(N))], '--', 'Color', [0 0.3 0], 'LineWidth', p.ContourLineWidth); end;
          plot(v.MouseTrack.Tail{MouseIndex}(N,2),   v.MouseTrack.Tail{MouseIndex}(N,1),'x', 'Color', [0 0.3 0], 'LineWidth', 2, 'MarkerSize', 10); 
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.tailend_togglebutton,'Value',0);
            % plot back tail
              if p.PlotTailContour == 1, plot([cell2mat(v.MouseTrack.TailContourY{MouseIndex}(N))], [cell2mat(v.MouseTrack.TailContourX{MouseIndex}(N))], 'g--', 'LineWidth', p.ContourLineWidth); end;
        else          
          % find closest point on body boundary that will be the nose
            tempY2 = (cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N)) - y).^2;
            tempX2 = (cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N)) - x).^2;
            indClosest = find(tempX2 + tempY2 == min(tempX2 + tempY2)); indClosest = indClosest(1);
          % save location
            tempX = cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N));
            tempY = cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N));
            v.MouseTrack.Tail{MouseIndex}(N,2) = tempY(indClosest);
            v.MouseTrack.Tail{MouseIndex}(N,1) = tempX(indClosest);
          % calculate new bodybackcenter position (based on FindTail)
            % convert variables to format that's readable by autotrack commands
              Boundary{1}(:,1) = cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N));
              Boundary{1}(:,2) = cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N));
              indtail{1} = indClosest; 
              indnose{1} = v.MouseTrack.indNose{MouseIndex}(N);
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
              v.MouseTrack.indtail{MouseIndex}(N)      = indtail{1};
              
          % plot new position
            plot(v.MouseTrack.Tail{MouseIndex}(N,2),   v.MouseTrack.Tail{MouseIndex}(N,1),'gx', 'LineWidth', 2, 'MarkerSize', 10); 
            if p.PlotTailContour == 1, plot([cell2mat(v.MouseTrack.TailContourY{MouseIndex}(N))], [cell2mat(v.MouseTrack.TailContourX{MouseIndex}(N))], 'g--', 'LineWidth', p.ContourLineWidth); end;
            if p.PlotBodyBackCenter == 1, PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:), v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, [0.2 0.2 0.2]); end;
        end
        % set togglebutton status back to normal
          set(handles.tailend_togglebutton,'Value', 0);
    end;
end
%% TAIL 3 ------------------------------------------------------------------
if strcmp(Part,'tail3')
    % retrieve new button position after toggle
      handles.tail3_togglebuttonStatus = get(handles.tail3_togglebutton,'Value');
    if handles.tail3_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over original position to make it dark
          PlotCenterAndDirection(v.MouseTrack.Tail3Centroid{MouseIndex}(N,:), v.MouseTrack.Tail3Orientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        % exit if this point is not within boundaries
          if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.tail3_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.Tail3Centroid{MouseIndex}(N,:), v.MouseTrack.Tail3Orientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
        % plot this point
          plot(x, y, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', p.CentroidMarkerSize);
        % get second point for orientation
          [x2,y2] = myginput(1,'crosshair');
        % exit if this point is not within boundaries
          if x2 <= 0 | x2 >= picsize(2) | y2 <= 0 | y2 >= picsize(1)
            set(handles.tail3_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.Tail3Centroid{MouseIndex}(N,:), v.MouseTrack.Tail3Orientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
          % plot over original position to make it dark
            PlotCenterAndDirection(v.MouseTrack.Tail3Centroid{MouseIndex}(N,:), v.MouseTrack.Tail3Orientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
          % save centroid
            v.MouseTrack.Tail3Centroid{MouseIndex}(N,2) = x;
            v.MouseTrack.Tail3Centroid{MouseIndex}(N,1) = y;
          % calculate and save orientation
            [temp1, BodyOrientation, temp2] = FitLine([y y2], [x x2], y2, x2);
            v.MouseTrack.Tail3Orientation{MouseIndex}(N) = BodyOrientation;
          % plot
            PlotCenterAndDirection(v.MouseTrack.Tail3Centroid{MouseIndex}(N,:), v.MouseTrack.Tail3Orientation{MouseIndex}(N), p, [1 1 1]);
        % set togglebutton status back to normal
          set(handles.tail3_togglebutton,'Value', 0);
    end
end
%% TAIL 2 ------------------------------------------------------------------
if strcmp(Part,'tail2')
    % retrieve new button position after toggle
      handles.tail2_togglebuttonStatus = get(handles.tail2_togglebutton,'Value');
    if handles.tail2_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over original position to make it dark
          PlotCenterAndDirection(v.MouseTrack.Tail2Centroid{MouseIndex}(N,:), v.MouseTrack.Tail2Orientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        % exit if this point is not within boundaries
          if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.tail2_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.Tail2Centroid{MouseIndex}(N,:), v.MouseTrack.Tail2Orientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
        % plot this point
          plot(x, y, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', p.CentroidMarkerSize);
        % get second point for orientation
          [x2,y2] = myginput(1,'crosshair');
        % exit if this point is not within boundaries
          if x2 <= 0 | x2 >= picsize(2) | y2 <= 0 | y2 >= picsize(1)
            set(handles.tail2_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.Tail2Centroid{MouseIndex}(N,:), v.MouseTrack.Tail2Orientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
          % plot over original position to make it dark
            PlotCenterAndDirection(v.MouseTrack.Tail2Centroid{MouseIndex}(N,:), v.MouseTrack.Tail2Orientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
          % save centroid
            v.MouseTrack.Tail2Centroid{MouseIndex}(N,2) = x;
            v.MouseTrack.Tail2Centroid{MouseIndex}(N,1) = y;
          % calculate and save orientation
            [temp1, BodyOrientation, temp2] = FitLine([y y2], [x x2], y2, x2);
            v.MouseTrack.Tail2Orientation{MouseIndex}(N) = BodyOrientation;
          % plot
            PlotCenterAndDirection(v.MouseTrack.Tail2Centroid{MouseIndex}(N,:), v.MouseTrack.Tail2Orientation{MouseIndex}(N), p, [1 1 1]);
        % set togglebutton status back to normal
          set(handles.tail2_togglebutton,'Value', 0);
    end
end
%% TAIL 1 ------------------------------------------------------------------
if strcmp(Part,'tail1')
    % retrieve new button position after toggle
      handles.tail1_togglebuttonStatus = get(handles.tail1_togglebutton,'Value');
    if handles.tail1_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over original position to make it dark
          PlotCenterAndDirection(v.MouseTrack.Tail1Centroid{MouseIndex}(N,:), v.MouseTrack.Tail1Orientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        % exit if this point is not within boundaries
          if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.tail1_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.Tail1Centroid{MouseIndex}(N,:), v.MouseTrack.Tail1Orientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
        % plot this point
          plot(x, y, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', p.CentroidMarkerSize);
        % get second point for orientation
          [x2,y2] = myginput(1,'crosshair');
        % exit if this point is not within boundaries
          if x2 <= 0 | x2 >= picsize(2) | y2 <= 0 | y2 >= picsize(1)
            set(handles.tail1_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.Tail1Centroid{MouseIndex}(N,:), v.MouseTrack.Tail1Orientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
          % plot over original position to make it dark
            PlotCenterAndDirection(v.MouseTrack.Tail1Centroid{MouseIndex}(N,:), v.MouseTrack.Tail1Orientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
          % save centroid
            v.MouseTrack.Tail1Centroid{MouseIndex}(N,2) = x;
            v.MouseTrack.Tail1Centroid{MouseIndex}(N,1) = y;
          % calculate and save orientation
            [temp1, BodyOrientation, temp2] = FitLine([y y2], [x x2], y2, x2);
            v.MouseTrack.Tail1Orientation{MouseIndex}(N) = BodyOrientation;
          % plot
            PlotCenterAndDirection(v.MouseTrack.Tail1Centroid{MouseIndex}(N,:), v.MouseTrack.Tail1Orientation{MouseIndex}(N), p, [1 1 1]);
        % set togglebutton status back to normal
          set(handles.tail1_togglebutton,'Value', 0);
    end
end
%% BODY BACK ------------------------------------------------------------------
if strcmp(Part,'bodyback')
    % retrieve new button position after toggle
      handles.bodyback_togglebuttonStatus = get(handles.bodyback_togglebutton,'Value');
    if handles.bodyback_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over original position to make it dark
          PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:), v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        % exit if this point is not within boundaries
          if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.bodyback_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:), v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
        % plot this point
          plot(x, y, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', p.CentroidMarkerSize);
        % get second point for orientation
          [x2,y2] = myginput(1,'crosshair');
        % exit if this point is not within boundaries
          if x2 <= 0 | x2 >= picsize(2) | y2 <= 0 | y2 >= picsize(1)
            set(handles.bodyback_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:), v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
          % plot over original position to make it dark
            PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:), v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
          % save centroid
            v.MouseTrack.BodyBackCentroid{MouseIndex}(N,2) = x;
            v.MouseTrack.BodyBackCentroid{MouseIndex}(N,1) = y;
          % calculate and save orientation
            [temp1, BodyOrientation, temp2] = FitLine([y y2], [x x2], y2, x2);
            v.MouseTrack.BodyBackOrientation{MouseIndex}(N) = BodyOrientation;
          % plot
            PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:), v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, [1 1 1]);
        % set togglebutton status back to normal
          set(handles.bodyback_togglebutton,'Value', 0);
    end
end
%% BODY CENTER ------------------------------------------------------------------
if strcmp(Part,'bodycenter')
    % retrieve new button position after toggle
      handles.bodycenter_togglebuttonStatus = get(handles.bodycenter_togglebutton,'Value');
    if handles.bodycenter_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over original position to make it dark
          PlotCenterAndDirection(v.MouseTrack.BodyCentroid{MouseIndex}(N,:), v.MouseTrack.BodyOrientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        % exit if this point is not within boundaries
          if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.bodycenter_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.BodyCentroid{MouseIndex}(N,:), v.MouseTrack.BodyOrientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
        % plot this point
          plot(x, y, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', p.CentroidMarkerSize);
        % get second point for orientation
          [x2,y2] = myginput(1,'crosshair');
        % exit if this point is not within boundaries
          if x2 <= 0 | x2 >= picsize(2) | y2 <= 0 | y2 >= picsize(1)
            set(handles.bodycenter_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.BodyCentroid{MouseIndex}(N,:), v.MouseTrack.BodyOrientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
          % plot over original position to make it dark
            PlotCenterAndDirection(v.MouseTrack.BodyCentroid{MouseIndex}(N,:), v.MouseTrack.BodyOrientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
          % save centroid
            v.MouseTrack.BodyCentroid{MouseIndex}(N,2) = x;
            v.MouseTrack.BodyCentroid{MouseIndex}(N,1) = y;
          % calculate and save orientation
            [temp1, BodyOrientation, temp2] = FitLine([y y2], [x x2], y2, x2);
            v.MouseTrack.BodyOrientation{MouseIndex}(N) = BodyOrientation;
          % plot
            PlotCenterAndDirection(v.MouseTrack.BodyCentroid{MouseIndex}(N,:), v.MouseTrack.BodyOrientation{MouseIndex}(N), p, [1 1 1]);
        % set togglebutton status back to normal
          set(handles.bodycenter_togglebutton,'Value', 0);
    end
end
%% HEAD CENTER ------------------------------------------------------------------
if strcmp(Part,'headcenter')
    % retrieve new button position after toggle
      handles.headcenter_togglebuttonStatus = get(handles.headcenter_togglebutton,'Value');
    if handles.headcenter_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over original position to make it dark
          PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:), v.MouseTrack.HeadOrientation{MouseIndex}(N), p, [0.5 0.5 0.5]);
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        % exit if this point is not within boundaries
          if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.headcenter_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:), v.MouseTrack.HeadOrientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
        % plot this point
          plot(x, y, 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', p.CentroidMarkerSize);
        % get second point for orientation
          [x2,y2] = myginput(1,'crosshair');
        % exit if this point is not within boundaries
          if x2 <= 0 | x2 >= picsize(2) | y2 <= 0 | y2 >= picsize(1)
            set(handles.headcenter_togglebutton,'Value',0);
            % plot over original position to make it light again
              PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:), v.MouseTrack.HeadOrientation{MouseIndex}(N), p, [1 1 1]);
            return;
          end;
          % save centroid
            v.MouseTrack.HeadCentroid{MouseIndex}(N,2) = x;
            v.MouseTrack.HeadCentroid{MouseIndex}(N,1) = y;
          % calculate and save orientation
            [temp1, BodyOrientation, temp2] = FitLine([y y2], [x x2], y2, x2);
            v.MouseTrack.HeadOrientation{MouseIndex}(N) = BodyOrientation;
          % plot
            PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:), v.MouseTrack.HeadOrientation{MouseIndex}(N), p, [1 1 1]);
        % set togglebutton status back to normal
          set(handles.headcenter_togglebutton,'Value', 0);
    end
end
%% NOSE ------------------------------------------------------------------
if strcmp(Part,'nose')
    % retrieve new button position after toggle
      handles.nose_togglebuttonStatus = get(handles.nose_togglebutton,'Value');
    if handles.nose_togglebuttonStatus == 1 % this means it just got pressed down
        % plot over original position to make it dark
          plot(v.MouseTrack.Nose{MouseIndex}(N,2), v.MouseTrack.Nose{MouseIndex}(N,1), 'd', 'Color', [0.5 0 0], 'LineWidth', 2);         
        % let user place footprint manually
          [x,y] = myginput(1,'crosshair');
        % Save footprint for the points after the placement which are
        % before the next placement of the same footprint. Do this only if
        % the placement is inside the image area, otherwise don't place.
        picsize = size(handles.v.pic.R);
        % exit if this point is not within boundaries
          if x <= 0 | x >= picsize(2) | y <= 0 | y >= picsize(1)
            set(handles.nose_togglebutton,'Value',0);
            % plot over original position to make it light again
              plot(v.MouseTrack.Nose{MouseIndex}(N,2), v.MouseTrack.Nose{MouseIndex}(N,1), 'd', 'Color', [1 0 0], 'LineWidth', 2);         
            return;
          end;
          % find closest point on body boundary that will be the nose
            tempY2 = (cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N)) - y).^2;
            tempX2 = (cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N)) - x).^2;
            indClosest = find(tempX2 + tempY2 == min(tempX2 + tempY2)); indClosest = indClosest(1);
          % save location
            tempX = cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N));
            tempY = cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N));
            v.MouseTrack.Nose{MouseIndex}(N,2) = tempY(indClosest);
            v.MouseTrack.Nose{MouseIndex}(N,1) = tempX(indClosest);
          % recalculate head contour based on these coordiantes
            % first, darken previous head contour and center
              if p.PlotHeadContour == 1, plot([cell2mat(v.MouseTrack.HeadContourY{MouseIndex}(N))], [cell2mat(v.MouseTrack.HeadContourX{MouseIndex}(N))], '--', 'Color', [0 0 0.3], 'LineWidth', p.ContourLineWidth); end;
              if p.PlotHeadCenter == 1, PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:), v.MouseTrack.HeadOrientation{MouseIndex}(N), p, [0.2 0.2 0.2]); end;
              
            % identify HEAD and find points in it (from BodyProperties())
              % find points that are within p.HeadSideLength from the front point
                distancetemp = (tempX - v.MouseTrack.Nose{MouseIndex}(N,1)).^2 + (tempY - v.MouseTrack.Nose{MouseIndex}(N,2)).^2;
                ind = find(distancetemp < p.HeadSideLength^2);
                v.MouseTrack.HeadContourX{MouseIndex}(N) = {tempX(ind)};
                v.MouseTrack.HeadContourY{MouseIndex}(N) = {tempY(ind)};          

        % identify DIRECTION OF HEAD
          % find two points for which the circumference of the triangle with nose is greatest 
            % find the point that is farthest away from the nose
              distancetemp = (tempX(ind) - v.MouseTrack.Nose{MouseIndex}(N,1)).^2 + (tempY(ind) - v.MouseTrack.Nose{MouseIndex}(N,2)).^2;
              ind2 = find(distancetemp == max(distancetemp)); ind2 = ind2(1);
            % find distance of each HeadSide point from the point farthest from the nose
              distancetemp2 = (tempX(ind) - tempX(ind(ind2))).^2 + (tempY(ind) - tempY(ind(ind2))).^2;
            % find distance of each HeadSide point from the nose
              distancetemp3 = (tempX(ind) - v.MouseTrack.Nose{MouseIndex}(N,1)).^2 + (tempY(ind) - v.MouseTrack.Nose{MouseIndex}(N,2)).^2;
            % find total circumference of triangle with nose, the farthest point from the nose, and a third point
              circumferencetemp = distancetemp + distancetemp2 + distancetemp3;
            % find the point for which this circumference is greatest, i.e. the one that is the farthest from the nose on the side other than the farthest point 
              ind3 = find(circumferencetemp == max(circumferencetemp)); ind3 = ind3(1);
            % find middle point between two farthest points, and add that to the nose point to define the ends of the line along the head
              HeadLineX = [(tempX(ind(ind2)) + tempX(ind(ind3)))/2 v.MouseTrack.Nose{MouseIndex}(N,1)];
              HeadLineY = [(tempY(ind(ind2)) + tempY(ind(ind3)))/2 v.MouseTrack.Nose{MouseIndex}(N,2)];
            % find centroid and orientation of head
              [HeadCentroid, HeadOrientation, HeadMajorAxisLength] = FitLine([HeadLineX v.MouseTrack.Nose{MouseIndex}(N,1)], [HeadLineY v.MouseTrack.Nose{MouseIndex}(N,2)], v.MouseTrack.Nose{MouseIndex}(N,1), v.MouseTrack.Nose{MouseIndex}(N,2));
              v.MouseTrack.HeadCentroid{MouseIndex}(N,:) = HeadCentroid;  
              v.MouseTrack.HeadOrientation{MouseIndex}(N) = HeadOrientation;
          % plot
            plot(v.MouseTrack.Nose{MouseIndex}(N,2), v.MouseTrack.Nose{MouseIndex}(N,1), 'd', 'Color', [1 0 0], 'LineWidth', 2);      
            % plot head contour and center
              if p.PlotHeadContour == 1, plot([cell2mat(v.MouseTrack.HeadContourY{MouseIndex}(N))], [cell2mat(v.MouseTrack.HeadContourX{MouseIndex}(N))], 'b--', 'LineWidth', p.ContourLineWidth); end;
              if p.PlotHeadCenter == 1, PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:), v.MouseTrack.HeadOrientation{MouseIndex}(N), p, [1 1 1]); end;

        % set togglebutton status back to normal
          set(handles.nose_togglebutton,'Value', 0);
    end
end
% save data;
  handles.v = v;






return;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%