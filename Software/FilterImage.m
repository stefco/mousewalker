function v = FilterImage(v,p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function v = FilterImage(v,p)
%
% filter image with masks defined in Masks(p) and assigne pic.foot and
% pic.body based on color and inversion parameters.
%
% (c) Imre Bartos 2013
  

% make pixels that are within mask 0
    if p.invert == 0
      % find pixels that are within RED mask
        Rtemp = abs(v.pic.R - p.picMedian.R);
      % find pixels that are within GREEN mask
        Gtemp = abs(v.pic.G - p.picMedian.G);
      % find pixels that are within BLUE mask
        Btemp = abs(v.pic.B - p.picMedian.B);
    else
      % find pixels that are within RED mask
        Rtemp = abs(255 - v.pic.R - p.picMedian.R);
      % find pixels that are within GREEN mask
        Gtemp = abs(255 - v.pic.G - p.picMedian.G);
      % find pixels that are within BLUE mask
        Btemp = abs(255 - v.pic.B - p.picMedian.B);
    end;

    % make those pixels zero that are within the error bar of all three colors    
      FILTERind = find(Rtemp <= p.BGoffset.R & Gtemp <= p.BGoffset.G & Btemp <= p.BGoffset.B);

    % apply masks 
      v.pic.filtered.R = v.pic.R;
      v.pic.filtered.G = v.pic.G;
      v.pic.filtered.B = v.pic.B;
      v.pic.filtered.R(FILTERind) = 0;
      v.pic.filtered.G(FILTERind) = 0;
      v.pic.filtered.B(FILTERind) = 0;
      
      if (p.foot.inversion == 1 & strcmp(p.foot.color,'R')) | (p.body.inversion == 1 & strcmp(p.body.color,'R')) | (p.tail.inversion == 1 & strcmp(p.tail.color,'R'))
        v.pic.invfiltered.R = 255 - v.pic.R;
        v.pic.invfiltered.R(FILTERind) = 0;
      end;
      if (p.foot.inversion == 1 & strcmp(p.foot.color,'G')) | (p.body.inversion == 1 & strcmp(p.body.color,'G')) | (p.tail.inversion == 1 & strcmp(p.tail.color,'G'))
        v.pic.invfiltered.G = 255 - v.pic.G;
        v.pic.invfiltered.G(FILTERind) = 0;
      end;
      if (p.foot.inversion == 1 & strcmp(p.foot.color,'B')) | (p.body.inversion == 1 & strcmp(p.body.color,'B')) | (p.tail.inversion == 1 & strcmp(p.tail.color,'B'))
        v.pic.invfiltered.B = 255 - v.pic.B;
        v.pic.invfiltered.B(FILTERind) = 0;
      end;


% identify picture in which the program should search for feet and body  
  if     strcmp(p.foot.color,'R') & p.foot.inversion == 0; v.pic.foot = v.pic.filtered.R - p.DPM.R;
  elseif strcmp(p.foot.color,'R') & p.foot.inversion == 1, v.pic.foot = v.pic.invfiltered.R - p.DPM.R; 
  elseif strcmp(p.foot.color,'G') & p.foot.inversion == 0, v.pic.foot = v.pic.filtered.G - p.DPM.G; 
  elseif strcmp(p.foot.color,'G') & p.foot.inversion == 1, v.pic.foot = v.pic.invfiltered.G - p.DPM.G; 
  elseif strcmp(p.foot.color,'B') & p.foot.inversion == 0, v.pic.foot = v.pic.filtered.B - p.DPM.B; 
  elseif strcmp(p.foot.color,'B') & p.foot.inversion == 1, v.pic.foot = v.pic.invfiltered.B - p.DPM.B; end;
  if     strcmp(p.body.color,'R') & p.body.inversion == 0, v.pic.body = v.pic.filtered.R - p.DPM.R; 
  elseif strcmp(p.body.color,'R') & p.body.inversion == 1, v.pic.body = v.pic.invfiltered.R - p.DPM.R; 
  elseif strcmp(p.body.color,'G') & p.body.inversion == 0, v.pic.body = v.pic.filtered.G - p.DPM.G; 
  elseif strcmp(p.body.color,'G') & p.body.inversion == 1, v.pic.body = v.pic.invfiltered.G - p.DPM.G; 
  elseif strcmp(p.body.color,'B') & p.body.inversion == 0, v.pic.body = v.pic.filtered.B - p.DPM.B; 
  elseif strcmp(p.body.color,'B') & p.body.inversion == 1, v.pic.body = v.pic.invfiltered.B - p.DPM.B; end;
  if     strcmp(p.tail.color,'R') & p.tail.inversion == 0, v.pic.tail = v.pic.filtered.R - p.DPM.R; 
  elseif strcmp(p.tail.color,'R') & p.tail.inversion == 1, v.pic.tail = v.pic.invfiltered.R - p.DPM.R; 
  elseif strcmp(p.tail.color,'G') & p.tail.inversion == 0, v.pic.tail = v.pic.filtered.G - p.DPM.G; 
  elseif strcmp(p.tail.color,'G') & p.tail.inversion == 1, v.pic.tail = v.pic.invfiltered.G - p.DPM.G; 
  elseif strcmp(p.tail.color,'B') & p.tail.inversion == 0, v.pic.tail = v.pic.filtered.B - p.DPM.B; 
  elseif strcmp(p.tail.color,'B') & p.tail.inversion == 1, v.pic.tail = v.pic.invfiltered.B - p.DPM.B; end;
  

% filter out everything that is above or below the thresholds
  v.pic.foot(v.pic.foot < p.foot.threshold.low)  = 0;
  v.pic.foot(v.pic.foot > p.foot.threshold.high) = 0;
  v.pic.body(v.pic.body < p.body.threshold.low)  = 0;
  v.pic.body(v.pic.body > p.body.threshold.high) = 0;
  % only do tail if it is not disabled
    if p.tail.threshold.low >= 0 & p.tail.threshold.high >= 0
      v.pic.tail(v.pic.tail < p.tail.threshold.low)  = 0;
      v.pic.tail(v.pic.tail > p.tail.threshold.high) = 0;
    else
      v.pic.tail(:) = 0;
    end; 

% filter out everything that is smaller than what we are looking for
  v.pic.body = CleanPIC(v.pic.body, p.MinBodySize);
  v.pic.foot = CleanPIC(v.pic.foot, p.MinFingerSize);
  % only do tail if it is not disabled
    if p.tail.threshold.low >= 0 & p.tail.threshold.high >= 0
      v.pic.tail = CleanPIC(v.pic.tail, p.MinTailSize);
    end; 
  
% generate original image in body color
  if     strcmp(p.body.color,'R')
    v.pic.original = v.pic.filtered.R;
  elseif strcmp(p.body.color,'G')
    v.pic.original = v.pic.filtered.G;
  elseif strcmp(p.body.color,'B')
    v.pic.original = v.pic.filtered.B;
  end;
  
return;