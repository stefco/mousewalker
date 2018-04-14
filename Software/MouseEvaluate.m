function MouseEvaluate(handles, DataFileName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function MouseEvaluate(handles,DataFileName)
%
% Evaluate, save and plot results obtained from mouse.
%
% (c) Imre Bartos 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameter to turn plot on or off for the purposes of testing (1-on; 0-off)
  PLOT = 1;
% parameter to turn excel file generation on/off (1-on; 0-off)
  EXCEL = 1;
% parameter to turn plot of step collections on or off for the purposes of testing (1-on; 0-off)
  PLOTSTEPS = 0;
% parameter to turn plot of images with all steps on them on or off for the purposes of testing (1-on; 0-off)
  PLOTSTEPSALL = 0;
  
% if there is filename given then load handles from filename
  if nargin > 1
    load(DataFileName);
  else
    % load data for evaluation (i.e. rename variable for simplicity)
      p = handles.p;
      v = handles.v;         
  end;

% if this is a MAC then xlswrite will have to work differently
  if ismac
    % allow mac-compatible xlswrite
      addpath('./Software/XLWRITE');
    % initialize Java
      javaaddpath('jxl.jar');
      javaaddpath('MXL.jar');
      import mymxl.*;
      import jxl.*; 
  end;
  
% make sure new parameters are no problem for older analyses
  if ~isfield(p,'FixedBodyLength'), p.FixedBodyLength = -1; end; 
  
  
% turn off warnings
  warning('off','all');
  
% determine inputFolderName for indexing files with reference to the experiment
  ind = find(p.inputFolderName == '\' | p.inputFolderName == '/');
  % make sure the last element is considered '/' or '\'
    if ind(end) == length(p.inputFolderName)
      ExperimentName = p.inputFolderName(ind(end-1)+1:ind(end)-1);
    else
      ExperimentName = p.inputFolderName(ind(end)+1:length(p.inputFolderName));
    end;
 
% define colors for different legs
  ColorLF = [ 32 178 170]/255;
  ColorLH = [  0   0 205]/255;
  ColorRF = [255  69   0]/255;
  ColorRH = [34  139  34]/255;
  RGB     = [ColorLF; ColorLH; ColorRF; ColorRH];

% determine which mouse is not completely erased, and make sure to only analyze those
  MouseArray = [];
  for i = 1:v.MouseTrack.NumberOfMice % loop over mice
    % if there is data for this mouse include it in the array
      if max(v.MouseTrack.TrackTime{i}) > 0
        MouseArray = [MouseArray i];
      end;
  end;
  

  
% create subdirectory for each mouse
  for i = MouseArray % loop over mice
    OutputMouseFoldername{i} = [AddSlash(p.outputFolderName) 'Mouse_' num2str(i) '/'];
    % create Images folder if it doesn't exist
      DoesFolderExist = exist(OutputMouseFoldername{i});
      if DoesFolderExist ~= 7
        mkdir(OutputMouseFoldername{i})
      end;
  end;

  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LEG PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('LEG PLOTS')
% j = 1;
% i = 1;
% [Distance(1,j), PerpDist(1,j), ParaDist(1,j), Angle(1,j)] = LegDistance(v.MouseTrack.LegLF.Centroid{i}(:,1),  v.MouseTrack.LegLF.Centroid{i}(:,2), v.MouseTrack.BodyCentroid{i}(j,1), v.MouseTrack.BodyCentroid{i}(j,2),  v.MouseTrack.HeadCentroid{i}(j,1), v.MouseTrack.HeadCentroid{i}(j,2));
% Distance
% PerpDist
% ParaDist
% Angle
% a = v.MouseTrack.LegLF.Centroid{i}(:,1),  v.MouseTrack.LegLF.Centroid{i}(:,2), v.MouseTrack.BodyCentroid{i}(j,1), v.MouseTrack.BodyCentroid{i}(j,2),  v.MouseTrack.HeadCentroid{i}(j,1), v.MouseTrack.HeadCentroid{i}(j,2));


  for i = MouseArray % loop over mice
    % Derive other values that are used in the analysis
      for j = 1:length(v.MouseTrack.TrackTime{i})
          [Distance{i}(1,j), PerpDist{i}(1,j), ParaDist{i}(1,j), Angle{i}(1,j)] = LegDistance(v.MouseTrack.LegLF.Centroid{i}(j,1),  v.MouseTrack.LegLF.Centroid{i}(j,2), v.MouseTrack.BodyCentroid{i}(j,1), v.MouseTrack.BodyCentroid{i}(j,2),  v.MouseTrack.HeadCentroid{i}(j,1), v.MouseTrack.HeadCentroid{i}(j,2));
          [Distance{i}(2,j), PerpDist{i}(2,j), ParaDist{i}(2,j), Angle{i}(2,j)] = LegDistance(v.MouseTrack.LegLH.Centroid{i}(j,1),  v.MouseTrack.LegLH.Centroid{i}(j,2), v.MouseTrack.BodyCentroid{i}(j,1), v.MouseTrack.BodyCentroid{i}(j,2),  v.MouseTrack.HeadCentroid{i}(j,1), v.MouseTrack.HeadCentroid{i}(j,2));
          [Distance{i}(3,j), PerpDist{i}(3,j), ParaDist{i}(3,j), Angle{i}(3,j)] = LegDistance(v.MouseTrack.LegRF.Centroid{i}(j,1),  v.MouseTrack.LegRF.Centroid{i}(j,2), v.MouseTrack.BodyCentroid{i}(j,1), v.MouseTrack.BodyCentroid{i}(j,2),  v.MouseTrack.HeadCentroid{i}(j,1), v.MouseTrack.HeadCentroid{i}(j,2));
          [Distance{i}(4,j), PerpDist{i}(4,j), ParaDist{i}(4,j), Angle{i}(4,j)] = LegDistance(v.MouseTrack.LegRH.Centroid{i}(j,1),  v.MouseTrack.LegRH.Centroid{i}(j,2), v.MouseTrack.BodyCentroid{i}(j,1), v.MouseTrack.BodyCentroid{i}(j,2),  v.MouseTrack.HeadCentroid{i}(j,1), v.MouseTrack.HeadCentroid{i}(j,2));
      end;
      % check for ABORT
        if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
        
      if PLOT == 1
        % LEG DISTANCE
          PlotResults(Distance{i}, v.MouseTrack.TrackTime{i}, 'Leg distances from the center of the body', 'distance [mm]', 1, [OutputMouseFoldername{i} 'Leg_Distance_' ExperimentName '.png'], RGB);
          % check for ABORT
            if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

        % LEG PARALLEL DISTANCE
          PlotResults(ParaDist{i}, v.MouseTrack.TrackTime{i}, 'Leg parallel distances from the center of the body', 'distance [mm]', 3, [OutputMouseFoldername{i} 'Leg_Para_Distance_' ExperimentName '.png'], RGB);
          % check for ABORT
            if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

        % LEG PERPENDICULAR DISTANCE
          PlotResults(PerpDist{i}, v.MouseTrack.TrackTime{i}, 'Leg perpendicular distances from the center of the body', 'distance [mm]', 2, [OutputMouseFoldername{i} 'Leg_Perp_Distance_' ExperimentName '.png'], RGB);
          % check for ABORT
            if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

        % LEG ANGLE 
          PlotResults(Angle{i},    v.MouseTrack.TrackTime{i}, 'Leg angles from the center of the body compared to the direction of the body', 'angle [degrees]', 4, [OutputMouseFoldername{i} 'Leg_Angle_' ExperimentName '.png'], RGB);
          % check for ABORT
            if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      end;
      
      % check for ABORT
        if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
     
  end;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE MIN,MAX,MEAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate extreme and mean values
% calculate min, max and mean distances from center of body
disp('CALCULATE MIN,MAX,MEAN')

  for i = MouseArray % loop over mice
    ind = 1:length(v.MouseTrack.TrackTime{i});
    for j = 1:4
%         if at least one step was made with this foot
          % Distance
            D = Distance{i}(j,ind);
            IND = find(D ~= -1);
            if ~isempty(IND)
                MinDist{i}(j)  = min(D(IND));
                MaxDist{i}(j)  = max(D(IND));
                MeanDist{i}(j) = mean(D(IND));
            else
                MinDist{i}(j)  = -1;
                MaxDist{i}(j)  = -1;
                MeanDist{i}(j) = -1;
            end;                
          % Perpendicular distance
            D = PerpDist{i}(j,ind);
            IND = find(D ~= -1);
            if ~isempty(IND)
                MinPerpDist{i}(j)  = min(D(IND));
                MaxPerpDist{i}(j)  = max(D(IND));
                MeanPerpDist{i}(j) = mean(D(IND));
            else
                MinPerpDist{i}(j)  = -1;
                MaxPerpDist{i}(j)  = -1;
                MeanPerpDist{i}(j) = -1;
            end;                
          % Distance
            D = ParaDist{i}(j,ind);
            IND = find(D ~= -1);
            if ~isempty(IND)            
                MinParaDist{i}(j)  = min(D(IND));
                MaxParaDist{i}(j)  = max(D(IND));
                MeanParaDist{i}(j) = mean(D(IND));
            else
                MinParaDist{i}(j)  = -1;
                MaxParaDist{i}(j)  = -1;
                MeanParaDist{i}(j) = -1;
            end
          % Angle
            D = Angle{i}(j,ind);
            IND = find(D ~= -1);
            if ~isempty(IND)            
                MinAngle{i}(j)  = min(D(IND));
                MaxAngle{i}(j)  = max(D(IND));
                MeanAngle{i}(j) = mean(D(IND));
            else
                MinAngle{i}(j)  = -1;
                MaxAngle{i}(j)  = -1;
                MeanAngle{i}(j) = -1;
            end;
%         end;
    end;  
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

    
  end

% %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % FOOTPRINT DATA FILL MANUAL
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('FOOTPRINT DATA CORRECTIONS')
% % this part will check for those footprints that were selected manually but
% % the corresponding frames were not yet loaded. For these, to save time,
% % MouseWalker has not yet determined the footprint properties. It is done here.
% 
% if PLOT == 1
% 
% %%%%%%%%%%%%%%%%%%%%%%%%
% % CORRECTION!: previously, manual footprint selection assigned the same
% % footprint brightness to all footprints assigned after the one selected.
% % Remove this so that these can be reassigned with the correct brightness
% 
%   for i = MouseArray % loop over mice
%     % LF
%       % find those frames for which there is a footprint and footprint properties are determined  
%         ind = find(v.MouseTrack.LegLF.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegLF.FootSize{i} > 0 );
%       % loop over these frames
%         for j = ind(end:-1:2)
%           % if footprint property is same as previous then make property incomplete (-1)
%             if v.MouseTrack.LegLF.FootSize{i}(j) == v.MouseTrack.LegLF.FootSize{i}(j-1) | v.MouseTrack.LegLF.FootSize{i}(j) == (p.MaxFingerDistance*2+1)^2
%               v.MouseTrack.LegLF.FootSize{i}(j) = -1;
%               v.MouseTrack.LegLF.FootTotalBrightness{i}(j) = -1;
%               v.MouseTrack.LegLF.FootMaxBrightness{i}(j) = -1;
%             end;
%         end;
%     % LH
%       % find those frames for which there is a footprint and footprint properties are determined  
%         ind = find(v.MouseTrack.LegLH.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegLH.FootSize{i} > 0 );
%       % loop over these frames
%         for j = ind(end:-1:2)
%           % if footprint property is same as previous then make property incomplete (-1)
%             if v.MouseTrack.LegLH.FootSize{i}(j) == v.MouseTrack.LegLH.FootSize{i}(j-1)
%               v.MouseTrack.LegLH.FootSize{i}(j) = -1;
%               v.MouseTrack.LegLH.FootTotalBrightness{i}(j) = -1;
%               v.MouseTrack.LegLH.FootMaxBrightness{i}(j) = -1;
%             end;
%         end;
%     % RF
%       % find those frames for which there is a footprint and footprint properties are determined  
%         ind = find(v.MouseTrack.LegRF.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegRF.FootSize{i} > 0 );
%       % loop over these frames
%         for j = ind(end:-1:2)
%           % if footprint property is same as previous then make property incomplete (-1)
%             if v.MouseTrack.LegRF.FootSize{i}(j) == v.MouseTrack.LegRF.FootSize{i}(j-1)
%               v.MouseTrack.LegRF.FootSize{i}(j) = -1;
%               v.MouseTrack.LegRF.FootTotalBrightness{i}(j) = -1;
%               v.MouseTrack.LegRF.FootMaxBrightness{i}(j) = -1;
%             end;
%         end;
%     % RH
%       % find those frames for which there is a footprint and footprint properties are determined  
%         ind = find(v.MouseTrack.LegRH.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegRH.FootSize{i} > 0 );
%       % loop over these frames
%         for j = ind(end:-1:2)
%           % if footprint property is same as previous then make property incomplete (-1)
%             if v.MouseTrack.LegRH.FootSize{i}(j) == v.MouseTrack.LegRH.FootSize{i}(j-1)
%               v.MouseTrack.LegRH.FootSize{i}(j) = -1;
%               v.MouseTrack.LegRH.FootTotalBrightness{i}(j) = -1;
%               v.MouseTrack.LegRH.FootMaxBrightness{i}(j) = -1;
%             end;
%         end;
%   end;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%
% 
%   for i = MouseArray % loop over mice
%     % LF
%       % find those frames for which there is a footprint but the footprint properties have not yet been determined  
%         ind = find(v.MouseTrack.LegLF.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegLF.FootSize{i} < 0 );
%       % loop over these frames
%         for j = ind
%           % determine which frame this corresponds to
%               N = v.MouseTrack.TrackIndex{i}(j);  
%           if N > 0    
%             % load corresponding pic
%               v.pic = PictureReader(N, p);  
%               % subtract background
%                 v = FilterImage(v,p);
%             % Set data to specified
%               x = v.MouseTrack.LegLF.Centroid{i}(j,2);
%               y = v.MouseTrack.LegLF.Centroid{i}(j,1);
%             % Identify and save brightness - within p.MaxFingerDistance
%             % calculate edges of foot
%               v.MouseTrack.LegLF.FootMinX{i}(j) = max(y-p.MaxFingerDistance,1);
%               v.MouseTrack.LegLF.FootMaxX{i}(j) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
%               v.MouseTrack.LegLF.FootMinY{i}(j) = max(x-p.MaxFingerDistance,1);
%               v.MouseTrack.LegLF.FootMaxY{i}(j) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
%             % sized rectangle (for simplicity)
%               indX = round(v.MouseTrack.LegLF.FootMinX{i}(j)) : round(v.MouseTrack.LegLF.FootMaxX{i}(j));
%               indY = round(v.MouseTrack.LegLF.FootMinY{i}(j)) : round(v.MouseTrack.LegLF.FootMaxY{i}(j));
%               FootMatrix = v.pic.foot(indX,indY);
%               indFoot = find(FootMatrix(:) > 0);
%             % calculate total footsize
%               v.MouseTrack.LegLF.FootSize{i}(j) = length(indFoot);
%             % calculate total brightness
%               v.MouseTrack.LegLF.FootTotalBrightness{i}(j) = sum(sum(FootMatrix));
%             % calcuate maximum brightness of foot
%               v.MouseTrack.LegLF.FootMaxBrightness{i}(j) = max(max(FootMatrix));          
%           end;
%         end;
%     % LH
%       % find those frames for which there is a footprint but the footprint properties have not yet been determined  
%         ind = find(v.MouseTrack.LegLH.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegLH.FootSize{i} < 0 );
%       % loop over these frames
%         for j = ind
%           % determine which frame this corresponds to
%               N = v.MouseTrack.TrackIndex{i}(j);  
%           if N > 0    
%             % load corresponding pic
%               v.pic = PictureReader(N, p);  
%               % subtract background
%                 v = FilterImage(v,p);
%             % Set data to specified
%               x = v.MouseTrack.LegLH.Centroid{i}(j,2);
%               y = v.MouseTrack.LegLH.Centroid{i}(j,1);
%             % Identify and save brightness - within p.MaxFingerDistance
%             % calculate edges of foot
%               v.MouseTrack.LegLH.FootMinX{i}(j) = max(y-p.MaxFingerDistance,1);
%               v.MouseTrack.LegLH.FootMaxX{i}(j) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
%               v.MouseTrack.LegLH.FootMinY{i}(j) = max(x-p.MaxFingerDistance,1);
%               v.MouseTrack.LegLH.FootMaxY{i}(j) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
%             % sized rectangle (for simplicity)
%               indX = round(v.MouseTrack.LegLH.FootMinX{i}(j)) : round(v.MouseTrack.LegLH.FootMaxX{i}(j));
%               indY = round(v.MouseTrack.LegLH.FootMinY{i}(j)) : round(v.MouseTrack.LegLH.FootMaxY{i}(j));
%               FootMatrix = v.pic.foot(indX,indY);
%               indFoot = find(FootMatrix(:) > 0);
%             % calculate total footsize
%               v.MouseTrack.LegLH.FootSize{i}(j) = length(indFoot);
%             % calculate total brightness
%               v.MouseTrack.LegLH.FootTotalBrightness{i}(j) = sum(sum(FootMatrix));
%             % calcuate maximum brightness of foot
%               v.MouseTrack.LegLH.FootMaxBrightness{i}(j) = max(max(FootMatrix));    
%           end;
%         end;
%     % RF
%       % find those frames for which there is a footprint but the footprint properties have not yet been determined  
%         ind = find(v.MouseTrack.LegRF.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegRF.FootSize{i} < 0 );
%       % loop over these frames
%         for j = ind
%           % determine which frame this corresponds to
%               N = v.MouseTrack.TrackIndex{i}(j);  
%           if N > 0    
%             % load corresponding pic
%               v.pic = PictureReader(N, p);  
%               % subtract background
%                 v = FilterImage(v,p);
%             % Set data to specified
%               x = v.MouseTrack.LegRF.Centroid{i}(j,2);
%               y = v.MouseTrack.LegRF.Centroid{i}(j,1);
%             % Identify and save brightness - within p.MaxFingerDistance
%             % calculate edges of foot
%               v.MouseTrack.LegRF.FootMinX{i}(j) = max(y-p.MaxFingerDistance,1);
%               v.MouseTrack.LegRF.FootMaxX{i}(j) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
%               v.MouseTrack.LegRF.FootMinY{i}(j) = max(x-p.MaxFingerDistance,1);
%               v.MouseTrack.LegRF.FootMaxY{i}(j) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
%             % sized rectangle (for simplicity)
%               indX = round(v.MouseTrack.LegRF.FootMinX{i}(j)) : round(v.MouseTrack.LegRF.FootMaxX{i}(j));
%               indY = round(v.MouseTrack.LegRF.FootMinY{i}(j)) : round(v.MouseTrack.LegRF.FootMaxY{i}(j));
%               FootMatrix = v.pic.foot(indX,indY);
%               indFoot = find(FootMatrix(:) > 0);
%             % calculate total footsize
%               v.MouseTrack.LegRF.FootSize{i}(j) = length(indFoot);
%             % calculate total brightness
%               v.MouseTrack.LegRF.FootTotalBrightness{i}(j) = sum(sum(FootMatrix));
%             % calcuate maximum brightness of foot
%               v.MouseTrack.LegRF.FootMaxBrightness{i}(j) = max(max(FootMatrix));                      
%           end;
%         end;
%     % RH
%       % find those frames for which there is a footprint but the footprint properties have not yet been determined  
%         ind = find(v.MouseTrack.LegRH.Centroid{i}(:,1)' > 0 & v.MouseTrack.LegRH.FootSize{i} < 0 );
%       % loop over these frames
%         for j = ind
%           % determine which frame this corresponds to
%               N = v.MouseTrack.TrackIndex{i}(j);  
%           if N > 0    
%             % load corresponding pic
%               v.pic = PictureReader(N, p);  
%               % subtract background
%                 v = FilterImage(v,p);
%             % Set data to specified
%               x = v.MouseTrack.LegRH.Centroid{i}(j,2);
%               y = v.MouseTrack.LegRH.Centroid{i}(j,1);
%             % Identify and save brightness - within p.MaxFingerDistance
%             % calculate edges of foot
%               v.MouseTrack.LegRH.FootMinX{i}(j) = max(y-p.MaxFingerDistance,1);
%               v.MouseTrack.LegRH.FootMaxX{i}(j) = min(y+p.MaxFingerDistance,length(v.pic.foot(:,1)));
%               v.MouseTrack.LegRH.FootMinY{i}(j) = max(x-p.MaxFingerDistance,1);
%               v.MouseTrack.LegRH.FootMaxY{i}(j) = min(x+p.MaxFingerDistance,length(v.pic.foot(1,:)));    
%             % sized rectangle (for simplicity)
%               indX = round(v.MouseTrack.LegRH.FootMinX{i}(j)) : round(v.MouseTrack.LegRH.FootMaxX{i}(j));
%               indY = round(v.MouseTrack.LegRH.FootMinY{i}(j)) : round(v.MouseTrack.LegRH.FootMaxY{i}(j));
%               FootMatrix = v.pic.foot(indX,indY);
%               indFoot = find(FootMatrix(:) > 0);
%             % calculate total footsize
%               v.MouseTrack.LegRH.FootSize{i}(j) = length(indFoot);
%             % calculate total brightness
%               v.MouseTrack.LegRH.FootTotalBrightness{i}(j) = sum(sum(FootMatrix));
%             % calcuate maximum brightness of foot
%               v.MouseTrack.LegRH.FootMaxBrightness{i}(j) = max(max(FootMatrix));              
%           end;
%         end;
%     
%   end;
%   
%   % save correction back in file
%     if nargin > 1
%       save(DataFileName, 'p', 'v');
%     end;
%     
% end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOOTPRINT SIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('FOOTPRINT SIZE')

  for i = MouseArray % loop over mice
    
    % make sure footsize is 0 whereever there is no foot
      v.MouseTrack.LegLF.FootSize{i}(v.MouseTrack.LegLF.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegLH.FootSize{i}(v.MouseTrack.LegLH.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegRF.FootSize{i}(v.MouseTrack.LegRF.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegRH.FootSize{i}(v.MouseTrack.LegRH.Centroid{i}(:,1) < 0) = 0;
    
    % find times that are not cancelled
      indT = find(v.MouseTrack.TrackTime{i} > 0);
    
    if PLOT == 1  
      h = figure('visible', 'off');
      plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegLF.FootSize{i}(indT)) / p.mm2pix^2,'-', 'Color', ColorLF, 'LineWidth', 3, 'DisplayName', 'Left Fore');
      hold on;
      plot(v.MouseTrack.TrackTime{i}(indT), max(0,v.MouseTrack.LegRF.FootSize{i}(indT))/ p.mm2pix^2,'-', 'Color', ColorRF, 'LineWidth', 3, 'DisplayName', 'Right Fore');
      plot(v.MouseTrack.TrackTime{i}(indT), max(0,v.MouseTrack.LegLH.FootSize{i}(indT))/ p.mm2pix^2,'-', 'Color', ColorLH, 'LineWidth', 3, 'DisplayName', 'Left Hind');
      plot(v.MouseTrack.TrackTime{i}(indT), max(0,v.MouseTrack.LegRH.FootSize{i}(indT))/ p.mm2pix^2,'-', 'Color', ColorRH, 'LineWidth', 3, 'DisplayName', 'Right Hind');
      plot(v.MouseTrack.TrackTime{i}(indT),(max(0,v.MouseTrack.LegRF.FootSize{i}(indT))+max(0,v.MouseTrack.LegRH.FootSize{i}(indT))+max(0,v.MouseTrack.LegLF.FootSize{i}(indT))+max(0,v.MouseTrack.LegLH.FootSize{i}(indT))) / p.mm2pix^2,'--', 'Color', [0.3 0.3 0.3]/255, 'LineWidth', 3, 'DisplayName', 'Total');
      legend('Location', 'NE');
      grid on;
      set(gca,'FontSize', 14);
      xlabel('Time [s]');
      ylabel('Total footprint size [mm^2]');
      % record Xlim so it can be used later to synchronize plots
        axis tight;
        Xlim{i} = get(gca, 'XLim');
      box on;
      set(gca,'LineWidth',2);
      hold off;
      outputfilename = [OutputMouseFoldername{i} 'Foot_Size_' ExperimentName '.png'];
      saveas(h,outputfilename);
      close(h);   
    end;
    
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
    
  end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TAIL SHAKING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate how much the tail points move perpendicularly
  disp('TAIL SHAKING') ;

  for i = MouseArray % loop over mice
    % assign first acceleration point
      v.MouseTrack.BodyPerpAcceleration{i}(1)  = -1;
      v.MouseTrack.Tail1PerpAcceleration{i}(1) = -1;
      v.MouseTrack.Tail2PerpAcceleration{i}(1) = -1;
      v.MouseTrack.Tail3PerpAcceleration{i}(1) = -1;
    % calculate perpendicular motion of tail point compared to previous tail point
      for j = 1:length(v.MouseTrack.TrackTime{i})-1 % loop over time
        if v.MouseTrack.BodyCentroid{i}(j,1) > 0 & v.MouseTrack.BodyCentroid{i}(j,2) > 0 & v.MouseTrack.BodyCentroid{i}(j+1,1) > 0 & v.MouseTrack.BodyCentroid{i}(j+1,2) > 0 & v.MouseTrack.TrackTime{i}(j) > 0 & v.MouseTrack.TrackTime{i}(j+1) > 0 & v.MouseTrack.Tail1Centroid{i}(j,1) > 0 & v.MouseTrack.Tail2Centroid{i}(j,1) > 0 & v.MouseTrack.Tail3Centroid{i}(j,1) > 0
          % TAIL1
            % calculate perpendicular distance
              x1     = v.MouseTrack.Tail1Centroid{i}(j,1) - v.MouseTrack.BodyCentroid{i}(j,1);
              y1     = v.MouseTrack.Tail1Centroid{i}(j,2) - v.MouseTrack.BodyCentroid{i}(j,2);
              angle1 = v.MouseTrack.Tail1Orientation{i}(j);
              x2     = v.MouseTrack.Tail1Centroid{i}(j+1,1) - v.MouseTrack.BodyCentroid{i}(j+1,1);
              y2     = v.MouseTrack.Tail1Centroid{i}(j+1,2) - v.MouseTrack.BodyCentroid{i}(j+1,2);
              [DistPar, DistPerp] = DistanceFromLine(x2, y2, x1 + [0 cosd(angle1)], y1 + [0 sind(angle1)]);
            % assign perp motion to tailperpspeed
              v.MouseTrack.Tail1PerpSpeed{i}(j) = DistPerp / p.fps /p.mm2pix;
            % assign perp acceleration to tailperpacceleration
              if j > 1 & v.MouseTrack.Tail1Centroid{i}(j-1,1) > 0
                v.MouseTrack.Tail1PerpAcceleration{i}(j) = (v.MouseTrack.Tail1PerpSpeed{i}(j) - v.MouseTrack.Tail1PerpSpeed{i}(j-1)) / p.fps;
              else
                v.MouseTrack.Tail1PerpAcceleration{i}(j) = -1;
              end;
          % TAIL2
            % calculate perpendicular distance
              x1     = v.MouseTrack.Tail2Centroid{i}(j,1) - v.MouseTrack.BodyCentroid{i}(j,1);
              y1     = v.MouseTrack.Tail2Centroid{i}(j,2) - v.MouseTrack.BodyCentroid{i}(j,2);
              angle1 = v.MouseTrack.Tail2Orientation{i}(j);
              x2     = v.MouseTrack.Tail2Centroid{i}(j+1,1) - v.MouseTrack.BodyCentroid{i}(j+1,1);
              y2     = v.MouseTrack.Tail2Centroid{i}(j+1,2) - v.MouseTrack.BodyCentroid{i}(j+1,2);
              [DistPar, DistPerp] = DistanceFromLine(x2, y2, x1 + [0 cosd(angle1)], y1 + [0 sind(angle1)]);
            % assign perp motion to tailperpspeed
              v.MouseTrack.Tail2PerpSpeed{i}(j) = DistPerp / p.fps /p.mm2pix;
            % assign perp acceleration to tailperpacceleration
              if j > 1 & v.MouseTrack.Tail2Centroid{i}(j-1,1) > 0
                v.MouseTrack.Tail2PerpAcceleration{i}(j) = (v.MouseTrack.Tail2PerpSpeed{i}(j) - v.MouseTrack.Tail2PerpSpeed{i}(j-1)) / p.fps;
              else
                v.MouseTrack.Tail2PerpAcceleration{i}(j) = -1;
              end;
          % TAIL3
            % calculate perpendicular distance
              x1     = v.MouseTrack.Tail3Centroid{i}(j,1) - v.MouseTrack.BodyCentroid{i}(j,1);
              y1     = v.MouseTrack.Tail3Centroid{i}(j,2) - v.MouseTrack.BodyCentroid{i}(j,2);
              angle1 = v.MouseTrack.Tail3Orientation{i}(j);
              x2     = v.MouseTrack.Tail3Centroid{i}(j+1,1) - v.MouseTrack.BodyCentroid{i}(j+1,1);
              y2     = v.MouseTrack.Tail3Centroid{i}(j+1,2) - v.MouseTrack.BodyCentroid{i}(j+1,2);
              [DistPar, DistPerp] = DistanceFromLine(x2, y2, x1 + [0 cosd(angle1)], y1 + [0 sind(angle1)]);
            % assign perp motion to tailperpspeed
              v.MouseTrack.Tail3PerpSpeed{i}(j) = DistPerp / p.fps /p.mm2pix;
            % assign perp acceleration to tailperpacceleration
              if j > 1 & v.MouseTrack.Tail3Centroid{i}(j-1,1) > 0
                v.MouseTrack.Tail3PerpAcceleration{i}(j) = (v.MouseTrack.Tail3PerpSpeed{i}(j) - v.MouseTrack.Tail3PerpSpeed{i}(j-1)) / p.fps;
              else
                v.MouseTrack.Tail3PerpAcceleration{i}(j) = -1;
              end;
          % BODY CENTER
            % calculate perpendicular distance
              x1     = v.MouseTrack.BodyCentroid{i}(j,1);
              y1     = v.MouseTrack.BodyCentroid{i}(j,2);
              angle1 = v.MouseTrack.BodyOrientation{i}(j);
              x2     = v.MouseTrack.BodyCentroid{i}(j+1,1);
              y2     = v.MouseTrack.BodyCentroid{i}(j+1,2);
              [DistPar, DistPerp] = DistanceFromLine(x2, y2, x1 + [0 cosd(angle1)], y1 + [0 sind(angle1)]);
            % assign perp motion to tailperpspeed
              v.MouseTrack.BodyPerpSpeed{i}(j) = DistPerp / p.fps /p.mm2pix;
            % assign perp acceleration to tailperpacceleration
              if j > 1 & v.MouseTrack.BodyCentroid{i}(j-1,1) > 0
                v.MouseTrack.BodyPerpAcceleration{i}(j) = (v.MouseTrack.BodyPerpSpeed{i}(j) - v.MouseTrack.BodyPerpSpeed{i}(j-1)) / p.fps;
              else
                v.MouseTrack.BodyPerpAcceleration{i}(j) = -1;
              end;
        else
          % save variable as not-assigned
            v.MouseTrack.Tail1PerpSpeed{i}(j) = -1;
            v.MouseTrack.Tail2PerpSpeed{i}(j) = -1;
            v.MouseTrack.Tail3PerpSpeed{i}(j) = -1;
            v.MouseTrack.BodyPerpSpeed{i}(j)  = -1;
        end;
      end;
    % assign last point
      v.MouseTrack.Tail1PerpSpeed{i}(length(v.MouseTrack.TrackTime{i})) = -1;
      v.MouseTrack.Tail2PerpSpeed{i}(length(v.MouseTrack.TrackTime{i})) = -1;
      v.MouseTrack.Tail3PerpSpeed{i}(length(v.MouseTrack.TrackTime{i})) = -1;
      v.MouseTrack.BodyPerpSpeed{i}(length(v.MouseTrack.TrackTime{i}))  = -1;
      v.MouseTrack.Tail1PerpAcceleration{i}(length(v.MouseTrack.TrackTime{i})) = -1;
      v.MouseTrack.Tail2PerpAcceleration{i}(length(v.MouseTrack.TrackTime{i})) = -1;
      v.MouseTrack.Tail3PerpAcceleration{i}(length(v.MouseTrack.TrackTime{i})) = -1;
      v.MouseTrack.BodyPerpAcceleration{i}(length(v.MouseTrack.TrackTime{i}))  = -1;
      
    % PLOT results  
      if PLOT == 1
        % SPEED
        % find times that are not cancelled
          indT = find(v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.Tail1PerpSpeed{i} ~= -1 & v.MouseTrack.Tail1PerpSpeed{i} < 100);
        h = figure('visible', 'off');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.BodyPerpSpeed{i}(indT),'-',  'Color', [0.7 0.7 0.7], 'LineWidth', 5, 'DisplayName', 'Body');
        hold on;
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.Tail1PerpSpeed{i}(indT),'-',  'Color', [0.7 0.1 0.1], 'LineWidth', 3, 'DisplayName', 'Tail 1');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.Tail2PerpSpeed{i}(indT),'--',  'Color', [0.1 0.7 0.1], 'LineWidth', 3, 'DisplayName', 'Tail 2');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.Tail3PerpSpeed{i}(indT),'-.',  'Color', [0.1 0.1 0.7], 'LineWidth', 3, 'DisplayName', 'Tail 3');
        legend('Location', 'NE');
        grid on;
        set(gca,'FontSize', 14);
        xlabel('Time [s]');
        ylabel('Perpendicular speed [mm/s]');
        xlim(Xlim{i});
        box on;
        set(gca,'LineWidth',2);
        hold off;
        outputfilename = [OutputMouseFoldername{i} 'Tail_Shake_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
        close(h);
        % ACCELERATION
        % find times that are not cancelled
          indT = find(v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.Tail1PerpAcceleration{i} ~= -1 & v.MouseTrack.Tail1PerpAcceleration{i} < 100);
        h = figure('visible', 'off');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.BodyPerpAcceleration{i}(indT),'-',  'Color', [0.7 0.7 0.7], 'LineWidth', 5, 'DisplayName', 'Body');
        hold on;
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.Tail1PerpAcceleration{i}(indT),'-',  'Color', [0.7 0.1 0.1], 'LineWidth', 3, 'DisplayName', 'Tail 1');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.Tail2PerpAcceleration{i}(indT),'--',  'Color', [0.1 0.7 0.1], 'LineWidth', 3, 'DisplayName', 'Tail 2');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.Tail3PerpAcceleration{i}(indT),'-.',  'Color', [0.1 0.1 0.7], 'LineWidth', 3, 'DisplayName', 'Tail 3');
        legend('Location', 'NE');
        grid on;
        set(gca,'FontSize', 14);
        xlabel('Time [s]');
        ylabel('Perpendicular acceleration [mm/s]');
        xlim(Xlim{i});
        ylim([-0.01 0.01]);
        box on;
        set(gca,'LineWidth',2);
        hold off;
        outputfilename = [OutputMouseFoldername{i} 'Tail_Acceleration_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
        close(h);

      end;
      
     
  end;
  

  

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BODY PART ANGLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the orientations of body parts compared to each other
disp('BODY PART ANGLES');

  for i = MouseArray % loop over mice

    % identify indices where there is no body. These will not be considered
      indNoBody = find(v.MouseTrack.BodyCentroid{i}(:,1) <= 0);

    % calculate angles compared to body center
      % head
        v.MouseTrack.RelativeOrientation.HeadToBody{i} = mod(v.MouseTrack.HeadOrientation{i} - v.MouseTrack.BodyOrientation{i} + 180, 360) - 180;
        v.MouseTrack.RelativeOrientation.HeadToBody{i}(indNoBody) = -1;
      % back
        v.MouseTrack.RelativeOrientation.BackToBody{i} = mod(v.MouseTrack.BodyBackOrientation{i} - v.MouseTrack.BodyOrientation{i} + 180, 360) - 180;
        v.MouseTrack.RelativeOrientation.BackToBody{i}(indNoBody) = -1;
      % tail 1
        v.MouseTrack.RelativeOrientation.Tail1ToBody{i} = mod(v.MouseTrack.Tail1Orientation{i} - v.MouseTrack.BodyOrientation{i} + 180, 360) - 180;
        v.MouseTrack.RelativeOrientation.Tail1ToBody{i}(indNoBody) = -1;
      % tail 2
        v.MouseTrack.RelativeOrientation.Tail2ToBody{i} = mod(v.MouseTrack.Tail2Orientation{i} - v.MouseTrack.BodyOrientation{i} + 180, 360) - 180;
        v.MouseTrack.RelativeOrientation.Tail2ToBody{i}(indNoBody) = -1;
      % tail 3
        v.MouseTrack.RelativeOrientation.Tail3ToBody{i} = mod(v.MouseTrack.Tail3Orientation{i} - v.MouseTrack.BodyOrientation{i} + 180, 360) - 180;
        v.MouseTrack.RelativeOrientation.Tail3ToBody{i}(indNoBody) = -1;
    % calculate tail angles relative to middle tail point (tail2)
      % tail 1
        v.MouseTrack.RelativeOrientation.Tail1ToTail2{i} = mod(v.MouseTrack.Tail1Orientation{i} - v.MouseTrack.Tail2Orientation{i} + 180, 360) - 180;
        v.MouseTrack.RelativeOrientation.Tail1ToTail2{i}(indNoBody) = -1;
      % tail 3
        v.MouseTrack.RelativeOrientation.Tail3ToTail2{i} = mod(v.MouseTrack.Tail3Orientation{i} - v.MouseTrack.Tail2Orientation{i} + 180, 360) - 180;
        v.MouseTrack.RelativeOrientation.Tail3ToTail2{i}(indNoBody) = -1;
    

    % find times that are not cancelled
      indT = find(v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodyCentroid{i}(:,1)' > 0);

    if PLOT == 1  
      % plot compared to body    
        h = figure('visible', 'off');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.RelativeOrientation.HeadToBody{i}(indT),'-',   'Color', [0.0 0.0 0.7], 'LineWidth', 3, 'DisplayName', 'Head');
        hold on;
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.RelativeOrientation.BackToBody{i}(indT),'--',  'Color', [0.7 0.0 0.0], 'LineWidth', 3, 'DisplayName', 'Back');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.RelativeOrientation.Tail1ToBody{i}(indT),'-.',  'Color', [0.1 1.0 0.1], 'LineWidth', 3, 'DisplayName', 'Tail 1');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.RelativeOrientation.Tail2ToBody{i}(indT),'-.',  'Color', [0.1 0.7 0.1], 'LineWidth', 3, 'DisplayName', 'Tail 2');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.RelativeOrientation.Tail3ToBody{i}(indT),'-.',  'Color', [0.0 0.3 0.0], 'LineWidth', 3, 'DisplayName', 'Tail 3');
        legend('Location', 'NE');
        grid on;
        set(gca,'FontSize', 14);
        xlabel('Time [s]');
        ylabel('Orientation compared to body [deg]');
        xlim(Xlim{i});
        box on;
        set(gca,'LineWidth',2);
        hold off;
        outputfilename = [OutputMouseFoldername{i} 'Orientation_vs_Body_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
        close(h); 

      % plot compared to tail center
        h = figure('visible', 'off');
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.RelativeOrientation.Tail1ToTail2{i}(indT),'-.',  'Color', [0.1 1.0 0.1], 'LineWidth', 3, 'DisplayName', 'Tail 1');
        hold on;
        plot(v.MouseTrack.TrackTime{i}(indT),v.MouseTrack.RelativeOrientation.Tail3ToTail2{i}(indT),'-.',  'Color', [0.0 0.3 0.0], 'LineWidth', 3, 'DisplayName', 'Tail 3');
        legend('Location', 'NE');
        grid on;
        set(gca,'FontSize', 14);
        xlabel('Time [s]');
        ylabel('Orientation compared to tail middle point [deg]');
        xlim(Xlim{i});
        box on;
        set(gca,'LineWidth',2);
        hold off;
        outputfilename = [OutputMouseFoldername{i} 'Orientation_vs_Tail2_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
        close(h);   
    end;
    
  end
  
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CORRELATION: HIND LEG VS. TAIL ANGLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot correlation beteen hind leg parallel position compared to body
% center and the angle of the tail.
disp('CORRELATION: HIND LEG VS. TAIL ANGLE')

  for i = MouseArray % loop over mice
    
    % find times that are not cancelled
      indT_LH = find(ParaDist{i}(2,:) ~= -1 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodyCentroid{i}(:,1)' > 0);
      indT_RH = find(ParaDist{i}(4,:) ~= -1 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodyCentroid{i}(:,1)' > 0);
      
     % plot
       if PLOT == 1

         h = figure('visible', 'off');
         plot(ParaDist{i}(2,indT_LH) / p.mm2pix,v.MouseTrack.RelativeOrientation.Tail1ToBody{i}(indT_LH),'x',  'Color', [1 0 0], 'LineWidth', 2, 'DisplayName', 'LH vs tail1');
         hold on;
         plot(ParaDist{i}(2,indT_LH) / p.mm2pix,v.MouseTrack.RelativeOrientation.Tail2ToBody{i}(indT_LH),'x',  'Color', [0 1 0], 'LineWidth', 2, 'DisplayName', 'LH vs tail2');
         plot(ParaDist{i}(2,indT_LH) / p.mm2pix,v.MouseTrack.RelativeOrientation.Tail3ToBody{i}(indT_LH),'x',  'Color', [0 0 1], 'LineWidth', 2, 'DisplayName', 'LH vs tail3');

         legend('Location', 'NE');
         plot(ParaDist{i}(2,indT_LH) / p.mm2pix,v.MouseTrack.RelativeOrientation.Tail1ToBody{i}(indT_LH),'-',  'Color', [1   0.5 0.5], 'LineWidth', 1);
         plot(ParaDist{i}(2,indT_LH) / p.mm2pix,v.MouseTrack.RelativeOrientation.Tail2ToBody{i}(indT_LH),'-',  'Color', [0.5 1   0.5], 'LineWidth', 1);
         plot(ParaDist{i}(2,indT_LH) / p.mm2pix,v.MouseTrack.RelativeOrientation.Tail3ToBody{i}(indT_LH),'-',  'Color', [0.5 0.5 1  ], 'LineWidth', 1);
         grid on;
         set(gca,'FontSize', 14);
         xlabel('Hind leg parallel distance [mm]');
         ylabel('Orientation of tail compared to body center orientation [deg]');
         box on;
         set(gca,'LineWidth',2);
         hold off;
         outputfilename = [OutputMouseFoldername{i} 'Correlation_hindleg_tail_' ExperimentName '.png'];
         saveas(h,outputfilename,'png');
         close(h);   
       end;
%     ParaDist{i}(2,indT) % LH
%     ParaDist{i}(4,indT) % RH
%     v.MouseTrack.RelativeOrientation.Tail1ToBody{i}(indT)
%     v.MouseTrack.RelativeOrientation.Tail2ToBody{i}(indT)
%     v.MouseTrack.RelativeOrientation.Tail3ToBody{i}(indT)
%     v.MouseTrack.RelativeOrientation.BackToBody{i}(indT)
  end;  

 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOOTPRINT BRIGHTNESS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('FOOTPRINT BRIGHTNESS')

  for i = MouseArray % loop over mice
    
    % make sure footsize is 0 whereever there is no foot
      v.MouseTrack.LegLF.FootTotalBrightness{i}(v.MouseTrack.LegLF.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegLH.FootTotalBrightness{i}(v.MouseTrack.LegLH.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegRF.FootTotalBrightness{i}(v.MouseTrack.LegRF.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegRH.FootTotalBrightness{i}(v.MouseTrack.LegRH.Centroid{i}(:,1) < 0) = 0;
    
    % find times that are not cancelled
      indT = find(v.MouseTrack.TrackTime{i} > 0);
    
    if PLOT == 1
      h = figure('visible', 'off');
      plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegLF.FootTotalBrightness{i}(indT)),'-', 'Color', ColorLF, 'LineWidth', 3, 'DisplayName', 'Left Fore');
      hold on;
      plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegRF.FootTotalBrightness{i}(indT)),'-', 'Color', ColorRF, 'LineWidth', 3, 'DisplayName', 'Right Fore');
      plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegLH.FootTotalBrightness{i}(indT)),'-', 'Color', ColorLH, 'LineWidth', 3, 'DisplayName', 'Left Hind');
      plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegRH.FootTotalBrightness{i}(indT)),'-', 'Color', ColorRH, 'LineWidth', 3, 'DisplayName', 'Right Hind');
      plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegRF.FootTotalBrightness{i}(indT))+max(0,v.MouseTrack.LegRH.FootTotalBrightness{i}(indT))+max(0,v.MouseTrack.LegLF.FootTotalBrightness{i}(indT))+max(0,v.MouseTrack.LegLH.FootTotalBrightness{i}(indT)),'--', 'Color', [0.3 0.3 0.3]/255, 'LineWidth', 3, 'DisplayName', 'Total');
      legend('Location', 'NE');
      grid on;
      set(gca,'FontSize', 14);
      xlabel('Time [s]');
      ylabel('Total footprint brightness [au]');
      xlim(Xlim{i});
      box on;
      set(gca,'LineWidth',2);
      hold off;
      outputfilename = [OutputMouseFoldername{i} 'Foot_Brightness_' ExperimentName '.png'];
      saveas(h,outputfilename,'png');
      close(h);
    end;
    
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
    
  end

% check for ABORT
  if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
  

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOOTPRINT PRESSURE (BRIGHTNESS / AREA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('FOOTPRINT PRESSURE (BRIGHTNESS / AREA)')

  for i = MouseArray % loop over mice
    
    % make sure footsize is 0 whereever there is no foot
      v.MouseTrack.LegLF.FootPressure{i}(v.MouseTrack.LegLF.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegLH.FootPressure{i}(v.MouseTrack.LegLH.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegRF.FootPressure{i}(v.MouseTrack.LegRF.Centroid{i}(:,1) < 0) = 0;
      v.MouseTrack.LegRH.FootPressure{i}(v.MouseTrack.LegRH.Centroid{i}(:,1) < 0) = 0;    
    
    % calculate pressure (make it -1 if area is undefined or zero)
      ind = find(v.MouseTrack.LegRF.FootSize{i}(:) > 0 & v.MouseTrack.TrackTime{i}' > 0);
      v.MouseTrack.LegRF.FootPressure{i}(ind) = v.MouseTrack.LegRF.FootTotalBrightness{i}(ind) ./ v.MouseTrack.LegRF.FootSize{i}(ind) * p.mm2pix^2;
      v.MouseTrack.LegRF.FootPressure{i}(v.MouseTrack.LegRF.FootSize{i}(:) <= 0 | v.MouseTrack.TrackTime{i}' <= 0) = -1;
      ind = find(v.MouseTrack.LegRH.FootSize{i}(:) > 0 & v.MouseTrack.TrackTime{i}' > 0);
      v.MouseTrack.LegRH.FootPressure{i}(ind) = v.MouseTrack.LegRH.FootTotalBrightness{i}(ind) ./ v.MouseTrack.LegRH.FootSize{i}(ind) * p.mm2pix^2;
      v.MouseTrack.LegRH.FootPressure{i}(v.MouseTrack.LegRH.FootSize{i}(:) <= 0 | v.MouseTrack.TrackTime{i}' <= 0) = -1;
      ind = find(v.MouseTrack.LegLF.FootSize{i}(:) > 0 & v.MouseTrack.TrackTime{i}' > 0);
      v.MouseTrack.LegLF.FootPressure{i}(ind) = v.MouseTrack.LegLF.FootTotalBrightness{i}(ind) ./ v.MouseTrack.LegLF.FootSize{i}(ind) * p.mm2pix^2;
      v.MouseTrack.LegLF.FootPressure{i}(v.MouseTrack.LegLF.FootSize{i}(:) <= 0 | v.MouseTrack.TrackTime{i}' <= 0) = -1;
      ind = find(v.MouseTrack.LegLH.FootSize{i}(:) > 0 & v.MouseTrack.TrackTime{i}' > 0);
      v.MouseTrack.LegLH.FootPressure{i}(ind) = v.MouseTrack.LegLH.FootTotalBrightness{i}(ind) ./ v.MouseTrack.LegLH.FootSize{i}(ind) * p.mm2pix^2;
      v.MouseTrack.LegLH.FootPressure{i}(v.MouseTrack.LegLH.FootSize{i}(:) <= 0 | v.MouseTrack.TrackTime{i}' <= 0) = -1;
      TotalFootPressure = (max(0,v.MouseTrack.LegRF.FootTotalBrightness{i}) + ...
                           max(0,v.MouseTrack.LegRH.FootTotalBrightness{i}) + ...
                           max(0,v.MouseTrack.LegLF.FootTotalBrightness{i}) + ...
                           max(0,v.MouseTrack.LegLH.FootTotalBrightness{i})) ./ ...
                          (max(0,v.MouseTrack.LegRF.FootSize{i}) + ...
                           max(0,v.MouseTrack.LegRH.FootSize{i}) + ...
                           max(0,v.MouseTrack.LegLF.FootSize{i}) + ...
                           max(0,v.MouseTrack.LegLH.FootSize{i})) * p.mm2pix^2;
                         
    % find times that are not cancelled
      indT = find(v.MouseTrack.TrackTime{i} > 0);
      
    % plot
      if PLOT == 1
        h = figure('visible', 'off'); 
        % legend first
          plot(-1,-1,'-', 'Color', ColorLF, 'LineWidth', 3, 'DisplayName', 'Left Fore');
          hold on;
          plot(-1,-1,'-', 'Color', ColorRF, 'LineWidth', 3, 'DisplayName', 'Right Fore');
          plot(-1,-1,'-', 'Color', ColorLH, 'LineWidth', 3, 'DisplayName', 'Left Hind');
          plot(-1,-1,'-', 'Color', ColorRH, 'LineWidth', 3, 'DisplayName', 'Right Hind');
          plot(-1,-1, '--', 'Color', [0.3 0.3 0.3]/255, 'LineWidth', 3, 'DisplayName', 'Total');
          legend('Location', 'SE');
        % now the real data
          for j = 1:length(indT)-1
            if v.MouseTrack.LegLF.FootPressure{i}(indT(j)) > 0 & v.MouseTrack.LegLF.FootPressure{i}(indT(j+1)) > 0
              plot(v.MouseTrack.TrackTime{i}(indT(j:j+1)),max(0,v.MouseTrack.LegLF.FootPressure{i}(indT(j:j+1))),'-', 'Color', ColorLF, 'LineWidth', 3, 'DisplayName', 'Left Fore');
            end;
            if v.MouseTrack.LegRF.FootPressure{i}(indT(j)) > 0 & v.MouseTrack.LegRF.FootPressure{i}(indT(j+1)) > 0
              plot(v.MouseTrack.TrackTime{i}(indT(j:j+1)),max(0,v.MouseTrack.LegRF.FootPressure{i}(indT(j:j+1))),'-', 'Color', ColorRF, 'LineWidth', 3, 'DisplayName', 'Right Fore');
            end;
            if v.MouseTrack.LegLH.FootPressure{i}(indT(j)) > 0 & v.MouseTrack.LegLH.FootPressure{i}(indT(j+1)) > 0
              plot(v.MouseTrack.TrackTime{i}(indT(j:j+1)),max(0,v.MouseTrack.LegLH.FootPressure{i}(indT(j:j+1))),'-', 'Color', ColorLH, 'LineWidth', 3, 'DisplayName', 'Left Hind');
            end;
            if v.MouseTrack.LegRH.FootPressure{i}(indT(j)) > 0 & v.MouseTrack.LegRH.FootPressure{i}(indT(j+1)) > 0
              plot(v.MouseTrack.TrackTime{i}(indT(j:j+1)),max(0,v.MouseTrack.LegRH.FootPressure{i}(indT(j:j+1))),'-', 'Color', ColorRH, 'LineWidth', 3, 'DisplayName', 'Right Hind');
            end;
            if TotalFootPressure(indT(j)) > 0 & TotalFootPressure(indT(j+1)) > 0
              plot(v.MouseTrack.TrackTime{i}(indT(j:j+1)), TotalFootPressure(indT(j:j+1)), '--', 'Color', [0.3 0.3 0.3]/255, 'LineWidth', 3, 'DisplayName', 'Total');
            end;
          end;
        grid on;
        set(gca,'FontSize', 14);
        xlabel('Time [s]');
        ylabel('Total footprint pressure [brightness/mm^2]');
        box on;
        xlim(Xlim{i});
        set(gca,'LineWidth',2);
        hold off;
        outputfilename = [OutputMouseFoldername{i} 'Foot_Pressure_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
        close(h);      
      end;
  end

% check for ABORT
  if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LEGTIME ---- FOOTPRINT TIMING (STANCE VS SWING)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('LEGTIME ---- FOOTPRINT TIMING (STANCE VS SWING)')

  for i = MouseArray % loop over mice
    
    % open figure
      h = figure('visible', 'off');

    % plot footprint timing
      [StartStepIndexLF{i}, StartStepIndexLH{i}, StartStepIndexRF{i}, StartStepIndexRH{i}, StopStepIndexLF{i}, StopStepIndexLH{i}, StopStepIndexRF{i}, StopStepIndexRH{i}] = ...
        FootprintTimingPlot(v, p, i, h);      
      
      if PLOT == 1
        xlim(Xlim{i});  
        % save results
          outputfilename = [OutputMouseFoldername{i} 'Leg_Time_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');
      end;
      close(h);  
    
  end;

  % check for ABORT
    if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BODY SPEED & ACCELERATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('BODY SPEED & ACCELERATION')

  for i = MouseArray % loop over mice
    
    % calculate body speed and acceleration
      % initialize to prepare for case when length(time)<2
        v.MouseTrack.BodySpeed{i} = 0;
        v.MouseTrack.BodyAcceleration{i} = 0;
      for j = 1:length(v.MouseTrack.TrackTime{i})-1 % loop over time
          if v.MouseTrack.BodyCentroid{i}(j,1) > 0 & v.MouseTrack.BodyCentroid{i}(j,2) > 0 & v.MouseTrack.BodyCentroid{i}(j+1,1) > 0 & v.MouseTrack.BodyCentroid{i}(j+1,2) > 0 & v.MouseTrack.TrackTime{i}(j) > 0 & v.MouseTrack.TrackTime{i}(j+1) > 0
              v.MouseTrack.BodySpeed{i}(j) = sqrt((v.MouseTrack.BodyCentroid{i}(j+1,1) - v.MouseTrack.BodyCentroid{i}(j,1))^2 + (v.MouseTrack.BodyCentroid{i}(j+1,2) - v.MouseTrack.BodyCentroid{i}(j,2))^2)*p.fps;
          else
              v.MouseTrack.BodySpeed{i}(j) = 0;
          end;
          if j > 1 & v.MouseTrack.BodySpeed{i}(j) ~= 0 & v.MouseTrack.BodySpeed{i}(j-1) ~= 0
            v.MouseTrack.BodyAcceleration{i}(j) = (v.MouseTrack.BodySpeed{i}(j) - v.MouseTrack.BodySpeed{i}(j-1)) / p.fps;      
          else
            v.MouseTrack.BodyAcceleration{i}(j) = 0;
          end;
      end;
      if length(v.MouseTrack.TrackTime{i})>1 & length(v.MouseTrack.BodySpeed{i}) >= length(v.MouseTrack.TrackTime{i})-1
        v.MouseTrack.BodySpeed{i}(length(v.MouseTrack.TrackTime{i})) = v.MouseTrack.BodySpeed{i}(length(v.MouseTrack.TrackTime{i})-1);
      end;
      v.MouseTrack.BodyAcceleration{i}(length(v.MouseTrack.TrackTime{i})) = 0;
    
    % plot results
      if PLOT == 1
        % open figure - speed
          h = figure('visible', 'off');   
        % plot  
          plot_BODY_SPEED(v.MouseTrack.TrackTime{i}, v.MouseTrack.BodySpeed{i}, Xlim{i}, p);        
        % save figure  
          outputfilename = [OutputMouseFoldername{i} 'Body_Speed_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');
          close(h);
        % open figure - acceleration
          h = figure('visible', 'off');   
        % plot  
          plot_BODY_ACCELERATION(v.MouseTrack.TrackTime{i}, v.MouseTrack.BodyAcceleration{i}, Xlim{i}, p);        
        % save figure  
          outputfilename = [OutputMouseFoldername{i} 'Body_Acceleration_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');
          close(h);
      end;
  end;

% check for ABORT
  if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACCELERATION HISTOGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('ACCELERATION HISTOGRAM')

  for i = MouseArray % loop over mice

    % group points according to speed
      ind0 = find(v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} ~=  -1 & v.MouseTrack.BodySpeed{i} < 100 & v.MouseTrack.Tail1PerpAcceleration{i} ~= -1);
      ind1 = find(v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 100 & v.MouseTrack.BodySpeed{i} < 200 & v.MouseTrack.Tail1PerpAcceleration{i} ~= -1);
      ind2 = find(v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 200 & v.MouseTrack.Tail1PerpAcceleration{i} ~= -1);
      
    % calculate mean and STD for these
      Speed0BodyAccelerationMean{i}  = mean(v.MouseTrack.BodyPerpAcceleration{i}(ind0));
      Speed0BodyAccelerationSTD{i}   =  std(v.MouseTrack.BodyPerpAcceleration{i}(ind0));
      Speed0Tail1AccelerationMean{i} = mean(v.MouseTrack.Tail1PerpAcceleration{i}(ind0));
      Speed0Tail1AccelerationSTD{i}  =  std(v.MouseTrack.Tail1PerpAcceleration{i}(ind0));
      Speed0Tail2AccelerationMean{i} = mean(v.MouseTrack.Tail2PerpAcceleration{i}(ind0));
      Speed0Tail2AccelerationSTD{i}  =  std(v.MouseTrack.Tail2PerpAcceleration{i}(ind0));
      Speed0Tail3AccelerationMean{i} = mean(v.MouseTrack.Tail3PerpAcceleration{i}(ind0));
      Speed0Tail3AccelerationSTD{i}  =  std(v.MouseTrack.Tail3PerpAcceleration{i}(ind0));
      Speed1BodyAccelerationMean{i}  = mean(v.MouseTrack.BodyPerpAcceleration{i}(ind1));
      Speed1BodyAccelerationSTD{i}   =  std(v.MouseTrack.BodyPerpAcceleration{i}(ind1));
      Speed1Tail1AccelerationMean{i} = mean(v.MouseTrack.Tail1PerpAcceleration{i}(ind1));
      Speed1Tail1AccelerationSTD{i}  =  std(v.MouseTrack.Tail1PerpAcceleration{i}(ind1));
      Speed1Tail2AccelerationMean{i} = mean(v.MouseTrack.Tail2PerpAcceleration{i}(ind1));
      Speed1Tail2AccelerationSTD{i}  =  std(v.MouseTrack.Tail2PerpAcceleration{i}(ind1));
      Speed1Tail3AccelerationMean{i} = mean(v.MouseTrack.Tail3PerpAcceleration{i}(ind1));
      Speed1Tail3AccelerationSTD{i}  =  std(v.MouseTrack.Tail3PerpAcceleration{i}(ind1));
      Speed2BodyAccelerationMean{i}  = mean(v.MouseTrack.BodyPerpAcceleration{i}(ind2));
      Speed2BodyAccelerationSTD{i}   =  std(v.MouseTrack.BodyPerpAcceleration{i}(ind2));
      Speed2Tail1AccelerationMean{i} = mean(v.MouseTrack.Tail1PerpAcceleration{i}(ind2));
      Speed2Tail1AccelerationSTD{i}  =  std(v.MouseTrack.Tail1PerpAcceleration{i}(ind2));
      Speed2Tail2AccelerationMean{i} = mean(v.MouseTrack.Tail2PerpAcceleration{i}(ind2));
      Speed2Tail2AccelerationSTD{i}  =  std(v.MouseTrack.Tail2PerpAcceleration{i}(ind2));
      Speed2Tail3AccelerationMean{i} = mean(v.MouseTrack.Tail3PerpAcceleration{i}(ind2));
      Speed2Tail3AccelerationSTD{i}  =  std(v.MouseTrack.Tail3PerpAcceleration{i}(ind2));
     
    % calculate the characteristic maximum values for acceleration
      % this will be based on those points that are local extrema. We will
      % take their median value
      % temporal difference in steps that should be used to identify what
      % is a local maximum. A value will have to be local maximum within +-Nmax 
        Nmax = 2;
      % find those points that are local extrema
        temp00 = [];
        temp01 = [];
        temp02 = [];
        temp03 = [];
        temp10 = [];
        temp11 = [];
        temp12 = [];
        temp13 = [];
        temp20 = [];
        temp21 = [];
        temp22 = [];
        temp23 = [];
        for j = Nmax+1:length(v.MouseTrack.TrackTime{i})-Nmax
          if min(v.MouseTrack.TrackTime{i}(j-Nmax:j+Nmax)) > 0 & isempty(find(v.MouseTrack.BodySpeed{i}(j-Nmax:j+Nmax) == -1))
            if v.MouseTrack.BodySpeed{i}(j) < 100
              temp = v.MouseTrack.BodyPerpAcceleration{i};  if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp00 = [temp00 temp(j)]; end;
              temp = v.MouseTrack.Tail1PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp01 = [temp01 temp(j)]; end;
              temp = v.MouseTrack.Tail2PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp02 = [temp02 temp(j)]; end;
              temp = v.MouseTrack.Tail3PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp03 = [temp03 temp(j)]; end;
            end;
            if v.MouseTrack.BodySpeed{i}(j) > 100 & v.MouseTrack.BodySpeed{i}(j) < 200
              temp = v.MouseTrack.BodyPerpAcceleration{i};  if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp10 = [temp10 temp(j)]; end;
              temp = v.MouseTrack.Tail1PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp11 = [temp11 temp(j)]; end;
              temp = v.MouseTrack.Tail2PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp12 = [temp12 temp(j)]; end;
              temp = v.MouseTrack.Tail3PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp13 = [temp13 temp(j)]; end;
            end;
            if v.MouseTrack.BodySpeed{i}(j) > 200
              temp = v.MouseTrack.BodyPerpAcceleration{i};  if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp20 = [temp20 temp(j)]; end;
              temp = v.MouseTrack.Tail1PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp21 = [temp21 temp(j)]; end;
              temp = v.MouseTrack.Tail2PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp22 = [temp22 temp(j)]; end;
              temp = v.MouseTrack.Tail3PerpAcceleration{i}; if (temp(j) == max(temp(j-Nmax:j+Nmax)) | temp(j) == min(temp(j-Nmax:j+Nmax))) & isempty(find(temp(j-Nmax:j+Nmax) == -1)), temp23 = [temp23 temp(j)]; end;
            end;
          end;
        end;
        if isempty(temp00), temp00 = 0; end;
        if isempty(temp01), temp01 = 0; end;
        if isempty(temp02), temp02 = 0; end;
        if isempty(temp03), temp03 = 0; end;
        if isempty(temp10), temp10 = 0; end;
        if isempty(temp11), temp11 = 0; end;
        if isempty(temp12), temp12 = 0; end;
        if isempty(temp13), temp13 = 0; end;
        if isempty(temp20), temp20 = 0; end;
        if isempty(temp21), temp21 = 0; end;
        if isempty(temp22), temp22 = 0; end;
        if isempty(temp23), temp23 = 0; end;
        v.MouseTrack.BodyPerpAccelerationExtreme0{i}  = median(abs(temp00));
        v.MouseTrack.Tail1PerpAccelerationExtreme0{i} = median(abs(temp01));
        v.MouseTrack.Tail2PerpAccelerationExtreme0{i} = median(abs(temp02));
        v.MouseTrack.Tail3PerpAccelerationExtreme0{i} = median(abs(temp03));
        v.MouseTrack.BodyPerpAccelerationExtreme1{i}  = median(abs(temp10));
        v.MouseTrack.Tail1PerpAccelerationExtreme1{i} = median(abs(temp11));
        v.MouseTrack.Tail2PerpAccelerationExtreme1{i} = median(abs(temp12));
        v.MouseTrack.Tail3PerpAccelerationExtreme1{i} = median(abs(temp13));
        v.MouseTrack.BodyPerpAccelerationExtreme2{i}  = median(abs(temp20));
        v.MouseTrack.Tail1PerpAccelerationExtreme2{i} = median(abs(temp21));
        v.MouseTrack.Tail2PerpAccelerationExtreme2{i} = median(abs(temp22));
        v.MouseTrack.Tail3PerpAccelerationExtreme2{i} = median(abs(temp23));
        
    % make histograms
      Nbin = [-0.01:0.001:0.01];
      [n0Tail1, x0Tail1] = hist(v.MouseTrack.Tail1PerpAcceleration{i}(ind0), Nbin);
      [n0Tail2, x0Tail2] = hist(v.MouseTrack.Tail2PerpAcceleration{i}(ind0), Nbin);
      [n0Tail3, x0Tail3] = hist(v.MouseTrack.Tail3PerpAcceleration{i}(ind0), Nbin);
      [n0Body,  x0Body ] = hist(v.MouseTrack.BodyPerpAcceleration{i}(ind0),  Nbin);
      [n1Tail1, x1Tail1] = hist(v.MouseTrack.Tail1PerpAcceleration{i}(ind1), Nbin);
      [n1Tail2, x1Tail2] = hist(v.MouseTrack.Tail2PerpAcceleration{i}(ind1), Nbin);
      [n1Tail3, x1Tail3] = hist(v.MouseTrack.Tail3PerpAcceleration{i}(ind1), Nbin);
      [n1Body,  x1Body ] = hist(v.MouseTrack.BodyPerpAcceleration{i}(ind1),  Nbin);
      [n2Tail1, x2Tail1] = hist(v.MouseTrack.Tail1PerpAcceleration{i}(ind2), Nbin);
      [n2Tail2, x2Tail2] = hist(v.MouseTrack.Tail2PerpAcceleration{i}(ind2), Nbin);
      [n2Tail3, x2Tail3] = hist(v.MouseTrack.Tail3PerpAcceleration{i}(ind2), Nbin);
      [n2Body,  x2Body ] = hist(v.MouseTrack.BodyPerpAcceleration{i}(ind2),  Nbin);
    % plot
      if PLOT == 1    
        % 0 - 100 mm/s^2
          h = figure('visible', 'off');
          plot(x0Body,  n0Body,  '--',   'Color', [0.0 0.0 0.0],          'LineWidth', 2, 'DisplayName', 'Body');
          hold on;
          plot(x0Tail1, n0Tail1,  '-',   'Color', [0.7 0.0 0.0],          'LineWidth', 2, 'DisplayName', 'Tail1');
          plot(x0Tail2, n0Tail2,  '-',   'Color', [0.0 0.7 0.0],          'LineWidth', 2, 'DisplayName', 'Tail2');
          plot(x0Tail3, n0Tail3,  '-',   'Color', [0.1 0.1 0.7],          'LineWidth', 2, 'DisplayName', 'Tail3');
          legend('Location', 'NE');
          grid on;
          set(gca,'FontSize', 14);
          xlabel('Acceleration [mm/s^2]');
          box on;
          set(gca,'LineWidth',2);
          hold off;
          outputfilename = [OutputMouseFoldername{i} 'Acceleration_Histogram_0_100_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');
          close(h);          
        % 100 - 200 mm/s^2
          h = figure('visible', 'off');
          plot(x1Body,  n1Body,  '--',   'Color', [0.0 0.0 0.0],          'LineWidth', 2, 'DisplayName', 'Body');
          hold on;
          plot(x1Tail1, n1Tail1,  '-',   'Color', [0.7 0.0 0.0],          'LineWidth', 2, 'DisplayName', 'Tail1');
          plot(x1Tail2, n1Tail2,  '-',   'Color', [0.0 0.7 0.0],          'LineWidth', 2, 'DisplayName', 'Tail2');
          plot(x1Tail3, n1Tail3,  '-',   'Color', [0.1 0.1 0.7],          'LineWidth', 2, 'DisplayName', 'Tail3');
          legend('Location', 'NE');
          grid on;
          set(gca,'FontSize', 14);
          xlabel('Acceleration [mm/s^2]');
          box on;
          set(gca,'LineWidth',2);
          hold off;
          outputfilename = [OutputMouseFoldername{i} 'Acceleration_Histogram_100_200_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');
          close(h);          
        % > 200 mm/s^2
          h = figure('visible', 'off');
          plot(x2Body,  n2Body,  '--',   'Color', [0.0 0.0 0.0],          'LineWidth', 2, 'DisplayName', 'Body');
          hold on;
          plot(x2Tail1, n2Tail1,  '-',   'Color', [0.7 0.0 0.0],          'LineWidth', 2, 'DisplayName', 'Tail1');
          plot(x2Tail2, n2Tail2,  '-',   'Color', [0.0 0.7 0.0],          'LineWidth', 2, 'DisplayName', 'Tail2');
          plot(x2Tail3, n2Tail3,  '-',   'Color', [0.1 0.1 0.7],          'LineWidth', 2, 'DisplayName', 'Tail3');
          legend('Location', 'NE');
          grid on;
          set(gca,'FontSize', 14);
          xlabel('Acceleration [mm/s^2]');
          box on;
          set(gca,'LineWidth',2);
          hold off;
          outputfilename = [OutputMouseFoldername{i} 'Acceleration_Histogram_200_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');
          close(h);          
      end;
      
  end;      

  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LEGTIME BODYSPEED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('LEGTIME BODYSPEED')

  for i = MouseArray % loop over mice
    
    % open figure
      h = figure('visible', 'off');

    % LEGTIME
      h1 = subplot(2,1,1);
      subplot('Position',[0.14 0.46 0.83 0.5])
      % plot footprint timing
        [StartStepIndexLF{i}, StartStepIndexLH{i}, StartStepIndexRF{i}, StartStepIndexRH{i}, StopStepIndexLF{i}, StopStepIndexLH{i}, StopStepIndexRF{i}, StopStepIndexRH{i}] = ...
          FootprintTimingPlot(v, p, i, h);        
        
        set(gca,'XtickLabel','');
        xlabel('');
        if PLOT == 1, xlim(Xlim{i}); end;

      if PLOT == 1
        % BODYSPEED
          h2 = subplot(2,1,2);
          subplot('Position',[0.14 0.15 0.83 0.28]);
          plot_BODY_SPEED(v.MouseTrack.TrackTime{i}, v.MouseTrack.BodySpeed{i}, Xlim{i}, p)
      
        % SAVE figure  
          outputfilename = [OutputMouseFoldername{i} 'Leg_Time_Body_Speed_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');
      end;
      close(h);
        
  end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE LEG COMBINATION CODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate ratio of frames where N number of legs are present versus total
% number of frames where at least one leg is present.
disp('CALCULATE LEG COMBINATION CODE')

  for i = MouseArray % loop over mice
    Total{i}(1:5)  = 0;
    FourIndex{i}   = 0; % all four legs are down
    PaceIndex{i}   = 0; % Pace:  Ipsilateral (same side) fore and hind leg only in stance phase
    TrotIndex{i}   = 0; % Trot:  Contralateral (opposite side) fore and hind leg only in stance phase
    WalkIndex{i}   = 0; % Walk: Three of the four corner legs only in stance phase
    BoundIndex{i}  = 0; % Bound/hoping: two hind vs two fore.
    OneLegIndex{i} = 0; % Jump: all legs are swinging (in the air)
    JumpIndex{i}   = 0; % Jump: all legs are swinging (in the air)
    LeftFrontLegX  = v.MouseTrack.LegLF.Centroid{i}(:,1);
    RightFrontLegX = v.MouseTrack.LegRF.Centroid{i}(:,1);
    LeftBackLegX   = v.MouseTrack.LegLH.Centroid{i}(:,1);
    RightBackLegX  = v.MouseTrack.LegRH.Centroid{i}(:,1);
    CombinationCode{i} = [];
    for j = 1:length(v.MouseTrack.TrackTime{i})
      if v.MouseTrack.TrackTime{i}(j) > 0
        N = 0;
        if LeftFrontLegX(j)   > 0, N = N+1; end;
        if RightFrontLegX(j)  > 0, N = N+1; end;
        if LeftBackLegX(j)    > 0, N = N+1; end;
        if RightBackLegX(j)   > 0, N = N+1; end;    
        Total{i}(N+1) = Total{i}(N+1) + 1;
        % initialize CombinationCode. It is 0 for non-canonical combinations,
        % while it will be 1 or -1 for tri and tetrapods, respectively.
          CombinationCode{i}(j) = -3;
            % identify jump events
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  < 0, JumpIndex{i}      = JumpIndex{i}     + 1;  CombinationCode{i}(j) = -2; end;
            % identify 1-foot events
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  < 0, OneLegIndex{i}    = OneLegIndex{i}   + 1;  CombinationCode{i}(j) = -1; end;
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  < 0, OneLegIndex{i}    = OneLegIndex{i}   + 1;  CombinationCode{i}(j) = -1; end;
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  < 0, OneLegIndex{i}    = OneLegIndex{i}   + 1;  CombinationCode{i}(j) = -1; end;
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  > 0, OneLegIndex{i}    = OneLegIndex{i}   + 1;  CombinationCode{i}(j) = -1; end;
            % identify bound/hoping events
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  < 0, BoundIndex{i}     = BoundIndex{i}    + 1;  CombinationCode{i}(j) =  0; end;
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  > 0, BoundIndex{i}     = BoundIndex{i}    + 1;  CombinationCode{i}(j) =  0; end;
            % identify pace events
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  < 0, PaceIndex{i}      = PaceIndex{i}     + 1;  CombinationCode{i}(j) =  1; end;
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  > 0, PaceIndex{i}      = PaceIndex{i}     + 1;  CombinationCode{i}(j) =  1; end;
            % identify trot events
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  > 0, TrotIndex{i}      = TrotIndex{i}     + 1;  CombinationCode{i}(j) =  2; end;
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  < 0, TrotIndex{i}      = TrotIndex{i}     + 1;  CombinationCode{i}(j) =  2; end;
            % identify walk events
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  < 0, WalkIndex{i}      = WalkIndex{i}     + 1;  CombinationCode{i}(j) =  3; end;
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  < 0 & RightBackLegX(j)  > 0, WalkIndex{i}      = WalkIndex{i}     + 1;  CombinationCode{i}(j) =  3; end;
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  < 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  > 0, WalkIndex{i}      = WalkIndex{i}     + 1;  CombinationCode{i}(j) =  3; end;
              if  LeftFrontLegX(j)  < 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  > 0, WalkIndex{i}      = WalkIndex{i}     + 1;  CombinationCode{i}(j) =  3; end;      
            % identify four leg event  
              if  LeftFrontLegX(j)  > 0 & RightFrontLegX(j)  > 0 & LeftBackLegX(j)  > 0 & RightBackLegX(j)  > 0, FourIndex{i}      = FourIndex{i}     + 1;  CombinationCode{i}(j) =  4; end;      
      else
        CombinationCode{i}(j) = -3;
      end;
    end
  end;
  

  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% SPEED DISTRIBUTION WHILE TROTTING AND OTHERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find times when mouse has a certain gait and plot histogram of body speed
% at these times
disp('SPEED DISTRIBUTION WHILE TROTTING AND OTHERS')         
  
  for i = MouseArray % loop over mice
    % find trotting times
      indHop   = find(CombinationCode{i} ==  0 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 0);
      indPace  = find(CombinationCode{i} ==  1 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 0);
      indTrot  = find(CombinationCode{i} ==  2 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 0);
      indWalk  = find(CombinationCode{i} ==  3 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 0);
      indFour  = find(CombinationCode{i} ==  4 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 0);
      indOther = find(CombinationCode{i} == -3 & v.MouseTrack.TrackTime{i} > 0 & v.MouseTrack.BodySpeed{i} >= 0);
    % create histogram of bodyspeeds at this time
      [nHop,  vHop  ] = hist(smooth(v.MouseTrack.BodySpeed{i}(indHop  ),1) / p.mm2pix, [0:15:300]);
      [nPace, vPace ] = hist(smooth(v.MouseTrack.BodySpeed{i}(indPace ),1) / p.mm2pix, [0:15:300]);
      [nTrot, vTrot ] = hist(smooth(v.MouseTrack.BodySpeed{i}(indTrot ),1) / p.mm2pix, [0:15:300]);
      [nWalk, vWalk ] = hist(smooth(v.MouseTrack.BodySpeed{i}(indWalk ),1) / p.mm2pix, [0:15:300]);
      [nFour, vFour ] = hist(smooth(v.MouseTrack.BodySpeed{i}(indFour ),1) / p.mm2pix, [0:15:300]);
      [nOther,vOther] = hist(smooth(v.MouseTrack.BodySpeed{i}(indOther),1) / p.mm2pix, [0:15:300]);
    % plot
      if PLOT == 1         
        h = figure('visible', 'off');
        plot(vHop , nHop ,  '-',   'Color', [0 1 0],          'LineWidth', 2, 'DisplayName', 'Bound/hop');
        hold on;
        plot(vPace, nPace,  '-',   'Color', [0 0 1],          'LineWidth', 2, 'DisplayName', 'Pace');
        plot(vTrot, nTrot,  '-',   'Color', [1 0 0],          'LineWidth', 2, 'DisplayName', 'Trot');
        plot(vWalk, nWalk,  '--',  'Color', [0 0 0],          'LineWidth', 2, 'DisplayName', 'Walk');
        plot(vFour, nFour,  ':',   'Color', [0.3 0.3 0.3],    'LineWidth', 2, 'DisplayName', '4 feet');
        plot(vOther,nOther, '.-',  'Color', [255;127;36]/255, 'LineWidth', 2, 'DisplayName', 'Other');
        legend('Location', 'NE');
        grid on;
        set(gca,'FontSize', 14);
        xlabel('Body speed [mm/s]');
        box on;
        set(gca,'LineWidth',2);
        hold off;
        outputfilename = [OutputMouseFoldername{i} 'SpeedDist_Gait_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
        close(h);       
      end;
  end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% LEG COMBINATION COLOR CODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot combination color code as a function of time. 
%  four  legs         (four)  +4
%  three legs         (walk)  +3
%  two opposite       (trot)  +2
%  two same side      (pace)  +1
%  two front or back  (bound)  0
%  1 leg                      -1
%  jump (0 leg)               -2
%  something else             -3
% calculate moving average using parameter CombinationBinSize that defines
% over how many frames one should average
disp('LEG COMBINATION COLOR CODE')       

  for i = MouseArray % loop over mice
      
    % plot
      if PLOT == 1
        h = figure('visible', 'off');
        axes('position', [0 0 1 1])

        plot_LEG_COMBINATION_COLOR_CODE(v.MouseTrack.TrackTime{i}, CombinationCode{i}, p);

        set(h,'PaperUnits', 'normalized');
        set(h,'PaperPosition', [0 0 1 0.09]);

      % SAVE plot
        outputfilename = [OutputMouseFoldername{i} 'Combination_Color_Code_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
      % draw the same thing but with fixed x scale
        XLIM = xlim;
        set(h,'PaperPosition', [0 0 2*(XLIM(2) - XLIM(1)) 0.09]);
      % SAVE fixed scale plot
        outputfilename = [OutputMouseFoldername{i} 'Combination_Color_Code_Fixed_Scale_' ExperimentName '.png'];
        % only save if file is not too big (otherwise it freezes)
          if (XLIM(2) - XLIM(1))*p.fps < 400
            saveas(h,outputfilename,'png');
          end;
      % close plot
        close(h);
      end;
      
  end;
  
  % check for ABORT
    if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
% LEG COMBINATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('LEG COMBINATION')
    
  for i = MouseArray % loop over mice

    if PLOT == 1
      % create figure
        h = figure('visible', 'off');    

      % plot
        Plot_LEG_COMBINATION(v.MouseTrack.TrackTime{i}, CombinationCode{i}, p);

      % SAVE plot
        outputfilename = [OutputMouseFoldername{i} 'Combination_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');

      % save the same plot but with fixed scale
        % set picture size to have correct ratio, such that 0.5 sec is the original size
          set(h,'PaperUnits', 'normalized');
          XLIM = xlim;
          set(h,'PaperPosition', [0 0 2*(XLIM(2) - XLIM(1)) 1]);

      % SAVE plot
        outputfilename = [OutputMouseFoldername{i} 'Combination_Fixed_Scale_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');

      % close figure
        close(h);
    end;
    
  end;

  % check for ABORT
    if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LEG_TIME + BODY_SPEED + LEG_COMBINATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% combine these three in one plot
disp('LEG_TIME + BODY_SPEED + LEG_COMBINATION')

  for i = MouseArray % loop over mice

    % create figure
      h = figure('visible', 'off');

    % plot LEG TIME
      h1 = subplot(4,1,1);
      subplot('Position',[0.14 0.71 0.83 0.28]);
      [StartStepIndexLF{i}, StartStepIndexLH{i}, StartStepIndexRF{i}, StartStepIndexRH{i}, StopStepIndexLF{i}, StopStepIndexLH{i}, StopStepIndexRF{i}, StopStepIndexRH{i}] = ...
        FootprintTimingPlot(v, p, i, h);
      
      if PLOT == 1

        set(gca, 'XLim', Xlim{i}); 
        set(gca,'XTickLabel',[]);

        % TEXT on screen
          LineWidth = 40;      
          % name of data
          text(Xlim{i}(1),-1000-1*LineWidth,['Data name: ' ExperimentName '  (mouse #' num2str(i) ')'],'FontSize', 20,'FontName','FixedWidth', 'Interpreter', 'None');        
      
        % plot BODY SPEED
          h2 = subplot(4,1,2);
          subplot('Position',[0.14 0.56 0.83 0.14]);      
          plot_BODY_SPEED(v.MouseTrack.TrackTime{i}, v.MouseTrack.BodySpeed{i}, Xlim{i}, p);
          set(gca, 'XLim', Xlim{i}); 
          set(gca,'XTickLabel',[]);

        % plot LEG COMBINATION COLOR CODE
          h3 = subplot(4,1,3);
          subplot('Position',[0.14 0.41 0.83 0.14]);      
          plot_LEG_COMBINATION_COLOR_CODE(v.MouseTrack.TrackTime{i}, CombinationCode{i}, p);
          set(gca, 'XLim', Xlim{i}); 
          set(gca,'XTickLabel',[]);

        % plot LEG COMBINATION
          h4 = subplot(4,1,4);
          subplot('Position',[0.14 0.26 0.83 0.14]);
          Plot_LEG_COMBINATION(v.MouseTrack.TrackTime{i}, CombinationCode{i}, p);
          set(gca, 'XLim', Xlim{i}); 

        % SAVE plot
          outputfilename = [OutputMouseFoldername{i} 'Leg_Time_Body_Speed_Combination_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');

        % save the same plot but with fixed scale
          % set picture size to have correct ratio, such that 0.5 sec is the original size
            set(h,'PaperUnits', 'normalized');
            XLIM = xlim;
            set(h,'PaperPosition', [0 0 2*(XLIM(2) - XLIM(1)) 1]);

        % SAVE plot
            outputfilename = [OutputMouseFoldername{i} 'Leg_Time_Body_Speed_Combination_Fixed_Scale_' ExperimentName '.png'];
            saveas(h,outputfilename,'png');
      end;        
    % close figure
      close(h);
      
  end;
  

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BODY CENTER DIRECTION COMPARED TO MOTION DIRECTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show the direction of the body center w.r.t. the direction of motion as a
% function of time.
disp('BODY CENTER DIRECTION COMPARED TO MOTION DIRECTION');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP RELATIVE POSITION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('STEP RELATIVE POSITION')

  % make lines on figure little brighter than end points
    brightning = 1;

  % initialize
    StartPosition = [];
    StopPosition = [];

  for i = MouseArray % loop over mice
    
    % open figure
      h = figure('visible', 'off');       

    % plot step relative positions 
      [StartPosition, StopPosition] = StepRelativePositionPlot(v, p, i, ColorLF, ColorLH, ColorRF, ColorRH, StartStepIndexLF, StartStepIndexLH, StartStepIndexRF, StartStepIndexRH, StopStepIndexLF, StopStepIndexLH, StopStepIndexRF, StopStepIndexRH, brightning, h, StartPosition, StopPosition);

    % set picture size to have correct ratio
      H = xlim;
      W = ylim;
      set(h,'PaperPosition', [0 0 H(2)-H(1) W(2)-W(1)]*8);
      set(gca,'Layer','Top'); % put grid on top    
      
    % save figure
      if PLOT == 1
        outputfilename = [OutputMouseFoldername{i} 'Step_Start_Relative_Position_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
      end;
      close(h);        
      
  end;
  
  % check for ABORT
    if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BODY LENGTH 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('BODY LENGTH')  
    
  for i = MouseArray % loop over mice
    % calculate length of body for times in which the mouse is present
      % find times that are not cancelled
        indT = find(v.MouseTrack.TrackTime{i}' > 0 & v.MouseTrack.BodyCentroid{i}(:,1) > 0 & v.MouseTrack.BodyBackCentroid{i}(:,1) > 0);
      BodyLengthArray{i} = 4*sqrt((v.MouseTrack.BodyCentroid{i}(:,1) - v.MouseTrack.BodyBackCentroid{i}(:,1)).^2+(v.MouseTrack.BodyCentroid{i}(:,2) - v.MouseTrack.BodyBackCentroid{i}(:,2)).^2) / p.mm2pix;   
      BodyLengthArrayNose{i} = 2*sqrt((v.MouseTrack.BodyCentroid{i}(:,1) - v.MouseTrack.Nose{i}(:,1)).^2+(v.MouseTrack.BodyCentroid{i}(:,2) - v.MouseTrack.Nose{i}(:,2)).^2) / p.mm2pix;   
      
    % plot
      if PLOT == 1  
        h = figure('visible', 'off');       
        h1 = subplot(2,1,1);
        subplot('Position',[0.14 0.46 0.83 0.5])        
        plot(v.MouseTrack.TrackTime{i}(indT), smooth(BodyLengthArray{i}(indT),1),  '-',   'Color', [1 0 0],          'LineWidth', 2, 'DisplayName', 'Body length (back)');
        hold on;
        plot(v.MouseTrack.TrackTime{i}(indT), smooth(BodyLengthArrayNose{i}(indT),1),  '-',   'Color', [0 0 1],          'LineWidth', 2, 'DisplayName', 'Body length (nose)');
        legend('Location', 'SE');
        grid on;
        set(gca,'FontSize', 14);
        ylabel('Body length [mm]');
        box on;
        set(gca,'LineWidth',2);
        set(gca,'XtickLabel','');
        xlabel('');        
        xlim(Xlim{i});    
        hold off;
        % BODYSPEED
          h2 = subplot(2,1,2);
          subplot('Position',[0.14 0.15 0.83 0.28]);
          plot_BODY_SPEED(v.MouseTrack.TrackTime{i}, v.MouseTrack.BodySpeed{i}, Xlim{i}, p);
        outputfilename = [OutputMouseFoldername{i} 'BodyLength_' ExperimentName '.png'];
        saveas(h,outputfilename,'png');
        close(h);       
      end;      
      
  end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUMMARY PLOT  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('SUMMARY PLOT')  

  for i = MouseArray % loop over mice

    % define summary plot
      h = figure('visible', 'off','PaperPosition', [0 0 22 14], 'Units', 'inches');

    % FOOTPRINT TIMING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      % define subplot
        h1 = subplot(5,2,[1 3]);
        subplot('Position',[0.05 0.7 0.45 0.25], 'FontSize', 14);
      % plot footprint timing
        [StartStepIndexLF{i}, StartStepIndexLH{i}, StartStepIndexRF{i}, StartStepIndexRH{i}, StopStepIndexLF{i}, StopStepIndexLH{i}, StopStepIndexRF{i}, StopStepIndexRH{i}] = ...
          FootprintTimingPlot(v, p, i, h1);
      if PLOT == 1  
        % set up figure
          set(gca,'XtickLabel','');
          xlabel('');
          xlim(Xlim{i}); 

        % TEXT ON SCREEN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          % Things have to be between 0 and 1 (both x and y coordinates)
            LineWidth = 40;      
            % name of data
            text(Xlim{i}(1),-1000-1*LineWidth,['Data name: ' ExperimentName '  (mouse #' num2str(i) ')'],'FontSize', 20,'FontName','FixedWidth', 'Interpreter', 'None');        


        % BODY SPEED ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          % define subplot
            h2 = subplot(5,2,5);
            subplot('Position',[0.05 0.55 0.45 0.145], 'FontSize', 14);
          % plot body speed
            plot_BODY_SPEED(v.MouseTrack.TrackTime{i}, v.MouseTrack.BodySpeed{i}, Xlim{i}, p); 
            set(gca,'XtickLabel','');
            set(gca, 'XLim', Xlim{i});

        % COMBINATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          % define subplot
            h3 = subplot(5,2,7);
            subplot('Position',[0.05 0.4 0.45 0.145], 'FontSize', 14);    
          % plot combination
            Plot_LEG_COMBINATION(v.MouseTrack.TrackTime{i}, CombinationCode{i}, p);
            set(gca,'XtickLabel','');
            set(gca, 'XLim', Xlim{i}); 


        % FOOTPRINT TOTAL BRIGHTNESS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          % define subplot
            h4 = subplot(5,2,9);
            subplot('Position',[0.05 0.2 0.45 0.195], 'FontSize', 14);    
          % plot footprint total brightness
            indT = find(v.MouseTrack.TrackTime{i} > 0);
            plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegLF.FootSize{i}(indT)) / p.mm2pix^2,'-', 'Color', ColorLF, 'LineWidth', 3, 'DisplayName', 'Left Fore');
            hold on;
            plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegRF.FootSize{i}(indT)) / p.mm2pix^2,'-', 'Color', ColorRF, 'LineWidth', 3, 'DisplayName', 'Right Fore');
            plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegLH.FootSize{i}(indT)) / p.mm2pix^2,'-', 'Color', ColorLH, 'LineWidth', 3, 'DisplayName', 'Left Hind');
            plot(v.MouseTrack.TrackTime{i}(indT),max(0,v.MouseTrack.LegRH.FootSize{i}(indT)) / p.mm2pix^2,'-', 'Color', ColorRH, 'LineWidth', 3, 'DisplayName', 'Right Hind');
            plot(v.MouseTrack.TrackTime{i}(indT),(max(0,v.MouseTrack.LegRF.FootSize{i}(indT))+max(0,v.MouseTrack.LegRH.FootSize{i}(indT))+max(0,v.MouseTrack.LegLF.FootSize{i}(indT))+max(0,v.MouseTrack.LegLH.FootSize{i}(indT))) / p.mm2pix^2,'--', 'Color', [0.3 0.3 0.3]/255, 'LineWidth', 3, 'DisplayName', 'Total');
            legend('Location', 'NE');
            grid on;
            set(gca,'FontSize', 14);
            xlabel('Time [s]');
            ylabel('Total footprint size [mm^2]');
            box on;
            set(gca,'LineWidth',2);
            hold off;    
            set(gca, 'XLim', Xlim{i});


        % STEP RELATIVE POSITION
          % define plot
            h5 = subplot(5,2,[2 4 6 8]);
            subplot('Position',[0.55 0.1 0.4 0.85], 'FontSize', 14)    

          % plot step relative positions 
            [StartPosition, StopPosition] = StepRelativePositionPlot(v, p, i, ColorLF, ColorLH, ColorRF, ColorRH, StartStepIndexLF, StartStepIndexLH, StartStepIndexRF, StartStepIndexRH, StopStepIndexLF, StopStepIndexLH, StopStepIndexRF, StopStepIndexRH, brightning, h, StartPosition, StopPosition);        

        % save figure
          outputfilename = [OutputMouseFoldername{i} 'Summary_Plot_' ExperimentName '.png'];
          saveas(h,outputfilename,'png');    
      end;
      close(h);
  end;  
  
  
% check for ABORT
  if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXCEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write data to excel file
disp('EXCEL')
if EXCEL == 1
  for i = MouseArray % loop over mice
    
    % excel file name for this mouse
      ExcelFileName = [OutputMouseFoldername{i} 'MouseTrackExcel_' ExperimentName '_' num2str(i) '.xls'];
    
    % 1.INFORMATION SHEET =================================================
      disp('   1. Info Sheet')
      InfoData = [{'INFORMATION SHEET'};...
                  {''};...
                  {'Sheet  1: Information'};...
                  {'Sheet  2: Parameters'};...
                  {'Sheet  3: Body'};...
                  {'Sheet  4: LF'};...
                  {'Sheet  5: LH'};...
                  {'Sheet  6: RF'};...
                  {'Sheet  7: RH'};...
%                   {'Sheet 10: Leg Combinations'};...
                  {'Sheet 11: Minimum/Maximum/Mean Leg Distance and Angle Information'};...
                  {'Sheet 12: Full data'};...
                  {'Sheet 13: Step size and velocity'};...
                  {'Sheet 14: Body velocity'};...
                  {'Sheet 15: Leg alignment'};...
                  {''};...
                  {''};...
                  {''};...
                  {'Columns in sheet 3:'};...
                  {'1: time'};...
                  {': x coordinate'};...
                  {': y coordinate'};...
                  {': directional parameter #1'};...
                  {': directional parameter #2'};...
                  {': directional parameter #3'};...
                  {': orientation'};...
                  {': STD x'};...
                  {': STD y'};...
                  {''};...
                  {'Columns in sheets 4-9:'};...
                  {'1: time'};...
                  {'2: distance'};...
                  {'3: parallel distance'};...
                  {'4: perpendicular distance'};...
                  {'5: angle between leg and body direction'}];
      WriteExcel(ExcelFileName, InfoData,'1.Info_Sheet');
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      
  % 2. PARAMETERS =========================================================
    disp('   2. PARAMETERS');
    Data = { 'PARAMETERS' '';...
        '' '';...
        'Frame settings--------------------------------------------------' '';...
        'Video frame per second [fps]: ' num2str(p.fps);...
        'Distance calibration [pixel/mm]: ' num2str(p.mm2pix);...
        '' '';...
        'Number of frames where the mouse''s body is on: ' num2str(length(find(v.MouseTrack.BodyCentroid{i}(:,1) > 0)))};
      WriteExcel(ExcelFileName, Data,'2.Parameters');    
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      
  % 3. BODY ===============================================================
    disp('   3. BODY');
    % find times that are not cancelled
      indT = find(v.MouseTrack.TrackTime{i} > 0);
      Data = [v.MouseTrack.TrackTime{i}(indT)' ...
              v.MouseTrack.Nose{i}(indT,2) ...
              v.MouseTrack.Nose{i}(indT,1) ...
              v.MouseTrack.HeadCentroid{i}(indT,2) ...
              v.MouseTrack.HeadCentroid{i}(indT,1) ...
              v.MouseTrack.HeadOrientation{i}(indT)' ...
              v.MouseTrack.BodyCentroid{i}(indT,2) ...
              v.MouseTrack.BodyCentroid{i}(indT,1) ...
              v.MouseTrack.BodyOrientation{i}(indT)' ...
              v.MouseTrack.BodyBackCentroid{i}(indT,2) ...
              v.MouseTrack.BodyBackCentroid{i}(indT,1) ...
              v.MouseTrack.BodyBackOrientation{i}(indT)' ...
              v.MouseTrack.Tail1Centroid{i}(indT,2) ...
              v.MouseTrack.Tail1Centroid{i}(indT,1) ...
              v.MouseTrack.Tail1Orientation{i}(indT)' ...
              v.MouseTrack.Tail2Centroid{i}(indT,2) ...
              v.MouseTrack.Tail2Centroid{i}(indT,1) ...
              v.MouseTrack.Tail2Orientation{i}(indT)' ...
              v.MouseTrack.Tail3Centroid{i}(indT,2) ...
              v.MouseTrack.Tail3Centroid{i}(indT,1) ...
              v.MouseTrack.Tail3Orientation{i}(indT)' ...
              v.MouseTrack.Tail{i}(indT,2) ...
              v.MouseTrack.Tail{i}(indT,1)];
    Data = num2cell(Data);
    Data(2:end+1,:) = Data;
    Data(1,:) = {'Time', 'NoseX', 'NoseY', 'HeadX', 'HeadY', 'HeadAngle', 'BodyX', 'BodyY', 'BodyAngle', 'BodyBackX', 'BodyBackY', 'BodyBackAngle', 'Tail1X', 'Tail1Y', 'Tail1Angle', 'Tail2X', 'Tail2Y', 'Tail2Angle', 'Tail3X', 'Tail3Y', 'Tail3Angle', 'TailEndX', 'TailEndY'};            
    if length(Data) == 0, Data = {'No data...', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''}; end;    
    WriteExcel(ExcelFileName, Data,'3.Body');

    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      
      
      
  % 4. LF =================================================================
    disp('   4. LF');
    Ind = find(Distance{i}(1,:) ~= -1 & v.MouseTrack.TrackTime{i} > 0);
    Data = [v.MouseTrack.TrackTime{i}(Ind)' v.MouseTrack.LegLF.Centroid{i}(Ind,2) v.MouseTrack.LegLF.Centroid{i}(Ind,1) Distance{i}(1,Ind)' ParaDist{i}(1,Ind)' PerpDist{i}(1,Ind)' Angle{i}(1,Ind)'];
    if length(Data) == 0, Data = {'No data...', '', '', '', '', '', ''}; end;    
    Data = num2cell(Data);
    Data(2:end+1,:) = Data;
    Data(1,:) = {'Time', 'X', 'Y', 'Distance', 'Para', 'Perp', 'Angle'};
    WriteExcel(ExcelFileName, Data,'4.LF');
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;      
  % 5. LH =================================================================
    disp('   5. LH');
    Ind = find(Distance{i}(2,:) ~= -1 & v.MouseTrack.TrackTime{i} > 0);
    Data = [v.MouseTrack.TrackTime{i}(Ind)' v.MouseTrack.LegLH.Centroid{i}(Ind,2) v.MouseTrack.LegLH.Centroid{i}(Ind,1) Distance{i}(2,Ind)' ParaDist{i}(2,Ind)' PerpDist{i}(2,Ind)' Angle{i}(2,Ind)'];
    if length(Data) == 0, Data = {'No data...', '', '', '', '', '', ''}; end;    
    Data = num2cell(Data);
    Data(2:end+1,:) = Data;
    Data(1,:) = {'Time', 'X', 'Y', 'Distance', 'Para', 'Perp', 'Angle'};
    WriteExcel(ExcelFileName, Data,'5.LH');
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;      
  % 6. RF =================================================================
    disp('   6. RF');
    Ind = find(Distance{i}(3,:) ~= -1 & v.MouseTrack.TrackTime{i} > 0);
    Data = [v.MouseTrack.TrackTime{i}(Ind)' v.MouseTrack.LegRF.Centroid{i}(Ind,2) v.MouseTrack.LegRF.Centroid{i}(Ind,1) Distance{i}(3,Ind)' ParaDist{i}(3,Ind)' PerpDist{i}(3,Ind)' Angle{i}(3,Ind)'];
    if length(Data) == 0, Data = {'No data...', '', '', '', '', '', ''}; end;    
    Data = num2cell(Data);
    Data(2:end+1,:) = Data;
    Data(1,:) = {'Time', 'X', 'Y', 'Distance', 'Para', 'Perp', 'Angle'};
    WriteExcel(ExcelFileName, Data,'6.RF');
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;      
  % 7. RH =================================================================
    disp('   7. RH');
    Ind = find(Distance{i}(4,:) ~= -1 & v.MouseTrack.TrackTime{i} > 0);
    Data = [v.MouseTrack.TrackTime{i}(Ind)' v.MouseTrack.LegRH.Centroid{i}(Ind,2) v.MouseTrack.LegRH.Centroid{i}(Ind,1) Distance{i}(4,Ind)' ParaDist{i}(4,Ind)' PerpDist{i}(4,Ind)' Angle{i}(4,Ind)'];
    if length(Data) == 0, Data = {'No data...', '', '', '', '', '', ''}; end;    
    Data = num2cell(Data);
    Data(2:end+1,:) = Data;
    Data(1,:) = {'Time', 'X', 'Y', 'Distance', 'Para', 'Perp', 'Angle'};
    WriteExcel(ExcelFileName, Data,'7.RH');      
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;      
      
  % 10. LEG COMBINATIONS ==================================================
    disp('  10. LEG COMBINATIONS');
    
    % find number of leg combinations
      LegDown(1:16) = 0; % each represents a combination of legs. This will be a count of how many times that combination is down.
      % find times that are not cancelled
        indT = find(v.MouseTrack.TrackTime{i} > 0);
      for j = indT
          % Each leg is represented with 2^k where k is the leg number (order: LF LH RF RH)
            LegCombination = 0;
            NumberofLegs = 0;
          % convert leg combination into number from 1 to 16
            if v.MouseTrack.LegLF.Centroid{i}(j,1) > 0 LegCombination = LegCombination + 2^3; NumberofLegs = NumberofLegs + 1; end;
            if v.MouseTrack.LegLH.Centroid{i}(j,1) > 0 LegCombination = LegCombination + 2^2; NumberofLegs = NumberofLegs + 1; end;
            if v.MouseTrack.LegRF.Centroid{i}(j,1) > 0 LegCombination = LegCombination + 2^1; NumberofLegs = NumberofLegs + 1; end;
            if v.MouseTrack.LegRH.Centroid{i}(j,1) > 0 LegCombination = LegCombination + 2^0; NumberofLegs = NumberofLegs + 1; end;
          % save legcombinations in an array
            LegCombinationArray(j) = LegCombination;
          % make the empty legcombination be 16 so Matlab can store it (sinde indices start with 1 and not 0)
            if LegCombination  == 0
                LegCombination = 16;
            end;
          % add 1 to the combination found
            LegDown(LegCombination) = LegDown(LegCombination) + 1;
      end;
      % cut out no legs
        LegDown = LegDown(1:15);
      % order combinations
        [B, CommonLegDown] = sort(LegDown);
        B = B(15:-1:1);
        CommonLegDown = CommonLegDown(15:-1:1);
        MostCommonCombinations = dec2bin(CommonLegDown,4);
        NumbersofCombinations = B;
        
    % Leg Combinations
      DataCell = {'Leg combinations with numbers of occurrences for each combination:' ''; ...
        '' ''; ...
        '1 - leg is present in combination' ''; ...
        '0 - leg is notpresent in combination' ''; ...
        '' ''; ...
        'Leg order in combination:' ''; ...
        'LF LH RF RH' ''; ...
        '' ''; ...
        [ '  ' num2str(MostCommonCombinations(1,:))]   NumbersofCombinations(1); ...
        [ '  ' num2str(MostCommonCombinations(2,:))]   NumbersofCombinations(2); ...
        [ '  ' num2str(MostCommonCombinations(3,:))]   NumbersofCombinations(3); ...
        [ '  ' num2str(MostCommonCombinations(4,:))]   NumbersofCombinations(4); ...
        [ '  ' num2str(MostCommonCombinations(5,:))]   NumbersofCombinations(5); ...
        [ '  ' num2str(MostCommonCombinations(6,:))]   NumbersofCombinations(6); ...
        [ '  ' num2str(MostCommonCombinations(7,:))]   NumbersofCombinations(7); ...
        [ '  ' num2str(MostCommonCombinations(8,:))]   NumbersofCombinations(8); ...
        [ '  ' num2str(MostCommonCombinations(9,:))]   NumbersofCombinations(9); ...
        [ '  ' num2str(MostCommonCombinations(10,:))]  NumbersofCombinations(10); ...
        [ '  ' num2str(MostCommonCombinations(11,:))]  NumbersofCombinations(11); ...
        [ '  ' num2str(MostCommonCombinations(12,:))]  NumbersofCombinations(12); ...
        [ '  ' num2str(MostCommonCombinations(13,:))]  NumbersofCombinations(13); ...
        [ '  ' num2str(MostCommonCombinations(14,:))]  NumbersofCombinations(14); ...
        [ '  ' num2str(MostCommonCombinations(15,:))]  NumbersofCombinations(15); ...
        '' ''; ...
        '' ''; ...
        'Leg Number Index (ratio of frames where the fly has N leg present):' ''; ...
        '' ''; ...
        'N=1' num2str(Total{i}(2)/sum(Total{i}(2:end))); ...
        'N=2' num2str(Total{i}(3)/sum(Total{i}(2:end))); ...
        'N=3' num2str(Total{i}(4)/sum(Total{i}(2:end))); ...
        'N=4' num2str(Total{i}(5)/sum(Total{i}(2:end))); ...
        '' ''; ...
        'Four index'  num2str(  FourIndex{i}/sum(Total{i}(2:end))); ...
        'Pace index'  num2str(  PaceIndex{i}/sum(Total{i}(2:end))); ...
        'Trot index'  num2str(  TrotIndex{i}/sum(Total{i}(2:end))); ...
        'Walk index'  num2str(  WalkIndex{i}/sum(Total{i}(2:end))); ...
        'Bound index' num2str( BoundIndex{i}/sum(Total{i}(2:end)));...
        '1-leg index' num2str(OneLegIndex{i}/sum(Total{i}(2:end)));...
        'Jump index'  num2str(  JumpIndex{i}/sum(Total{i}(2:end)))};...
%         '' ''; ...
%         '' ''; ...        
%         'Fraction of 2+ FP turnons' num2str(FractionOf2OrMoreTurnons); ...
%         '' ''; ...
%         '' ''; ...        
%         'Average combination trace code' num2str(AVGcombtrace); ...
%         'STD combination trace code' num2str(STDcombtrace)};    
    
    WriteExcel(ExcelFileName, DataCell,['10.Leg combinations']);
     
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      

  % 11. POSITION STATISTICS ===============================================
    disp('  11. POSITION STATISTICS');
    if isfield(StartPosition, 'X')
    % determine start and stop position averages
      if length(StartPosition.X.LF) >= i, StartPosition.X.Avg.LF{i} = mean(StartPosition.X.LF{i}); else StartPosition.X.Avg.LF{i} = -1; end;
      if length(StartPosition.X.LH) >= i, StartPosition.X.Avg.LH{i} = mean(StartPosition.X.LH{i}); else StartPosition.X.Avg.LH{i} = -1; end;
      if length(StartPosition.X.RF) >= i, StartPosition.X.Avg.RF{i} = mean(StartPosition.X.RF{i}); else StartPosition.X.Avg.RF{i} = -1; end;
      if length(StartPosition.X.RH) >= i, StartPosition.X.Avg.RH{i} = mean(StartPosition.X.RH{i}); else StartPosition.X.Avg.RH{i} = -1; end;
      if length(StartPosition.Y.LF) >= i, StartPosition.Y.Avg.LF{i} = mean(StartPosition.Y.LF{i}); else StartPosition.Y.Avg.LF{i} = -1; end;
      if length(StartPosition.Y.LH) >= i, StartPosition.Y.Avg.LH{i} = mean(StartPosition.Y.LH{i}); else StartPosition.Y.Avg.LH{i} = -1; end;
      if length(StartPosition.Y.RF) >= i, StartPosition.Y.Avg.RF{i} = mean(StartPosition.Y.RF{i}); else StartPosition.Y.Avg.RF{i} = -1; end;
      if length(StartPosition.Y.RH) >= i, StartPosition.Y.Avg.RH{i} = mean(StartPosition.Y.RH{i}); else StartPosition.Y.Avg.RH{i} = -1; end;
      if length(StopPosition.X.LF) >= i,  StopPosition.X.Avg.LF{i}  = mean(StopPosition.X.LF{i});  else StopPosition.X.Avg.LF{i}  = -1; end;
      if length(StopPosition.X.LH) >= i,  StopPosition.X.Avg.LH{i}  = mean(StopPosition.X.LH{i});  else StopPosition.X.Avg.LH{i}  = -1; end;
      if length(StopPosition.X.RF) >= i,  StopPosition.X.Avg.RF{i}  = mean(StopPosition.X.RF{i});  else StopPosition.X.Avg.RF{i}  = -1; end;
      if length(StopPosition.X.RH) >= i,  StopPosition.X.Avg.RH{i}  = mean(StopPosition.X.RH{i});  else StopPosition.X.Avg.RH{i}  = -1; end;
      if length(StopPosition.Y.LF) >= i,  StopPosition.Y.Avg.LF{i}  = mean(StopPosition.Y.LF{i});  else StopPosition.Y.Avg.LF{i}  = -1; end;
      if length(StopPosition.Y.LH) >= i,  StopPosition.Y.Avg.LH{i}  = mean(StopPosition.Y.LH{i});  else StopPosition.Y.Avg.LH{i}  = -1; end;
      if length(StopPosition.Y.RF) >= i,  StopPosition.Y.Avg.RF{i}  = mean(StopPosition.Y.RF{i});  else StopPosition.Y.Avg.RF{i}  = -1; end;
      if length(StopPosition.Y.RH) >= i,  StopPosition.Y.Avg.RH{i}  = mean(StopPosition.Y.RH{i});  else StopPosition.Y.Avg.RH{i}  = -1; end;
      if length(StartPosition.X.LF) >= i, StartPosition.X.STD.LF{i} = std(StartPosition.X.LF{i});  else StartPosition.X.STD.LF{i} = -1; end;
      if length(StartPosition.X.LH) >= i, StartPosition.X.STD.LH{i} = std(StartPosition.X.LH{i});  else StartPosition.X.STD.LH{i} = -1; end;
      if length(StartPosition.X.RF) >= i, StartPosition.X.STD.RF{i} = std(StartPosition.X.RF{i});  else StartPosition.X.STD.RF{i} = -1; end;
      if length(StartPosition.X.RH) >= i, StartPosition.X.STD.RH{i} = std(StartPosition.X.RH{i});  else StartPosition.X.STD.RH{i} = -1; end;
      if length(StartPosition.Y.LF) >= i, StartPosition.Y.STD.LF{i} = std(StartPosition.Y.LF{i});  else StartPosition.Y.STD.LF{i} = -1; end;
      if length(StartPosition.Y.LH) >= i, StartPosition.Y.STD.LH{i} = std(StartPosition.Y.LH{i});  else StartPosition.Y.STD.LH{i} = -1; end;
      if length(StartPosition.Y.RF) >= i, StartPosition.Y.STD.RF{i} = std(StartPosition.Y.RF{i});  else StartPosition.Y.STD.RF{i} = -1; end;
      if length(StartPosition.Y.RH) >= i, StartPosition.Y.STD.RH{i} = std(StartPosition.Y.RH{i});  else StartPosition.Y.STD.RH{i} = -1; end;
      if length(StopPosition.X.LF) >= i,  StopPosition.X.STD.LF{i}  = std(StopPosition.X.LF{i});   else StopPosition.X.STD.LF{i}  = -1; end;
      if length(StopPosition.X.LH) >= i,  StopPosition.X.STD.LH{i}  = std(StopPosition.X.LH{i});   else StopPosition.X.STD.LH{i}  = -1; end;
      if length(StopPosition.X.RF) >= i,  StopPosition.X.STD.RF{i}  = std(StopPosition.X.RF{i});   else StopPosition.X.STD.RF{i}  = -1; end;
      if length(StopPosition.X.RH) >= i,  StopPosition.X.STD.RH{i}  = std(StopPosition.X.RH{i});   else StopPosition.X.STD.RH{i}  = -1; end;
      if length(StopPosition.Y.LF) >= i,  StopPosition.Y.STD.LF{i}  = std(StopPosition.Y.LF{i});   else StopPosition.Y.STD.LF{i}  = -1; end;
      if length(StopPosition.Y.LH) >= i,  StopPosition.Y.STD.LH{i}  = std(StopPosition.Y.LH{i});   else StopPosition.Y.STD.LH{i}  = -1; end;
      if length(StopPosition.Y.RF) >= i,  StopPosition.Y.STD.RF{i}  = std(StopPosition.Y.RF{i});   else StopPosition.Y.STD.RF{i}  = -1; end;
      if length(StopPosition.Y.RH) >= i,  StopPosition.Y.STD.RH{i}  = std(StopPosition.Y.RH{i});   else StopPosition.Y.STD.RH{i}  = -1; end;
      
    % Calculate the distance difference between the AEP and PEP of left-right leg pairs
      AEPFrontDiff{i}  = sqrt((StartPosition.X.Avg.LF{i} - StartPosition.X.Avg.RF{i})^2 + (StartPosition.Y.Avg.LF{i} - StartPosition.Y.Avg.RF{i})^2);
      PEPFrontDiff{i}  = sqrt(( StopPosition.X.Avg.LF{i} -  StopPosition.X.Avg.RF{i})^2 + ( StopPosition.Y.Avg.LF{i} -  StopPosition.Y.Avg.RF{i})^2);
      AEPHindDiff{i}   = sqrt((StartPosition.X.Avg.LH{i} - StartPosition.X.Avg.RH{i})^2 + (StartPosition.Y.Avg.LH{i} - StartPosition.Y.Avg.RH{i})^2);
      PEPHindDiff{i}   = sqrt(( StopPosition.X.Avg.LH{i} -  StopPosition.X.Avg.RH{i})^2 + ( StopPosition.Y.Avg.LH{i} -  StopPosition.Y.Avg.RH{i})^2);
      
    % Calculate leg position jitter
      Jitter = zeros(1,4);    
      % LF
        Jittercount = 0;
        ind = find(PerpDist{i}(1,:) ~= -1);
        if ~isempty(ind)
          ind = ind(ind >= StartStepIndexLF{i}(1) & ind <= StartStepIndexLF{i}(end)); % this makes sure that only those parts are taken into account that are not part of the steps that are present at the very first or last frames with the body on
          Para = [];
          Perp = [];
          PerpMovingAvg = -1;
          for j = 1:length(ind)-1
              if ind(j+1) - ind(j) == 1
                  I = [ind(j) ind(j+1)];
                  Para(end+1) = ParaDist{i}(1,I(2)) / p.mm2pix;
                  Perp(end+1) = PerpDist{i}(1,I(2)) / p.mm2pix;
              else
                  if length(Perp) > 0
                      % Calculate moving average
                        Jittercount = Jittercount + 1;
                        PerpMovingAvg(Jittercount) = sum(abs(smooth(Perp,5)' - Perp));
                        Para = [];
                        Perp = [];
                  end;
              end
          end
          JitterLF{i}     = mean(PerpMovingAvg);
        else
          JitterLF{i}     = -1;          
        end;
      % LH
        Jittercount = 0;
        ind = find(PerpDist{i}(2,:) ~= -1);
        if ~isempty(ind)
          ind = ind(ind >= StartStepIndexLH{i}(1) & ind <= StartStepIndexLH{i}(end)); % this makes sure that only those parts are taken into account that are not part of the steps that are present at the very first or last frames with the body on
          Para = [];
          Perp = [];
          PerpMovingAvg = -1;
          for j = 1:length(ind)-1
              if ind(j+1) - ind(j) == 1
                  I = [ind(j) ind(j+1)];
                  Para(end+1) = ParaDist{i}(2,I(2)) / p.mm2pix;
                  Perp(end+1) = PerpDist{i}(2,I(2)) / p.mm2pix;
              else
                  if length(Perp) > 0
                      % Calculate moving average
                        Jittercount = Jittercount + 1;
                        PerpMovingAvg(Jittercount) = sum(abs(smooth(Perp,5)' - Perp));
                        Para = [];
                        Perp = [];
                  end;
              end
          end
          JitterLH{i}     = mean(PerpMovingAvg);
        else
          JitterLH{i}     = -1;          
        end;
      % RF
        Jittercount = 0;
        ind = find(PerpDist{i}(3,:) ~= -1);
        if ~isempty(ind)
          ind = ind(ind >= StartStepIndexRF{i}(1) & ind <= StartStepIndexRF{i}(end)); % this makes sure that only those parts are taken into account that are not part of the steps that are present at the very first or last frames with the body on
          Para = [];
          Perp = [];
          PerpMovingAvg = -1;
          for j = 1:length(ind)-1
              if ind(j+1) - ind(j) == 1
                  I = [ind(j) ind(j+1)];
                  Para(end+1) = ParaDist{i}(3,I(2)) / p.mm2pix;
                  Perp(end+1) = PerpDist{i}(3,I(2)) / p.mm2pix;
              else
                  if length(Perp) > 0
                      % Calculate moving average
                        Jittercount = Jittercount + 1;
                        PerpMovingAvg(Jittercount) = sum(abs(smooth(Perp,5)' - Perp));
                        Para = [];
                        Perp = [];
                  end;
              end
          end
          JitterRF{i}     = mean(PerpMovingAvg);
        else
          JitterRF{i}     = -1;          
        end;
      % RH
        Jittercount = 0;
        ind = find(PerpDist{i}(4,:) ~= -1);
        if ~isempty(ind)
          ind = ind(ind >= StartStepIndexRH{i}(1) & ind <= StartStepIndexRH{i}(end)); % this makes sure that only those parts are taken into account that are not part of the steps that are present at the very first or last frames with the body on
          Para = [];
          Perp = [];
          PerpMovingAvg = -1;
          for j = 1:length(ind)-1
              if ind(j+1) - ind(j) == 1
                  I = [ind(j) ind(j+1)];
                  Para(end+1) = ParaDist{i}(4,I(2)) / p.mm2pix;
                  Perp(end+1) = PerpDist{i}(4,I(2)) / p.mm2pix;
              else
                  if length(Perp) > 0
                      % Calculate moving average
                        Jittercount = Jittercount + 1;
                        PerpMovingAvg(Jittercount) = sum(abs(smooth(Perp,5)' - Perp));
                        Para = [];
                        Perp = [];
                  end;
              end
          end
          JitterRH{i}     = mean(PerpMovingAvg);
        else
          JitterRH{i}     = -1;          
        end;

    % Calculate Body position jitter
      BodyJitter{i} = 0;    

      indT = find(v.MouseTrack.TrackTime{i} > 0);
      
      SmoothBodyX = smooth(v.MouseTrack.BodyCentroid{i}(indT,1),5);
      SmoothBodyY = smooth(v.MouseTrack.BodyCentroid{i}(indT,2),5);

      BodyJitter{i} = mean(sqrt((SmoothBodyX - v.MouseTrack.BodyCentroid{i}(indT,1)).^2 + (SmoothBodyY - v.MouseTrack.BodyCentroid{i}(indT,2)).^2)) / p.mm2pix;
      
    Data = {' ' 'LF' 'RF' 'LH' 'RH'; ...
            'distance min               '           MinDist{i}(1)           MinDist{i}(3)           MinDist{i}(2)           MinDist{i}(4); ...
            'distance max               '           MaxDist{i}(1)           MaxDist{i}(3)           MaxDist{i}(2)           MaxDist{i}(4); ...
            'distance mean              '          MeanDist{i}(1)          MeanDist{i}(3)          MeanDist{i}(2)          MeanDist{i}(4); ...
            'parallel distance min      '       MinParaDist{i}(1)       MinParaDist{i}(3)       MinParaDist{i}(2)       MinParaDist{i}(4); ...
            'parallel distance max      '       MaxParaDist{i}(1)       MaxParaDist{i}(3)       MaxParaDist{i}(2)       MaxParaDist{i}(4); ...
            'parallel distance mean     '      MeanParaDist{i}(1)      MeanParaDist{i}(3)      MeanParaDist{i}(2)      MeanParaDist{i}(4); ...
            'perpendicular distance min '   abs(MinPerpDist{i}(1))  abs(MinPerpDist{i}(3))  abs(MinPerpDist{i}(2))  abs(MinPerpDist{i}(4)); ...
            'perpendicular distance max '   abs(MaxPerpDist{i}(1))  abs(MaxPerpDist{i}(3))  abs(MaxPerpDist{i}(2))  abs(MaxPerpDist{i}(4)); ...
            'perpendicular distance mean'  abs(MeanPerpDist{i}(1)) abs(MeanPerpDist{i}(3)) abs(MeanPerpDist{i}(2)) abs(MeanPerpDist{i}(4)); ...
            'angle min                  '          MinAngle{i}(1)          MinAngle{i}(3)          MinAngle{i}(2)          MinAngle{i}(4); ...
            'angle max                  '          MaxAngle{i}(1)          MaxAngle{i}(3)          MaxAngle{i}(2)          MaxAngle{i}(4); ...
            'angle mean                 '         MeanAngle{i}(1)         MeanAngle{i}(3)         MeanAngle{i}(2)         MeanAngle{i}(4); ...
            'AEP Perp avg               ' StartPosition.X.Avg.LF{i} StartPosition.X.Avg.RF{i} StartPosition.X.Avg.LH{i} StartPosition.X.Avg.RH{i}; ...
            'AEP Perp std               ' StartPosition.X.STD.LF{i} StartPosition.X.STD.RF{i} StartPosition.X.STD.LH{i} StartPosition.X.STD.RH{i}; ...
            'AEP Para avg               ' StartPosition.Y.Avg.LF{i} StartPosition.Y.Avg.RF{i} StartPosition.Y.Avg.LH{i} StartPosition.Y.Avg.RH{i}; ...
            'AEP Para std               ' StartPosition.Y.STD.LF{i} StartPosition.Y.STD.RF{i} StartPosition.Y.STD.LH{i} StartPosition.Y.STD.RH{i}; ...
            'PEP Perp avg               '  StopPosition.X.Avg.LF{i}  StopPosition.X.Avg.RF{i}  StopPosition.X.Avg.LH{i}  StopPosition.X.Avg.RH{i}; ...
            'PEP Perp std               '  StopPosition.X.STD.LF{i}  StopPosition.X.STD.RF{i}  StopPosition.X.STD.LH{i}  StopPosition.X.STD.RH{i}; ...
            'PEP Para avg               '  StopPosition.Y.Avg.LF{i}  StopPosition.Y.Avg.RF{i}  StopPosition.Y.Avg.LH{i}  StopPosition.Y.Avg.RH{i}; ...  
            'PEP Para std               '  StopPosition.Y.STD.LF{i}  StopPosition.Y.STD.RF{i}  StopPosition.Y.STD.LH{i}  StopPosition.Y.STD.RH{i}; ...
            'AEP left-right diff        '  AEPFrontDiff{i} ' ' AEPHindDiff{i} ' '; ...
            'PEP left-right diff        '  PEPFrontDiff{i} ' ' PEPHindDiff{i} ' '; ...
            'Stance instability         ' JitterLF{i} JitterRF{i}  JitterLH{i}  JitterRH{i}; ...
            'Body stability             ' BodyJitter{i} ' ' ' ' ' '};
    else
      Data = {''};
    end;
    WriteExcel(ExcelFileName, Data,'11.Pos. stat.');
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;      

   % 12. AllData ==========================================================
     disp('  12. AllData');
      % Make a huge matrix for the excel spreadsheet
        % define index variable
          j = 1;
        % time
          Title(j) = {'Time'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.TrackTime{i}; j = j + 1;
        % nose position X
          Title(j) = {'Nose X'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.Nose{i}(:,1); j = j + 1;
        % nose position Y
          Title(j) = {'Nose Y'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.Nose{i}(:,2); j = j + 1; 
        % head position X
          Title(j) = {'Head X'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.HeadCentroid{i}(:,1); j = j + 1;
        % head position Y
          Title(j) = {'Head Y'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.HeadCentroid{i}(:,2); j = j + 1;
        % head orientation
          Title(j) = {'Head angle'};
          % handle error that was previously miswriting headorientation
          % information - it is corrected but older analyses may have this
            if length(v.MouseTrack.HeadOrientation{i}) ~= length(v.MouseTrack.BodyOrientation{i})
              v.MouseTrack.HeadOrientation{i} = [v.MouseTrack.HeadOrientation{i}(1,:) zeros(1,length(v.MouseTrack.BodyOrientation{i})-length(v.MouseTrack.HeadOrientation{i}(1,:)))];
            end;
          MouseMatrix{i}(:,j)  = v.MouseTrack.HeadOrientation{i}; j = j + 1;
        % body position X
          Title(j) = {'Body X'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.BodyCentroid{i}(:,1); j = j + 1;
        % body position Y
          Title(j) = {'Body Y'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.BodyCentroid{i}(:,2); j = j + 1;
        % body orientation
          Title(j) = {'Body angle'};
          MouseMatrix{i}(:,j)  = v.MouseTrack.BodyOrientation{i}; j = j + 1;
        % body back position X
          Title(j) = {'Back X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.BodyBackCentroid{i}(:,1); j = j + 1;
        % body back position Y
          Title(j) = {'Back Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.BodyBackCentroid{i}(:,2); j = j + 1;
        % body back orientation
          Title(j) = {'Back angle'};
          MouseMatrix{i}(:,j) = v.MouseTrack.BodyBackOrientation{i}; j = j + 1;
        % tail 1 position X
          Title(j) = {'Tail1 X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail1Centroid{i}(:,1); j = j + 1;
        % tail 1 position Y
          Title(j) = {'Tail1 Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail1Centroid{i}(:,2); j = j + 1;
        % tail 1 orientation
          Title(j) = {'Tail1 angle'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail1Orientation{i}; j = j + 1;
        % tail 2 position X
          Title(j) = {'Tail2 X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail2Centroid{i}(:,1); j = j + 1;
        % tail 2 position Y
          Title(j) = {'Tail2 Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail2Centroid{i}(:,2); j = j + 1;
        % tail 2 orientation
          Title(j) = {'Tail2 alpha'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail2Orientation{i}; j = j + 1;
        % tail 3 position X
          Title(j) = {'Tail3 X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail3Centroid{i}(:,1); j = j + 1;
        % tail 3 position Y
          Title(j) = {'Tail3 Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail3Centroid{i}(:,2); j = j + 1;
        % tail 3 orientation
          Title(j) = {'Tail3 angle'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail3Orientation{i}; j = j + 1;
        % tail position X 
          Title(j) = {'TailEnd X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail{i}(:,1); j = j + 1;
        % tail position Y
          Title(j) = {'TailEnd Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.Tail{i}(:,2); j = j + 1;
        % RF leg centroid X
          Title(j) = {'RF X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRF.Centroid{i}(:,1); j = j + 1;
        % RF leg centroid Y
          Title(j) = {'RF Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRF.Centroid{i}(:,2); j = j + 1;
        % RF footsize
          Title(j) = {'RF size'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRF.FootSize{i}(:) / p.mm2pix^2; j = j + 1;
        % RF foot total brightness
          Title(j) = {'RF brightness'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRF.FootTotalBrightness{i}(:); j = j + 1;
        % RF foot total pressure (brightness/area)
          Title(j) = {'RF pressure'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRF.FootPressure{i}(:); j = j + 1;
        % RH leg centroid X
          Title(j) = {'RH X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRF.Centroid{i}(:,1); j = j + 1;
        % RH leg centroid Y
          Title(j) = {'RH Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRH.Centroid{i}(:,2); j = j + 1;
        % RH footsize
          Title(j) = {'RH size'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRH.FootSize{i}(:) / p.mm2pix^2; j = j + 1;
        % RH foot total brightness
          Title(j) = {'RH brightness'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRH.FootTotalBrightness{i}(:); j = j + 1;
        % RH foot total pressure (brightness/area)
          Title(j) = {'RH pressure'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegRH.FootPressure{i}(:); j = j + 1;
        % LF leg centroid X
          Title(j) = {'LF X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLF.Centroid{i}(:,1); j = j + 1;
        % LF leg centroid Y
          Title(j) = {'LF Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLF.Centroid{i}(:,2); j = j + 1;
        % LF footsize
          Title(j) = {'LF size'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLF.FootSize{i}(:) / p.mm2pix^2; j = j + 1;
        % LF foot total brightness
          Title(j) = {'LF brightness'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLF.FootTotalBrightness{i}(:); j = j + 1;
        % LF foot total pressure (brightness/area)
          Title(j) = {'LF pressure'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLF.FootPressure{i}(:); j = j + 1;
        % LH leg centroid X
          Title(j) = {'LH X'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLH.Centroid{i}(:,1); j = j + 1;
        % LH leg centroid Y
          Title(j) = {'LH Y'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLH.Centroid{i}(:,2); j = j + 1;
        % LH footsize
          Title(j) = {'LH size'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLH.FootSize{i}(:) / p.mm2pix^2; j = j + 1;
        % LH foot total brightness
          Title(j) = {'LH brightness'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLH.FootTotalBrightness{i}(:);
        % LH foot total pressure (brightness/area)
          Title(j) = {'LH pressure'};
          MouseMatrix{i}(:,j) = v.MouseTrack.LegLH.FootPressure{i}(:); j = j + 1;
          
    % save data on excel spreadsheet
      Data = num2cell(MouseMatrix{i});
      Data(2:end+1,:) = Data;
      Data(1,:) = Title;
      WriteExcel(ExcelFileName, Data,['12.All Mouse Data']);
      
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      
   % 13. STEP SIZE AND VELOCITY ===========================================
     disp('  13. STEP SIZE AND VELOCITY');

     % find first and last frames with the body on. Lets which are present 
     % on this frame will not be used for the analysis as they might be 
     % showing middles of steps
       temp = find(v.MouseTrack.BodyCentroid{i}(:,1) > 0);
       if length(temp) > 0
           FirstTimeIndex = temp(1);
           LastTimeIndex = temp(end);

         % calculate step positions and times
           % LF
             counter_LF = 0;
             starttime = 0;
             stoptime = -1;
             StopStep_LF = [];
             for j = 1:length(v.MouseTrack.TrackTime{i}) % loop over time
               if v.MouseTrack.LegLF.Centroid{i}(j,1) ~= -1 & v.MouseTrack.TrackTime{i}(j) > 0
                 if starttime == 0
                   starttime = j;
                 end;
                 stoptime = j;
               else
                 if starttime ~= 0 & stoptime ~= -1;
                   % save step only if this is not a step starting on the very
                   % first frame or very last frame
                     if starttime > FirstTimeIndex & stoptime < LastTimeIndex
                       % save step
                         counter_LF = counter_LF + 1;
                         StartStep_LF(counter_LF) = starttime;
                         StopStep_LF(counter_LF) = stoptime;
                         LegXatStart_LF(counter_LF) = v.MouseTrack.LegLF.Centroid{i}(starttime,1);
                         LegYatStart_LF(counter_LF) = v.MouseTrack.LegLF.Centroid{i}(starttime,2);
                         LegXatStop_LF(counter_LF) = v.MouseTrack.LegLF.Centroid{i}(stoptime,1);
                         LegYatStop_LF(counter_LF) = v.MouseTrack.LegLF.Centroid{i}(stoptime,2);
                     end;
                 end;
                   starttime = 0;
               end;
             end;
           % LH
             counter_LH = 0;
             starttime = 0;
             stoptime = -1;
             StopStep_LH = [];             
             for j = 1:length(v.MouseTrack.TrackTime{i}) % loop over time
               if v.MouseTrack.LegLH.Centroid{i}(j,1) ~= -1 & v.MouseTrack.TrackTime{i}(j) > 0
                 if starttime == 0
                   starttime = j;
                 end;
                 stoptime = j;
               else
                 if starttime ~= 0 & stoptime ~= -1;
                   % save step only if this is not a step starting on the very
                   % first frame or very last frame
                     if starttime > FirstTimeIndex & stoptime < LastTimeIndex
                       % save step
                         counter_LH = counter_LH + 1;
                         StartStep_LH(counter_LH) = starttime;
                         StopStep_LH(counter_LH) = stoptime;
                         LegXatStart_LH(counter_LH) = v.MouseTrack.LegLH.Centroid{i}(starttime,1);
                         LegYatStart_LH(counter_LH) = v.MouseTrack.LegLH.Centroid{i}(starttime,2);
                         LegXatStop_LH(counter_LH) = v.MouseTrack.LegLH.Centroid{i}(stoptime,1);
                         LegYatStop_LH(counter_LH) = v.MouseTrack.LegLH.Centroid{i}(stoptime,2);
                     end;
                 end;
                   starttime = 0;
               end;
             end;
           % RF
             counter_RF = 0;
             starttime = 0;
             stoptime = -1;
             StopStep_RF = [];
             for j = 1:length(v.MouseTrack.TrackTime{i}) % loop over time
               if v.MouseTrack.LegRF.Centroid{i}(j,1) ~= -1 & v.MouseTrack.TrackTime{i}(j) > 0
                 if starttime == 0
                   starttime = j;
                 end;
                 stoptime = j;
               else
                 if starttime ~= 0 & stoptime ~= -1;
                   % save step only if this is not a step starting on the very
                   % first frame or very last frame
                     if starttime > FirstTimeIndex & stoptime < LastTimeIndex
                       % save step
                         counter_RF = counter_RF + 1;
                         StartStep_RF(counter_RF) = starttime;
                         StopStep_RF(counter_RF) = stoptime;
                         LegXatStart_RF(counter_RF) = v.MouseTrack.LegRF.Centroid{i}(starttime,1);
                         LegYatStart_RF(counter_RF) = v.MouseTrack.LegRF.Centroid{i}(starttime,2);
                         LegXatStop_RF(counter_RF) = v.MouseTrack.LegRF.Centroid{i}(stoptime,1);
                         LegYatStop_RF(counter_RF) = v.MouseTrack.LegRF.Centroid{i}(stoptime,2);
                     end;
                 end;
                   starttime = 0;
               end;
             end;
           % RH
             counter_RH = 0;
             starttime = 0;
             stoptime = -1;
             StopStep_RH = [];             
             for j = 1:length(v.MouseTrack.TrackTime{i}) % loop over time
               if v.MouseTrack.LegRH.Centroid{i}(j,1) ~= -1 & v.MouseTrack.TrackTime{i}(j) > 0
                 if starttime == 0
                   starttime = j;
                 end;
                 stoptime = j;
               else
                 if starttime ~= 0 & stoptime ~= -1;
                   % save step only if this is not a step starting on the very
                   % first frame or very last frame
                     if starttime > FirstTimeIndex & stoptime < LastTimeIndex
                       % save step
                         counter_RH = counter_RH + 1;
                         StartStep_RH(counter_RH) = starttime;
                         StopStep_RH(counter_RH) = stoptime;
                         LegXatStart_RH(counter_RH) = v.MouseTrack.LegRH.Centroid{i}(starttime,1);
                         LegYatStart_RH(counter_RH) = v.MouseTrack.LegRH.Centroid{i}(starttime,2);
                         LegXatStop_RH(counter_RH) = v.MouseTrack.LegRH.Centroid{i}(stoptime,1);
                         LegYatStop_RH(counter_RH) = v.MouseTrack.LegRH.Centroid{i}(stoptime,2);
                     end;
                 end;
                   starttime = 0;
               end;
             end;


        % calculate step sizes and times
          % LF
            StepLength_LF = [];
            SwingDuration_LF = [];
            StanceDuration_LF = [];  
            TotalStepDuration_LF = [];
            StepVelocity_LF = [];
            for j = 1:counter_LF-1 % loop over steps
              % Step - basically means swing. From lifting the leg to placing it again
                StepLength_LF(j)          = sqrt((LegXatStart_LF(j+1) - LegXatStop_LF(j))^2 + (LegYatStart_LF(j+1) - LegYatStop_LF(j))^2);
                SwingDuration_LF(j)       = v.MouseTrack.TrackTime{i}(StartStep_LF(j+1)) - v.MouseTrack.TrackTime{i}(StopStep_LF(j))  - 1 / p.fps;
              % Stance - from placing the leg to lifting it again
                StanceDuration_LF(j)      = v.MouseTrack.TrackTime{i}(StopStep_LF(j))    - v.MouseTrack.TrackTime{i}(StartStep_LF(j)) + 1 / p.fps;
              % Total step - stance and swing together
                TotalStepDuration_LF(j)   = v.MouseTrack.TrackTime{i}(StopStep_LF(j+1))  - v.MouseTrack.TrackTime{i}(StopStep_LF(j));
              % calculate how much the body moved during the swing
                BodyStepLength_LF(j)      = sqrt((v.MouseTrack.BodyCentroid{i}(StopStep_LF(j),1) - v.MouseTrack.BodyCentroid{i}(StartStep_LF(j),1))^2 + (v.MouseTrack.BodyCentroid{i}(StopStep_LF(j),2) - v.MouseTrack.BodyCentroid{i}(StartStep_LF(j),2))^2);
                StepVelocity_LF(j)        = (StepLength_LF(j) / SwingDuration_LF(j) - BodyStepLength_LF(j)/StanceDuration_LF(j))/1000;
            end;
          % LH
            StepLength_LH = [];
            SwingDuration_LH = [];
            StanceDuration_LH = [];  
            TotalStepDuration_LH = [];
            StepVelocity_LH = [];
            for j = 1:counter_LH-1 % loop over steps
              % Step - basically means swing. From lifting the leg to placing it again
                StepLength_LH(j)          = sqrt((LegXatStart_LH(j+1) - LegXatStop_LH(j))^2 + (LegYatStart_LH(j+1) - LegYatStop_LH(j))^2);
                SwingDuration_LH(j)       = v.MouseTrack.TrackTime{i}(StartStep_LH(j+1)) - v.MouseTrack.TrackTime{i}(StopStep_LH(j))  - 1 / p.fps;
              % Stance - from placing the leg to lifting it again
                StanceDuration_LH(j)      = v.MouseTrack.TrackTime{i}(StopStep_LH(j))    - v.MouseTrack.TrackTime{i}(StartStep_LH(j)) + 1 / p.fps;
              % Total step - stance and swing together
                TotalStepDuration_LH(j)   = v.MouseTrack.TrackTime{i}(StopStep_LH(j+1))  - v.MouseTrack.TrackTime{i}(StopStep_LH(j));
              % calculate how much the body moved during the swing
                BodyStepLength_LH(j)      = sqrt((v.MouseTrack.BodyCentroid{i}(StopStep_LH(j),1) - v.MouseTrack.BodyCentroid{i}(StartStep_LH(j),1))^2 + (v.MouseTrack.BodyCentroid{i}(StopStep_LH(j),2) - v.MouseTrack.BodyCentroid{i}(StartStep_LH(j),2))^2);
                StepVelocity_LH(j)        = (StepLength_LH(j) / SwingDuration_LH(j) - BodyStepLength_LH(j)/StanceDuration_LH(j))/1000;
            end;
          % RF
            StepLength_RF = [];
            SwingDuration_RF = [];
            StanceDuration_RF = [];  
            TotalStepDuration_RF = [];
            StepVelocity_RF = [];
            for j = 1:counter_RF-1 % loop over steps
              % Step - basically means swing. From lifting the leg to placing it again
                StepLength_RF(j)          = sqrt((LegXatStart_RF(j+1) - LegXatStop_RF(j))^2 + (LegYatStart_RF(j+1) - LegYatStop_RF(j))^2);
                SwingDuration_RF(j)       = v.MouseTrack.TrackTime{i}(StartStep_RF(j+1)) - v.MouseTrack.TrackTime{i}(StopStep_RF(j)) - 1 / p.fps;
              % Stance - from placing the leg to lifting it again
                StanceDuration_RF(j)      = v.MouseTrack.TrackTime{i}(StopStep_RF(j)) - v.MouseTrack.TrackTime{i}(StartStep_RF(j)) + 1 / p.fps;
              % Total step - stance and swing together
                TotalStepDuration_RF(j)   = v.MouseTrack.TrackTime{i}(StopStep_RF(j+1)) - v.MouseTrack.TrackTime{i}(StopStep_RF(j));
              % calculate how much the body moved during the swing
                BodyStepLength_RF(j)      = sqrt((v.MouseTrack.BodyCentroid{i}(StopStep_RF(j),1) - v.MouseTrack.BodyCentroid{i}(StartStep_RF(j),1))^2 + (v.MouseTrack.BodyCentroid{i}(StopStep_RF(j),2) - v.MouseTrack.BodyCentroid{i}(StartStep_RF(j),2))^2);
                StepVelocity_RF(j)        = (StepLength_RF(j) / SwingDuration_RF(j) - BodyStepLength_RF(j)/StanceDuration_RF(j))/1000;
            end;
          % RH
            StepLength_RH = [];
            SwingDuration_RH = [];
            StanceDuration_RH = [];  
            TotalStepDuration_RH = [];
            StepVelocity_RH = [];
            for j = 1:counter_RH-1 % loop over steps
              % Step - basically means swing. From lifting the leg to placing it again
                StepLength_RH(j)          = sqrt((LegXatStart_RH(j+1) - LegXatStop_RH(j))^2 + (LegYatStart_RH(j+1) - LegYatStop_RH(j))^2);
                SwingDuration_RH(j)       = v.MouseTrack.TrackTime{i}(StartStep_RH(j+1)) - v.MouseTrack.TrackTime{i}(StopStep_RH(j)) - 1 / p.fps;
              % Stance - from placing the leg to lifting it again
                StanceDuration_RH(j)      = v.MouseTrack.TrackTime{i}(StopStep_RH(j)) - v.MouseTrack.TrackTime{i}(StartStep_RH(j)) + 1 / p.fps;
              % Total step - stance and swing together
                TotalStepDuration_RH(j)   = v.MouseTrack.TrackTime{i}(StopStep_RH(j+1)) - v.MouseTrack.TrackTime{i}(StopStep_RH(j));
              % calculate how much the body moved during the swing
                BodyStepLength_RH(j)      = sqrt((v.MouseTrack.BodyCentroid{i}(StopStep_RH(j),1) - v.MouseTrack.BodyCentroid{i}(StartStep_RH(j),1))^2 + (v.MouseTrack.BodyCentroid{i}(StopStep_RH(j),2) - v.MouseTrack.BodyCentroid{i}(StartStep_RH(j),2))^2);
                StepVelocity_RH(j)        = (StepLength_RH(j) / SwingDuration_RH(j) - BodyStepLength_RH(j)/StanceDuration_RH(j))/1000;
            end;

          % calculate phases ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              % extract fore and hind step times
                if length(StopStep_LF) > 0, LeftForeStepTimes     = v.MouseTrack.TrackTime{i}(StopStep_LF(1,1:counter_LF)); else, LeftForeStepTimes = []; end;
                if length(StopStep_LH) > 0, LeftHindStepTimes     = v.MouseTrack.TrackTime{i}(StopStep_LH(1,1:counter_LH)); else, LeftHindStepTimes = []; end;
                if length(StopStep_RF) > 0, RightForeStepTimes    = v.MouseTrack.TrackTime{i}(StopStep_RF(1,1:counter_RF)); else, RightForeStepTimes = []; end;
                if length(StopStep_RH) > 0, RightHindStepTimes    = v.MouseTrack.TrackTime{i}(StopStep_RH(1,1:counter_RH)); else, RightHindStepTimes = []; end;
            % FORE
              PhaseF = [];
              for j = 1:counter_LF
                  % find left fore swing starts that are before the current right fore swing start
                    ind_after = find(RightForeStepTimes < LeftForeStepTimes(j));
                  % assign value only if there is such
                    if ~isempty(ind_after)
                        % calculate new value
                          if length(TotalStepDuration_RF) >= ind_after(end) & TotalStepDuration_RF(ind_after(end)) ~= 0
                              NewLag = (LeftForeStepTimes(j) - RightForeStepTimes(ind_after(end))) / TotalStepDuration_RF(ind_after(end));
                              % assign
                                PhaseF = [PhaseF NewLag];
                          end;
                    end;
              end  
            % HIND
              PhaseH = [];
              for j = 1:counter_LH
                  % find left fore swing starts that are before the current right fore swing start
                    ind_after = find(RightHindStepTimes < LeftHindStepTimes(j));
                  % assign value only if there is such
                    if ~isempty(ind_after)
                        % calculate new value
                          if length(TotalStepDuration_RH(:)) >= ind_after(end) & TotalStepDuration_RH(ind_after(end)) ~= 0
                              NewLag = (LeftHindStepTimes(j) - RightHindStepTimes(ind_after(end))) / TotalStepDuration_RH(ind_after(end));
                              % assign
                                PhaseH = [PhaseH NewLag];
                          end;
                    end;
              end    


            % Metachronal lag LEFT 3L1
              % initialize
                MetachronalLeft3L1 = [];
              % only do it if there are step cycles
                if counter_LH > 1            
                  for j = 1:counter_LH
                      % find fore swing starts that are after the current hind swing start
                        ind_after = find(LeftForeStepTimes > LeftHindStepTimes(j) + TotalStepDuration_LH(1)/3);
                      % assign value only if there is such
                        if ~isempty(ind_after)
                            % calculate new value
                              NewLag = min(LeftForeStepTimes(ind_after) - LeftHindStepTimes(j));
                            % assign
                            MetachronalLeft3L1 = [MetachronalLeft3L1 NewLag];
                        end;
                  end
                end;
            % Metachronal lag RIGHT 3L1
              % initialize
                MetachronalRight3L1 = [];
              % only do it if there are step cycles
                if counter_RH > 1
                  for j = 1:counter_RH
                      % find fore swing starts that are after the current hind swing start
                        ind_after = find(RightForeStepTimes > RightHindStepTimes(j) + TotalStepDuration_RH(1)/3);
                      % assign value only if there is such
                        if ~isempty(ind_after)
                            % calculate new value
                              NewLag = min(RightForeStepTimes(ind_after) - RightHindStepTimes(j));
                            % assign
                            MetachronalRight3L1 = [MetachronalRight3L1 NewLag];
                        end;
                  end
                end;
          % step size and velocity information
          Data = zeros(28,max([counter_LF counter_LH counter_RF counter_RH]));
          Data( 1,1:counter_LF-1) =  v.MouseTrack.TrackTime{i}(StopStep_LF(1:counter_LF-1));
          Data( 2,1:counter_LF-1) =     StanceDuration_LF(1:counter_LF-1) ;
          Data( 3,1:counter_LF-1) =      SwingDuration_LF(1:counter_LF-1) ;
          Data( 4,1:counter_LF-1) = TotalStepDuration_LF(1:counter_LF-1) ;
          Data( 5,1:counter_LF-1) =   StepVelocity_LF(1:counter_LF-1) ;
          Data( 6,1:counter_LF-1) =     StepLength_LF(1:counter_LF-1) ;
          Data( 7,1:counter_LH-1) =  v.MouseTrack.TrackTime{i}(StopStep_LH(1:counter_LH-1));
          Data( 8,1:counter_LH-1) =     StanceDuration_LH(1:counter_LH-1) ;
          Data( 9,1:counter_LH-1) =      SwingDuration_LH(1:counter_LH-1) ;
          Data(10,1:counter_LH-1) = TotalStepDuration_LH(1:counter_LH-1) ;
          Data(11,1:counter_LH-1) =   StepVelocity_LH(1:counter_LH-1) ;
          Data(12,1:counter_LH-1) =     StepLength_LH(1:counter_LH-1) ;
          Data(13,1:counter_RF-1) =  v.MouseTrack.TrackTime{i}(StopStep_RF(1:counter_RF-1));
          Data(14,1:counter_RF-1) =     StanceDuration_RF(1:counter_RF-1) ;
          Data(15,1:counter_RF-1) =      SwingDuration_RF(1:counter_RF-1) ;
          Data(16,1:counter_RF-1) = TotalStepDuration_RF(1:counter_RF-1) ;
          Data(17,1:counter_RF-1) =   StepVelocity_RF(1:counter_RF-1) ;
          Data(18,1:counter_RF-1) =     StepLength_RF(1:counter_RF-1) ;
          Data(19,1:counter_RH-1) =  v.MouseTrack.TrackTime{i}(StopStep_RH(1:counter_RH-1));
          Data(20,1:counter_RH-1) =     StanceDuration_RH(1:counter_RH-1) ;
          Data(21,1:counter_RH-1) =      SwingDuration_RH(1:counter_RH-1) ;
          Data(22,1:counter_RH-1) = TotalStepDuration_RH(1:counter_RH-1) ;
          Data(23,1:counter_RH-1) =   StepVelocity_RH(1:counter_RH-1) ;
          Data(24,1:counter_RH-1) =     StepLength_RH(1:counter_RH-1) ;
          Data(25,1:length(PhaseF))      = PhaseF;
          Data(26,1:length(PhaseH))      = PhaseH;
          Data(27,1:length(MetachronalLeft3L1))  = MetachronalLeft3L1;
          Data(28,1:length(MetachronalRight3L1)) = MetachronalRight3L1;
          Data(29,1:counter_LF-1) = StanceDuration_LF(1:counter_LF-1) ./ (StanceDuration_LF(1:counter_LF-1) + SwingDuration_LF(1:counter_LF-1) + 10^-9);
          Data(30,1:counter_LH-1) = StanceDuration_LH(1:counter_LH-1) ./ (StanceDuration_LH(1:counter_LH-1) + SwingDuration_LH(1:counter_LH-1) + 10^-9);
          Data(31,1:counter_RF-1) = StanceDuration_RF(1:counter_RF-1) ./ (StanceDuration_RF(1:counter_RF-1) + SwingDuration_RF(1:counter_RF-1) + 10^-9);
          Data(32,1:counter_RH-1) = StanceDuration_RH(1:counter_RH-1) ./ (StanceDuration_RH(1:counter_RH-1) + SwingDuration_RH(1:counter_RH-1) + 10^-9);


          S = size(Data');
          clear DataCell;
          DataCell(2:S(1)+1,1:S(2)) = num2cell(Data');
          DataCell(1,1:S(2)) = {'Stance Offset(LF)' 'StanceDuration(LF)' 'SwingDuration(LF)' 'StepCycle(LF)' 'SwingSpeed(LF)' 'StepDist(LF)' 'Stance Offset(LH)' 'StanceDuration(LH)' 'SwingDuration(LH)' 'StepCycle(LH)' 'SwingSpeed(LH)' 'StepDist(LH)' 'Stance Offset(RF)' 'StanceDuration(RF)' 'SwingDuration(RF)' 'StepCycle(RF)' 'SwingSpeed(RF)' 'StepDist(RF)' 'Stance Offset(RH)' 'StanceDuration(RH)' 'SwingDuration(RH)' 'StepCycle(RH)' 'SwingSpeed(RH)' 'StepDist(RH)' 'Phase F' 'Phase H' 'Metachronal Left 3L1' 'Metachronal Right 3L1', 'DutyFactor(LF)', 'DutyFactor(LH)', 'DutyFactor(RF)', 'DutyFactor(RH)'};

          % make all the values that are smaller or equal to zero ' '
          S = size(DataCell);
          for j = 1:S(1)
              for k = 1:S(2)
                  if cell2mat(DataCell(j,k)) <= 0
                      DataCell(j,k) = {' '};
                  end;
              end
          end;     
       else
         DataCell = {'Stance Offset(LF)' 'StanceDuration(LF)' 'SwingDuration(LF)' 'StepCycle(LF)' 'SwingSpeed(LF)' 'StepDist(LF)' 'Stance Offset(LH)' 'StanceDuration(LH)' 'SwingDuration(LH)' 'StepCycle(LH)' 'SwingSpeed(LH)' 'StepDist(LH)' 'Stance Offset(RF)' 'StanceDuration(RF)' 'SwingDuration(RF)' 'StepCycle(RF)' 'SwingSpeed(RF)' 'StepDist(RF)' 'Stance Offset(RH)' 'StanceDuration(RH)' 'SwingDuration(RH)' 'StepCycle(RH)' 'SwingSpeed(RH)' 'StepDist(RH)' 'Phase F' 'Phase H' 'Metachronal Left 3L1' 'Metachronal Right 3L1'};         
       end; % if there is any footprint
       
       WriteExcel(ExcelFileName, DataCell,['13.Step_stat.']);
     
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      
   % 14. BODY VELOCITY ====================================================
     disp('  14. BODY VELOCITY');
      
     % calculate body velocity
       % find times that are not cancelled
         indT = find(v.MouseTrack.TrackTime{i} > 0);

       BodyVelocity = [];
       for j = 1:length(indT)-1 % loop over time
         if v.MouseTrack.BodyCentroid{i}(indT(j),1) > 0 & v.MouseTrack.BodyCentroid{i}(indT(j)+1,1) > 0 
           BodyVelocity(j) = sqrt((v.MouseTrack.BodyCentroid{i}(indT(j)+1,1) - v.MouseTrack.BodyCentroid{i}(indT(j),1))^2 + (v.MouseTrack.BodyCentroid{i}(indT(j)+1,2) - v.MouseTrack.BodyCentroid{i}(indT(j),2))^2) * p.fps / p.mm2pix;
         else
           BodyVelocity(j) = 0;
         end;
       end;

     % Body Velocity information
       Data = [v.MouseTrack.TrackTime{i}(indT(1:end-1)); BodyVelocity];
       DataCell = num2cell(Data');
       DataCell(2:end+1,1:end) = DataCell;
       DataCell(1,1:2) = {'t [s]' 'v [mm/s]'};
       DataCell(end+2,1:2) = {'Average' num2str(mean(BodyVelocity))};
       DataCell(end+3,1:2) = {'STD' num2str(std(BodyVelocity))};
      
     WriteExcel(ExcelFileName, DataCell,['14.Body velocity stat.']);
     
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      
   % 15. LEG ALIGNMENT ====================================================
%      disp('  15. LEG ALIGNMENT');
   % Dont need leg alignment here.

   % 16. AEP & PEP ====================================================
     disp('  16. AEP & PEP');
     
     % calculate average body length we will use length to be 4*(body center - body back)
       if p.FixedBodyLength <= 0
         ind = find(v.MouseTrack.BodyCentroid{i}(:,1) > 0);
         BodyLength = 4*median(sqrt((v.MouseTrack.BodyCentroid{i}(ind,1) - v.MouseTrack.BodyBackCentroid{i}(ind,1)).^2+(v.MouseTrack.BodyCentroid{i}(ind,2) - v.MouseTrack.BodyBackCentroid{i}(ind,2)).^2)); 
       else
         BodyLength = p.FixedBodyLength;
       end;
     
     % create header and initialize Data
       clear DataCell;
       DataCell(1,:) = {'LF AEP(x)'	'LF AEP(y)'	'RF AEP(x)'	'RF AEP(y)' 'LH AEP(x)' 'LH AEP(y)' 'RH AEP(x)' 'RH AEP(y)' 'LF PEP(x)' 'LF PEP(y)' 'RF PEP(x)' 'RF PEP(y)' 'LH PEP(x)' 'LH PEP(y)' 'RH PEP(x)' 'RH PEP(y)'};
       LENGTH = max([StartStepIndexLF{i} StopStepIndexLF{i} StartStepIndexLH{i} StopStepIndexLH{i} StartStepIndexRF{i} StopStepIndexRF{i} StartStepIndexRH{i} StopStepIndexRH{i}]);
       DataNum = zeros(LENGTH,16);  

     % add data to Data matrix
       % LF
         DataNum(1:length(StartStepIndexLF{i}), 1) = PerpDist{i}(1, StartStepIndexLF{i}) / BodyLength;
         DataNum(1:length(StartStepIndexLF{i}), 2) = ParaDist{i}(1, StartStepIndexLF{i}) / BodyLength;
         DataNum(1:length( StopStepIndexLF{i}), 9) = PerpDist{i}(1,  StopStepIndexLF{i}) / BodyLength;
         DataNum(1:length( StopStepIndexLF{i}),10) = ParaDist{i}(1,  StopStepIndexLF{i}) / BodyLength;
       % RF
         DataNum(1:length(StartStepIndexRF{i}), 3) = PerpDist{i}(3, StartStepIndexRF{i}) / BodyLength;
         DataNum(1:length(StartStepIndexRF{i}), 4) = ParaDist{i}(3, StartStepIndexRF{i}) / BodyLength;
         DataNum(1:length( StopStepIndexRF{i}),11) = PerpDist{i}(3,  StopStepIndexRF{i}) / BodyLength;
         DataNum(1:length( StopStepIndexRF{i}),12) = ParaDist{i}(3,  StopStepIndexRF{i}) / BodyLength;
       % LH
         DataNum(1:length(StartStepIndexLH{i}), 5) = PerpDist{i}(2, StartStepIndexLH{i}) / BodyLength;
         DataNum(1:length(StartStepIndexLH{i}), 6) = ParaDist{i}(2, StartStepIndexLH{i}) / BodyLength;
         DataNum(1:length( StopStepIndexLH{i}),13) = PerpDist{i}(2,  StopStepIndexLH{i}) / BodyLength;
         DataNum(1:length( StopStepIndexLH{i}),14) = ParaDist{i}(2,  StopStepIndexLH{i}) / BodyLength;
       % RH
         DataNum(1:length(StartStepIndexRH{i}), 7) = PerpDist{i}(4, StartStepIndexRH{i}) / BodyLength;
         DataNum(1:length(StartStepIndexRH{i}), 8) = ParaDist{i}(4, StartStepIndexRH{i}) / BodyLength;
         DataNum(1:length( StopStepIndexRH{i}),15) = PerpDist{i}(4,  StopStepIndexRH{i}) / BodyLength;
         DataNum(1:length( StopStepIndexRH{i}),16) = ParaDist{i}(4,  StopStepIndexRH{i}) / BodyLength;

     DataCell(2:size(DataNum,1)+1,:) = num2cell(DataNum);    

     % make all the values that are smaller or equal to zero ' '
       S = size(DataCell);
       for j = 1:S(1)
           for k = 1:S(2)
               if cell2mat(DataCell(j,k)) == 0
                   DataCell(j,k) = {' '};
               end;
           end
       end;     
     
     WriteExcel(ExcelFileName, DataCell,['16.AEP & PEP']);
     
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;

   % 17. AEP & PEP ====================================================
     disp('  17. FOOTPRINT PROPERTIES');
 
     % Footprint pressure average and STD     
       FootPressureAvg_LF{i} = mean(v.MouseTrack.LegLF.FootPressure{i}(v.MouseTrack.LegLF.FootPressure{i} > 0));
       FootPressureSTD_LF{i} =  std(v.MouseTrack.LegLF.FootPressure{i}(v.MouseTrack.LegLF.FootPressure{i} > 0));
       FootPressureAvg_LH{i} = mean(v.MouseTrack.LegLH.FootPressure{i}(v.MouseTrack.LegLH.FootPressure{i} > 0));
       FootPressureSTD_LH{i} =  std(v.MouseTrack.LegLH.FootPressure{i}(v.MouseTrack.LegLH.FootPressure{i} > 0));
       FootPressureAvg_RF{i} = mean(v.MouseTrack.LegRF.FootPressure{i}(v.MouseTrack.LegRF.FootPressure{i} > 0));
       FootPressureSTD_RF{i} =  std(v.MouseTrack.LegRF.FootPressure{i}(v.MouseTrack.LegRF.FootPressure{i} > 0));
       FootPressureAvg_RH{i} = mean(v.MouseTrack.LegRH.FootPressure{i}(v.MouseTrack.LegRH.FootPressure{i} > 0));
       FootPressureSTD_RH{i} =  std(v.MouseTrack.LegRH.FootPressure{i}(v.MouseTrack.LegRH.FootPressure{i} > 0));

       FootTotalBrightnessAvg_LF{i} = mean(v.MouseTrack.LegLF.FootTotalBrightness{i}(v.MouseTrack.LegLF.FootTotalBrightness{i} > 0));
       FootTotalBrightnessSTD_LF{i} =  std(v.MouseTrack.LegLF.FootTotalBrightness{i}(v.MouseTrack.LegLF.FootTotalBrightness{i} > 0));
       FootTotalBrightnessAvg_LH{i} = mean(v.MouseTrack.LegLH.FootTotalBrightness{i}(v.MouseTrack.LegLH.FootTotalBrightness{i} > 0));
       FootTotalBrightnessSTD_LH{i} =  std(v.MouseTrack.LegLH.FootTotalBrightness{i}(v.MouseTrack.LegLH.FootTotalBrightness{i} > 0));
       FootTotalBrightnessAvg_RF{i} = mean(v.MouseTrack.LegRF.FootTotalBrightness{i}(v.MouseTrack.LegRF.FootTotalBrightness{i} > 0));
       FootTotalBrightnessSTD_RF{i} =  std(v.MouseTrack.LegRF.FootTotalBrightness{i}(v.MouseTrack.LegRF.FootTotalBrightness{i} > 0));
       FootTotalBrightnessAvg_RH{i} = mean(v.MouseTrack.LegRH.FootTotalBrightness{i}(v.MouseTrack.LegRH.FootTotalBrightness{i} > 0));
       FootTotalBrightnessSTD_RH{i} =  std(v.MouseTrack.LegRH.FootTotalBrightness{i}(v.MouseTrack.LegRH.FootTotalBrightness{i} > 0));

       FootSizeAvg_LF{i} = mean(v.MouseTrack.LegLF.FootSize{i}(v.MouseTrack.LegLF.FootSize{i} > 0));
       FootSizeSTD_LF{i} =  std(v.MouseTrack.LegLF.FootSize{i}(v.MouseTrack.LegLF.FootSize{i} > 0));
       FootSizeAvg_LH{i} = mean(v.MouseTrack.LegLH.FootSize{i}(v.MouseTrack.LegLH.FootSize{i} > 0));
       FootSizeSTD_LH{i} =  std(v.MouseTrack.LegLH.FootSize{i}(v.MouseTrack.LegLH.FootSize{i} > 0));
       FootSizeAvg_RF{i} = mean(v.MouseTrack.LegRF.FootSize{i}(v.MouseTrack.LegRF.FootSize{i} > 0));
       FootSizeSTD_RF{i} =  std(v.MouseTrack.LegRF.FootSize{i}(v.MouseTrack.LegRF.FootSize{i} > 0));
       FootSizeAvg_RH{i} = mean(v.MouseTrack.LegRH.FootSize{i}(v.MouseTrack.LegRH.FootSize{i} > 0));
       FootSizeSTD_RH{i} =  std(v.MouseTrack.LegRH.FootSize{i}(v.MouseTrack.LegRH.FootSize{i} > 0));
       
     
     % create header and initialize Data
       clear DataCell;
       DataCell(2:9,1) = {'LF AVG'	'LF STD' 'LH AVG'	'LH STD' 'RF AVG'	'RF STD' 'RH AVG'	'RH STD'};
       DataCell(1,2:4) = {'Pressure' 'Brightness' 'FootSize'};
       DataNum = zeros(8,3);  

     % add data to Data matrix
       % LF
         DataNum(1, 1) = FootPressureAvg_LF{i};
         DataNum(2, 1) = FootPressureSTD_LF{i};
         DataNum(1, 2) = FootTotalBrightnessAvg_LF{i};
         DataNum(2, 2) = FootTotalBrightnessSTD_LF{i};
         DataNum(1, 3) = FootSizeAvg_LF{i} / p.mm2pix^2;
         DataNum(2, 3) = FootSizeSTD_LF{i};
       % LH
         DataNum(3, 1) = FootPressureAvg_LH{i};
         DataNum(4, 1) = FootPressureSTD_LH{i};
         DataNum(3, 2) = FootTotalBrightnessAvg_LH{i};
         DataNum(4, 2) = FootTotalBrightnessSTD_LH{i};
         DataNum(3, 3) = FootSizeAvg_LH{i} / p.mm2pix^2;
         DataNum(4, 3) = FootSizeSTD_LH{i};
       % RF
         DataNum(5, 1) = FootPressureAvg_RF{i};
         DataNum(6, 1) = FootPressureSTD_RF{i};
         DataNum(5, 2) = FootTotalBrightnessAvg_RF{i};
         DataNum(6, 2) = FootTotalBrightnessSTD_RF{i};
         DataNum(5, 3) = FootSizeAvg_RF{i} / p.mm2pix^2;
         DataNum(6, 3) = FootSizeSTD_RF{i};
       % RH
         DataNum(7, 1) = FootPressureAvg_RH{i};
         DataNum(8, 1) = FootPressureSTD_RH{i};
         DataNum(7, 2) = FootTotalBrightnessAvg_RH{i};
         DataNum(8, 2) = FootTotalBrightnessSTD_RH{i};
         DataNum(7, 3) = FootSizeAvg_RH{i} / p.mm2pix^2;
         DataNum(8, 3) = FootSizeSTD_RH{i};

     DataCell(2:9,2:4) = num2cell(DataNum);    

     % make all the values that are smaller or equal to zero ' '
       S = size(DataCell);
       for j = 1:S(1)
           for k = 1:S(2)
               if cell2mat(DataCell(j,k)) == 0
                   DataCell(j,k) = {' '};
               end;
           end
       end;     
       
     WriteExcel(ExcelFileName, DataCell,['17.Footprint']);
     
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
   
      
    % 18. ACCELERATION ====================================================
     disp('  18. ACCELERATION');
     
       clear DataCell;
       DataCell(2:5,1) = {'Body Perp'	'Tail 1 Perp' 'Tail2 Perp'	'Tail3 Perp'};
       DataCell(1,2:10) = {'Mean(v<100m/s) [mm/s^2]' 'STD(v<100m/s) [mm/s^2]' 'Extreme(v<100m/s) [mm/s^2]' 'Mean(100<v<200m/s) [mm/s^2]' 'STD(100<v<200m/s) [mm/s^2]' 'Extreme(100<v<200m/s) [mm/s^2]' 'Mean(v>200m/s) [mm/s^2]' 'STD(v>200m/s) [mm/s^2]' 'Extreme(v>200m/s) [mm/s^2]'};
       DataNum = zeros(4,9);  
      
       DataNum(1,1) =  Speed0BodyAccelerationMean{i};
       DataNum(1,2) =   Speed0BodyAccelerationSTD{i};
       DataNum(1,3) =  v.MouseTrack.BodyPerpAccelerationExtreme0{i};
       DataNum(2,1) = Speed0Tail1AccelerationMean{i};
       DataNum(2,2) =  Speed0Tail1AccelerationSTD{i};
       DataNum(2,3) = v.MouseTrack.Tail1PerpAccelerationExtreme0{i};
       DataNum(3,1) = Speed0Tail2AccelerationMean{i};
       DataNum(3,2) =  Speed0Tail2AccelerationSTD{i};
       DataNum(3,3) = v.MouseTrack.Tail2PerpAccelerationExtreme0{i};
       DataNum(4,1) = Speed0Tail3AccelerationMean{i};
       DataNum(4,2) =  Speed0Tail3AccelerationSTD{i};
       DataNum(4,3) = v.MouseTrack.Tail3PerpAccelerationExtreme0{i};
       DataNum(1,4) =  Speed1BodyAccelerationMean{i};
       DataNum(1,5) =   Speed1BodyAccelerationSTD{i};
       DataNum(1,6) =  v.MouseTrack.BodyPerpAccelerationExtreme1{i};
       DataNum(2,4) = Speed1Tail1AccelerationMean{i};
       DataNum(2,5) =  Speed1Tail1AccelerationSTD{i};
       DataNum(2,6) = v.MouseTrack.Tail1PerpAccelerationExtreme1{i};
       DataNum(3,4) = Speed1Tail2AccelerationMean{i};
       DataNum(3,5) =  Speed1Tail2AccelerationSTD{i};
       DataNum(3,6) = v.MouseTrack.Tail2PerpAccelerationExtreme1{i};
       DataNum(4,4) = Speed1Tail3AccelerationMean{i};
       DataNum(4,5) =  Speed1Tail3AccelerationSTD{i};
       DataNum(4,6) = v.MouseTrack.Tail3PerpAccelerationExtreme1{i};
       DataNum(1,7) =  Speed2BodyAccelerationMean{i};
       DataNum(1,8) =   Speed2BodyAccelerationSTD{i};
       DataNum(1,9) =  v.MouseTrack.BodyPerpAccelerationExtreme2{i};
       DataNum(2,7) = Speed2Tail1AccelerationMean{i};
       DataNum(2,8) =  Speed2Tail1AccelerationSTD{i};
       DataNum(2,9) = v.MouseTrack.Tail1PerpAccelerationExtreme2{i};
       DataNum(3,7) = Speed2Tail2AccelerationMean{i};
       DataNum(3,8) =  Speed2Tail2AccelerationSTD{i};
       DataNum(3,9) = v.MouseTrack.Tail2PerpAccelerationExtreme2{i};
       DataNum(4,7) = Speed2Tail3AccelerationMean{i};
       DataNum(4,8) =  Speed2Tail3AccelerationSTD{i};
       DataNum(4,9) = v.MouseTrack.Tail3PerpAccelerationExtreme2{i};
      
     DataCell(2:5,2:10) = num2cell(DataNum);    

     % make all the values that are smaller or equal to zero ' '
       S = size(DataCell);
       for j = 1:S(1)
           for k = 1:S(2)
               if cell2mat(DataCell(j,k)) == 0
                   DataCell(j,k) = {' '};
               end;
           end
       end;     
       
     WriteExcel(ExcelFileName, DataCell,['18.Acceleration']);
     
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EXCEL ADDITIONS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %on sheet 13. Step stat:
% 
% xlswrite(ExcelFileName, {'Hz, average frequency'},'13.Step_stat.', 'A17');
% xlswrite(ExcelFileName, {'average step Cycle/ in miliseconds/ SD'},'13.Step_stat.', 'A20');
% xlswrite(ExcelFileName, {'=AVERAGE(D2:D6,J2:J6,P2:P6,V2:V6,AB2:AB6,AH2:AH6)'},'13.Step_stat.', 'A21');
% xlswrite(ExcelFileName, {'=1/A21'},'13.Step_stat.', 'A18');
% 
% xlswrite(ExcelFileName, {'=A21*1000','=1000*(STDEV(D2:D6,J2:J6,P2:P6,V2:V6,AB2:AB6,AH2:AH6))'},'13.Step_stat.','B21');
% 
% xlswrite(ExcelFileName, {'swing speed (v)'},'13.Step_stat.', 'A25');
% xlswrite(ExcelFileName, {'F','H','average','SD'},'13.Step_stat.', 'A26');
% xlswrite(ExcelFileName, {'=AVERAGE(E2:E7,Q2:Q7)','=AVERAGE(K2:K7,E2:E7)','=AVERAGE(E2:E7,Q2:Q7,K2:K7,W2:W7)','=STDEV(E2:E7,Q2:Q7,K2:K7,W2:W7)'},'13.Step_stat.', 'A27');
% 
% xlswrite(ExcelFileName, {'step lenght (cm)','',''},'13.Step_stat.', 'A29');
% xlswrite(ExcelFileName, {'F','H','average','SD'},'13.Step_stat.', 'A30');
% xlswrite(ExcelFileName, {'=(AVERAGE(F2:F7,R2:R7))/10','=(AVERAGE(L2:L7,X2:X7))/10','=(AVERAGE(F2:F7,R2:R7,L2:L7,X2:X7)/10)','=(STDEV(F2:F7,R2:R7,L2:L7,X2:X7))/10'},'13.Step_stat.', 'A31');
% 
% xlswrite(ExcelFileName, {'step duration (t;seconds)','',''},'13.Step_stat.', 'A33');
% xlswrite(ExcelFileName, {'F','H','average','SD'},'13.Step_stat.', 'A34');
% xlswrite(ExcelFileName, {'=AVERAGE(C2:C7,O2:O7)','=AVERAGE(I2:I7,U2:U7)','=AVERAGE(C2:C7,O2:O7,I2:I7,U2:U7)','=STDEV(C2:C7,O2:O7,I2:I7,U2:U7)'},'13.Step_stat.', 'A35');
% 
% xlswrite(ExcelFileName, {'stance time (seconds)','',''},'13.Step_stat.', 'A37');
% xlswrite(ExcelFileName, {'F','H','average','SD'},'13.Step_stat.', 'A38');
% xlswrite(ExcelFileName, {'=AVERAGE(B2:B7,N2:N7)','=AVERAGE(H2:H7,T2:T7)','=AVERAGE(B2:B7,N2:N7,H2:H7,T2:T7)','=STDEV(B2:B7,N2:N7,H2:H7,T2:T7)'},'13.Step_stat.', 'A39');
% 
% 
% xlswrite(ExcelFileName, {'average phases'},'13.Step_stat.', 'A42');
% xlswrite(ExcelFileName, {'Phase F','Phase H'},'13.Step_stat.', 'A43');
% xlswrite(ExcelFileName, {'=AVERAGE(Y2:Y11)','=AVERAGE(Z2:Z11)'},'13.Step_stat.', 'A44');
% 
% %on 11.Pos. stat.
% 
% 
% xlswrite(ExcelFileName, {'=AVERAGE(B24:E24)'},'11.Pos. stat.', 'H24');
% xlswrite(ExcelFileName, {'=AVERAGE(D3:E3)'},'11.Pos. stat.', 'H3');
% xlswrite(ExcelFileName, {'=AVERAGE(B10:C10)','=AVERAGE(D10:E10)'},'11.Pos. stat.', 'H10');
% 
% % on 16.AEP & PEP
% 
% xlswrite(ExcelFileName, {'=SQRT(A15^2+B15^2)','=AVERAGE(A13,C13)','=SQRT(C15^2+D15^2)','','=SQRT(E15^2+F15^2)','=AVERAGE(E13,G13)','=SQRT(G15^2+H15^2)','','=SQRT(I15^2+J15^2)','=AVERAGE(I13,K13)','=SQRT(K15^2+L15^2)','','=SQRT(M15^2+N15^2)','=AVERAGE(M13,O13)','=SQRT(O15^2+P15^2)'},'16.AEP & PEP', 'A13');
% xlswrite(ExcelFileName, {'=AVERAGE(A2:A10)','=AVERAGE(B2:B10)','=AVERAGE(C2:C10)','=AVERAGE(D2:D10)','=AVERAGE(E2:E10)','=AVERAGE(F2:F10)','=AVERAGE(G2:G10)','=AVERAGE(H2:H10)','=AVERAGE(I2:I10)','=AVERAGE(J2:J10)','=AVERAGE(K2:K10)','=AVERAGE(L2:L10)','=AVERAGE(M2:M10)','=AVERAGE(N2:N10)','=AVERAGE(O2:O10)','=AVERAGE(P2:P10)'},'16.AEP & PEP','A14');
% xlswrite(ExcelFileName, {'=STDEV(A2:A10)','=STDEV(B2:B10)','=STDEV(C2:C10)','=STDEV(D2:D10)','=STDEV(E2:E10)','=STDEV(F2:F10)','=STDEV(G2:G10)','=STDEV(H2:H10)','=STDEV(I2:I10)','=STDEV(J2:J10)','=STDEV(K2:K10)','=STDEV(L2:L10)','=STDEV(M2:M10)','=STDEV(N2:N10)','=STDEV(O2:O10)','=STDEV(P2:P10)'},'16.AEP & PEP', 'A15');
% 
% xlswrite(ExcelFileName, {'=SQRT(A14^2+B14^2)','','=SQRT(C14^2+D14^2)','','=SQRT(E14^2+F14^2)','','=SQRT(G14^2+H14^2)','','=SQRT(I14^2+J14^2)','','=SQRT(K14^2+L14^2)','','=SQRT(M14^2+N14^2)','','=SQRT(O14^2+P14^2)'},'16.AEP & PEP', 'A16');
% xlswrite(ExcelFileName, {'SD AEP','=AVERAGE(A13:G13)','=AVERAGE(A16,C16)','','','','=AVERAGE(E16,G16)','','','','=AVERAGE(I16,K16)','','','','=AVERAGE(M16,O16)'},'16.AEP & PEP', 'A17');
% xlswrite(ExcelFileName, {'SD PEP','=AVERAGE(I13:P13)'},'16.AEP & PEP', 'A18');
% 
% xlswrite(ExcelFileName, {'xy component and xySD'},'16.AEP & PEP', 'A20');
% xlswrite(ExcelFileName, {'=AVERAGE(A14,C14)','=AVERAGE(B14,D14)','','','=AVERAGE(E14,G14)','=AVERAGE(F14,H14)','','','=AVERAGE(I14,K14)','=AVERAGE(J14,L14)','','','=AVERAGE(M14,O14)','=AVERAGE(N14,P14)'},'16.AEP & PEP', 'A21');
% xlswrite(ExcelFileName, {'=AVERAGE(A15,C15)','=AVERAGE(B15,D15)','','','=AVERAGE(E15,G15)','=AVERAGE(F15,H15)','','','=AVERAGE(I15,K15)','=AVERAGE(J15,L15)','','','=AVERAGE(M15,O15)','=AVERAGE(N15,P15)'},'16.AEP & PEP', 'A22');
% 
% 
%  %on sheet 1 Info sheet:
%  
% 
% xlswrite(ExcelFileName, {'label','speed cm/s','diag swing','single swing','lateral swing','freq','period ms','no swing','front/hind swing','sw v(AVR)','sw v(SD)','sw v(F)','sw v(H)','sw s(AVR)','sw s(SD)','sw s(F)','sw s(H)','sw t(AVR)','sw t(SD)','sw t(F)','sw t(H)','period SD','stc t(F)','stc t(H)','stc t(AVR)','stc t(SD)','varAEP_F','varAEP_H','varPEP_F','varPEP_H','stnc stabl','SD AEP','SD PEP','F AEP','H AEP','F PEP','H PEP','F AEPy','H AEPy','F PEPy','H PEPy','F AEPySD','H AEPySD','F PEPySD','H PEPySD','F AEPx','H AEPx','F PEPx','H PEPx','F AEPxSD','H AEPxSD','F PEPxSD','H PEPxSD','3 leg swing','Speed SD','framesON','body stbl','F_AEP STD','H_AEP STD','F_PEP STD','H_PEP STD','SwingV STD','all swing','Max Mdist','swT+stT','duty Fact','Phase F','Phase H','areaLF','areaLH','areaRF','areaRH','pressLF','pressLH','pressRF','pressRH','fps','px/mm'},'1.Info_Sheet', 'A40');
% 
%  
% xlswrite(ExcelFileName, {'=MID(CELL("filename"),SEARCH("[",CELL("filename"))+1, SEARCH("]",CELL("filename"))-SEARCH("[",CELL("filename"))-1)','=(SUMIF(''14.Body velocity stat.''!A:A,"Average",''14.Body velocity stat.''!B:B))/10','=''10.Leg combinations''!B35','=''10.Leg combinations''!B36','=''10.Leg combinations''!B34','=''13.Step_stat.''!A18','=''13.Step_stat.''!B21','=''10.Leg combinations''!B33','=''10.Leg combinations''!B37','=''13.Step_stat.''!C27','=''13.Step_stat.''!D27','=''13.Step_stat.''!A27','=''13.Step_stat.''!B27','=''13.Step_stat.''!C31','=''13.Step_stat.''!D31','=''13.Step_stat.''!A31','=''13.Step_stat.''!B31','=''13.Step_stat.''!C35','=''13.Step_stat.''!D35','=''13.Step_stat.''!A35','=''13.Step_stat.''!B35','=''13.Step_stat.''!C21','=''13.Step_stat.''!A39','=''13.Step_stat.''!B39','=''13.Step_stat.''!C39','=''13.Step_stat.''!D39','=''11.Pos. stat.''!B22','=''11.Pos. stat.''!D22','=''11.Pos. stat.''!B23','=''11.Pos. stat.''!D23','=''11.Pos. stat.''!H24','=''16.AEP & PEP''!B17','=''16.AEP & PEP''!B18','=''16.AEP & PEP''!C17','=''16.AEP & PEP''!G17','=''16.AEP & PEP''!K17','=''16.AEP & PEP''!O17','=''16.AEP & PEP''!B21','=''16.AEP & PEP''!F21','=''16.AEP & PEP''!J21','=''16.AEP & PEP''!N21','=''16.AEP & PEP''!B22','=''16.AEP & PEP''!F22','=''16.AEP & PEP''!J22','=''16.AEP & PEP''!N22','=''16.AEP & PEP''!A21','=''16.AEP & PEP''!E21','=''16.AEP & PEP''!I21','=''16.AEP & PEP''!M21','=''16.AEP & PEP''!A22','=''16.AEP & PEP''!E22','=''16.AEP & PEP''!I22','=''16.AEP & PEP''!M22','=''10.Leg combinations''!B38','=SUMIF(''14.Body velocity stat.''!A:A,"STD",''14.Body velocity stat.''!B:B)','=''2.Parameters''!B7','=''11.Pos. stat.''!B25','=''16.AEP & PEP''!B13','=''16.AEP & PEP''!F13','=''16.AEP & PEP''!J13','=''16.AEP & PEP''!M13','=K41/1000','=''10.Leg combinations''!B39','=''11.Pos. stat.''!H3','=R41+Y41','=Y41/(Y41+R41)','=''13.Step_stat.''!A44','=''13.Step_stat.''!B44','=''17.Footprint''!D2','=''17.Footprint''!D4','=''17.Footprint''!D6','=''17.Footprint''!D8','=''17.Footprint''!B2','=''17.Footprint''!B4','=''17.Footprint''!B6','=''17.Footprint''!B8','=''2.Parameters''!B4','=''2.Parameters''!B5'},'1.Info_Sheet', 'A41');
%  
% % xlswrite(ExcelFileName, {'label','speed cm/s','trot index','walk index','pace index','freq','period ms','four index','bound/hop','sw v(AVR)','sw v(SD)','sw v(F)','(empty)','sw v(H)','sw s(AVR)','sw s(SD)','sw s(F)','(empty)','sw s(H)','sw t(AVR)','sw t(SD)','sw t(F)','(empty)','sw t(H)','period SD','stc t(F)','(empty)','stc t(H)','stc t(AVR)','stc t(SD)','varAEP_F','(empty)','varAEP_H','varPEP_F','(empty)','varPEP_H','stnc stabl','SD AEP','SD PEP','(empty)','F AEP','(empty)','H AEP','F PEP','(empty)','H PEP','F AEPy','(empty)','H AEPy','F PEPy','(empty)','H PEPy','F AEPySD','(empty)','H AEPySD','F PEPySD','(empty)','H PEPySD','F AEPx','(empty)','H AEPx','F PEPx','(empty)','H PEPx','F AEPxSD','(empty)','H AEPxSD','F PEPxSD','(empty)','H PEPxSD','PeriodSD1000','Speed SD','(empty)','framesON','body stbl','(empty)','F_AEP STD','(empty)','H_AEP STD','F_PEP STD','(empty)','H_PEP STD','(empty)','SwingV STD','F_deltaEP','(empty)','H_deltaEP','non-can.','(empty)','(empty)','(empty)','Max Mdist','swT+stT','duty Fact','Phase F','(empty)','Phase H','areaLF','areaLH','areaRF','areaRH','pressLF','pressLH','pressRF','pressRH',},'1.Info_Sheet', 'A40');
% % 
% %  
% % xlswrite(ExcelFileName, {'=MID(CELL("filename"),SEARCH("[",CELL("filename"))+1, SEARCH("]",CELL("filename"))-SEARCH("[",CELL("filename"))-1)','=(SUMIF(''14.Body velocity stat.''!A:A,"Average",''14.Body velocity stat.''!B:B))/10','=''10.Leg combinations''!B35','=''10.Leg combinations''!B36','=''10.Leg combinations''!B34','=''13.Step_stat.''!A18','=''13.Step_stat.''!B21','=''10.Leg combinations''!B33','=''10.Leg combinations''!B37','=''13.Step_stat.''!C27','=''13.Step_stat.''!D27','=''13.Step_stat.''!A27','(empty)','=''13.Step_stat.''!B27','=''13.Step_stat.''!C31','=''13.Step_stat.''!D31','=''13.Step_stat.''!A31','(empty)','=''13.Step_stat.''!B31','=''13.Step_stat.''!C35','=''13.Step_stat.''!D35','=''13.Step_stat.''!A35','(empty)','=''13.Step_stat.''!B35','=''13.Step_stat.''!B21','=''13.Step_stat.''!A39','(empty)','=''13.Step_stat.''!B39','=''13.Step_stat.''!C39','=''13.Step_stat.''!D39','=''11.Pos. stat.''!B22','(empty)','=''11.Pos. stat.''!D22','=''11.Pos. stat.''!B23','(empty)','=''11.Pos. stat.''!D23','=''11.Pos. stat.''!H24','=''16.AEP & PEP''!B17','=''16.AEP & PEP''!B18','(empty)','=''16.AEP & PEP''!C17','(empty)','=''16.AEP & PEP''!G17','=''16.AEP & PEP''!K17','(empty)','=''16.AEP & PEP''!O17','=''16.AEP & PEP''!B21','(empty)','=''16.AEP & PEP''!F21','=''16.AEP & PEP''!J21','(empty)','=''16.AEP & PEP''!N21','=''16.AEP & PEP''!B22','(empty)','=''16.AEP & PEP''!F22','=''16.AEP & PEP''!J22','(empty)','=''16.AEP & PEP''!N22','=''16.AEP & PEP''!A21','(empty)','=''16.AEP & PEP''!E21','=''16.AEP & PEP''!I21','(empty)','=''16.AEP & PEP''!M21','=''16.AEP & PEP''!A22','(empty)','=''16.AEP & PEP''!E22','=''16.AEP & PEP''!I22','(empty)','=''16.AEP & PEP''!M22','=Y41*1000','=SUMIF(''14.Body velocity stat.''!A:A,"STD",''14.Body velocity stat.''!B:B)','(empty)','=''2.Parameters''!B7','=''11.Pos. stat.''!B25','(empty)','=''16.AEP & PEP''!B13','(empty)','=''16.AEP & PEP''!F13','=''16.AEP & PEP''!J13','(empty)','=''16.AEP & PEP''!M13','(empty)','=K41/1000','=CB41-BY41','(empty)','=CD41-CA41','=1-C41-D41-CX41','(empty)','(empty)','(empty)','=''11.Pos. stat.''!H3','=T41+AC41','=AC41/(AC41+T41)','=''13.Step_stat.''!A44','(empty)','=''13.Step_stat.''!B44','=''17.Footprint''!D2','=''17.Footprint''!D4','=''17.Footprint''!D6','=''17.Footprint''!D8','=''17.Footprint''!B2','=''17.Footprint''!B4','=''17.Footprint''!B6','=''17.Footprint''!B8'},'1.Info_Sheet', 'A41');
          
    % =====================================================================
    
    % check for ABORT
      if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
      
      

  end;
end; % EXCEL on/off  

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOOTPRINT TABLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('FOOTPRINT TABLE')  
% generate an image for each stance

  % size of window for 1 footprint
    SIZE = 1.5;
  if PLOTSTEPS == 1
    for i = MouseArray % loop over mice
      % initialize
        % create FootPrint folder in Results if it doesn't exist yet
          if ~exist([OutputMouseFoldername{i} '/FootPrint/']), mkdir([OutputMouseFoldername{i} '/FootPrint/']); end;      
        FootTable = [];
        counterLF = 0;
        counterLH = 0;
        counterRF = 0;
        counterRH = 0;
        v.pic = PictureReader(1, p);  
        % determine picture size
          S = size(v.pic.R);
          H = S(1);
          W = S(2);        
      % LF
        disp('  LF')
        FootPicAll = [];
        for j = 1:max(length(StartStepIndexLF{i}),length(StopStepIndexLF{i}))
          % initialize
            FootPic  = double(v.pic.R.*0);    
            FootDynamics = [];            
          for k = StartStepIndexLF{i}(j):StopStepIndexLF{i}(j)
           % handle the case when somehow there are -1's in the data
             if v.MouseTrack.TrackIndex{i}(k) ~= -1
              % read in mouse pic
                v.pic = PictureReader(v.MouseTrack.TrackIndex{i}(k), p);  
              % subtract background
                v = FilterImage(v, p);           
              % keep only parts that are related to the foot and body
                CleanFootPIC = CleanPIC(v.pic.foot, p.MinFootSize);
              % get maxima up all images
                FootPic = max(FootPic, double(CleanFootPIC));        
              % make frame series
                CropPic = CleanFootPIC;
                % make everything zero that's far from the first center
                  Xmin = round(max(1,v.MouseTrack.LegLF.Centroid{i}(k,1) - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,v.MouseTrack.LegLF.Centroid{i}(k,1) + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,v.MouseTrack.LegLF.Centroid{i}(k,2) - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,v.MouseTrack.LegLF.Centroid{i}(k,2) + p.MaxFingerDistance*SIZE));
                  CropPic([1:Xmin Xmax:end],:) = 0;
                  CropPic(:,[1:Ymin Ymax:end]) = 0;
                % centers
                  Xcenter = mean(mean(CropPic').*[1:length(mean(CropPic'))])/mean(mean(CropPic'));
                  Ycenter = mean(mean(CropPic ).*[1:length(mean(CropPic ))])/mean(mean(CropPic ));
                  % put in center if no data is recorded
                    if isnan(Xcenter) | isnan(Ycenter)
                      Xcenter = v.MouseTrack.LegLF.Centroid{i}(k,1);
                      Ycenter = v.MouseTrack.LegLF.Centroid{i}(k,2);
                    end;
                % borders should be max finger distance from center, unless there is border
                  Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                % save foot pic      
                  L = round(2*p.MaxFingerDistance*SIZE) + 1;
                  temp = zeros(L,L);
                  temp(1:Xmax-Xmin+1,1:Ymax-Ymin+1) = double(CropPic(Xmin:Xmax,Ymin:Ymax));
                  FootDynamics = [FootDynamics temp];
             end;
          end;
            % save picture of FootPic
              if max(FootPic(:)) > 0
                % determine where to center pic from footprint center
                  % make everything zero that's far from the first center
                    Xmin = round(max(1,v.MouseTrack.LegLF.Centroid{i}(StartStepIndexLF{i}(j),1) - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,v.MouseTrack.LegLF.Centroid{i}(StartStepIndexLF{i}(j),1) + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,v.MouseTrack.LegLF.Centroid{i}(StartStepIndexLF{i}(j),2) - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,v.MouseTrack.LegLF.Centroid{i}(StartStepIndexLF{i}(j),2) + p.MaxFingerDistance*SIZE));
                    FootPic([1:Xmin Xmax:end],:) = 0;
                    FootPic(:,[1:Ymin Ymax:end]) = 0;
                  % centers
                    Xcenter = mean(mean(FootPic').*[1:length(mean(FootPic'))])/mean(mean(FootPic'));
                    Ycenter = mean(mean(FootPic ).*[1:length(mean(FootPic ))])/mean(mean(FootPic ));
                    % put in center if no data is recorded
                      if isnan(Xcenter) | isnan(Ycenter)
                        Xcenter = v.MouseTrack.LegLF.Centroid{i}(k,1);
                        Ycenter = v.MouseTrack.LegLF.Centroid{i}(k,2);
                      end;
                  % borders should be max finger distance from center, unless there is border
                    Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                  % save footpic
                    Xstart = round(1             + counterLF*p.MaxFingerDistance*SIZE*2);
                    Xstop  = round(1 + Xmax-Xmin + counterLF*p.MaxFingerDistance*SIZE*2);
                    Ystart = round(1            );
                    Ystop  = round(1 + Ymax-Ymin);                  
                    FootTable(Xstart:Xstop,Ystart:Ystop) = FootPic(Xmin:Xmax,Ymin:Ymax);  
                    counterLF = counterLF+1;
                % create figure
                  S = size(FootPic(Xmin:Xmax,Ymin:Ymax));
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2) S(1)]);
                % plot MAX FOOT
                  imagesc(FootPic(Xmin:Xmax,Ymin:Ymax));
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootPrint_' ExperimentName '_LF_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);   
              end;
            % save picture of FootDynamics
              if ~isempty(FootDynamics)
                % create figure
                  S = size(FootDynamics);
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2)*3 S(1)*3]);
                % plot FOOT
                  imagesc(FootDynamics);
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % add SCALE BAR
                  hold on;
                  SizePic = size(FootDynamics);
                  P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
                  plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');                  
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootDynamics_' ExperimentName '_LF_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);                   
                % add pic to FootPicAll
                  Sall = size(FootPicAll);
                  FootPicAll(Sall(1)+1:Sall(1)+S(1),1:S(2)) = FootDynamics;
              end;
        end; % loop over steps
        % plot collection of steps
          if ~isempty(FootPicAll)
            % create figure
              S = size(FootPicAll);
              h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 S(2) S(1)]/300*4);
            % plot FOOT
              imagesc(FootPicAll);
              set(gca,'XtickLabel','','YtickLabel','');        
              box on;
            % add SCALE BAR
              hold on;
              SizePic = size(FootPicAll);
              P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
              plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
              set(gca,'position',[0 0 1 1],'units','normalized');
            % save figure
              outputfilename = [OutputMouseFoldername{i} '/FootDynamics_All_' ExperimentName '_LF_' num2str(j) '.png'];
%               saveas(h,outputfilename,'png');   
              print(h,'-dpng', '-r300', outputfilename);
              close(h);                               
          end;
      % LH
        disp('  LH');
        FootPicAll = [];
       for j = 1:max(length(StartStepIndexLH{i}),length(StopStepIndexLH{i}))
          % initialize
            FootPic  = double(v.pic.R.*0);    
            FootDynamics = [];
         for k = StartStepIndexLH{i}(j):StopStepIndexLH{i}(j)
           % handle the case when somehow there are -1's in the data
             if v.MouseTrack.TrackIndex{i}(k) ~= -1
              % read in mouse pic
                v.pic = PictureReader(v.MouseTrack.TrackIndex{i}(k), p);  
              % subtract background
                v = FilterImage(v, p);           
              % keep only parts that are related to the foot and body
                CleanFootPIC = CleanPIC(v.pic.foot, p.MinFootSize);
              % get maxima up all images
                FootPic = max(FootPic, double(CleanFootPIC));      
              % make frame series
                CropPic = CleanFootPIC;
                % make everything zero that's far from the first center
                  Xmin = round(max(1,v.MouseTrack.LegLH.Centroid{i}(k,1) - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,v.MouseTrack.LegLH.Centroid{i}(k,1) + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,v.MouseTrack.LegLH.Centroid{i}(k,2) - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,v.MouseTrack.LegLH.Centroid{i}(k,2) + p.MaxFingerDistance*SIZE));
                  CropPic([1:Xmin Xmax:end],:) = 0;
                  CropPic(:,[1:Ymin Ymax:end]) = 0;
                % centers
                  Xcenter = mean(mean(CropPic').*[1:length(mean(CropPic'))])/mean(mean(CropPic'));
                  Ycenter = mean(mean(CropPic ).*[1:length(mean(CropPic ))])/mean(mean(CropPic ));
                  % put in center if no data is recorded
                    if isnan(Xcenter) | isnan(Ycenter)
                      Xcenter = v.MouseTrack.LegLH.Centroid{i}(k,1);
                      Ycenter = v.MouseTrack.LegLH.Centroid{i}(k,2);
                    end;
                % borders should be max finger distance from center, unless there is border
                  Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                % save foot pic           
                  L = round(2*p.MaxFingerDistance*SIZE) + 1;
                  temp = zeros(L,L);
                  temp(1:Xmax-Xmin+1,1:Ymax-Ymin+1) = double(CropPic(Xmin:Xmax,Ymin:Ymax));
                  FootDynamics = [FootDynamics temp];
             end;
          end;
            % save picture of FootPic
              if max(FootPic(:)) > 0
                % determine where to center pic from footprint center
                  % make everything zero that's far from the first center
                    Xmin = round(max(1,v.MouseTrack.LegLH.Centroid{i}(StartStepIndexLH{i}(j),1) - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,v.MouseTrack.LegLH.Centroid{i}(StartStepIndexLH{i}(j),1) + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,v.MouseTrack.LegLH.Centroid{i}(StartStepIndexLH{i}(j),2) - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,v.MouseTrack.LegLH.Centroid{i}(StartStepIndexLH{i}(j),2) + p.MaxFingerDistance*SIZE));
                    FootPic([1:Xmin Xmax:end],:) = 0;
                    FootPic(:,[1:Ymin Ymax:end]) = 0;
                  % centers
                    Xcenter = mean(mean(FootPic').*[1:length(mean(FootPic'))])/mean(mean(FootPic'));
                    Ycenter = mean(mean(FootPic ).*[1:length(mean(FootPic ))])/mean(mean(FootPic ));
                    % put in center if no data is recorded
                      if isnan(Xcenter) | isnan(Ycenter)
                        Xcenter = v.MouseTrack.LegLH.Centroid{i}(k,1);
                        Ycenter = v.MouseTrack.LegLH.Centroid{i}(k,2);
                      end;
                  % borders should be max finger distance from center, unless there is border
                    Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                  % save footpic
                    Xstart = round(1             + counterLH*p.MaxFingerDistance*SIZE*2);
                    Xstop  = round(1 + Xmax-Xmin + counterLH*p.MaxFingerDistance*SIZE*2);
                    Ystart = round(1             + p.MaxFingerDistance*SIZE*2*1);
                    Ystop  = round(1 + Ymax-Ymin + p.MaxFingerDistance*SIZE*2*1);                  
                    FootTable(Xstart:Xstop,Ystart:Ystop) = FootPic(Xmin:Xmax,Ymin:Ymax);  
                    counterLH = counterLH+1;
                % create figure
                  S = size(FootPic(Xmin:Xmax,Ymin:Ymax));
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2) S(1)]);
                % plot MAX FOOT
                  imagesc(FootPic(Xmin:Xmax,Ymin:Ymax));
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootPrint_' ExperimentName '_LH_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);        
              end;
            % save picture of FootDynamics
              if ~isempty(FootDynamics)
                % create figure
                  S = size(FootDynamics);
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2)*3 S(1)*3]);
                % plot FOOT
                  imagesc(FootDynamics);
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % add SCALE BAR
                  hold on;
                  SizePic = size(FootDynamics);
                  P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
                  plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootDynamics_' ExperimentName '_LH_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);                   
                % add pic to FootPicAll
                  Sall = size(FootPicAll);
                  FootPicAll(Sall(1)+1:Sall(1)+S(1),1:S(2)) = FootDynamics;
              end;              
        end;      
        % plot collection of steps
          if ~isempty(FootPicAll)
            % create figure
              S = size(FootPicAll);
              h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 S(2) S(1)]/300*4);
            % plot FOOT
              imagesc(FootPicAll);
              set(gca,'XtickLabel','','YtickLabel','');        
              box on;
            % add SCALE BAR
              hold on;
              SizePic = size(FootPicAll);
              P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
              plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
              set(gca,'position',[0 0 1 1],'units','normalized');
            % save figure
              outputfilename = [OutputMouseFoldername{i} '/FootDynamics_All_' ExperimentName '_LH_' num2str(j) '.png'];
              print(h,'-dpng', '-r300', outputfilename);
              close(h);                               
          end;
      % RF
        disp('  RF')
        FootPicAll = [];
        for j = 1:max(length(StartStepIndexRF{i}),length(StopStepIndexRF{i}))
          % initialize
            FootPic  = double(v.pic.R.*0);    
            FootDynamics = [];
          for k = StartStepIndexRF{i}(j):StopStepIndexRF{i}(j)
           % handle the case when somehow there are -1's in the data
             if v.MouseTrack.TrackIndex{i}(k) ~= -1            
              % read in mouse pic
                v.pic = PictureReader(v.MouseTrack.TrackIndex{i}(k), p);  
              % subtract background
                v = FilterImage(v, p);           
              % keep only parts that are related to the foot and body
                CleanFootPIC = CleanPIC(v.pic.foot, p.MinFootSize);
              % get maxima up all images
                FootPic = max(FootPic, double(CleanFootPIC));        
              % make frame series
                CropPic = CleanFootPIC;
                % make everything zero that's far from the first center
                  Xmin = round(max(1,v.MouseTrack.LegRF.Centroid{i}(k,1) - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,v.MouseTrack.LegRF.Centroid{i}(k,1) + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,v.MouseTrack.LegRF.Centroid{i}(k,2) - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,v.MouseTrack.LegRF.Centroid{i}(k,2) + p.MaxFingerDistance*SIZE));
                  CropPic([1:Xmin Xmax:end],:) = 0;
                  CropPic(:,[1:Ymin Ymax:end]) = 0;
                % centers
                  Xcenter = mean(mean(CropPic').*[1:length(mean(CropPic'))])/mean(mean(CropPic'));
                  Ycenter = mean(mean(CropPic ).*[1:length(mean(CropPic ))])/mean(mean(CropPic ));
                  % put in center if no data is recorded
                    if isnan(Xcenter) | isnan(Ycenter)
                      Xcenter = v.MouseTrack.LegRF.Centroid{i}(k,1);
                      Ycenter = v.MouseTrack.LegRF.Centroid{i}(k,2);
                    end;
                % borders should be max finger distance from center, unless there is border
                  Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                % save foot pic           
                  L = round(2*p.MaxFingerDistance*SIZE) + 1;
                  temp = zeros(L,L);
                  temp(1:Xmax-Xmin+1,1:Ymax-Ymin+1) = double(CropPic(Xmin:Xmax,Ymin:Ymax));
                  FootDynamics = [FootDynamics temp];
             end;
          end;
            % save picture of FootPic
              if max(FootPic(:)) > 0
                % determine where to center pic from footprint center
                  % make everything zero that's far from the first center
                    Xmin = round(max(1,v.MouseTrack.LegRF.Centroid{i}(StartStepIndexRF{i}(j),1) - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,v.MouseTrack.LegRF.Centroid{i}(StartStepIndexRF{i}(j),1) + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,v.MouseTrack.LegRF.Centroid{i}(StartStepIndexRF{i}(j),2) - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,v.MouseTrack.LegRF.Centroid{i}(StartStepIndexRF{i}(j),2) + p.MaxFingerDistance*SIZE));
                    FootPic([1:Xmin Xmax:end],:) = 0;
                    FootPic(:,[1:Ymin Ymax:end]) = 0;
                  % centers
                    Xcenter = mean(mean(FootPic').*[1:length(mean(FootPic'))])/mean(mean(FootPic'));
                    Ycenter = mean(mean(FootPic ).*[1:length(mean(FootPic ))])/mean(mean(FootPic ));
                  % put in center if no data is recorded
                    if isnan(Xcenter) | isnan(Ycenter)
                      Xcenter = v.MouseTrack.LegRF.Centroid{i}(k,1);
                      Ycenter = v.MouseTrack.LegRF.Centroid{i}(k,2);
                    end;
                  % borders should be max finger distance from center, unless there is border
                    Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                  % save footpic
                    Xstart = round(1             + counterRF*p.MaxFingerDistance*SIZE*2);
                    Xstop  = round(1 + Xmax-Xmin + counterRF*p.MaxFingerDistance*SIZE*2);
                    Ystart = round(1             + p.MaxFingerDistance*SIZE*2*2);
                    Ystop  = round(1 + Ymax-Ymin + p.MaxFingerDistance*SIZE*2*2);                  
                    FootTable(Xstart:Xstop,Ystart:Ystop) = FootPic(Xmin:Xmax,Ymin:Ymax);  
                    counterRF = counterRF+1;
                % create figure
                  S = size(FootPic(Xmin:Xmax,Ymin:Ymax));
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2) S(1)]);
                % plot MAX FOOT
                  imagesc(FootPic(Xmin:Xmax,Ymin:Ymax));
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootPrint_' ExperimentName '_RF_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);        
              end;
            % save picture of FootDynamics
              if ~isempty(FootDynamics)
                % create figure
                  S = size(FootDynamics);
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2)*3 S(1)*3]);
                % plot FOOT
                  imagesc(FootDynamics);
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % add SCALE BAR
                  hold on;
                  SizePic = size(FootDynamics);
                  P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
                  plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
               % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootDynamics_' ExperimentName '_RF_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);                   
                % add pic to FootPicAll
                  Sall = size(FootPicAll);
                  FootPicAll(Sall(1)+1:Sall(1)+S(1),1:S(2)) = FootDynamics;
              end;                
        end;
        % plot collection of steps
          if ~isempty(FootPicAll)
            % create figure
              S = size(FootPicAll);
              h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 S(2) S(1)]/300*4);
            % plot FOOT
              imagesc(FootPicAll);
              set(gca,'XtickLabel','','YtickLabel','');        
              box on;
            % add SCALE BAR
              hold on;
              SizePic = size(FootPicAll);
              P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
              plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
              set(gca,'position',[0 0 1 1],'units','normalized');
            % save figure
              outputfilename = [OutputMouseFoldername{i} '/FootDynamics_All_' ExperimentName '_RF_' num2str(j) '.png'];
              print(h,'-dpng', '-r300', outputfilename);
              close(h);                               
          end;
      % RH
        disp('  RH');
        FootPicAll = [];
        for j = 1:max(length(StartStepIndexRH{i}),length(StopStepIndexRH{i}))
          % initialize
            FootPic  = double(v.pic.R.*0);    
            FootDynamics = [];
          for k = StartStepIndexRH{i}(j):StopStepIndexRH{i}(j)
           % handle the case when somehow there are -1's in the data
             if v.MouseTrack.TrackIndex{i}(k) ~= -1
              % read in mouse pic
                v.pic = PictureReader(v.MouseTrack.TrackIndex{i}(k), p);  
              % subtract background
                v = FilterImage(v, p);           
              % keep only parts that are related to the foot and body
                CleanFootPIC = CleanPIC(v.pic.foot, p.MinFootSize);
              % get maxima up all images
                FootPic = max(FootPic, double(CleanFootPIC));        
              % make frame series
                CropPic = CleanFootPIC;
                % make everything zero that's far from the first center
                  Xmin = round(max(1,v.MouseTrack.LegRH.Centroid{i}(k,1) - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,v.MouseTrack.LegRH.Centroid{i}(k,1) + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,v.MouseTrack.LegRH.Centroid{i}(k,2) - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,v.MouseTrack.LegRH.Centroid{i}(k,2) + p.MaxFingerDistance*SIZE));
                  CropPic([1:Xmin Xmax:end],:) = 0;
                  CropPic(:,[1:Ymin Ymax:end]) = 0;
                % centers
                  Xcenter = mean(mean(CropPic').*[1:length(mean(CropPic'))])/mean(mean(CropPic'));
                  Ycenter = mean(mean(CropPic ).*[1:length(mean(CropPic ))])/mean(mean(CropPic ));
                  % put in center if no data is recorded
                    if isnan(Xcenter) | isnan(Ycenter)
                      Xcenter = v.MouseTrack.LegRH.Centroid{i}(k,1);
                      Ycenter = v.MouseTrack.LegRH.Centroid{i}(k,2);
                    end;
                % borders should be max finger distance from center, unless there is border
                  Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                  Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                  Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                  Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                % save foot pic           
                  L = round(2*p.MaxFingerDistance*SIZE) + 1;
                  temp = zeros(L,L);
                  temp(1:Xmax-Xmin+1,1:Ymax-Ymin+1) = double(CropPic(Xmin:Xmax,Ymin:Ymax));
                  FootDynamics = [FootDynamics temp];
             end;
          end;
            % save picture of FootPic
              if max(FootPic(:)) > 0
                % determine where to center pic from footprint center
                  % make everything zero that's far from the first center
                    Xmin = round(max(1,v.MouseTrack.LegRH.Centroid{i}(StartStepIndexRH{i}(j),1) - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,v.MouseTrack.LegRH.Centroid{i}(StartStepIndexRH{i}(j),1) + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,v.MouseTrack.LegRH.Centroid{i}(StartStepIndexRH{i}(j),2) - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,v.MouseTrack.LegRH.Centroid{i}(StartStepIndexRH{i}(j),2) + p.MaxFingerDistance*SIZE));
                    FootPic([1:Xmin Xmax:end],:) = 0;
                    FootPic(:,[1:Ymin Ymax:end]) = 0;
                  % centers
                    Xcenter = mean(mean(FootPic').*[1:length(mean(FootPic'))])/mean(mean(FootPic'));
                    Ycenter = mean(mean(FootPic ).*[1:length(mean(FootPic ))])/mean(mean(FootPic ));
                    % put in center if no data is recorded
                      if isnan(Xcenter) | isnan(Ycenter)
                        Xcenter = v.MouseTrack.LegRH.Centroid{i}(k,1);
                        Ycenter = v.MouseTrack.LegRH.Centroid{i}(k,2);
                      end;
                  % borders should be max finger distance from center, unless there is border
                    Xmin = round(max(1,Xcenter - p.MaxFingerDistance*SIZE));
                    Xmax = round(min(H,Xcenter + p.MaxFingerDistance*SIZE));
                    Ymin = round(max(1,Ycenter - p.MaxFingerDistance*SIZE));
                    Ymax = round(min(W,Ycenter + p.MaxFingerDistance*SIZE));
                  % save footpic
                    Xstart = round(1             + counterRH*p.MaxFingerDistance*SIZE*2);
                    Xstop  = round(1 + Xmax-Xmin + counterRH*p.MaxFingerDistance*SIZE*2);
                    Ystart = round(1             + p.MaxFingerDistance*SIZE*2*3);
                    Ystop  = round(1 + Ymax-Ymin + p.MaxFingerDistance*SIZE*2*3);                  
                    FootTable(Xstart:Xstop,Ystart:Ystop) = FootPic(Xmin:Xmax,Ymin:Ymax);  
                    counterRH = counterRH+1;
                % create figure
                  S = size(FootPic(Xmin:Xmax,Ymin:Ymax));
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2) S(1)]);
                % plot MAX FOOT
                  imagesc(FootPic(Xmin:Xmax,Ymin:Ymax));
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootPrint_' ExperimentName '_RH_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);        
              end;
            % save picture of FootDynamics
              if ~isempty(FootDynamics)
                % create figure
                  S = size(FootDynamics);
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 S(2)*3 S(1)*3]);
                % plot FOOT
                  imagesc(FootDynamics);
                  set(gca,'XtickLabel','','YtickLabel','');        
                  box on;
                % add SCALE BAR
                  hold on;
                  SizePic = size(FootDynamics);
                  P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
                  plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
                  text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/FootPrint/FootDynamics_' ExperimentName '_RH_' num2str(j) '.png'];
                  saveas(h,outputfilename,'png');    
                  close(h);                   
                % add pic to FootPicAll
                  Sall = size(FootPicAll);
                  FootPicAll(Sall(1)+1:Sall(1)+S(1),1:S(2)) = FootDynamics;
              end;                
        end;     
        % plot collection of steps
          if ~isempty(FootPicAll)
            % create figure
              S = size(FootPicAll);
              h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 S(2) S(1)]/300*4);
            % plot FOOT
              imagesc(FootPicAll);
              set(gca,'XtickLabel','','YtickLabel','');        
              box on;
            % add SCALE BAR
              hold on;
              SizePic = size(FootPicAll);
              P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[22 20 20 22],'w');
              plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 22],'Color',[1 1 1], 'LineWidth', 2)
              text(SizePic(2)-p.mm2pix*10*2, 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
              set(gca,'position',[0 0 1 1],'units','normalized');
            % save figure
              outputfilename = [OutputMouseFoldername{i} '/FootDynamics_All_' ExperimentName '_RH_' num2str(j) '.png'];
              print(h,'-dpng', '-r300', outputfilename);
              close(h);                               
          end;
        % add to the bottom of the plot
          FootTable(Xstop+1:Xstop+1+round(p.MaxFingerDistance), Ystart:Ystop) = 0;          
        % plot foot table
          % add bottom row to foottable to make space for scale bar
            S = size(FootTable);            
            FootTable(S(1)+1:S(1)+40,:) = 0;
          % create figure
            S = size(FootTable);
            h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 S(2)*4 S(1)*4]/300);
          % plot MAX FOOT
            imagesc(FootTable);
          % add SCALE BAR
            hold on;
            SizePic = size(FootTable);
            P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),SizePic(1) - [22 20 20 22],'w');
            plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),SizePic(1) - [20 22],'Color',[1 1 1], 'LineWidth', 2)
            plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),SizePic(1) - [20 22],'Color',[1 1 1], 'LineWidth', 2)
            text(SizePic(2)-p.mm2pix*10*2, SizePic(1) - 28,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');
          % add labels to X axis  
            text(SizePic(2)*1/8,S(1)-5,'LF','Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');          
            text(SizePic(2)*3/8,S(1)-5,'LH','Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');          
            text(SizePic(2)*5/8,S(1)-5,'RF','Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');          
            text(SizePic(2)*7/8,S(1)-5,'RH','Color',[1 1 1], 'FontSize', 10,'HorizontalAlignment','center');          
          set(gca,'position',[0 0 1 1],'units','normalized');
          % save figure
            outputfilename = [OutputMouseFoldername{i} 'FootTable_' ExperimentName '.png'];
            set(gca, 'YtickLabel',''); 
%             set(gca,'YTickLabel',sprintf('%2.1f',str2num(YTicks) / p.mm2pix),'FontSize',14);
            set(gca,'XTick', [1 3 5 7]*p.MaxFingerDistance*SIZE, 'XTickLabel',{'LF' 'LH' 'RF' 'RH'},'FontSize',14);
            print(h,'-dpng', '-r300', outputfilename);
            close(h);        
    
    end; % loop over mice
  end; % PLOTSTEPS

  
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALL FOOTPRINT INEGRATED IN ONE IMAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('ALL FOOTPRINT INEGRATED IN ONE IMAGE')  

  if PLOTSTEPSALL == 1
    for i = MouseArray % loop over mice

      % create FootPrint folder in Results if it doesn't exist yet
        if ~exist([OutputMouseFoldername{i} '/ColoredFeet/']), mkdir([OutputMouseFoldername{i} '/ColoredFeet/']); end;      
     
      % initialize
        v.pic = PictureReader(1, p);  
        MaxFootPic  = double(v.pic.R.*0);
        MaxBodyPic  = double(v.pic.R.*0);
        ColoredFeetPic = double(v.pic.R.*0);
        % determine picture size
          S = size(v.pic.R);
          H = S(1);
          W = S(2);        
          
      % loop over frames
        for j = 1 : length(p.FileList)
          % display progress
            if mod(j,10) == 0, disp(j); end;
          % find mouse track index that corresponds to current frame
            N = find(v.MouseTrack.TrackIndex{i} == j);
          % continue only if mouse is present on this frame
            if (v.MouseTrack.BodyCentroid{i}(N,1)) ~= -1
            % read in mouse pic
              v.pic = PictureReader(j, p);  
            % subtract background
              v = FilterImage(v,p);           
            % keep only parts that are related to the foot and body
              CleanFootPIC = CleanPIC(v.pic.foot, p.MinFootSize);
              CleanBodyPIC = CleanPIC(v.pic.body, p.MinBodySize);
            % get maxima up all images
              MaxFootPic = max(MaxFootPic, double(CleanFootPIC));
              MaxBodyPic = max(MaxBodyPic, double(CleanBodyPIC));
            % COLORED FEET ----------------------------------------------
            % background - 0
            % body       - 1
            % LF         - 2
            % LH         - 3
            % RF         - 4
            % RH         - 5
              % remove potential previous body coloration by previous body positions
                ColoredFeetPic(ColoredFeetPic == 1) = 0;
              % add feet to pic
                if v.MouseTrack.LegLF.Centroid{i}(N,1) > 0
                  Xmin = round(max(1,v.MouseTrack.LegLF.Centroid{i}(N,1) - p.MaxFingerDistance));
                  Xmax = round(min(H,v.MouseTrack.LegLF.Centroid{i}(N,1) + p.MaxFingerDistance));
                  Ymin = round(max(1,v.MouseTrack.LegLF.Centroid{i}(N,2) - p.MaxFingerDistance));
                  Ymax = round(min(W,v.MouseTrack.LegLF.Centroid{i}(N,2) + p.MaxFingerDistance));
                  PicLF = CleanFootPIC;
                  PicLF([1:Xmin Xmax:end],:) = 0;
                  PicLF(:,[1:Ymin Ymax:end]) = 0;                    
                  % make those points in which PicLF is not zero equal to LF's number in ColoredFeetPic
                    ColoredFeetPic(PicLF ~= 0) = 2;
                end;
                if v.MouseTrack.LegLH.Centroid{i}(N,1) > 0
                  Xmin = round(max(1,v.MouseTrack.LegLH.Centroid{i}(N,1) - p.MaxFingerDistance));
                  Xmax = round(min(H,v.MouseTrack.LegLH.Centroid{i}(N,1) + p.MaxFingerDistance));
                  Ymin = round(max(1,v.MouseTrack.LegLH.Centroid{i}(N,2) - p.MaxFingerDistance));
                  Ymax = round(min(W,v.MouseTrack.LegLH.Centroid{i}(N,2) + p.MaxFingerDistance));
                  PicLH = CleanFootPIC;
                  PicLH([1:Xmin Xmax:end],:) = 0;
                  PicLH(:,[1:Ymin Ymax:end]) = 0;
                  % make those points in which PicLF is not zero equal to LF's number in ColoredFeetPic
                    ColoredFeetPic(PicLH ~= 0) = 3;
                end;
                if v.MouseTrack.LegRF.Centroid{i}(N,1) > 0
                  Xmin = round(max(1,v.MouseTrack.LegRF.Centroid{i}(N,1) - p.MaxFingerDistance));
                  Xmax = round(min(H,v.MouseTrack.LegRF.Centroid{i}(N,1) + p.MaxFingerDistance));
                  Ymin = round(max(1,v.MouseTrack.LegRF.Centroid{i}(N,2) - p.MaxFingerDistance));
                  Ymax = round(min(W,v.MouseTrack.LegRF.Centroid{i}(N,2) + p.MaxFingerDistance));
                  PicRF = CleanFootPIC;
                  PicRF([1:Xmin Xmax:end],:) = 0;
                  PicRF(:,[1:Ymin Ymax:end]) = 0;                    
                  % make those points in which PicLF is not zero equal to LF's number in ColoredFeetPic
                    ColoredFeetPic(PicRF ~= 0) = 4;
                end;
                if v.MouseTrack.LegRH.Centroid{i}(N,1) > 0
                  Xmin = round(max(1,v.MouseTrack.LegRH.Centroid{i}(N,1) - p.MaxFingerDistance));
                  Xmax = round(min(H,v.MouseTrack.LegRH.Centroid{i}(N,1) + p.MaxFingerDistance));
                  Ymin = round(max(1,v.MouseTrack.LegRH.Centroid{i}(N,2) - p.MaxFingerDistance));
                  Ymax = round(min(W,v.MouseTrack.LegRH.Centroid{i}(N,2) + p.MaxFingerDistance));
                  PicRH = CleanFootPIC;
                  PicRH([1:Xmin Xmax:end],:) = 0;
                  PicRH(:,[1:Ymin Ymax:end]) = 0;                    
                  % make those points in which PicLF is not zero equal to LF's number in ColoredFeetPic
                    ColoredFeetPic(PicRH ~= 0) = 5;
                end;
              % add body to pic
                ColoredFeetPic(CleanBodyPIC ~= 0 & ColoredFeetPic == 0) = 1;
              % plot foot table
                % create figure
                  S = size(ColoredFeetPic);
                  h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 S(2) S(1)]/300);
                % plot COLORED FEET
                  imagesc(ColoredFeetPic);
                  set(gca, 'Clim', [0 5]);
                  % colormap
                    %C = [1 1 1; 0.8 0.8 0.8; ColorLF; ColorLH; ColorRF; ColorRH];
                    C = [1 1 1; 0.8 0.8 0.8; [255	215	0]/255; ColorLH; ColorRF; ColorRH];                  
                    colormap(C);
                  box on;
                  set(gca,'position',[0 0 1 1],'units','normalized');
                % save figure
                  outputfilename = [OutputMouseFoldername{i} '/ColoredFeet/img' sprintf('%05d',j) '.png'];
                  set(gca,'XTick', [],'YTick', []);
                  print(h,'-dpng', '-r300', outputfilename);
                  close(h);        
                
            % -----------------------------------------------------------
            % check for ABORT
              if isfield(handles,'evaluate_togglebutton') & get(handles.evaluate_togglebutton,'Value') == 0; return; end;
            end;
         end;
      % plot the final version without the mouse
        % remove mouse
          ColoredFeetPic(ColoredFeetPic == 1) = 0;
          S = size(ColoredFeetPic);
        h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 S(2) S(1)]/300);
        % plot COLORED FEET
          imagesc(ColoredFeetPic);
          set(gca, 'Clim', [0 5]);
          % colormap
            %C = [1 1 1; 0.8 0.8 0.8; ColorLF; ColorLH; ColorRF; ColorRH];
            C = [1 1 1; 0.8 0.8 0.8; [255	215	0]/255; ColorLH; ColorRF; ColorRH];                  
            colormap(C);
          box on;
          set(gca,'position',[0 0 1 1],'units','normalized');
        % save figure
          outputfilename = [OutputMouseFoldername{i} '/ColoredFeet_' ExperimentName '.png'];
          set(gca,'XTick', [],'YTick', []);
          print(h,'-dpng', '-r300', outputfilename);
          close(h);        


      % determine picture size
        S = size(MaxFootPic);
        W = S(1);
        H = S(2);

      % create figure
        h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'inches', 'PaperPosition', [0 0 H W]/300);
      % plot MAX FOOT
        imagesc(MaxFootPic);
        set(gca,'XtickLabel','','YtickLabel','');        
        box on;        
      % add SCALE BAR
        hold on;
        SizePic = size(MaxFootPic);
        P1 = patch([-1.5 -1.5 -2.5 -2.5].*p.mm2pix*10+SizePic(2),[26 20 20 26],'w');
        plot([-1.5 -1.5].*p.mm2pix*10+SizePic(2),[20 26],'Color',[0.999 0.999 0.999], 'LineWidth', 2)
        plot(-[2.5 2.5].*p.mm2pix*10+SizePic(2),[20 26],'Color',[0.999 0.999 0.999], 'LineWidth', 2)
        text(SizePic(2)-p.mm2pix*10*2, 35,['1 cm (' num2str(p.mm2pix*40) ' px)'],'Color',[0.999 0.999 0.999], 'FontSize', 4,'HorizontalAlignment','center');
      % add body center trace
        % find times that are not cancelled
          indT = find(v.MouseTrack.TrackTime{i} > 0);
          plot(v.MouseTrack.BodyCentroid{i}(indT,2),v.MouseTrack.BodyCentroid{i}(indT,1),'Color', [200 200 200]/255, 'LineWidth', 1);
          hold off;
      % save figure
        set(gca,'position',[0 0 1 1],'units','normalized');
        set(gca,'XTick', [],'YTick', []);
        outputfilename = [OutputMouseFoldername{i} 'FootPrints_Max_' ExperimentName '.png'];
        print(h,'-dpng', '-r300', outputfilename);
        close(h);

    end;
  end; % PLOTSTEPS  
  
return;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [StartStepIndexLF, StartStepIndexLH, StartStepIndexRF, StartStepIndexRH, StopStepIndexLF, StopStepIndexLH, StopStepIndexRF, StopStepIndexRH] ...
         = FootprintTimingPlot(v, p, i, h)
% plot footprint timing to gca.

% define minimum time step
  dt = 1/p.fps*0.5;

    % find earliest footprint - this is where the graph will start from
      % find earliest point for each footprint, handle possibility that there was none
        indRF = find(v.MouseTrack.LegRF.Centroid{i}(:,1) ~= -1 & v.MouseTrack.TrackTime{i}' > 0); if isempty(indRF), indRF = 999999; end;
        indRH = find(v.MouseTrack.LegRH.Centroid{i}(:,1) ~= -1 & v.MouseTrack.TrackTime{i}' > 0); if isempty(indRH), indRH = 999999; end;
        indLF = find(v.MouseTrack.LegLF.Centroid{i}(:,1) ~= -1 & v.MouseTrack.TrackTime{i}' > 0); if isempty(indLF), indLF = 999999; end;
        indLH = find(v.MouseTrack.LegLH.Centroid{i}(:,1) ~= -1 & v.MouseTrack.TrackTime{i}' > 0); if isempty(indLH), indLH = 999999; end;
      % determine index of earliest footprint
        earliestfootprintindex = min([indRF(1) indRH(1) indLF(1) indLH(1)]);
    % find last footprint - this is where the graph will end; handle if there is no footprints
      temp = [indRF(end) indRH(end) indLF(end) indLH(end)];
      temp2 = temp(temp ~= 999999); if isempty(temp2), temp2 = 1; end;
      lastfootprintindex = max(temp2);
      
    % plot patches for each footprint
      starttime = earliestfootprintindex;
      stoptime = -1;
      StartStepIndexRF = [];
      StartStepIndexRH = [];
      StartStepIndexLF = [];
      StartStepIndexLH = [];
      StopStepIndexRF  = [];
      StopStepIndexRH  = [];
      StopStepIndexLF  = [];
      StopStepIndexLH  = [];
      for j = earliestfootprintindex:lastfootprintindex + 1 % loop over time indixes where at least one leg was down.
          if j <= lastfootprintindex & v.MouseTrack.LegLF.Centroid{i}(j,1) ~= -1
              if starttime == 0
                  starttime = j;
              end;
              stoptime = j;
          else
            % only plot if the start is not the first frame and stop is not last
              if starttime ~= 0 & stoptime ~= -1 % & starttime ~= earliestfootprintindex & stoptime ~= lastfootprintindex 
                  % plot patch
                    if v.MouseTrack.TrackTime{i}(starttime) > 0 & v.MouseTrack.TrackTime{i}(stoptime) > 0                  
                      P = patch([v.MouseTrack.TrackTime{i}(starttime)-dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(starttime)-dt], [0 0 100 100] - 150, [112,128,144]/255, 'EdgeColor', 'none');
                    end;
                    hold on;
                  % save start and stoptimes
                    StartStepIndexLF = [StartStepIndexLF starttime];
                    StopStepIndexLF  = [StopStepIndexLF  stoptime ];
              end;
              starttime = 0;
          end;
      end;
      starttime = earliestfootprintindex;
      stoptime = -1;
      for j = earliestfootprintindex:lastfootprintindex + 1 % loop over time indixes where at least one leg was down.
          if j <= lastfootprintindex & v.MouseTrack.LegLH.Centroid{i}(j,1) ~= -1
              if starttime == 0
                  starttime = j;
              end;
              stoptime = j;
          else
            % only plot if the start is not the first frame and stop is not last
              if starttime ~= 0 & stoptime ~= -1 % & starttime ~= earliestfootprintindex & stoptime ~= lastfootprintindex 
                  % plot patch
                    if v.MouseTrack.TrackTime{i}(starttime) > 0 & v.MouseTrack.TrackTime{i}(stoptime) > 0
                      P = patch([v.MouseTrack.TrackTime{i}(starttime)-dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(starttime)-dt], [0 0 100 100]+100 - 150, [112,128,144]/255, 'EdgeColor', 'none');
                    end;
                    hold on;
                  % save start and stoptimes
                    StartStepIndexLH = [StartStepIndexLH starttime];
                    StopStepIndexLH  = [StopStepIndexLH  stoptime ];
              end;
              starttime = 0;
          end;
      end;
      starttime = earliestfootprintindex;
      stoptime = -1;
      for j = earliestfootprintindex:lastfootprintindex + 1 % loop over time indixes where at least one leg was down.
          if j <= lastfootprintindex & v.MouseTrack.LegRF.Centroid{i}(j,1) ~= -1
              if starttime == 0
                  starttime = j;
              end;
              stoptime = j;
          else
            % only plot if the start is not the first frame and stop is not last
              if starttime ~= 0 & stoptime ~= -1 % & starttime ~= earliestfootprintindex & stoptime ~= lastfootprintindex 
                  % plot patch
                    if v.MouseTrack.TrackTime{i}(starttime) > 0 & v.MouseTrack.TrackTime{i}(stoptime) > 0
                      P = patch([v.MouseTrack.TrackTime{i}(starttime)-dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(starttime)-dt], [0 0 100 100]+200 - 150, [112,128,144]/255, 'EdgeColor', 'none');
                    end;
                    hold on;
                  % save start and stoptimes
                    StartStepIndexRF = [StartStepIndexRF starttime];
                    StopStepIndexRF  = [StopStepIndexRF  stoptime ];
              end;
              starttime = 0;
          end;
      end;
      starttime = earliestfootprintindex;
      stoptime = -1;
      for j = earliestfootprintindex:lastfootprintindex + 1 % loop over time indixes where at least one leg was down.
          if j <= lastfootprintindex & v.MouseTrack.LegRH.Centroid{i}(j,1) ~= -1
              if starttime == 0
                  starttime = j;
              end;
              stoptime = j;
          else
            % only plot if the start is not the first frame and stop is not last
              if starttime ~= 0 & stoptime ~= -1 % & starttime ~= earliestfootprintindex & stoptime ~= lastfootprintindex 
                  % plot patch
                    if v.MouseTrack.TrackTime{i}(starttime) > 0 & v.MouseTrack.TrackTime{i}(stoptime) > 0
                      P = patch([v.MouseTrack.TrackTime{i}(starttime)-dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(stoptime)+dt v.MouseTrack.TrackTime{i}(starttime)-dt], [0 0 100 100]+300 - 150, [112,128,144]/255, 'EdgeColor', 'none');
                    end;
                    hold on;
                  % save start and stoptimes
                    StartStepIndexRH = [StartStepIndexRH starttime];
                    StopStepIndexRH  = [StopStepIndexRH  stoptime ];
              end;
              starttime = 0;
          end;
      end;
    % get xlim
      axis tight;
      Xlim = get(gca, 'XLim');
    % plot lines to separate legs
      % the *2 is because we throw away the last footprints and want to make sure that lines don't end before end of screen. 
      plot([Xlim(1) Xlim(2)*2], [-50 -50], 'k:', 'LineWidth', 1);
      plot([Xlim(1) Xlim(2)*2], [ 50  50], 'k:', 'LineWidth', 1);
      plot([Xlim(1) Xlim(2)*2], [150 150], 'k:', 'LineWidth', 1);
    TEXT = ['LF'; 'LH'; 'RF'; 'RH'];
    ylim([-150 250]);
    xlabel('t [sec]');
%     grid on;;
    set(gca,'YTickLabel',TEXT, 'Ytick', [-100 0 100 200], 'TickLength', [0 0]);
    set(gca,'layer','top');
    set(gca,'XGrid','on','YGrid','off');
    box on;
    set(gca,'LineWidth',2);
    hold off;
    % FIRST/LAST REMOVE: if the first starts on the first frame where the
    % body is on or the last step ends on the last frame where the body is
    % on then remove them as they are likely truncated
      ind = find(v.MouseTrack.BodyCentroid{i}(:,1) > 0);
      if length(StartStepIndexLF) > 1 &  StartStepIndexLF(1) == ind(1),  StartStepIndexLF = StartStepIndexLF(2:end);    StopStepIndexLF =  StopStepIndexLF(2:end);   end;
      if length(StartStepIndexLH) > 1 &  StartStepIndexLH(1) == ind(1),  StartStepIndexLH = StartStepIndexLH(2:end);    StopStepIndexLH =  StopStepIndexLH(2:end);   end;
      if length(StartStepIndexRF) > 1 &  StartStepIndexRF(1) == ind(1),  StartStepIndexRF = StartStepIndexRF(2:end);    StopStepIndexRF =  StopStepIndexRF(2:end);   end;
      if length(StartStepIndexRH) > 1 &  StartStepIndexRH(1) == ind(1),  StartStepIndexRH = StartStepIndexRH(2:end);    StopStepIndexRH =  StopStepIndexRH(2:end);   end;
      if  length(StopStepIndexLF) > 1 & StopStepIndexLF(end) == ind(end), StopStepIndexLF =  StopStepIndexLF(1:end-1); StartStepIndexLF = StartStepIndexLF(1:end-1); end;
      if  length(StopStepIndexLH) > 1 & StopStepIndexLH(end) == ind(end), StopStepIndexLH =  StopStepIndexLH(1:end-1); StartStepIndexLH = StartStepIndexLH(1:end-1); end;
      if  length(StopStepIndexRF) > 1 & StopStepIndexRF(end) == ind(end), StopStepIndexRF =  StopStepIndexRF(1:end-1); StartStepIndexRF = StartStepIndexRF(1:end-1); end;
      if  length(StopStepIndexRH) > 1 & StopStepIndexRH(end) == ind(end), StopStepIndexRH =  StopStepIndexRH(1:end-1); StartStepIndexRH = StartStepIndexRH(1:end-1); end;
      
return;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [StartPosition, StopPosition] = StepRelativePositionPlot(v, p, i, ColorLF, ColorLH, ColorRF, ColorRH, StartStepIndexLF, StartStepIndexLH, StartStepIndexRF, StartStepIndexRH, StopStepIndexLF, StopStepIndexLH, StopStepIndexRF, StopStepIndexRH, brightning, h, StartPosition, StopPosition)
% plot footprint relative positions compared to body position and orientation

    hold off;
    % set up legend
      plot(-100, -100, 'o','color', ColorLF, 'MarkerSize', 5, 'MarkerFaceColor',ColorLF);
      hold on;
      plot(-100, -100, 'o','color', ColorRF, 'MarkerSize', 5, 'MarkerFaceColor',ColorRF);
      plot(-100, -100, 'o','color', ColorLH, 'MarkerSize', 5, 'MarkerFaceColor',ColorLH);
      plot(-100, -100, 'o','color', ColorRH, 'MarkerSize', 5, 'MarkerFaceColor',ColorRH);
      % legend
        L = legend('Left Fore', 'Right Fore', 'Left Hind', 'Right Hind');
        set(L,'Interpreter','none', 'FontSize', 12, 'Location', 'NorthWest');
      
    % calculate average body length we will use length to be 4*(body center - body back)
       if p.FixedBodyLength <= 0
         ind = find(v.MouseTrack.BodyCentroid{i}(:,1) > 0);
         BodyLength = 4*median(sqrt((v.MouseTrack.BodyCentroid{i}(ind,1) - v.MouseTrack.BodyBackCentroid{i}(ind,1)).^2+(v.MouseTrack.BodyCentroid{i}(ind,2) - v.MouseTrack.BodyBackCentroid{i}(ind,2)).^2)); 
       else
         BodyLength = p.FixedBodyLength;
       end;
       BodyWidth = BodyLength/3;
    
    % plot distance relative to body position and direction for each leg
      % LF
        for j = 1:length(StartStepIndexLF{i}) % loop over steps
          % convert points within this step to parallel/perpendicular components
            % initialize
              DistPar  = 0;
              DistPerp = 0;
            for k = 1:StopStepIndexLF{i}(j)-StartStepIndexLF{i}(j)+1 % loop over frames within step
              ind = StartStepIndexLF{i}(j)+k-1; % index of actual point
              [DistPar(k), DistPerp(k)] = DistanceFromLine(v.MouseTrack.LegLF.Centroid{i}(ind,1), v.MouseTrack.LegLF.Centroid{i}(ind,2), [v.MouseTrack.BodyCentroid{i}(ind,1) v.MouseTrack.HeadCentroid{i}(ind,1)], [v.MouseTrack.BodyCentroid{i}(ind,2) v.MouseTrack.HeadCentroid{i}(ind,2)]);
            end;
          % plot leg movement
            plot(-DistPerp / BodyLength, DistPar / BodyLength, 'Color', min(1,ColorLF*brightning), 'LineWidth', 3);
            plot(-DistPerp(1) / BodyLength, DistPar(1) / BodyLength, 'o','color', ColorLF, 'MarkerSize', 8, 'MarkerFaceColor',ColorLF);
          % save start and stopstep position
            StartPosition.X.LF{i}(j) = -DistPerp(1)   / BodyLength;
            StartPosition.Y.LF{i}(j) =  DistPar(1)    / BodyLength;
             StopPosition.X.LF{i}(j) = -DistPerp(end) / BodyLength;
             StopPosition.Y.LF{i}(j) =  DistPar(end)  / BodyLength;
        end;
      % LH
        for j = 1:length(StartStepIndexLH{i}) % loop over steps
          % convert points within this step to parallel/perpendicular components
            % initialize
              DistPar  = 0;
              DistPerp = 0;
            for k = 1:StopStepIndexLH{i}(j)-StartStepIndexLH{i}(j)+1 % loop over frames within step
              ind = StartStepIndexLH{i}(j)+k-1; % index of actual point
              [DistPar(k), DistPerp(k)] = DistanceFromLine(v.MouseTrack.LegLH.Centroid{i}(ind,1), v.MouseTrack.LegLH.Centroid{i}(ind,2), [v.MouseTrack.BodyCentroid{i}(ind,1) v.MouseTrack.HeadCentroid{i}(ind,1)], [v.MouseTrack.BodyCentroid{i}(ind,2) v.MouseTrack.HeadCentroid{i}(ind,2)]);
            end;
          % plot leg movement
            plot(-DistPerp / BodyLength, DistPar / BodyLength, 'Color', min(1,ColorLH*brightning), 'LineWidth', 3);
            plot(-DistPerp(1) / BodyLength, DistPar(1) / BodyLength, 'o','color', ColorLH, 'MarkerSize', 8, 'MarkerFaceColor',ColorLH);
          % save start and stopstep position
            StartPosition.X.LH{i}(j) = -DistPerp(1)   / BodyLength;
            StartPosition.Y.LH{i}(j) =  DistPar(1)    / BodyLength;
             StopPosition.X.LH{i}(j) = -DistPerp(end) / BodyLength;
             StopPosition.Y.LH{i}(j) =  DistPar(end)  / BodyLength;
        end;
      % RF
        for j = 1:length(StartStepIndexRF{i}) % loop over steps
          % convert points within this step to parallel/perpendicular components
            % initialize
              DistPar  = 0;
              DistPerp = 0;
            for k = 1:StopStepIndexRF{i}(j)-StartStepIndexRF{i}(j)+1 % loop over frames within step
              ind = StartStepIndexRF{i}(j)+k-1; % index of actual point
              [DistPar(k), DistPerp(k)] = DistanceFromLine(v.MouseTrack.LegRF.Centroid{i}(ind,1), v.MouseTrack.LegRF.Centroid{i}(ind,2), [v.MouseTrack.BodyCentroid{i}(ind,1) v.MouseTrack.HeadCentroid{i}(ind,1)], [v.MouseTrack.BodyCentroid{i}(ind,2) v.MouseTrack.HeadCentroid{i}(ind,2)]);
            end;            
          % plot leg movement
            plot(-DistPerp / BodyLength, DistPar / BodyLength, 'Color', min(1,ColorRF*brightning), 'LineWidth', 3);
            plot(-DistPerp(1) / BodyLength, DistPar(1) / BodyLength, 'o','color', ColorRF, 'MarkerSize', 8, 'MarkerFaceColor',ColorRF);
          % save start and stopstep position
            StartPosition.X.RF{i}(j) = -DistPerp(1)   / BodyLength;
            StartPosition.Y.RF{i}(j) =  DistPar(1)    / BodyLength;
             StopPosition.X.RF{i}(j) = -DistPerp(end) / BodyLength;
             StopPosition.Y.RF{i}(j) =  DistPar(end)  / BodyLength;
        end;
      % RH
        for j = 1:length(StartStepIndexRH{i}) % loop over steps
          % convert points within this step to parallel/perpendicular components
            % initialize
              DistPar  = 0;
              DistPerp = 0;
            for k = 1:StopStepIndexRH{i}(j)-StartStepIndexRH{i}(j)+1 % loop over frames within step
              ind = StartStepIndexRH{i}(j)+k-1; % index of actual point
              [DistPar(k), DistPerp(k)] = DistanceFromLine(v.MouseTrack.LegRH.Centroid{i}(ind,1), v.MouseTrack.LegRH.Centroid{i}(ind,2), [v.MouseTrack.BodyCentroid{i}(ind,1) v.MouseTrack.HeadCentroid{i}(ind,1)], [v.MouseTrack.BodyCentroid{i}(ind,2) v.MouseTrack.HeadCentroid{i}(ind,2)]);
            end;
          % plot leg movement
            plot(-DistPerp / BodyLength, DistPar / BodyLength, 'Color', min(1,ColorRH*brightning), 'LineWidth', 3);
            plot(-DistPerp(1) / BodyLength, DistPar(1) / BodyLength, 'o','color', ColorRH, 'MarkerSize', 8, 'MarkerFaceColor',ColorRH);
          % save start and stopstep position
            StartPosition.X.RH{i}(j) = -DistPerp(1)   / BodyLength;
            StartPosition.Y.RH{i}(j) =  DistPar(1)    / BodyLength;
             StopPosition.X.RH{i}(j) = -DistPerp(end) / BodyLength;
             StopPosition.Y.RH{i}(j) =  DistPar(end)  / BodyLength;
        end;   
        
    % plot ellipse
      t = 0:0.001:2*pi;
      plot(BodyWidth/BodyLength*cos(t)/2,sin(t)/2,'color',[0.5,0.5,0.5],'LineWidth',2)
    % plot little arrow
      plot([0 0],    [-0.15 0.15],'color',[0.5,0.5,0.5],'LineWidth',2)
      plot([0  0.01],[0.15 0.01] ,'color',[0.5,0.5,0.5],'LineWidth',1)
      plot([0 -0.01],[0.15 0.01] ,'color',[0.5,0.5,0.5],'LineWidth',1)

    % set picture limits
      XLIMIT = [-0.4 +0.4];
      YLIMIT = [-0.7 0.7];
    
      xlim(XLIMIT);
      ylim(YLIMIT);
          
    % set up figure
      title('Footprints relative to body position');
      xlabel('perpendicular dist. from body center [/body length]');
      ylabel('parallel dist. from body center [/body length]')
      grid on;
      set(gca, 'FontSize', 12)
      box on;
      set(gca,'LineWidth',2);
      hold off;
            
return;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function PlotResults(Variable, time, Title, YAxisName, figurenumber, outputfilename, RGB)
% plot Variable as a function of time with given title, axisnames and figurenumber


% create figure
  h = figure('visible', 'off');
  hold off;

% plot variable just for the legend first
for i = 1:4
    ind = find(Variable(i,:) ~= -1 & time ~= -1);
    plot(time(ind), Variable(i,ind), 'o','color', RGB(i,:), 'MarkerSize', 5, 'MarkerFaceColor',RGB(i,:));
    hold on;
end;
% plot data points
  for i = 1:4
      ind = find(Variable(i,:) ~= -1 & time ~= -1);
      for j = 1:length(ind)-1
          if ind(j+1) - ind(j) == 1
              I = [ind(j) ind(j+1)];
              plot(time(I), Variable(i,I),'color', RGB(i,:), 'LineWidth', 2);
          end
      end
  end;
% connect data points with thin line  
  for i = 1:4
      ind = find(Variable(i,:) ~= -1 & time ~= -1);
      plot(time(ind), Variable(i,ind), ':','color', RGB(i,:));
  end;
  
L = legend('Left Fore', 'Left Hind', 'Right Fore', 'Right Hind');
set(L,'Interpreter','none', 'FontSize', 8, 'Location', 'NorthWest');
title(Title);
xlabel('time [sec]');
ylabel(YAxisName);
grid on;
box on;
set(gca,'LineWidth',2);
hold off;

saveas(h,outputfilename,'png');

close(h);


return;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [Dist, DistPerp, DistPar, Angle] = LegDistance(LegX, LegY, BodyCentroidX, BodyCentroidY, HeadCentroidX, HeadCentroidY)
% determine leg parallel and perpendicular distance from body center along
% body line, also calculating the angle between leg-bodycenter and
% bodycenter-head

% run only if there is a leg
  if LegX ~= -1
    % DISTANCE from body center  
      Dist = sqrt((LegX - BodyCentroidX)^2 + (LegY - BodyCentroidY)^2);

    % PERPENDICULAR and PARALLEL distances
      [DistPar, DistPerp] = DistanceFromLine(LegX, LegY, [BodyCentroidX HeadCentroidX], [BodyCentroidY HeadCentroidY]);

    % ANGLE
      [temp1, Angle, temp2] = FitLine([BodyCentroidX HeadCentroidX], [BodyCentroidY HeadCentroidY], LegX, LegY);
      % make angle fall between 0-180 deg.
        Angle = mod(Angle,180);
  else
    Dist     = -1;
    DistPerp = -1;
    DistPar  = -1;
    Angle    = -1;
  end;

return;


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [d, x0, y0]  = point_to_line(x1,y1,m,b)
% calculate distance between line y=mx+b and point (x1,y1).
% d        - distance
% (x0,y0)  - coordinates of the closest point on the line to the point

    x0 = (m*y1 + x1 - m*b)   / (m^2 + 1);
    y0 = (m^2*y1 + m*x1 + b) / (m^2 + 1);
    d = abs(y1 - m*x1 - b)   / sqrt(m^2+1);

return;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Plot_LEG_COMBINATION(TIME, CombinationCode, p)
%  four  legs         (four)  +4
%  three legs         (walk)  +3
%  two opposite       (trot)  +2
%  two same side      (pace)  +1
%  two front or back  (bound)  0
%  1 leg                      -1
%  jump (0 leg)               -2

  % parameters
    % window size of moving average [frames]
      CombinationBinSize = 1;
      
    % min time step
      dt = 1 / p.fps * 0.5;
      
    % filter out those points where time == -1
      ind = find(TIME > 0);
      TIME = TIME(ind);
      CombinationCode = CombinationCode(ind);
      
  % plot
      Width = 0.5; % width of bars
      X = TIME;
      Y = CombinationCode;
      for j = 1:length(X)
          P = patch('Faces', [1 2 3 4], 'Vertices', [X(j)-dt Y(j)-Width/2; X(j)+dt Y(j)-Width/2; X(j)+dt Y(j)+Width/2; X(j)-dt Y(j)+Width/2], 'FaceColor', [0 0 128]/255, 'EdgeColor', 'none');          
          hold on;
      end;
%       set(gca,'Ytick', [-2 -1 0 1 2 3 4], 'YTickLabel',{'jump'; '1-leg'; 'bound/hop'; 'pace'; 'trot'; 'walk'; 'stand'}, 'FontSize', 12);
      set(gca,'Ytick', [-2 -1 0 1 2 3 4], 'YTickLabel',{'all'; '3 leg'; 'front/hind'; 'lateral'; 'diagonal'; 'single'; 'none'}, 'FontSize', 11);
      ylim([-3 5]);
      xlabel('t [sec]');
      grid on;
      box on;
      set(gca,'LineWidth',2);
      hold off;
      
return;


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plot_LEG_COMBINATION_COLOR_CODE(time, CombinationCode, p)
%  four  legs         (four)  +4
%  three legs         (walk)  +3
%  two opposite       (trot)  +2
%  two same side      (pace)  +1
%  two front or back  (bound)  0
%  1 leg                      -1
%  jump (0 leg)               -2
%  something else             -3

  % colors [RGB]
    % 4 legs (blue)
      RGB_four   = [30 30 30]/255;
    % 3 legs (green)
      RGB_walk   = [0 0 205]/255;
    % 2 same side (gray)
      RGB_pace   = [0 205 0]/255;
    % 2 opposite (red)
      RGB_trot   = [205 20 20]/255;
    % bound (???)
      RGB_bound  = [186	085	211]/255;
    % 1-leg (lightblue)
      RGB_1leg  = [238	221	130]/255;
    % jump (white)
      RGB_jump  = [253 253 253]/255;
    % other (white)
      RGB_other  = [250 250 250]/255;
      
  % min time step
    dt = 1 / p.fps * 0.5;
  
  % plot    
    hold off;
    for j = 1:length(time)
      % only if time is on
      if time(j) > 0
            if     CombinationCode(j) == -3 % other
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_other, 'EdgeColor', 'none');
            elseif CombinationCode(j) == -2 % jump
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_jump,  'EdgeColor', 'none');
            elseif CombinationCode(j) == -1 % 1-leg
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_1leg, 'EdgeColor', 'none');
            elseif CombinationCode(j) ==  0 % bound/hop
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_bound, 'EdgeColor', 'none');
            elseif CombinationCode(j) ==  1 % pace
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_pace,  'EdgeColor', 'none');
            elseif CombinationCode(j) ==  2 % trot
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_trot,  'EdgeColor', 'none');
            elseif CombinationCode(j) ==  3 % walk
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_walk,  'EdgeColor', 'none');
            elseif CombinationCode(j) ==  4 % four
              P = patch('Faces', [1 2 3 4], 'Vertices', [time(j)-dt 0; time(j)+dt 0; time(j)+dt 1; time(j)-dt 1], 'FaceColor', RGB_four,  'EdgeColor', 'none');
            end;
            hold on;
      end;
    end;

    hold off;
    axis tight;
    set(gca,'YTick', []);
    set(gca,'XTick', []);
    box on;
    set(gca,'LineWidth',2);
    
return;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plot_BODY_SPEED(time, BodySpeed, Xlim, p)

  % place body velocity with running average
    ind = find(time > 0 & BodySpeed ~= 0);
    plot(time(ind), smooth(BodySpeed(ind),6) / p.mm2pix,'--','color', [0 0 0], 'LineWidth', 2); 
    hold on;
%   % plot body velocity without smoothing too
%     plot(time(ind), smooth(BodySpeed(ind),3) / p.mm2pix,'--','color', [0.3 0.3 0.3], 'LineWidth', 0.5);
  % set up figure
    xlim(Xlim);
    xlabel('t [sec]');
    ylabel('Body speed [mm/s]')
    grid on;
    box on;
    set(gca,'LineWidth',2);
    set(gca,'FontSize', 14);    
    hold off;
        
return;

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plot_BODY_ACCELERATION(time, BodyAcceleration, Xlim, p)

  % place body velocity with running average
    ind = find(time > 0 & BodyAcceleration ~= 0);
    plot(time(ind), smooth(BodyAcceleration(ind),6) / p.mm2pix,'--','color', [0 0 0], 'LineWidth', 2); 
    hold on;
%   % plot body velocity without smoothing too
%     plot(time(ind), smooth(BodySpeed(ind),3) / p.mm2pix,'--','color', [0.3 0.3 0.3], 'LineWidth', 0.5);
  % set up figure
    xlim(Xlim);
    xlabel('t [sec]');
    ylabel('Body acceleration [mm/s^2]')
    grid on;
    box on;
    set(gca,'LineWidth',2);
    hold off;
        
return;

function WriteExcel(ExcelFileName, Data, SheetName)
% like xlswrite, but adopt to mac if necessary
  if ismac
    xlwrite(ExcelFileName, Data, SheetName);
  else
    xlswrite(ExcelFileName, Data, SheetName);
  end;
return;
