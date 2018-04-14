function [indTail] = FindTail(NumberOfObjects, Boundary, indOpposite, indnose, indtail, p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [indTail] = FindTail(NumberOfObjects, Boundary, indOpposite, indnose, indtail, p)
%
% Find boundary points that are part of the tail by requiring that they are
% closer to their opposite than p.MouseTailMaxThickness and that they are
% farther from the nose than the characteristic head size p.HeadSideLength.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for i = 1 : NumberOfObjects
    if indOpposite{i} ~= -1
      % find side points which are closer to opposite point than p.MouseTailMaxThickness
        distancetemp = (Boundary{i}(indOpposite{i},1) - Boundary{i}(:,1)).^2 + (Boundary{i}(indOpposite{i},2) - Boundary{i}(:,2)).^2;
        ind = find(distancetemp <= p.MouseTailMaxThickness^2);
      % find farthest point from the head that is not tail
        indnotail = find(distancetemp > p.MouseTailMaxThickness^2);
        % if everything is a big tail then the nose is the end of tail
          if isempty(indnotail)
            indendofnotail = indnose{i};
          else
            indendofnotail = indnotail(indnotail < indtail{i});
            indendofnotail = indendofnotail(end);
          end;
      % assign those points to the tail that are farther then the end of the tail
        ind2 = find(ind > indendofnotail & ind < indOpposite{i}(indendofnotail));
        % handle the case when there is nothing in this vector
          if ~isempty(ind2)
            indTail{i} = ind(ind2);
          else
            indTail{i} = indtail{i};
          end;
    else
      indTail{i} = indtail{i};
    end;
  end;  
  
return;