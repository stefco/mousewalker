function [BodyCentroid, BodyOrientation, BodyBackCentroid, BodyBackOrientation, HeadSide, HeadCentroid, HeadOrientation, HeadMajorAxisLength] = BodyProperties(NumberOfObjects, PIC, CC, indTail, indnose, Boundary, p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [BodyCentroid, BodyOrientation, BodyBackCentroid, BodyBackOrientation, HeadSide, HeadCentroid, HeadOrientation, HeadMajorAxisLength] = BodyProperties(NumberOfObjects, PIC, CC, indTail, indnose, Boundary, p)
%
% Find boundary points that are part of the tail by requiring that they are
% closer to their opposite than p.MouseTailMaxThickness and that they are
% farther from the nose than the characteristic head size p.HeadSideLength.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SEPARATE BODY AND IDENTIFY PARAMETERS
  for i = 1 : NumberOfObjects

    % do this for only those cases for which the tail was found
      if indTail{i}(1) ~= -1
        % create an image that only includes the current object
          PICnotail = zeros(size(PIC));
          PICnotail(CC.PixelIdxList{i}) = PIC(CC.PixelIdxList{i});

        % Remove tail from image
          if length(indTail{i}) > 2 % only execute of tail was identified
            % make polygon out of points surrounding tail
              X = [Boundary{i}(indTail{i},1); Boundary{i}(indTail{i}(1),1)];
              Y = [Boundary{i}(indTail{i},2); Boundary{i}(indTail{i}(1),2)];
            % find points on the image within this polygon
              % identify points that correspond to body+tail
                [I{i},J{i}] = ind2sub(size(PIC),CC.PixelIdxList{i});
              % find those that are within the polygon of the tail
                PartOfTailIndex{i} = inpolygon(I{i},J{i},X,Y);
            % save points of the bulk of the tail in separate variable
              TailBulk{i}(:,1) = I{i}(PartOfTailIndex{i});
              TailBulk{i}(:,2) = J{i}(PartOfTailIndex{i});
              % erase tail from temp pic
                PICnotail(TailBulk{i}(:,1),TailBulk{i}(:,2)) = 0;
          end;
          % Identify HEAD and head properties
            [HeadSide{i}, HeadCentroid{i}, HeadOrientation{i}, HeadMajorAxisLength{i}] = IdentifyHead(Boundary,indnose,i,p);
         
          % identify BODY POSITION & DIRECTION
          % Position will be center of mass of body
            % find connected parts on image
              CC2 = bwconncomp(PICnotail);

            % determine number of pixels in each group  
              numPixels = cellfun(@numel,CC2.PixelIdxList);
            % erase objects whose size is smaller than body threshold
              ind = find(numPixels < p.MinBodySize);
              for k = ind
                PICnotail(CC2.PixelIdxList{k}) = 0;
              end;
            % delineate (make things thicker)
              se90 = strel('line', 3, 90);
              se0 = strel('line', 3, 0);
              PICnotail = imdilate(PICnotail, [se90 se0]);
            % fill interior gaps
              PICnotail = imfill(PICnotail, 'holes');
            % smooth object
              seD = strel('diamond',1);
              PICnotail = imerode(PICnotail,seD);
            % find connected parts on image again, now with the removed parts
              CC2 = bwconncomp(PICnotail);            

            % find body centroid
              temp = regionprops(CC2, 'centroid');

            % exit if nothing was found
              if isempty(temp)
                BodyCentroid{i}           = [-1 -1];
                BodyOrientation{i}        = -1;
                BodyBackCentroid{i}       = [-1 -1];
                BodyBackOrientation{i}    = -1;
                HeadBulk{i}               = -1;
                HeadSide{i}               = [-1 -1];
                HeadCentroid{i}           = [-1 -1];
                HeadOrientation{i}        = -1;
                HeadMajorAxisLength{i}    = -1;
              else

                tempCentroid = temp.Centroid;
                BodyCentroid{i} = tempCentroid(2:-1:1); % change order to have x coordinate first

                % find body orientation - this will be along the line of the center of the body and the center of the head 
                  [temp1, BodyOrientation{i}, temp2] = FitLine([BodyCentroid{i}(1) HeadCentroid{i}(1)], [BodyCentroid{i}(2) HeadCentroid{i}(2)], HeadCentroid{i}(1), HeadCentroid{i}(2));

                % find orientation for back part of the body - position and direction between bodycentroid and end of tail towards the body
                  % find middle point for tail
                    TailMiddlePointX = (Boundary{i}(indTail{i}(1),1) + Boundary{i}(indTail{i}(end),1))/2;
                    TailMiddlePointY = (Boundary{i}(indTail{i}(1),2) + Boundary{i}(indTail{i}(end),2))/2;
                  [BodyBackCentroid{i}, BodyBackOrientation{i}, temp3] = FitLine([TailMiddlePointX BodyCentroid{i}(1)], [TailMiddlePointY BodyCentroid{i}(2)], BodyCentroid{i}(1), BodyCentroid{i}(2));
              end;
      else
        % handle if there was no tail and therefore couldnt run analysis
          BodyCentroid{i}           = [-1 -1];
          BodyOrientation{i}        = -1;
          BodyBackCentroid{i}       = [-1 -1];
          BodyBackOrientation{i}    = -1;
          HeadBulk{i}               = -1;
          HeadSide{i}               = [-1 -1];
          HeadCentroid{i}           = [-1 -1];
          HeadOrientation{i}        = -1;
          HeadMajorAxisLength{i}    = -1;
      end
  end;




return;