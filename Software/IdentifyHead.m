function [HeadSide, HeadCentroid, HeadOrientation, HeadMajorAxisLength] = IdentifyHead(Boundary,indnose,i,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [HeadSide, HeadCentroid, HeadOrientation, HeadMajorAxisLength] = IdentifyHead(Boundary,indnose,i,p)
%
% Find head and head properties. Output should be something{i}.
%
% (c) Imre Bartos 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % identify HEAD and find points in it
          % find points that are within p.HeadSideLength from the front point
            distancetemp = (Boundary{i}(:,1) - Boundary{i}(indnose{i},1)).^2 + (Boundary{i}(:,2) - Boundary{i}(indnose{i},2)).^2;
            ind = find(distancetemp < p.HeadSideLength^2);
            HeadSide(:,1) = Boundary{i}(ind,1);
            HeadSide(:,2) = Boundary{i}(ind,2);

        % identify DIRECTION OF HEAD
          % find two points for which the circumference of the triangle with nose is greatest 
            % find the point that is farthest away from the nose
              distancetemp = (HeadSide(:,1) - Boundary{i}(indnose{i},1)).^2 + (HeadSide(:,2) - Boundary{i}(indnose{i},2)).^2;
              ind2 = find(distancetemp == max(distancetemp)); ind2 = ind2(1);
            % find distance of each HeadSide point from the point farthest from the nose
              distancetemp2 = (HeadSide(:,1) - HeadSide(ind2,1)).^2 + (HeadSide(:,2) - HeadSide(ind2,2)).^2;
            % find distance of each HeadSide point from the nose
              distancetemp3 = (HeadSide(:,1) - Boundary{i}(indnose{i},1)).^2 + (HeadSide(:,2) - Boundary{i}(indnose{i},2)).^2;
            % find total circumference of triangle with nose, the farthest point from the nose, and a third point
              circumferencetemp = distancetemp + distancetemp2 + distancetemp3;
            % find the point for which this circumference is greatest, i.e. the one that is the farthest from the nose on the side other than the farthest point 
              ind = find(circumferencetemp == max(circumferencetemp)); ind = ind(1);
            % find middle point between two farthest points, and add that to the nose point to define the ends of the line along the head
              HeadLineX{i} = [(HeadSide(ind2,1) + HeadSide(ind,1))/2 Boundary{i}(indnose{i},1)];
              HeadLineY{i} = [(HeadSide(ind2,2) + HeadSide(ind,2))/2 Boundary{i}(indnose{i},2)];
            % find centroid and orientation of head
              [HeadCentroid, HeadOrientation, HeadMajorAxisLength] = FitLine([HeadLineX{i} Boundary{i}(indnose{i},1)], [HeadLineY{i} Boundary{i}(indnose{i},2)], Boundary{i}(indnose{i},1), Boundary{i}(indnose{i},2));
return;