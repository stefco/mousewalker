function [indOpposite] = FindBodyOppositeSide(NumberOfObjects, Boundary, indnose, indtail, p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [indOpposite] = FindBodyOppositeSide(NumberOfObjects, Boundary, indnose, indtail, p)
%
% Find indices for each point that connects it to the closest point on the
% opposite side of the mouse, where the two sides are defined by the
% boundary points divided by the nose and tail points.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for i = 1 : NumberOfObjects
  
    % separate boundary points on two sides (remember that Boundary starts with the nose (index_nose = 1))
      indSide1x{i} = Boundary{i}(1:indtail{i}-1, 1);
      indSide1y{i} = Boundary{i}(1:indtail{i}-1, 2);
      indSide2x{i} = Boundary{i}(indtail{i}:end, 1);
      indSide2y{i} = Boundary{i}(indtail{i}:end, 2);
      
    if ~isempty(indSide1x{i}) & ~isempty(indSide1y{i}) & ~isempty(indSide2x{i}) & ~isempty(indSide2y{i})
      % find opposite sides  
        % find shortest connection between opposite sides
          for j = 1:length(indSide1x{i})
            distancetemp = (indSide2x{i} - indSide1x{i}(j)).^2 + (indSide2y{i} - indSide1y{i}(j)).^2;
            indtemp = find(distancetemp == min(distancetemp));
            indOpposite1{i}(j) = indtemp(1);
          end;
          for j = 1:length(indSide2x{i})
            distancetemp = (indSide1x{i} - indSide2x{i}(j)).^2 + (indSide1y{i} - indSide2y{i}(j)).^2;
            indtemp = find(distancetemp == min(distancetemp));
            indOpposite2{i}(j) = indtemp(1);
          end;
        % find the points where both sides lose the same amount compared to the optimal
          for j = 1:length(indSide1x{i})
            % for this pixel, pair it with every pixel on the opposite side and calculate the mutual loss if they were paired compared to
            % both being paired with their optimal
              distancetemp  = (indSide2x{i} - indSide1x{i}(j)).^2 + (indSide2y{i} - indSide1y{i}(j)).^2;
              distancetemp2 = (indSide2x{i} - indSide1x{i}(indOpposite2{i})).^2 + (indSide2y{i} - indSide1y{i}(indOpposite2{i})).^2;
              totaldistancetemp = distancetemp - distancetemp2;
              indtemp = find(totaldistancetemp == min(totaldistancetemp));
              indOpposite1improved{i}(j) = indtemp(1)+indtail{i}-1;
          end;        
          for j = 1:length(indSide2x{i})
            % for this pixel, pair it with every pixel on the opposite side and calculate the mutual loss if they were paired compared to
            % both being paired with their optimal
              distancetemp  = (indSide1x{i} - indSide2x{i}(j)).^2 + (indSide1y{i} - indSide2y{i}(j)).^2;
              distancetemp2 = (indSide1x{i} - indSide2x{i}(indOpposite1{i})).^2 + (indSide1y{i} - indSide2y{i}(indOpposite1{i})).^2;
              totaldistancetemp = distancetemp - distancetemp2;
              indtemp = find(totaldistancetemp == min(totaldistancetemp));
              indOpposite2improved{i}(j) = indtemp(1);
          end;        
      % merge opposite indices from the two sides
        indOpposite{i} = [indOpposite1improved{i} indOpposite2improved{i}];
    else
      indOpposite{i} = -1;
    end
  end;  

  return;
  