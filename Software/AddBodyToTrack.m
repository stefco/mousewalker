function [v] = AddBodyToTrack(v,p, MouseIndex, indBody)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v] = AddBodyToTrack(v,p, MouseIndex, indBody)
%
% Add mouse body to tracked data. It can either be to an already tracked
% mouse or a new mouse, based on whether the index of the new mouse is
% greater than the number of tracked mice.
%
% MouseIndex - index of mouse track to which mouse info should be added. If
%              it's greater than existing trackes a new track is created.
%
% indBody    - index of body in current frame that should be added to
%              tracks.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% either add to existing mouse or create new mouse track
  if MouseIndex <= v.MouseTrack.NumberOfMice
    % add to existing
      % update length of track - use N here for simplity in assignment below
        % if there was already a track with this index, jump to that one, otherwise add to end
          % find if there is any track with the current frameindex
            ind = find(v.MouseTrack.TrackIndex{MouseIndex} == p.FrameIndex);
          if ~isempty(ind)
            N = ind(1);
          else
            N = v.MouseTrack.TrackLength{MouseIndex} + 1;  
            % set track number to N
              v.MouseTrack.TrackLength{MouseIndex} = N;
          end;
  else
    % create new mouse track
      % increase tracked mouse number
        v.MouseTrack.NumberOfMice = MouseIndex;
      % set track number to 1
        v.MouseTrack.TrackLength{MouseIndex}      = 1;
      % set track index to the beginning (1)
        N = 1;
      % create empty leg variables for new track
        v.MouseTrack.LegRF.Centroid{MouseIndex}(1,1:2) = -1;
        v.MouseTrack.LegRH.Centroid{MouseIndex}(1,1:2) = -1;
        v.MouseTrack.LegLF.Centroid{MouseIndex}(1,1:2) = -1;
        v.MouseTrack.LegLH.Centroid{MouseIndex}(1,1:2) = -1;
    
  end;

% add tracked body
  v.MouseTrack.TrackTime{MouseIndex}(N)           = v.time;
  v.MouseTrack.TrackIndex{MouseIndex}(N)          = p.FrameIndex;
  v.MouseTrack.Nose{MouseIndex}(N,:)              = v.body.Boundary{indBody}(v.body.indnose{indBody},:);
  v.MouseTrack.indNose{MouseIndex}(N)             = v.body.indnose{indBody};
  v.MouseTrack.BodyContourX{MouseIndex}(N)        = {v.body.Boundary{indBody}(:,1)};
  v.MouseTrack.BodyContourY{MouseIndex}(N)        = {v.body.Boundary{indBody}(:,2)};
  v.MouseTrack.HeadContourX{MouseIndex}(N)        = {v.body.HeadSide{indBody}(:,1)};
  v.MouseTrack.HeadContourY{MouseIndex}(N)        = {v.body.HeadSide{indBody}(:,2)};
  v.MouseTrack.HeadCentroid{MouseIndex}(N,:)      = v.body.HeadCentroid{indBody}(:);
  v.MouseTrack.HeadOrientation{MouseIndex}(N)     = v.body.HeadOrientation{indBody};
  v.MouseTrack.BodyCentroid{MouseIndex}(N,:)      = v.body.BodyCentroid{indBody}(:);
  v.MouseTrack.BodyOrientation{MouseIndex}(N)     = v.body.BodyOrientation{indBody};
  v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:)  = v.body.BodyBackCentroid{indBody}(:);
  v.MouseTrack.BodyBackOrientation{MouseIndex}(N) = v.body.BodyBackOrientation{indBody};
  if v.body.indTail{indBody}(1) ~= -1
    v.MouseTrack.TailContourX{MouseIndex}(N)        = {v.body.Boundary{indBody}(v.body.indTail{indBody},1)};
    v.MouseTrack.TailContourY{MouseIndex}(N)        = {v.body.Boundary{indBody}(v.body.indTail{indBody},2)};
    v.MouseTrack.Tail1Centroid{MouseIndex}(N,:)     = v.body.Tail1Centroid{indBody}(:);
    v.MouseTrack.Tail1Orientation{MouseIndex}(N)    = v.body.Tail1Orientation{indBody};
    v.MouseTrack.Tail2Centroid{MouseIndex}(N,:)     = v.body.Tail2Centroid{indBody}(:);
    v.MouseTrack.Tail2Orientation{MouseIndex}(N)    = v.body.Tail2Orientation{indBody};
    v.MouseTrack.Tail3Centroid{MouseIndex}(N,:)     = v.body.Tail3Centroid{indBody}(:);
    v.MouseTrack.Tail3Orientation{MouseIndex}(N)    = v.body.Tail3Orientation{indBody};
    v.MouseTrack.Tail{MouseIndex}(N,:)              = v.body.Boundary{indBody}(v.body.indtail{indBody},:); 
    v.MouseTrack.indtail{MouseIndex}(N)             = v.body.indtail{indBody}; 
  else
    v.MouseTrack.TailContourX{MouseIndex}(N)        = {-1};
    v.MouseTrack.TailContourY{MouseIndex}(N)        = {-1};    
    v.MouseTrack.Tail1Centroid{MouseIndex}(N,1:2)   = -1;
    v.MouseTrack.Tail1Orientation{MouseIndex}(N)    = -1;
    v.MouseTrack.Tail2Centroid{MouseIndex}(N,1:2)   = -1;
    v.MouseTrack.Tail2Orientation{MouseIndex}(N)    = -1;
    v.MouseTrack.Tail3Centroid{MouseIndex}(N,1:2)   = -1;
    v.MouseTrack.Tail3Orientation{MouseIndex}(N)    = -1;
    v.MouseTrack.Tail{MouseIndex}(N,:)              = -1;
    v.MouseTrack.indtail{MouseIndex}(N)             = -1; 
  end;
  
  
return;

