function [Tail1Centroid, Tail1Orientation, Tail1MajorAxisLength, Tail2Centroid, Tail2Orientation, Tail2MajorAxisLength, Tail3Centroid, Tail3Orientation, Tail3MajorAxisLength] ...
         = TailProperties(NumberOfObjects, indTail, indtail, Boundary, indOpposite)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Tail1Centroid, Tail1Orientation, Tail1MajorAxisLength, Tail2Centroid, Tail2Orientation, Tail2MajorAxisLength, Tail3Centroid, Tail3Orientation, Tail3MajorAxisLength] ...
%         = TailProperties(NumberOfObjects, indTail, indtail, Boundary, indOpposite)
%
% Determine properties of the tail. 
%
% - find position and orientation at three points: front, middle and back.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i = 1 : NumberOfObjects
  % do this for only those cases for which the tail was found and if tail
  % is long enough
    if indTail{i}(1) ~= -1 & length(indTail{i}) > 10
      % find orientation
      % divide tail to front, middle and end, and identify direction for each 
      % the opposite lines will be used for this
        % find middle point for all side points and their opposite points
          MidPointsX = (Boundary{i}(:,1) + Boundary{i}(indOpposite{i},1))/2;
          MidPointsY = (Boundary{i}(:,2) + Boundary{i}(indOpposite{i},2))/2;
        % calculate angle for each third
          % find points of tail that are on one side of the body (i.e. one side using the nose-tail division). 
            ind = find(indTail{i} <= indtail{i});
            indTailSide = indTail{i}(ind);
          % subselect MidPoints so it only has one side
            MidPointsX = MidPointsX(indTailSide);
            MidPointsY = MidPointsY(indTailSide);
          % length unit will be 1/15th of the tail length
            L = length(MidPointsX)/15;
          % continue only if there are enough points on one side of the tail
            if L > 0.5
              % 1st/3
                index11 = round(L);
                index12 = round(L*3);
                [Tail1Centroid{i}, Tail1Orientation{i}, Tail1MajorAxisLength{i}] = FitLine(MidPointsX(index11:index12), MidPointsY(index11:index12), MidPointsX(index11), MidPointsY(index11));
              % 2nd/3
                index21 = round(L*7);
                index22 = round(L*9);
                [Tail2Centroid{i}, Tail2Orientation{i}, Tail2MajorAxisLength{i}] = FitLine(MidPointsX(index21:index22), MidPointsY(index21:index22), MidPointsX(index21), MidPointsY(index21));
              % 3rd/3
                index31 = round(L*12);
                index32 = round(L*14);
                [Tail3Centroid{i}, Tail3Orientation{i}, Tail3MajorAxisLength{i}] = FitLine(MidPointsX(index31:index32), MidPointsY(index31:index32), MidPointsX(index31), MidPointsY(index31));
            else
              % define variables indicating that there was no data
                Tail1Centroid{i}(1:2)    = -1;
                Tail1Orientation{i}      = -1;
                Tail1MajorAxisLength{i}	 = -1;
                Tail2Centroid{i}(1:2)    = -1;
                Tail2Orientation{i}      = -1;
                Tail2MajorAxisLength{i}	 = -1;
                Tail3Centroid{i}(1:2)    = -1;
                Tail3Orientation{i}      = -1;
                Tail3MajorAxisLength{i}  = -1;                    
            end;
    else
      % define variables indicating that there was no data
        Tail1Centroid{i}(1:2)    = -1;
        Tail1Orientation{i}      = -1;
        Tail1MajorAxisLength{i}	 = -1;
        Tail2Centroid{i}(1:2)    = -1;
        Tail2Orientation{i}      = -1;
        Tail2MajorAxisLength{i}	 = -1;
        Tail3Centroid{i}(1:2)    = -1;
        Tail3Orientation{i}      = -1;
        Tail3MajorAxisLength{i}  = -1;      
    end;
end;

% if there were no objects still make placeholders for the variables
  if NumberOfObjects == 0
    Tail1Centroid(1:2)    = -1;
    Tail1Orientation      = -1;
    Tail1MajorAxisLength	 = -1;
    Tail2Centroid(1:2)    = -1;
    Tail2Orientation      = -1;
    Tail2MajorAxisLength	 = -1;
    Tail3Centroid(1:2)    = -1;
    Tail3Orientation      = -1;
    Tail3MajorAxisLength  = -1;   
  end;
  
  
  
return;