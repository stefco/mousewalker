function [indnose, indtail, Boundary] = TuneNosePoint(NumberOfObjects, Boundary, indtail, indTail, Tail1Centroid, CC, p, v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [indnose, indtail, Boundary] = TuneNosePoint(NumberOfObjects, Boundary, indtail, indTail, Tail1Centroid, CC, p, v)
%
% Find better nose point given the reconstructed tail information.
%
% (c) Imre Bartos 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for i = 1 : NumberOfObjects
    % find body centroid
      temp = regionprops(CC, 'centroid');
      centroid = temp(i).Centroid;
      centroid = centroid(2:-1:1);
    % find middle point between body centroid and tail1 point
      if Tail1Centroid{i}(1) ~= -1
        BackPoint(1) = (centroid(1) + Tail1Centroid{i}(1))/2;
        BackPoint(2) = (centroid(2) + Tail1Centroid{i}(2))/2;
      else
        BackPoint(1) = (centroid(1) + Boundary{i}(indtail{i},1))/2;
        BackPoint(2) = (centroid(2) + Boundary{i}(indtail{i},2))/2;
      end;
    % create BoundaryNoTail from which the tail points are removed (we put them at the back point so they will not be far from it)
      BoundaryNoTail = Boundary{i};
      BoundaryNoTail(indTail{i},1) = BackPoint(1);
      BoundaryNoTail(indTail{i},2) = BackPoint(2);
    % identify nose as farthest point from back of the body that's not the tail
        dist = (BoundaryNoTail(:,1) - BackPoint(1)).^2 + (BoundaryNoTail(:,2) - BackPoint(2)).^2;
        indnose{i} = find(dist == max(dist)); indnose{i} = indnose{i}(1);
    % reorganize points such that the nose should have index 1;
      % get length of bondary
        L = length(Boundary{i});
      % extend data as if it was circular so we can than cut the right part
        B = [Boundary{i}; Boundary{i}];
      % make starting point the one at the head and cut off extra
        Boundary{i} = B(indnose{i}:indnose{i}+L-1,:);
      % move indnose and indtail to their position in this new Boundary
        indtail{i} = mod(indtail{i} - indnose{i} + 1 + L,L); 
        if indtail{i} == 0, indtail{i} = L; end;
        indnose{i} = 1;      
  end;
   




return;