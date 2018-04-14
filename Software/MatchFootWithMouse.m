function [v, match] = MatchFootWithMouse(v, p, MouseIndex, FootIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v, match] = MatchFootWithMouse(v, p, MouseIndex, FootIndex)
%
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set match to 0 indicating no match (will be updated if we find match)
  match = 0;

% find track position corresponding to present time and call it N
  N = find(v.MouseTrack.TrackIndex{MouseIndex} == p.FrameIndex);
  
% quit if there is no current body
  if isempty(N), return; end;

% calculate position of foot compared to body - calculate parallel and
% perpendicular positions of footprint compared to body line (line from the center of body to center of head)
  Xpoint = v.foot.FootCentroid{FootIndex}(1);
  Ypoint = v.foot.FootCentroid{FootIndex}(2);  
  Xline(1) = v.MouseTrack.BodyCentroid{MouseIndex}(N,1);
  Yline(1) = v.MouseTrack.BodyCentroid{MouseIndex}(N,2);
  Xline(2) = v.MouseTrack.HeadCentroid{MouseIndex}(N,1);
  Yline(2) = v.MouseTrack.HeadCentroid{MouseIndex}(N,2);
  [DistPar, DistPerp] = DistanceFromLine(Xpoint, Ypoint, Xline, Yline);
  
% calculate distance of body center and head center
  DistBodyToHead = sqrt((Xline(2) - Xline(1))^2 + (Yline(2) - Yline(1))^2);
  
% calculate the point at the end of the body, taken as the point half way between the body back point and the first tail 1/3rd point   
  if v.MouseTrack.Tail1Centroid{MouseIndex}(N,1) ~= -1
    BodyEndPointX = (v.MouseTrack.BodyBackCentroid{MouseIndex}(N,1) + v.MouseTrack.Tail1Centroid{MouseIndex}(N,1))/2;
    BodyEndPointY = (v.MouseTrack.BodyBackCentroid{MouseIndex}(N,2) + v.MouseTrack.Tail1Centroid{MouseIndex}(N,2))/2;
  else
    % if there was no tail, estimate the back of the body by assuming that the distance will be the same of the back of the body from the back point than the back point from the center of the body 
    BodyEndPointX = (2*v.MouseTrack.BodyBackCentroid{MouseIndex}(N,1) - v.MouseTrack.BodyCentroid{MouseIndex}(N,1))/2;
    BodyEndPointY = (2*v.MouseTrack.BodyBackCentroid{MouseIndex}(N,2) - v.MouseTrack.BodyCentroid{MouseIndex}(N,2))/2;
  end;
  % calculate of distance of this point from bodybackpoint parallel to the body-head centroid
    [DistBodyEndPointPar, temp] = DistanceFromLine(BodyEndPointX, BodyEndPointY, Xline, Yline);
  % calculate foot's distance from body center
    DistFootFromCenter2 = (Xline(1) - Xpoint)^2 + (Yline(1) - Ypoint)^2;
    
% calculate footprint's distance from closest point of the body surface
  DistFromContour = (cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N)) - Xpoint).^2 + (cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N)) - Ypoint).^2;
  DistFromContour = sqrt(min(DistFromContour));

%% TAIL ----- if print appears under tail first then it's the tail and not a new footprint
  % if the "footprint" was not matched yet and if the tail contour is defined
    if match == 0 & max(cell2mat(v.MouseTrack.TailContourX{MouseIndex}(N))) > 0
      % extract mouse tail for polygon
        xv = cell2mat(v.MouseTrack.TailContourX{MouseIndex}(N));
        yv = cell2mat(v.MouseTrack.TailContourY{MouseIndex}(N));
      % find if "footprint" centroid is within the polygon defined by the contour of the tail
        [in,on] = inpolygon(Xpoint,Ypoint,xv,yv);
      % we also need to take into account if footprint is just slightly
      % outside as it can happen
        dist2 = min(((Xpoint - xv).^2+(Ypoint - yv).^2));
      % if center is within tail then this is a match between the tail and
      % the "footprint" and we don't want this "footprint" to be associated
      % with any of the feet, so we set match to 1. Also consider footprint
      % a tail brightnening if it is close to tail
        if in > 0 | on > 0 | dist2 < 3^2
          match = 1;
        end;
    end

%% OUTSIDE OF BODY ----- filter out those "footprints" that are outside of the body as they must be fake
  % if the "footprint" was not matched yet and if the body contour is defined
    if match == 0 & max(cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N))) > 0
      % extract mouse body for polygon
        xv = cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N));
        yv = cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N));
      % find if "footprint" centroid is within the polygon defined by the contour of the tail
        [in,on] = inpolygon(Xpoint,Ypoint,xv,yv);
      % we also need to take into account if footprint is just slightly
      % outside as it can happen
        dist2 = min(((Xpoint - xv).^2+(Ypoint - yv).^2));
      % this can only be a real footprint if it is within the body or close
      % to the edge. We want to ignore points that are outside as they
      % can't be real.
        if in == 0 & on == 0 & dist2 > (2*p.MaxFingerDistance)^2
          match = 1;
        end;      
    end;
    
%% BUTT ----- filter our butt that touches the ground at the back right at bodyback 
  % if the "footprint" was not matched yet and if the bodyback is defined
    if match == 0 & v.MouseTrack.BodyBackCentroid{MouseIndex}(N,1) > 0
      % this is considered butt if it starts off within p.MaxFingerDistance of the bodyback
        dist2 = (Xpoint - v.MouseTrack.BodyBackCentroid{MouseIndex}(N,1)).^2+(Ypoint - v.MouseTrack.BodyBackCentroid{MouseIndex}(N,2)).^2;
      if dist2 < (p.MaxFingerDistance/2)^2
        match = 1;
      end;
    end;
    
%% RIGHT FRONT ----- check if its not assigned yet and if there was no match  
    % needs to start from the right side of the body and neet to be closer
    % to the head center than the body center
  if v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) == -1 
    if match == 0 & DistPerp >= 0 & DistPar > DistBodyToHead/4 & DistFromContour < DistBodyToHead/2
%         v.MouseTrack.LegRF.Centroid{MouseIndex}(N,:) = v.foot.FootCentroid{FootIndex};
        [v] = UpdateFootInformation(v,MouseIndex,N,1, FootIndex, 'RF');
        match = 1;
    else
%       v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1:2) = -1;
        [v] = UpdateFootInformation(v,MouseIndex,N,-1, FootIndex, 'RF');
    end
  end;
%% RIGHT HIND ----- check if its not assigned yet and if there was no match  
    % needs to start from the right side of the body and neet to be behind
    % 1/3rd of the distance between the body center and head center, and
    % needs to be not more behind of the end of the body than 2/3rd of the body center - head distance
  if v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) == -1 
    if match == 0 & DistPerp >= 0 & DistPar < DistBodyToHead/3 & DistPar > - abs(DistBodyEndPointPar)*3  & DistFromContour < DistBodyToHead/2
%         v.MouseTrack.LegRH.Centroid{MouseIndex}(N,:) = v.foot.FootCentroid{FootIndex};
        [v] = UpdateFootInformation(v,MouseIndex,N,1, FootIndex, 'RH');
        match = 1;
    else
%       v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1:2) = -1;
        [v] = UpdateFootInformation(v,MouseIndex,N,-1, FootIndex, 'RH');
    end;
  end;
%% LEFT FRONT ----- check if its not assigned yet and if there was no match  
    % needs to start from the left side of the body and neet to be closer
    % to the head center than the body center
  if v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) == -1 
    if match == 0 & DistPerp < 0 & DistPar > DistBodyToHead/4 & DistFromContour < DistBodyToHead/2
        [v] = UpdateFootInformation(v,MouseIndex,N,1, FootIndex, 'LF');
%         v.MouseTrack.LegLF.Centroid{MouseIndex}(N,:) = v.foot.FootCentroid{FootIndex};
        match = 1;
    else
        [v] = UpdateFootInformation(v,MouseIndex,N,-1, FootIndex, 'LF');
%       v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1:2) = -1;
    end;
  end;
%% LEFT HIND ----- check if its not assigned yet and if there was no match  
    % needs to start from the left side of the body and neet to be behind
    % 1/3rd of the distance between the body center and head center, and
    % needs to be not more behind of the end of the body than 2/3rd of the body center - head distance
  if v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) == -1 
    if match == 0 & DistPerp < 0 & DistPar < DistBodyToHead/3 & DistPar > - abs(DistBodyEndPointPar)*3 & DistFromContour < DistBodyToHead/2
        [v] = UpdateFootInformation(v,MouseIndex,N,1, FootIndex, 'LH');
%         v.MouseTrack.LegLH.Centroid{MouseIndex}(N,:) = v.foot.FootCentroid{FootIndex};
        match = 1;
    else
        [v] = UpdateFootInformation(v,MouseIndex,N,-1, FootIndex, 'LH');
%       v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1:2) = -1;
    end;
  end;
  
return;