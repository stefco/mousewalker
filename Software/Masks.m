function [DPM, picMedian] = Masks(p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [DPM, picMedian] = Masks(p)
%
% Calculate Dead Pixel Mask (DPM), average picture brightness (picAVG) and 
% picture standard deviation (picSTD). DPM is 255 everywhere where the 
% background is too bright that it should be removed from the analysis, 
% and 0 everywhere else.
%
% Calculate everything separately for RGB colors.
%
% (c) Imre Bartos, 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obtain frame file names
  Files = p.FileList;
  
% Load files in the comparison period at the end of the frame series and 
% obtain data from them.
  counter = 0;

  for i = 1 : round(length(Files)/p.BGlength) : length(Files)
    % read in next picture
      pic = PictureReader(i, p);

    % if no picture found exit  
      if pic.missing == 1, break, end;

    % increase counter
      counter = counter + 1;
      
    % put data from image to matrix
      BGmatrix.R(:,:,counter) = pic.R;
      BGmatrix.G(:,:,counter) = pic.G;
      BGmatrix.B(:,:,counter) = pic.B;      
  end;
% tic
  picMedian.R = median(BGmatrix.R,3);
  picMedian.G = median(BGmatrix.G,3);
  picMedian.B = median(BGmatrix.B,3);
% toc
%   indR = find(picMedian.R > p.BGthreshold.R);
%   indG = find(picMedian.G > p.BGthreshold.G);
%   indB = find(picMedian.B > p.BGthreshold.B);
  DPM.R = picMedian.R;
  DPM.G = picMedian.G;
  DPM.B = picMedian.B;
  DPM.R(:) = 0;
  DPM.G(:) = 0;
  DPM.B(:) = 0;
%   DPM.R(indR) = 255;
%   DPM.G(indG) = 255;
%   DPM.B(indB) = 255;
  
  
return;

% =========================================================================


