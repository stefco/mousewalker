function TESTmouse()


% just for testing

% initialize
  [v, p] = Initialization();

% define frame input folder
  p.inputFolderName = 'C:/Documents/Mouse/Mouse Tracker/Videos/04-12-1315-47-37.409';

% determine list of files in input folder p.inputFolderName 
  p.FileList = [LS([p.inputFolderName '/*.jpg']); LS([p.inputFolderName '/*.png']); LS([p.inputFolderName '/*.bmp']); LS([p.inputFolderName '/*.tif']); LS([p.inputFolderName '/*.jpeg'])];


% calculate background for filter
  [p.DPM, p.picAVG, p.picSTD] = Masks(p);      

  
% loop over frames  
for i = 37:70%length(p.FileList(:,1))  
  disp(['i = ' num2str(i)])
  
% frameindex - index of file in the framelist
  p.FrameIndex = i;
% increment time
  v.time = p.FrameIndex * 1/p.fps;
% read in mouse pic
  v.pic = PictureReader(p.FrameIndex, p);

% subtract background
  v = FilterImage(v,p);

%    figure(1)
%    PIC = v.pic.filtered.G;
%    PIC(PIC < p.foot.threshold.low) = 0;
%    PIC(PIC > p.foot.threshold.high) = 0;
%   imagesc(PIC);
  
% Find feet  
  [v] = FindMouseFeet(v,p);
  
% Find body
  [v] = FindMouseBody(v,p);
  
% Connect body with feet
  [v] = TrackMice(v,p); 

% % plot image with recovered parameters specified in settings
%   PlotMouse(v,p);

end;

% save results
  SaveResults(v,p);

% % Evaluate results
%   MouseEvaluate(v,p);


return;
%% plot  



% plot  
  figure(3);
  image(v.pic.foot);
  colorbar;
  colormap(p.color);
  hold on;
  for i = 1:v.foot.NumberOfObjects
    if v.foot.PartOfFoot(i) == 1
      plot(v.foot.FingerCentroid{i}(2), v.foot.FingerCentroid{i}(1),'wx', 'LineWidth', 2, 'MarkerSize', 8);
    end;
  end;
  for i  = 1:length(v.foot.Boundary)
      plot(v.foot.Boundary{i}(:,2), v.foot.Boundary{i}(:,1), 'm', 'LineWidth', 2)
  end;
  hold off;



figure(2);
image(v.pic.body);
colorbar;
colormap(p.color);
hold on;
  for i = 1 : v.body.NumberOfObjects
% plot(v.body.Boundary{i}(:,2), v.body.Boundary{i}(:,1), 'w', 'LineWidth', 2);
% plot(v.body.Boundary{i}(1:v.body.indtail{i}-1,2), v.body.Boundary{i}(1:v.body.indtail{i}-1,1), 'c', 'LineWidth', 2);
% plot(v.body.Boundary{i}(v.body.indtail{i}:end,2), v.body.Boundary{i}(v.body.indtail{i}:end,1), 'c', 'LineWidth', 2);

% plot(v.body.Boundary{i}(v.body.indnose{i},2), v.body.Boundary{i}(v.body.indnose{i},1), 'rd', 'LineWidth', 2, 'MarkerSize', 8);
% plot(v.body.Boundary{i}(v.body.indtail{i},2), v.body.Boundary{i}(v.body.indtail{i},1), 'ro', 'LineWidth', 2, 'MarkerSize', 8);
% for j = 1:3:length(v.body.Boundary{i})
%   plot([v.body.Boundary{i}(j,2) v.body.Boundary{i}(v.body.indOpposite{i}(j),2)], [v.body.Boundary{i}(j,1) v.body.Boundary{i}(v.body.indOpposite{i}(j),1)]);
% end;
%     plot(indysmototh{i}, indxsmooth{i}, 'w', 'LineWidth', 2);
%     plot(indSide1y{i}, indSide1x{i}, 'g', 'LineWidth', 2);
%     plot(B{i}(indhead{i},2),  B{i}(indhead{i},1), 'd', 'LineWidth', 2)
%     plot(B{i}(indtail{i},2), B{i}(indtail{i},1), 'go', 'LineWidth', 2)
%     for j=1:length(indSide1x{i})
%       plot([indSide1y{i}(j) indSide2y{i}(indOpposite1improved{i}(j))], [indSide1x{i}(j) indSide2x{i}(indOpposite1improved{i}(j))], 'b', 'LineWidth', 2);
%     end;
%     plot(BodyHalfWayLineY{i},BodyHalfWayLineX{i},'w', 'LineWidth', 1);
%     plot(BodyHalfWayLineY2{i},BodyHalfWayLineX2{i},'g', 'LineWidth', 3);
% plot([indSide2y{i}(indOpposite1improved{i}(indTailEnd{i})) - indSide1y{i}(indTailEnd{i})], [indSide2x{i}(indOpposite1improved{i}(indTailEnd{i})) - indSide1x{i}(indTailEnd{i})])
if length(v.body.indTail{i}) > 0
%   % midline of tail
%     plot(v.body.TailHalfWayLineY{i}, v.body.TailHalfWayLineX{i}, 'w', 'LineWidth', 2);
  % boundary of tail  
    plot([v.body.Boundary{i}(v.body.indTail{i},2); v.body.Boundary{i}(v.body.indTail{i}(1),2)], [v.body.Boundary{i}(v.body.indTail{i},1); v.body.Boundary{i}(v.body.indTail{i}(1),1)], 'g--', 'LineWidth', 2);
end;
if length(v.body.HeadSide{i}) > 0
  % boundary of head
    plot([v.body.HeadSide{i}(:,2); v.body.HeadSide{i}(1,2)], [v.body.HeadSide{i}(:,1); v.body.HeadSide{i}(1,1)], 'b--', 'LineWidth', 2);
end;
if ~isempty(v.body.BodyCentroid{i})
  % body direction
    plot(v.body.BodyCentroid{i}(2)+cosd(mod(v.body.BodyOrientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], v.body.BodyCentroid{i}(1)+sind(mod(v.body.BodyOrientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], 'w', 'LineWidth', 2)
    plot(v.body.BodyCentroid{i}(2), v.body.BodyCentroid{i}(1), 'wo', 'MarkerFaceColor', 'w', 'MarkerSize', 8);
  % body back direction
    plot(v.body.BodyBackCentroid{i}(2)+cosd(mod(v.body.BodyBackOrientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], v.body.BodyBackCentroid{i}(:,1)+sind(mod(v.body.BodyBackOrientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], 'w', 'LineWidth', 2)
    plot(v.body.BodyBackCentroid{i}(2), v.body.BodyBackCentroid{i}(1), 'wo', 'MarkerFaceColor', 'w');
end;
% head direction
  plot(v.body.HeadCentroid{i}(:,2)+cosd(mod(v.body.HeadOrientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], v.body.HeadCentroid{i}(:,1)+sind(mod(v.body.HeadOrientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], 'w', 'LineWidth', 2);
  plot(v.body.HeadCentroid{i}(:,2), v.body.HeadCentroid{i}(:,1), 'wo', 'MarkerFaceColor', 'w');
if length(v.body.indTail{i}) > 2
  % tail directions
%   bbb = v.body.Tail1Centroid{i}
  plot(v.body.Tail1Centroid{i}(:,2)+cosd(mod(v.body.Tail1Orientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], v.body.Tail1Centroid{i}(:,1)+sind(mod(v.body.Tail1Orientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], 'w', 'LineWidth', 2);
  plot(v.body.Tail1Centroid{i}(:,2), v.body.Tail1Centroid{i}(:,1), 'wo', 'MarkerFaceColor', 'w');
  plot(v.body.Tail2Centroid{i}(:,2)+cosd(mod(v.body.Tail2Orientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], v.body.Tail2Centroid{i}(:,1)+sind(mod(v.body.Tail2Orientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], 'w', 'LineWidth', 2);
  plot(v.body.Tail2Centroid{i}(:,2), v.body.Tail2Centroid{i}(:,1), 'wo', 'MarkerFaceColor', 'w');
  plot(v.body.Tail3Centroid{i}(:,2)+cosd(mod(v.body.Tail3Orientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], v.body.Tail3Centroid{i}(:,1)+sind(mod(v.body.Tail3Orientation{i}+720,180))*p.DirectionBarLength/2*[-1 1], 'w', 'LineWidth', 2);
  plot(v.body.Tail3Centroid{i}(:,2), v.body.Tail3Centroid{i}(:,1), 'wo', 'MarkerFaceColor', 'w');  
end;
  end;
hold off;

% % find contrast lines
%   [~, threshold] = edge(PIC, 'sobel');
%   fudgeFactor = 0.5;
%   BWs = edge(PIC,'sobel', threshold * fudgeFactor);
% 
% % delineate
%   se90 = strel('line', 3, 90);
%   se0 = strel('line', 3, 0);
%   BWsdil = imdilate(BWs, [se90 se0]);
% 
% % fill interior gaps
%   BWdfill = imfill(BWsdil, 'holes');
% 
% % smooth object
%   seD = strel('diamond',1);
%   BWfinal = imerode(BWdfill,seD);
%   BWfinal = imerode(BWfinal,seD);
%   
% % find outline
%   BWoutline = bwperim(BWfinal);
%   Segout = PIC*0;
%   Segout(BWoutline) = 255;
%   figure(6), imshow(Segout), title('outlined original image');



return;

%%
function [X Y] = calculateEllipse(x, y, a, b, angle, steps)
% from http://stackoverflow.com/questions/2153768/draw-ellipse-and-ellipsoid-in-matlab  
    %# This functions returns points to draw an ellipse
    %#
    %#  @param x     X coordinate
    %#  @param y     Y coordinate
    %#  @param a     Semimajor axis
    %#  @param b     Semiminor axis
    %#  @param angle Angle of the ellipse (in degrees)
    %#

    error(nargchk(5, 6, nargin));
    if nargin<6, steps = 36; end

    beta = -angle * (pi / 180);
    sinbeta = sin(beta);
    cosbeta = cos(beta);

    alpha = linspace(0, 360, steps)' .* (pi / 180);
    sinalpha = sin(alpha);
    cosalpha = cos(alpha);

    X = x + (a * cosalpha * cosbeta - b * sinalpha * sinbeta);
    Y = y + (a * cosalpha * sinbeta + b * sinalpha * cosbeta);

    if nargout==1, X = [X Y]; end
return;
