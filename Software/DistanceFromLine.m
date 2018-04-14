function [DistPar, DistPerp] = DistanceFromLine(Xpoint, Ypoint, Xline, Yline)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [DistPar, DistPerp] = DistanceFromLine(Xpoint, Ypoint, Xline, Yline)
%
% Calculate distance of point {Xpoint,Ypoint} from line defined by
% {Xline,Yline}, where Xline and Yline are ordered vectors containing the
% back and front of the line, such that   
% 
% Xline := [X_back X_front]
%
% DistPerp - perpendicular disance from the line. Its sign defines the side
%            on which the point is. It is positive if it corresponds to the
%            "right side", and it is negative for the "left side".  
%
% DistPar  - parallel distance from the back of the line
%            {Xline(1),Yline(1)}, projected to the direction of the line.
%            
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% rename variables
  v1 = [Xline(1) Yline(1)];
  v2 = [Xline(2) Yline(2)];
  pt = [Xpoint   Ypoint];
  
% calculate difference vectors
  a = v2 - v1;
  b = pt - v1;
  
% calculate perpendicular distance from vector product
  d = cross([a 0],[b 0]) / norm(a);
  DistPerp = d(3);
  
% calculate parallel distance from dot product
  DistPar = dot(a,b)/norm(a);
  
return;