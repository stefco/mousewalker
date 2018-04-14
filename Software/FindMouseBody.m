function [v] = FindMouseBody(v,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v] = FindMouseBody(v,p)
%
% Identify mouse body on picture and output its position and other
% properties.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% remane picture for simplicity
  PIC = v.pic.body;

% find boundary of each body and smooth image
  [Boundary, CC, NumberOfObjects, body_cleaned] = FindBodyBoundary(PIC, p);

% continue only if there is body  
  if Boundary{1}(1) ~= -1  

    % identify tail and nose point on the boundary and make boundary start with nose point 
      [indnose, indtail, Boundary] = FindTailNosePoints(NumberOfObjects, Boundary, CC, p, v);    

    % find crosslines of body -- the lines connecting the closest points on the two sides
      [indOpposite] = FindBodyOppositeSide(NumberOfObjects, Boundary, indnose, indtail, p);

    % find tail - find points that are on the sides of the tail  
      [indTail] = FindTail(NumberOfObjects, Boundary, indOpposite, indnose, indtail, p);
      
    % tail properties - determine properties of tail
      [Tail1Centroid, Tail1Orientation, Tail1MajorAxisLength, Tail2Centroid, Tail2Orientation, Tail2MajorAxisLength, Tail3Centroid, Tail3Orientation, Tail3MajorAxisLength] ...
        = TailProperties(NumberOfObjects, indTail, indtail, Boundary, indOpposite);
      
    % finetune nose point with tail information
      [indnose, indtail, Boundary] = TuneNosePoint(NumberOfObjects, Boundary, indtail, indTail, Tail1Centroid, CC, p, v);

    % REPEAT with finetuned nose: find crosslines of body -- the lines connecting the closest points on the two sides
      [indOpposite] = FindBodyOppositeSide(NumberOfObjects, Boundary, indnose, indtail, p);

    % REPEAT with finetuned nose: find tail - find points that are on the sides of the tail  
      [indTail] = FindTail(NumberOfObjects, Boundary, indOpposite, indnose, indtail, p);
      
    % REPEATs with finetuned nose: tail properties - determine properties of tail
      [Tail1Centroid, Tail1Orientation, Tail1MajorAxisLength, Tail2Centroid, Tail2Orientation, Tail2MajorAxisLength, Tail3Centroid, Tail3Orientation, Tail3MajorAxisLength] ...
        = TailProperties(NumberOfObjects, indTail, indtail, Boundary, indOpposite);
      
    % body properties - determine properties of the body
      [BodyCentroid, BodyOrientation, BodyBackCentroid, BodyBackOrientation, HeadSide, HeadCentroid, HeadOrientation, HeadMajorAxisLength] ...
        = BodyProperties(NumberOfObjects, PIC, CC, indTail, indnose, Boundary, p);

    % save variables for global use
      v.pic.body_cleaned = body_cleaned;
      v.body.Boundary = Boundary;
      v.body.CC = CC;
      v.body.NumberOfObjects = NumberOfObjects;
      v.body.indnose = indnose;
      v.body.HeadSide = HeadSide;
      v.body.HeadCentroid = HeadCentroid;
      v.body.HeadOrientation = HeadOrientation;
      v.body.indOpposite = indOpposite;
      v.body.BodyCentroid = BodyCentroid;
      v.body.BodyOrientation = BodyOrientation;
      v.body.BodyBackCentroid = BodyBackCentroid;
      v.body.BodyBackOrientation = BodyBackOrientation;
      v.body.Tail1Centroid   = Tail1Centroid;
      v.body.Tail1Orientation = Tail1Orientation;
      v.body.Tail2Centroid   = Tail2Centroid;
      v.body.Tail2Orientation = Tail2Orientation;
      v.body.Tail3Centroid   = Tail3Centroid;
      v.body.Tail3Orientation = Tail3Orientation;
      v.body.indtail = indtail;
      v.body.indTail = indTail;
  else
    v.pic.body_cleaned = PIC;
    v.body.Boundary = -1;
    v.body.NumberOfObjects = 0;
    v.body.indnose = 0;
  end;


  

return;


