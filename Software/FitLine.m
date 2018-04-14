function [Centroid, BodyOrientation, BodyMajorAxisLength] = FitLine(X, Y, HeadPositionX, HeadPositionY)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [Centroid, BodyOrientation, BodyMajorAxisLength] = FitLine(X, Y, HeadPositionX, HeadPositionY)
%
% Fit line to points described by X, Y. Determine which is the forward
% direction based on the position of head HeadPosition.
%
% orientation - standard angle [deg], with 0deg pointing along the X axis
% (down on the screen), and increasing counterclockwise 
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find end that is closer to HeadPosition
  Dist1   = (HeadPositionX - X(1))^2 + (HeadPositionY - Y(1))^2;
  Distend = (HeadPositionX - X(end))^2 + (HeadPositionY - Y(end))^2;
% change direction start is closer to head
  if Dist1 < Distend
    X = X(end:-1:1);
    Y = Y(end:-1:1);
  end;

% fit in the direction that is better to avoid problem with vertical lines
  if abs(X(1) - X(end)) > abs(Y(1) - Y(end))
    if X(1) < X(2)
      FIT = polyfit(X,Y,1);
    else
      FIT = polyfit(X(2:-1:1),Y(2:-1:1),1);
    end;
    % determine centroid
      Centroid(1) = (X(1) + X(end))/2;
      Centroid(2) = FIT(1) * Centroid(1) + FIT(2);
    % determine orientation - orientation should be 0 if pointing towards the right of the screen (which is the y direction), and should grow with increasing x, which is downward 
      BodyOrientation = atan(FIT(1))*180/pi;
      if X(1) > X(2), BodyOrientation = mod(BodyOrientation + 180 + 720, 360); end;
    % determine length
      BodyMajorAxisLength = abs(X(1) - X(end))*sqrt(1+FIT(1)^2);
  else
    % handle redundant data
      if Y(1) == Y(2)
        Centroid            = [-1 -1];
        BodyOrientation     = -1;
        BodyMajorAxisLength = -1;
        return;
      end;
    if Y(1) < Y(2)
      FIT = polyfit(Y,X,1);
    else
      FIT = polyfit(Y(2:-1:1),X(2:-1:1),1);
    end;     
    % determine centroid
      Centroid(2) = (Y(1) + Y(end))/2;
      Centroid(1) = FIT(1) * Centroid(2) + FIT(2);
    % determine orientation - orientation should be 0 if pointing towards the right of the screen (which is the y direction), and should grow with increasing x, which is downward 
      BodyOrientation = mod(720 - atan(FIT(1))*180/pi + 90,360);
      if Y(1) > Y(2), BodyOrientation = mod(BodyOrientation + 180 + 720, 360); end;
    % determine length
      BodyMajorAxisLength = abs(Y(1) - Y(end))*sqrt(1+FIT(1)^2);
  end; 

  % something went wrong just make values -1
    if max(isnan([Centroid BodyOrientation BodyMajorAxisLength]))
        Centroid            = [-1 -1];
        BodyOrientation     = -1;
        BodyMajorAxisLength = -1;
    end;

return