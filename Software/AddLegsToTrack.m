function [v] = AddLegsToTrack(v, p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v] = AddLegsToTrack(v, p, MouseIndex)
%
% Add mouse legs to tracked data. It needs to be connected to an existing
% track (it may be a new one that was just created), otherwise the 'leg' is
% ignored.
%
% MouseIndex - index of mouse track to which leg info should be checked,
%              and if matches, added.
%
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% index matching feet. This index for each foot remains zero as long as the
% foot is not assigned to any foot track.
  footmatch = zeros(1,v.foot.NumberOfFeet);
  % FIRST CHECK IF FOOT IS PART OF EXISTING FOOTPRINT TRACK
  % loop over bodies identified so far
    for MouseIndex = 1 : v.MouseTrack.NumberOfMice
      % find track position corresponding to present time and call it N
        N = find(v.MouseTrack.TrackIndex{MouseIndex} == p.FrameIndex);
      % continue only if there is tracking at this time
      % check only if this is not first round
        if ~isempty(N) & N > 1
          % Right Front -------------------------------------------------------
            [NewCentroid, footmatch, matchIndex] = FootCentroidMatch(v.MouseTrack.LegRF.Centroid{MouseIndex}(N-1,:), footmatch, v, p, MouseIndex, N);
            % if match was achieved, update foottrack, otherwise set foot to zero
              [v] = UpdateFootInformation(v,MouseIndex,N,NewCentroid, matchIndex, 'RF');
%               if NewCentroid(1) ~= -1, v.MouseTrack.LegRF.Centroid{MouseIndex}(N,:) = NewCentroid; else v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1:2) = -1; end;
          % Right Hind --------------------------------------------------------
            [NewCentroid, footmatch, matchIndex] = FootCentroidMatch(v.MouseTrack.LegRH.Centroid{MouseIndex}(N-1,:), footmatch, v, p, MouseIndex, N);
            % if match was achieved, update foottrack
              [v] = UpdateFootInformation(v,MouseIndex,N,NewCentroid, matchIndex, 'RH');
%               if NewCentroid(1) ~= -1, v.MouseTrack.LegRH.Centroid{MouseIndex}(N,:) = NewCentroid; else v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1:2) = -1; end;
          % Left Front --------------------------------------------------------
            [NewCentroid, footmatch, matchIndex] = FootCentroidMatch(v.MouseTrack.LegLF.Centroid{MouseIndex}(N-1,:), footmatch, v, p, MouseIndex, N);
            % if match was achieved, update foottrack
              [v] = UpdateFootInformation(v,MouseIndex,N,NewCentroid, matchIndex, 'LF');
%               if NewCentroid(1) ~= -1, v.MouseTrack.LegLF.Centroid{MouseIndex}(N,:) = NewCentroid; else v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1:2) = -1; end;
          % Left Hind ---------------------------------------------------------
            [NewCentroid, footmatch, matchIndex] = FootCentroidMatch(v.MouseTrack.LegLH.Centroid{MouseIndex}(N-1,:), footmatch, v, p, MouseIndex, N);
            % if match was achieved, update foottrack
              [v] = UpdateFootInformation(v,MouseIndex,N,NewCentroid, matchIndex, 'LH');
%               if NewCentroid(1) ~= -1, v.MouseTrack.LegLH.Centroid{MouseIndex}(N,:) = NewCentroid; else v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1:2) = -1; end;
        end;          
    end;     

% ADD FEET that are new
  % loop over mice
    for MouseIndex = 1 : v.MouseTrack.NumberOfMice
      % find legs that have not been added to anything. This will be refreshed after checking for each mouse
        ind = find(footmatch == 0);
      % loop over feet that have not been added
        for FootIndex = ind
          % check if foot(FootIndex) can belong to mouse(MouseIndex), given
          % that some feet of the mouse may already been identified (these cannot be reallocated)
            [v, match] = MatchFootWithMouse(v, p, MouseIndex, FootIndex);         
        end;
    end;

    
return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [NewCentroid, footmatch, matchIndex] = FootCentroidMatch(PreviousCentroid, footmatch, v, p, MouseIndex, N)    
% compares current list of foot centroids to centroid from foot tracks from
% previous frame. If any matches then output the match: the foot on the
% current frame will then be added to the track of the match, and the index
% of the matching foot (matchIndex) will be output.

% initialize
  NewCentroid(1:2) = -1;
  matchIndex = -1;

  if PreviousCentroid(1) ~= -1
    % do this only if there was any feet found
      if v.foot.NumberOfFeet > 0
        % calculate distance of each current leg to tracked leg
          for j = 1:v.foot.NumberOfFeet
            % only consider if this foot has not been matched before
              if footmatch(j) == 0
                dist(j) = (PreviousCentroid(1) - v.foot.FootCentroid{j}(1)).^2 + (PreviousCentroid(2) - v.foot.FootCentroid{j}(2)).^2;
                % if foot is outside of body then ignore it anyway
                  % extract mouse tail for polygon
                    xv = cell2mat(v.MouseTrack.BodyContourX{MouseIndex}(N));
                    yv = cell2mat(v.MouseTrack.BodyContourY{MouseIndex}(N));
                  % find if "footprint" centroid is within the polygon defined by the contour of the tail
                    [in,on] = inpolygon(v.foot.FootCentroid{j}(1),v.foot.FootCentroid{j}(2),xv,yv);
                  % we also need to take into account if footprint is just slightly
                  % outside as it can happen
                    dist2 = min(((v.foot.FootCentroid{j}(1) - xv).^2+(v.foot.FootCentroid{j}(2) - yv).^2));
                  % this can only be a real footprint if it is within the body or close
                  % to the edge. We want to ignore points that are outside as they
                  % can't be real.
                    if in == 0 & on == 0 & dist2 > (2*p.MaxFingerDistance)^2
                      dist(j) = 10^8;
                    end;
              else
                dist(j) = 10^8;
              end
          end;

        % if minumum distance smaller than allowed foot movement per turn then declare this the same foot
          matchIndex = find(dist == min(dist)); matchIndex = matchIndex(1);
          if dist(matchIndex) <= p.maxFootStep^2
            NewCentroid(1:2) = v.foot.FootCentroid{matchIndex};
            % make sure that this foot will not be assigned again
              footmatch(matchIndex) = 1;
          end;
      end;        
  end;


return;
