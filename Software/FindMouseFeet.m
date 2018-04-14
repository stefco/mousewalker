function [v] = FindMouseFeet(v,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v] = FindMouseFeet(v,p)
%
% Identify mouse feet on picture and output its position and other
% properties.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear pics of dirt (not needed as is done already in FilterImage)
  PIC = v.pic.foot;  
  
%% find fingers and paw
  
% find connected parts on image again, now with the removed parts
  CC = bwconncomp(PIC);  
 
% determine number of objects
  NumberOfObjects = length(CC.PixelIdxList);
  
% only do the rest of this if we found anything
  if NumberOfObjects > 0
    % convert linear indices to subscripts
      for i = 1 : NumberOfObjects
        [I{i},J{i}] = ind2sub(size(PIC),CC.PixelIdxList{i});
      end;

    % find outline for each element
      for i = 1 : NumberOfObjects
        % find northernmost point for object
          ind = find(I{i} == min(I{i}));
          ind = ind(1);
        % trace booundaries from this point
          Boundary{i} = bwtraceboundary(PIC,[I{i}(ind) J{i}(ind)],'NE');
      end;


    % find finger centroid
      temp = regionprops(CC, 'centroid');
      for i = 1:NumberOfObjects
        FingerCentroid{i} = temp(i).Centroid(2:-1:1); % change order to have x coordinate first  
      end;

    % % find fingers - find circles with size range defined by [p.MinFingerSize p.MaxFingerSize]
    %   [centers, radii] = imfindcircles(PIC,[p.MinFingerSize p.MaxFingerSize],'Sensitivity',0.98); % ,'Edge',0.03


    % IDENTIFY FEET - find fingers and paw that are part of the same foot by looking for ones that are near each other
      % for each pair of fingers/paws find distance
        for i = 1:NumberOfObjects
          for j = 1:NumberOfObjects
            FingerDistance(i,j) = (FingerCentroid{i}(1) - FingerCentroid{j}(1)).^2 + (FingerCentroid{i}(2) - FingerCentroid{j}(2)).^2;
          end;
        end;
      % loop over fingers: find the fingers that are within foot distance and
      % add them to the same foot. Go over all fingers/paws
        % PartOfFoot will define which paw
          PartOfFoot(1:NumberOfObjects) = 0;
        % loop over fingers/paws - make each finger part of the same foot as
        % the one previous that it is close enough to

          for i = 1:NumberOfObjects
            % if this finger still hasn't been assigned a foot, increase foot
            % counter and assign foot to this one
              if PartOfFoot(i) == 0, PartOfFoot(i) = max(PartOfFoot) + 1; end;
            % find fingers that are within reach
              ind = find(FingerDistance(i,i+1:end) <= p.MaxFingerDistance^2);
            % make these fingers part of the same foot
              PartOfFoot(ind+i) = PartOfFoot(i);
          end;      

    % COMBINE FINGERS to calculate total centroid, size etc
      % loop over separate feet identified
        for i = 1:max(PartOfFoot)
          % find fingers that are part of this foot
            ind = find(PartOfFoot == i);
          % add all points from these fingers
            X = [];
            Y = [];
            FootTotalBrightness{i} = 0;
            FootMaxBrightness{i}   = 0;
            for j = 1:length(ind)
              X = [X I{ind(j)}'];
              Y = [Y J{ind(j)}'];
            end;
            for j = 1:length(X)
              % calculate total brightness
                FootTotalBrightness{i} = FootTotalBrightness{i} + PIC(X(j),Y(j));
              % calcuate maximum brightness of foot
                FootMaxBrightness{i} = max(FootMaxBrightness{i},PIC(X(j),Y(j)));
            end;
          % calculate centroid
            FootCentroid{i}(1) = mean(X);
            FootCentroid{i}(2) = mean(Y);
          % calculate total footsize
            FootSize{i} = length(X);
          % calculate edges of foot
            FootMinX{i} = min(X);
            FootMaxX{i} = max(X);
            FootMinY{i} = min(Y);
            FootMaxY{i} = max(Y);
        end;

    % save variables for global use
      v.foot.Boundary = Boundary; 
      v.foot.FingerCentroid = FingerCentroid;
      v.foot.PartOfFoot = PartOfFoot;
      v.foot.FootCentroid = FootCentroid;
      v.foot.FootSize = FootSize;
      v.foot.FootTotalBrightness = FootTotalBrightness;
      v.foot.FootMaxBrightness = FootMaxBrightness;
      v.foot.FootMinX = FootMinX;
      v.foot.FootMaxX = FootMaxX;
      v.foot.FootMinY = FootMinY;
      v.foot.FootMaxY = FootMaxY;
      v.foot.NumberOfFeet = max(PartOfFoot);
      v.foot.NumberOfObjects = NumberOfObjects;
  else
    v.foot.NumberOfObjects = 0;
    v.foot.Boundary = -1;
    v.foot.NumberOfFeet = 0;
  end;
  
return;