function [v] = UpdateFootInformation(v,MouseIndex,N,NewCentroid, matchIndex, Foot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v] = UpdateFootInformation(v,MouseIndex,N,NewCentroid, matchIndex, Foot)
%
% check if this is a new foot, and if not, add information to existing foot
% track. Otherwise output that this foot has been discontinued.
%
% (c) Imre Bartos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% assign leg in question
  if     strcmp(Foot,'RF')
    Leg = v.MouseTrack.LegRF;
  elseif strcmp(Foot,'RH')
    Leg = v.MouseTrack.LegRH;
  elseif strcmp(Foot,'LF')
    Leg = v.MouseTrack.LegLF;
  elseif strcmp(Foot,'LH')
    Leg = v.MouseTrack.LegLH;
  end;


% if the coordinates of Foot for mouse MouseIndex match the coordinates of
% the new foot, add the new foot's parameters to the end of the existing track
  if NewCentroid(1) ~= -1
    Leg.Centroid{MouseIndex}(N,1:2)        = v.foot.FootCentroid{matchIndex}(1:2); 
    Leg.FootSize{MouseIndex}(N)            = v.foot.FootSize{matchIndex}; 
    Leg.FootTotalBrightness{MouseIndex}(N) = v.foot.FootTotalBrightness{matchIndex}; 
    Leg.FootMaxBrightness{MouseIndex}(N)   = v.foot.FootMaxBrightness{matchIndex}; 
    Leg.FootMinX{MouseIndex}(N)            = v.foot.FootMinX{matchIndex}; 
    Leg.FootMaxX{MouseIndex}(N)            = v.foot.FootMaxX{matchIndex}; 
    Leg.FootMinY{MouseIndex}(N)            = v.foot.FootMinY{matchIndex}; 
    Leg.FootMaxY{MouseIndex}(N)            = v.foot.FootMaxY{matchIndex}; 
  else
    Leg.Centroid{MouseIndex}(N,1:2)        = -1; 
    Leg.FootSize{MouseIndex}(N)            = -1; 
    Leg.FootTotalBrightness{MouseIndex}(N) = -1; 
    Leg.FootMaxBrightness{MouseIndex}(N)   = -1; 
    Leg.FootMinX{MouseIndex}(N)            = -1; 
    Leg.FootMaxX{MouseIndex}(N)            = -1; 
    Leg.FootMinY{MouseIndex}(N)            = -1; 
    Leg.FootMaxY{MouseIndex}(N)            = -1; 
  end;

% assign leg in question
  if     strcmp(Foot,'RF')
    v.MouseTrack.LegRF = Leg;
  elseif strcmp(Foot,'RH')
    v.MouseTrack.LegRH = Leg;
  elseif strcmp(Foot,'LF')
    v.MouseTrack.LegLF = Leg;
  elseif strcmp(Foot,'LH')
    v.MouseTrack.LegLH = Leg;
  end;

return;