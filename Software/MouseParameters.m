function p = MouseParameters()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function Param = MouseParameters()
%
% Define parameters that will be used of the analysys
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decide what to PLOT (1 - original image; 2 - body image; 3 - foot image)
% this basically decides whether to use any filter to select body or foot before plotting
  p.WhatToPlot = 3;

% Invert brightness
% 1 - invert
% 0 - no change
  p.invert = 0; % Inverted colors

% Foot/Body identification inversion. Decide whether either should be searched for in the inverse background subtracted field
  p.foot.inversion = 0;
  p.body.inversion = 0;
  p.tail.inversion = 0;
  
% FoodBody color in which the program should search for them
  p.foot.color = 'R';
  p.body.color = 'R';
  p.tail.color = 'R';
  
% background - max brightness offset (above BG STD) that is considered background compared to BG average 
  p.BGoffset.R = 20;
  p.BGoffset.G = 20;
  p.BGoffset.B = 20;  
  
% define whether use filter (1-yes; 0-no)
  p.useFilter = 1;  
  
% Filter background length is the number of frames at the end of the series of frames in
% the frame folder that will be used for calculating the background masks.
  p.BGlength = 10; % Background length [frames]      
%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BOUNDARY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define part of the images that is used for the analysis. Each part
% defines the number of pixels ommited. E.g. cut.up = 50 means that the top
% 50 rows of the picture is omitted.
  p.cut.up = 0;
  p.cut.down = 0;
  p.cut.right = 0;
  p.cut.left = 0;  

%==========================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRACK PLOT SETTINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot nose (1 - yes; 0 - no)   
  p.PlotNose = 1;  
% plot head center (1 - yes; 0 - no)  
  p.PlotHeadCenter = 1;
% plot head contour (1 - yes; 0 - no)  
  p.PlotHeadContour = 1;
% plot body center (1 - yes; 0 - no)  
  p.PlotBodyCenter = 1;
% plot body back center (1 - yes; 0 - no)  
  p.PlotBodyBackCenter = 1;
% plot tail1-3 center (1 - yes; 0 - no)  
  p.PlotTail1Center = 1;
  p.PlotTail2Center = 1;
  p.PlotTail3Center = 1;
% plot tail contour (1 - yes; 0 - no)  
  p.PlotTailContour = 1;
% plot feet (1 - yes; 0 - no)  
  p.PlotFeet = 1;

  
% contour line width for head and tail  
  p.ContourLineWidth = 2;  
  
% size of circle showing feet
  p.FootMarkerSize = 25;
  
% font size of legs
  p.FootFontSize = 14;
  
% length and width of bar showing direction of body, head and tail
% (width=linewidth; length in pixels), and size of centroid (markersize)
  p.DirectionBarLength = 30;  
  p.DirectionBarWidth  = 1;  
  p.CentroidMarkerSize = 5;  
  
% define colors
%   p.colorFront  = [255;255;0]/255;
  p.colorFront   = [9;249;17]/255;
  p.colorHind = [3;180;200]/255;

% defines the colormap of the picture
% Options: 'Jet', 'HSV', 'Hot', 'Cool', 'Spring', 'Summer', 'Autumn',
% 'Winter', 'Gray', 'Bone', 'Copper', 'Pink', 'Lines'
  p.color = 'hot'; % Colormap  

% plot images for each frame while in auto analysis mode
  p.drawwhileauto = 1;

% brightness factor of body and feet
  p.bodybrightness = 4;
  p.tailbrightness = 4;
  p.footbrightness = 4;
  
% Set forced direction in which the body is required to face during autotracking
% 1 - no forced direction (N/A); 2 - up; 3 - down; 4 - left; 5 - right.
  p.ForceDirection = 1;

%========================================================================== 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRACKING PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Threshold brightness for the feet, body and tail. 
  p.body.threshold.low = 4; 
  p.body.threshold.high = 255; 
  p.foot.threshold.low = 4; 
  p.foot.threshold.high = 255; 
  p.tail.threshold.low = 4; 
  p.tail.threshold.high = 255; 

% Define the minimum size of coherent pixels that are identified as parts of a body. 
  p.MinBodySize = 29000;  
% Define the minimum size of coherent pixels that are identified as parts of a tail part. 
  p.MinTailSize = 1000;  
% Define the minimum size of coherent pixels that are identified as parts of a foot part. 
  p.MinFootSize = 10;  
  
% Define min and max size of a small part of a foot, e.g. a finger
  p.MinFingerSize = 2;  
  p.MaxFingerSize = 8;  
  
% Max finger distance within which we consider them part of one foot
  p.MaxFingerDistance = 30;

% Mouse tail thickness -- the point where the body gets thicker than this
% is the end of the tail and the beginning of the body
  p.MouseTailMaxThickness = 30;
  
% length of head from nose to end along the side
  p.HeadSideLength = 120;
  
% maximum distance that the body is assumed to be able to move between two consecutive frames in order to be followed
  p.maxBodyStep = 100;
  
% maximum distance that a footprint is allowed to move between two consecutive frames in order to be considered the same footprint 
  p.maxFootStep = 10;  
  
% for evaluation only. If -1, the program will take the median measured value for the body length from nose to beginning of tail as the body length.
% if >0, for the evaluation this value will be used as the length of the body
  p.FixedBodyLength = -1;
  
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER SETTINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frame per second
  p.fps = 250;
  
% pixel <-> mm conversion: how many pixel is 1 mm
  p.mm2pix =  3;
  
% plot lengthbar (1 - plot; 0 - don't plot)  
  p.lengthbar = 0;
%==========================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER SETTINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% these are not important for the user for now, they may help speeding up
% the process

% define which colors will be used
  p.useRedColor   = 1;
  p.useGreenColor = 1;
  p.useBlueColor  = 1;

% Defines level of smoothing of the frame pictures.
% 0 if there should be no smoothing. 
% 'n' if there should be smoothing over a distance of n from a given pixel. 
% E.g. if smoothing is 2 then the pixels value will be the average of the 
% pixels over a 2*n+1 rectangle centered around the pixel.
  p.smoothing = 0; % Smoothing   
  
% The points of the outline of the mouse body will be smoothed as smooth(points, p.SmoothOutine).   
  p.SmoothOutline = 20;  
  
% brightness threshold. The picture will be cut out for pixels which exceed 
% this threshold, on average, in the reference pictures.
  p.BGthreshold.R = 255; % Background threshold [0-255]
  p.BGthreshold.G = 255; % Background threshold [0-255]
  p.BGthreshold.B = 255; % Background threshold [0-255]  
%==========================================================================






  

  
  
% Define start path for loading and saving data separately. If start_path does not exist the 
% program will resume to the Matlab directory. After using the program, it
% will always start with the directory that was last specified.
  p.inputFolderName = '<SPECIFY INPUT DIRECTORY>'; % Input directory path
  p.outputFolderName = '<default>'; % Results directory path  
   
  
  


  
  
  
  
%% PLOT PARAMETERS  
  

  

  

return;