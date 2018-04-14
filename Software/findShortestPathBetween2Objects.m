function pathPixelsIdxList = findShortestPathBetween2Objects(varargin)
	% FINDSHORTESTPATHBETWEEN2OBJECTS Find the shortest path between 
	% two objects in the image.
	%     PATHPIXELSIDXLIST = FINDSHORTESTPATHBETWEEN2OBJECTS(IMGPATH/POINTSPOSITIONS, ONEPATHONLY, MASK)
	% 	  returns indexes of pixels representing the shortest path(s) between 
	%	  the two objects or points. If the argument imgPath is given, the 
	%     shortest path between the two objects in the image will be found.
	%     If the pointsPositions argument is given, the shortest path between
	%     the two points is found. If the argument onePathOnly is true, the 
	%     only one central path will be returned even if there are multiple 
	%     paths of the same length. If the mask image is provided, the path
	%     will be such that it doesn't go through the objects in the mask.

	if nargin < 1
		error('The imgPath argument is a required!');
	elseif nargin < 2
		error('The onePathOnly argument is a required!');
	end

	if isfloat(varargin{1})
		pointsPositions = varargin{1};
	elseif ischar(varargin{1})
		imgPath = varargin{1};
	end
	onePathOnly = varargin{2};
	if nargin == 3
		mask = varargin{3};
	end
	
	if exist('imgPath') && exist(imgPath, 'file') ~= 2
		error(['The image file ' imgPath ' was not found!']);
	end

	if exist('imgPath')
		imgOrig = imread(imgPath);
	    % The objects in the image have to be light, the background dark.
	    img = im2bw(imgOrig);
	end

    if nargin < 3 && exist('imgPath')
		mask = logical(ones(size(img)));
	else
		mask = ~im2bw(mask);
	end
	
	if exist('imgPath') && numel(mask) ~= numel(img)
		error(['The mask matrix must be of the same size as '...
			'the image matrix on imgPath!']);
	end
	
    if exist('imgPath')
    	objectsPixelsIdxList = findObjectsPixelIdxLists(img);
    	[object1Img, object2Img] = isolateObjects(img, objectsPixelsIdxList);
    	dist1 = bwdistgeodesic(mask, object1Img, 'quasi-euclidean');
    	dist2 = bwdistgeodesic(mask, object2Img, 'quasi-euclidean');
    elseif exist('pointsPositions')
    	dist1 = bwdistgeodesic(mask, pointsPositions(1), pointsPositions(2), 'quasi-euclidean');
    	dist2 = bwdistgeodesic(mask, pointsPositions(3), pointsPositions(4), 'quasi-euclidean');
    end
    distSum = dist1 + dist2;
    % Round the distance transform values to multiples of 1/8 to avoid 
    % problems due to single-precision relative floating-point precision.
    distSum = round(distSum * 8) / 8;
    distSum(isnan(distSum)) = inf;
    % Matrix of 1's where the shortest paths are, 0's everywhere else.
    shortestPathMap = imregionalmin(distSum);
    if onePathOnly
    	shortestPathMap = bwmorph(shortestPathMap, 'thin', inf);
    end
    
    pathPixelsIdxList = find(shortestPathMap == 1);

function pixelIdxLists = findObjectsPixelIdxLists(img)
	% FINDOBJECTSPIXELIDXLISTS Find indexes of the pixels of the two objects 
	% in the image.
	% PIXELIDXLISTS = FINDOBJECTSPIXELIDXLISTS(img) returns a cell structure
	% of two lists of indexes of the two objects, one list per object.

    CC = bwconncomp(img);
    if (numel(CC.PixelIdxList) ~= 2)
    	error('More than 2 objects were found in the image!');
    end
    pixelIdxLists = CC.PixelIdxList;
    
function [object1Img, object2Img] = isolateObjects(img, objectsPixelsIdxList)
	% ISOLATEOBJECTS Isolates the two objects in the image and returns two 
	% individual images with one object on each image.
	% [OBJECT1IMG, OBJECT2IMG] = ISOLATEOBJECTS(IMG, OBJECTSPIXELSIDXLIST) 
	% Isolate the two objects in img and return two separate images where 
	% the first image contains only the first object and the second image 
	% only the second object.
	object1Img = img;
	object1Img(objectsPixelsIdxList{2}) = 0;
	object2Img = img;
	object2Img(objectsPixelsIdxList{1}) = 0;
