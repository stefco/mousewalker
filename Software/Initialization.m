function [v, p] = Initialization()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [v, p] = Initialization()
%
% Initialize parameters and workspace for first run.
%
% (c) Imre Bartos, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% load parameters
  if exist('ParametersDefault.mat', 'file')
    load('ParametersDefault.mat');
  else
    p = MouseParameters();
  end;
    
% initialize variables struct  
  v = [];

% initialize mouse and feet tracker
  % number of mice tracked
     v.MouseTrack.NumberOfMice = 0;
  % time starts at zero
    v.time = 0;


    
    
return;