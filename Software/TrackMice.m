function [v] = TrackMice(v,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v] = TrackMice(v,p)
%
% Track mice and their parts. Find which leg corresponds to which body and
% which leg is which. Identify which mouse and feet correspond to which
% tracked animal.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ADD BODIES to EXISTING tracks if they match
  % set match to zero - this means that none of the bodies identified in
  % the current frame are matched with any of the bodies in the previous
  % frame
    match = zeros(1,v.body.NumberOfObjects);
    
  % loop over bodies identified so far
    for i = 1 : v.MouseTrack.NumberOfMice
      % compare all current mice with i'th previous mouse. If their location
      % is within p.maxBodyStep then they will be considered part of the
      % same body
        % find if there is any track with the current frameindex
          indPreviousFrame = find(v.MouseTrack.TrackIndex{i} == p.FrameIndex-1);
        % consider only mouse bodies that are active, i.e. they have been present in the last round
          if ~isempty(indPreviousFrame)
            % find distance^2 between i'th mouse from previous frame and current mice 
              % use only those current mice that have not been associated with anything
                ind = find(match == 0);
                % initialize
                  dist = 10^8;
                for j = 1:length(ind)     
                  dist(j) = (v.MouseTrack.BodyCentroid{i}(indPreviousFrame,1) - v.body.BodyCentroid{ind(j)}(1)).^2 + (v.MouseTrack.BodyCentroid{i}(indPreviousFrame,2) - v.body.BodyCentroid{ind(j)}(2)).^2;
                end;
            % if min distance is smaller than p.maxBodyStep then this will be considered the next position of the i'th mouse
              if min(dist) <= p.maxBodyStep^2
                % identify index of min distance
                  indBody = ind(find(min(dist) == dist)); indBody = indBody(1);
                % save mouse information to track
                  [v] = AddBodyToTrack(v, p, i, indBody);
                % set match to i
                  match(indBody) = i;           
              end;
          end;    
        % if a body that was previously identified does not match with any
        % current body, remove it from this frame
          ind = find(match == i);
          indCurrentFrame = find(v.MouseTrack.TrackIndex{i} == p.FrameIndex);
          if isempty(ind) & ~isempty(indCurrentFrame) % nothing was identified with currently present body
            % cut body and legs at Indices
              N = indCurrentFrame;
              v.MouseTrack.TrackTime{i}(N)           = -1;
              v.MouseTrack.TrackIndex{i}(N)          = -1;
              v.MouseTrack.Nose{i}(N,:)              = -1;
              v.MouseTrack.HeadContourX{i}(N)        = {-1};
              v.MouseTrack.HeadContourY{i}(N)        = {-1};
              v.MouseTrack.HeadCentroid{i}(N,:)      = -1;
              v.MouseTrack.HeadOrientation{i}(N)     = -1;
              v.MouseTrack.BodyCentroid{i}(N,:)      = -1;
              v.MouseTrack.BodyOrientation{i}(N)     = -1;
              v.MouseTrack.BodyBackCentroid{i}(N,:)  = -1;
              v.MouseTrack.BodyBackOrientation{i}(N) = -1;
              v.MouseTrack.TailContourX{i}(N)        = {-1};
              v.MouseTrack.TailContourY{i}(N)        = {-1};    
              v.MouseTrack.Tail1Centroid{i}(N,1:2)   = -1;
              v.MouseTrack.Tail1Orientation{i}(N)    = -1;
              v.MouseTrack.Tail2Centroid{i}(N,1:2)   = -1;
              v.MouseTrack.Tail2Orientation{i}(N)    = -1;
              v.MouseTrack.Tail3Centroid{i}(N,1:2)   = -1;
              v.MouseTrack.Tail3Orientation{i}(N)    = -1;
              v.MouseTrack.Tail{i}(N,:)              = -1;                   
          end;        
    end;

% ADD BODIES to NEW tracks if they haven't matched with anything
  % if some of the mice in the current plot have not been associated with
  % previous tracks, open a new track for them
    % identify those current mice that were not connected with previous ones
      ind = find(match == 0);
    % make new tracks for these
      for j = 1:length(ind)
        % new mouse index should be increment from current mouse track number 
          MouseIndex = v.MouseTrack.NumberOfMice + 1
        % add tracked body
          [v] = AddBodyToTrack(v,p, MouseIndex, ind(j));
      end;

% ADD LEGS - only that can be assigned to bodies, otherwise ignore them
  [v] = AddLegsToTrack(v, p);

  
return;