function handles = SavePictures(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function handles = SavePictures(handles)
%
% save pictures to file.
%
% (c) Imre Bartos 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('export_fig');

% define colors for different legs and body points
  ColorLF = [ 32 178 170]/255;
  ColorLH = [  0   0 205]/255;
  ColorRF = [255  69   0]/255;
  ColorRH = [34  139  34]/255;
  if handles.p.body.threshold.low > 200 & handles.p.WhatToPlot == 1
    ColorBodyDirections = [0 0 0];
  else
    ColorBodyDirections = [1 1 1];
  end;
  
% if no data was loaded then quit
  if isfield(handles,'v')
    % save to local variables
      v = handles.v;
      p = handles.p;
    % determine status of picture togglebutton
      ButtonStatus = get(handles.picture_togglebutton,'Value');
    % start saving pictures if button is toggled down
      if ButtonStatus == 1
          S = size(v.pic.R);
          W = S(1);
          H = S(2);
          % cange button name to indicate that function is running
            set(handles.picture_togglebutton,'string','cancel','BackgroundColor',[240 200 200]/255);
          FrameNumber  = str2num(get(handles.frame_edit,'String'));
          i = FrameNumber;
          % identify mouse sizes
            for MouseIndex = 1:v.MouseTrack.NumberOfMice
              % make imagesize somewhat bigger than the max tail-nose distance
                ind = find(v.MouseTrack.Tail{MouseIndex}(:,1) ~= -1 & v.MouseTrack.Nose{MouseIndex}(:,1) ~= -1 & v.MouseTrack.TrackIndex{MouseIndex}' ~= -1);
                if ~isempty(ind)
                  ImageSize(MouseIndex) = round(1.5*sqrt(max((v.MouseTrack.Tail{MouseIndex}(ind,1) - v.MouseTrack.Nose{MouseIndex}(ind,1)).^2 + (v.MouseTrack.Tail{MouseIndex}(ind,2) - v.MouseTrack.Nose{MouseIndex}(ind,2)).^2))/2)*2;
                else
                  ImageSize(MouseIndex) = -1;
                end;
            end;

          while i <= length(p.FileList) && ButtonStatus == 1
              % save full image
                h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 H W]);
                axes('position', [0 0 1 1]);                
                set(handles.frame_edit,'String',num2str(i));
                handles = PlotMouse(handles);
                v = handles.v;
                p = handles.p;
                % FrameNumber  = str2num(get(handles.frame_edit,'String'));
                outputfilename = [AddSlash(p.outputFolderName) 'Images/image' sprintf('%05d',i) '.jpg'];
                saveas(h,outputfilename);
%                 export_fig(outputfilename);
                close(h);
              % SAVE ONLY SURROUNDING OF MOUSE
                for MouseIndex = 1:0%v.MouseTrack.NumberOfMice
                  % find if there is any track with the current frameindex
                    N = find(v.MouseTrack.TrackIndex{MouseIndex} == i);
                  if ~isempty(N)
                    % create figure
                      h = figure('visible','off','PaperPositionMode', 'manual', 'PaperUnits', 'points', 'PaperPosition', [0 0 ImageSize(MouseIndex) ImageSize(MouseIndex)]);                  
                      axes('position', [0 0 1 1]);
                    % find indices corresponding to small image edges.
                      BodyX = v.MouseTrack.BodyCentroid{MouseIndex}(N,1);
                      BodyY = v.MouseTrack.BodyCentroid{MouseIndex}(N,2);
                      Xmin = round(BodyX - ImageSize(MouseIndex)/2);
                      Xmax = round(BodyX + ImageSize(MouseIndex)/2);
                      Ymin = round(BodyY - ImageSize(MouseIndex)/2);
                      Ymax = round(BodyY + ImageSize(MouseIndex)/2);
                    % calculate part of indices that are within actual image
                      Xminallowed = max(1, Xmin);
                      Xmaxallowed = min(W, Xmax);
                      Yminallowed = max(1, Ymin);
                      Ymaxallowed = min(H, Ymax);
                    % calculate how much the image has to be offset because of the difference between allowed and actual XYmin 
                      Xoffset = Xminallowed - Xmin;
                      Yoffset = Yminallowed - Ymin;
                      Xreduction = Xmax - Xmaxallowed;
                      Yreduction = Ymax - Ymaxallowed;
                    % create sub-image around mouse
                       % original + bleeding area ( + ImageSize(MouseIndex)/2 on each side 
                         PicRGB = zeros(ImageSize(MouseIndex)+1,ImageSize(MouseIndex)+1,3);
                         size(1+Xoffset:ImageSize(MouseIndex)+1-Xreduction)
                         size(1+Yoffset:ImageSize(MouseIndex)+1-Yreduction)
                         size(Xminallowed:Xmaxallowed)
                         size(Yminallowed:Ymaxallowed)
                         PicRGB(1+Xoffset:ImageSize(MouseIndex)+1-Xreduction,1+Yoffset:ImageSize(MouseIndex)+1-Yreduction,1) = v.pic.R(Xminallowed:Xmaxallowed,Yminallowed:Ymaxallowed);
                         PicRGB(1+Xoffset:ImageSize(MouseIndex)+1-Xreduction,1+Yoffset:ImageSize(MouseIndex)+1-Yreduction,2) = v.pic.G(Xminallowed:Xmaxallowed,Yminallowed:Ymaxallowed);
                         PicRGB(1+Xoffset:ImageSize(MouseIndex)+1-Xreduction,1+Yoffset:ImageSize(MouseIndex)+1-Yreduction,3) = v.pic.B(Xminallowed:Xmaxallowed,Yminallowed:Ymaxallowed);
                         image(PicRGB/256);
                         hold on;
                         axis off;
                       % plot mouse tracks
                        % plot head center if set
                          if p.PlotHeadCenter == 1, PlotCenterAndDirection(v.MouseTrack.HeadCentroid{MouseIndex}(N,:) - [Xmin Ymin], v.MouseTrack.HeadOrientation{MouseIndex}(N), p, ColorBodyDirections); end;
                          hold on;
                        % plot body center if set
                          if p.PlotBodyCenter == 1, PlotCenterAndDirection(v.MouseTrack.BodyCentroid{MouseIndex}(N,:) - [Xmin Ymin], v.MouseTrack.BodyOrientation{MouseIndex}(N), p, ColorBodyDirections); end;
                        % plot body back center if set
                          if p.PlotBodyBackCenter == 1, PlotCenterAndDirection(v.MouseTrack.BodyBackCentroid{MouseIndex}(N,:) - [Xmin Ymin], v.MouseTrack.BodyBackOrientation{MouseIndex}(N), p, ColorBodyDirections); end;
                        % plot tail1-3 center if set
                          if p.PlotTail1Center == 1, PlotCenterAndDirection(v.MouseTrack.Tail1Centroid{MouseIndex}(N,:) - [Xmin Ymin], v.MouseTrack.Tail1Orientation{MouseIndex}(N), p, ColorBodyDirections); end;
                          if p.PlotTail2Center == 1, PlotCenterAndDirection(v.MouseTrack.Tail2Centroid{MouseIndex}(N,:) - [Xmin Ymin], v.MouseTrack.Tail2Orientation{MouseIndex}(N), p, ColorBodyDirections); end;
                          if p.PlotTail3Center == 1, PlotCenterAndDirection(v.MouseTrack.Tail3Centroid{MouseIndex}(N,:) - [Xmin Ymin], v.MouseTrack.Tail3Orientation{MouseIndex}(N), p, ColorBodyDirections); end;
                        % plot head contour
                          if p.PlotHeadContour == 1, plot([cell2mat(v.MouseTrack.HeadContourY{MouseIndex}(N))] - Ymin, [cell2mat(v.MouseTrack.HeadContourX{MouseIndex}(N))] - Xmin, 'b--', 'LineWidth', p.ContourLineWidth); end;
                        % plot tail contour
                          if p.PlotTailContour == 1, plot([cell2mat(v.MouseTrack.TailContourY{MouseIndex}(N))] - Ymin, [cell2mat(v.MouseTrack.TailContourX{MouseIndex}(N))] - Xmin, 'g--', 'LineWidth', p.ContourLineWidth); end;
                        % plot feet
                          if p.PlotFeet == 1
                            % plot
                              if v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) ~= -1
                                plot(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2) - Ymin,   v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) - Xmin,'o', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
                                text(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2)+17 - Ymin,v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1)-17 - Xmin,'RF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
                                % plot line of this step cycle
                                  maxj = 0;
                                  j = 1;
                                  while j > 0
                                    if N-j > 0 & v.MouseTrack.LegRF.Centroid{MouseIndex}(N - j,2) > 0 & v.MouseTrack.BodyCentroid{MouseIndex}(N - j,1) > 0
                                      maxj = j;
                                      j = j + 1;
                                    else
                                      j = 0;
                                    end;
                                    % introduce cutoff at j=10
                                      j = mod(j,10);                                    
                                  end;
                                  % plot lines if step cycle longer than 1
                                    if maxj > 0
                                      plot(v.MouseTrack.LegRF.Centroid{MouseIndex}(N-maxj:N,2) - Ymin + v.MouseTrack.BodyCentroid{MouseIndex}(N,2) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,2),   v.MouseTrack.LegRF.Centroid{MouseIndex}(N-maxj:N,1) - Xmin + v.MouseTrack.BodyCentroid{MouseIndex}(N,1) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,1),'-', 'Color', ColorRF, 'LineWidth', 3);                                       
                                    end;
                              end;
                              if v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) ~= -1
                                plot(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2) - Ymin,   v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) - Xmin,'o', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
                                text(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2)+17 - Ymin,v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1)-17 - Xmin,'RH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
                                % plot line of this step cycle
                                  maxj = 0;
                                  j = 1;
                                  while j > 0
                                    if N-j > 0 & v.MouseTrack.LegRH.Centroid{MouseIndex}(N - j,2) > 0 & v.MouseTrack.BodyCentroid{MouseIndex}(N - j,1) > 0
                                      maxj = j;
                                      j = j + 1;
                                    else
                                      j = 0;
                                    end;
                                    % introduce cutoff at j=10
                                      j = mod(j,10);                                    
                                  end;
                                  % plot lines if step cycle longer than 1
                                    if maxj > 0
                                      plot(v.MouseTrack.LegRH.Centroid{MouseIndex}(N-maxj:N,2) - Ymin + v.MouseTrack.BodyCentroid{MouseIndex}(N,2) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,2),   v.MouseTrack.LegRH.Centroid{MouseIndex}(N-maxj:N,1) - Xmin + v.MouseTrack.BodyCentroid{MouseIndex}(N,1) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,1),'-', 'Color', ColorRF, 'LineWidth', 3);                                       
                                    end;                                
                              end;
                              if v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) ~= -1
                                plot(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2) - Ymin,   v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) - Xmin,'o', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
                                text(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2)+17 - Ymin,v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1)-17 - Xmin,'LF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
                                % plot line of this step cycle
                                  maxj = 0;
                                  j = 1;
                                  while j > 0
                                    if N-j > 0 & v.MouseTrack.LegLF.Centroid{MouseIndex}(N - j,2) > 0 & v.MouseTrack.BodyCentroid{MouseIndex}(N - j,1) > 0
                                      maxj = j;
                                      j = j + 1;
                                    else
                                      j = 0;
                                    end;
                                    % introduce cutoff at j=10
                                      j = mod(j,10);                                    
                                  end;
                                  % plot lines if step cycle longer than 1
                                    if maxj > 0
                                      plot(v.MouseTrack.LegLF.Centroid{MouseIndex}(N-maxj:N,2) - Ymin + v.MouseTrack.BodyCentroid{MouseIndex}(N,2) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,2),   v.MouseTrack.LegLF.Centroid{MouseIndex}(N-maxj:N,1) - Xmin + v.MouseTrack.BodyCentroid{MouseIndex}(N,1) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,1),'-', 'Color', ColorRF, 'LineWidth', 3);                                       
                                    end;                                
                              end;
                              if v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) ~= -1
                                plot(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2) - Ymin,v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) - Xmin,'o', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
                                text(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2)+17 - Ymin,v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1)-17 - Xmin,'LH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
                                % plot line of this step cycle
                                  maxj = 0;
                                  j = 1;
                                  while j > 0
                                    if N-j > 0 & v.MouseTrack.LegLH.Centroid{MouseIndex}(N - j,2) > 0 & v.MouseTrack.BodyCentroid{MouseIndex}(N - j,1) > 0
                                      maxj = j;
                                      j = j + 1;
                                    else
                                      j = 0;
                                    end;
                                    % introduce cutoff at j=10
                                      j = mod(j,10);
                                  end;
                                  % plot lines if step cycle longer than 1
                                    if maxj > 0
                                      plot(v.MouseTrack.LegLH.Centroid{MouseIndex}(N-maxj:N,2) - Ymin + v.MouseTrack.BodyCentroid{MouseIndex}(N,2) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,2),   v.MouseTrack.LegLH.Centroid{MouseIndex}(N-maxj:N,1) - Xmin + v.MouseTrack.BodyCentroid{MouseIndex}(N,1) - v.MouseTrack.BodyCentroid{MouseIndex}(N-maxj:N,1),'-', 'Color', ColorRF, 'LineWidth', 3);                                       
                                    end;                                
                              end;
                          end;
                        % plot nose if set -- put to the end so it shows up on top
                          if p.PlotNose == 1, plot(v.MouseTrack.Nose{MouseIndex}(N,2) - Ymin, v.MouseTrack.Nose{MouseIndex}(N,1) - Xmin, 'rd', 'LineWidth', 2); end;                                   
                    % save
                      imageFolderName = [AddSlash(p.outputFolderName) 'Images/Mouse_' num2str(MouseIndex)];
                      % create Images folder if it doesn't exist
                        DoesFolderExist = exist(imageFolderName);
                        if DoesFolderExist ~= 7
                            mkdir(imageFolderName);
                        end;
                      outputfilename = [imageFolderName '/image_mouse_' num2str(MouseIndex) '_' sprintf('%05d',i) '.jpg'];
                      saveas(h,outputfilename);
                      close(h);
                  end;
                end;
              % next
                i = i + 1;
                ButtonStatus = get(handles.picture_togglebutton,'Value');
          end;
      end;
    % redraw frame when finished saving pics so we jump to last picture
      handles = PlotMouse(handles);
  end;
  % make sure that after the analysis the toggle button is up and has the right text
    set(handles.picture_togglebutton,'Value',0);
    set(handles.picture_togglebutton,'string','picture','BackgroundColor', [240 240 240]/255);

    
return;