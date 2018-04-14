function pic = PictureReader(index, p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in a picture with the given index and folder name
%
% INPUTS:
% index          - the # in the file name.
% p.smoothing    - 0 if there should be no smoothing. 'n' if there should 
%                  be smoothing over a distance of n from a given pixel. 
%                  E.g. if smoothing is 2 then the pixels value will be the 
%                  average of the pixels over a 2*n+1 rectangle centered 
%                  around the pixel.
% p.inputFolderName   - folder name where the frame files are.
% p.FileList     - list of frames
%
% OUTPUT:
% pic.raw.R      - picture from the frame file (RED)
% pic.raw.G      - picture from the frame file (GREEN)
% pic.raw.B      - picture from the frame file (BLUE)
% pic.R          - picture after applied smoothing and side cuts (RED)
% pic.G          - picture after applied smoothing and side cuts (GREEN)
% pic.B          - picture after applied smoothing and side cuts (BLUE)
% pic.missing    - 1 if the program had trouble reading in the image
%
%
% (c) Imre Bartos 2013 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% determine file name of actual frame, but only if we are working with frames
  if p.VideoInput == 0
    fullpicturename = sprintf('%s%s', AddSlash(p.inputFolderName), p.FileList(index,:));
  end;

  try
    % load frame
      if p.VideoInput == 0
        rawpic = (imread(fullpicturename));
      else
        rawpic = read(p.VideoObject,index);
      end;
      
    % save original raw pic for drawing
      pic.rawpic = rawpic;

    % if this is a black and white picture, make the three colors the same
      if size(rawpic,3) == 1
        % decompose frame to three colors
          pic.raw.R = rawpic;    
          pic.raw.G = rawpic;    
          pic.raw.B = rawpic;
      else
        % decompose frame to three colors
          pic.raw.R = rawpic(:,:,1);    
          pic.raw.G = rawpic(:,:,2);    
          pic.raw.B = rawpic(:,:,3);    
      end;
    % invert if selected
      if p.invert == 1
          pic.raw.R = 255 - pic.raw.R;
          pic.raw.G = 255 - pic.raw.G;
          pic.raw.B = 255 - pic.raw.B;
      end;
    % indicate that pic is not missing
      pic.missing = 0;
     
  catch ME1
    % if something went wrong with reading the picture, indicate that it's missing
      disp('Something went wrong with reading the picture...')
      pic.missing = 1;
    % initialize everything  
      pic.R       = [];
      pic.G       = [];
      pic.B       = [];
      pic.raw.R   = [];
      pic.raw.G   = [];
      pic.raw.B   = [];
  end;

  % convert picture to double from uint8
    pic.raw.R = double(pic.raw.R) + 1;
    pic.raw.G = double(pic.raw.G) + 1;
    pic.raw.B = double(pic.raw.B) + 1;


  % cut out unnecessary parts from the side
    if p.cut.up ~= 0 | p.cut.down ~= 0 | p.cut.left ~= 0 | p.cut.right ~= 0
      rawpictempR = pic.raw.R(max(p.cut.up,1):end-p.cut.down,max(p.cut.left,1):end-p.cut.right);
      rawpictempG = pic.raw.G(max(p.cut.up,1):end-p.cut.down,max(p.cut.left,1):end-p.cut.right);
      rawpictempB = pic.raw.B(max(p.cut.up,1):end-p.cut.down,max(p.cut.left,1):end-p.cut.right);
    else
      rawpictempR = pic.raw.R;
      rawpictempG = pic.raw.G;
      rawpictempB = pic.raw.B;
    end;

% smooth picture
  if p.smoothing ~= 0
      AddR = rawpictempR;
      AddG = rawpictempG;
      AddB = rawpictempB;
      AddR(:,:) = 0;
      AddG(:,:) = 0;
      AddB(:,:) = 0;
      n = p.smoothing;
      for i = -n:n
          for j = -n:n
              AddR(n+2:end-n-2,n+2:end-n-2) = AddR(n+2:end-n-2,n+2:end-n-2) + rawpictempR(n+2+i:end-n-2+i,n+2+j:end-n-2+j);
              AddG(n+2:end-n-2,n+2:end-n-2) = AddG(n+2:end-n-2,n+2:end-n-2) + rawpictempG(n+2+i:end-n-2+i,n+2+j:end-n-2+j);
              AddB(n+2:end-n-2,n+2:end-n-2) = AddB(n+2:end-n-2,n+2:end-n-2) + rawpictempB(n+2+i:end-n-2+i,n+2+j:end-n-2+j);
          end;
      end;
      rawpictempR = AddR ./ (2*n+1)^2;
      rawpictempG = AddG ./ (2*n+1)^2;
      rawpictempB = AddB ./ (2*n+1)^2;
  end;
  
  pic.R = rawpictempR;
  pic.G = rawpictempG;
  pic.B = rawpictempB;
  

  clear zeros index picturename rawpic2 fullpicturename rawpic;
  
return;