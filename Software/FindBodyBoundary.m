function [Boundary, CC, NumberOfObjects, body_cleaned] = FindBodyBoundary(PIC, p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [Boundary, CC, NumberOfObjects, body_cleaned] = FindBodyBoundary(PIC, p)
%
% Find end of tail and nose.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clean body image  
  body_cleaned = CleanPIC(PIC, p.MinBodySize);
  
% find connected parts on image again, now with the removed parts
  CC = bwconncomp(body_cleaned);  

% determine number of objects
  NumberOfObjects = length(CC.PixelIdxList);
  
% only do the rest of this if we found any body
  if NumberOfObjects > 0
  % convert linear indices to subscripts
    for i = 1 : NumberOfObjects
      [I{i},J{i}] = ind2sub(size(body_cleaned),CC.PixelIdxList{i});
    end;

  % find outline for each element
    for i = 1 : NumberOfObjects
      % find northernmost point for object
        ind = find(I{i} == min(I{i}));
        ind = ind(1);
      % trace booundaries from this point
      Boundary{i} = bwtraceboundary(body_cleaned,[I{i}(ind) J{i}(ind)],'NE');
    end;


  % find smooth version of outline
    for i = 1 : NumberOfObjects
      Boundary{i}(:,1) = smooth(Boundary{i}(:,1),p.SmoothOutline);
      Boundary{i}(:,2) = smooth(Boundary{i}(:,2),p.SmoothOutline);
    end;  
  else
    Boundary{1}(1:2) = -1;
    CC = -1;
  end;
  
  
  
return;
  