function PlotFeet(MouseIndex, N, v, p)
% plot feet for a given mouse

% plot
  % The commented region plots rectangles around the feet.
  %   p.minFootPlotSize = 30;
  %   p.FootPlotRectangleDivision = 2;
  %   D = p.FootPlotRectangleDivision;
  if v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1) ~= -1
    plot(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
    text(v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2)+p.MaxFingerDistance,v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'RF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
%     minY = min(v.MouseTrack.LegRF.FootMinY{MouseIndex}(N),v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2)-p.minFootPlotSize/2);
%     minX = min(v.MouseTrack.LegRF.FootMinX{MouseIndex}(N),v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1)-p.minFootPlotSize/2);
%     maxY = max(v.MouseTrack.LegRF.FootMaxY{MouseIndex}(N),v.MouseTrack.LegRF.Centroid{MouseIndex}(N,2)+p.minFootPlotSize/2);
%     maxX = max(v.MouseTrack.LegRF.FootMaxX{MouseIndex}(N),v.MouseTrack.LegRF.Centroid{MouseIndex}(N,1)+p.minFootPlotSize/2);
%     plot([minY minY minY+(maxY-minY)/D], [minX+(maxX-minX)/D minX minX],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY-(maxY-minY)/D maxY maxY], [minX minX minX+(maxX-minX)/3],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY maxY maxY-(maxY-minY)/D], [maxX-(maxX-minX)/D maxX maxX],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([minY+(maxY-minY)/D minY minY], [maxX maxX maxX-(maxX-minX)/D],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     text(maxY+3,minX-3,'RF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
  end;
  if v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1) ~= -1
    plot(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
    text(v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2)-p.MaxFingerDistance,v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'RH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
%     minY = min(v.MouseTrack.LegRH.FootMinY{MouseIndex}(N),v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2)-p.minFootPlotSize/2);
%     minX = min(v.MouseTrack.LegRH.FootMinX{MouseIndex}(N),v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1)-p.minFootPlotSize/2);
%     maxY = max(v.MouseTrack.LegRH.FootMaxY{MouseIndex}(N),v.MouseTrack.LegRH.Centroid{MouseIndex}(N,2)+p.minFootPlotSize/2);
%     maxX = max(v.MouseTrack.LegRH.FootMaxX{MouseIndex}(N),v.MouseTrack.LegRH.Centroid{MouseIndex}(N,1)+p.minFootPlotSize/2);
%     plot([minY minY minY+(maxY-minY)/3], [minX+(maxX-minX)/D minX minX],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY-(maxY-minY)/D maxY maxY], [minX minX minX+(maxX-minX)/D],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY maxY maxY-(maxY-minY)/D], [maxX-(maxX-minX)/D maxX maxX],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([minY+(maxY-minY)/D minY minY], [maxX maxX maxX-(maxX-minX)/D],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     text(maxY+3,minX-3,'RH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
  end;
  if v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1) ~= -1
    plot(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2),   v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
    text(v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2)+p.MaxFingerDistance,v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'LF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
%     minY = min(v.MouseTrack.LegLF.FootMinY{MouseIndex}(N),v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2)-p.minFootPlotSize/2);
%     minX = min(v.MouseTrack.LegLF.FootMinX{MouseIndex}(N),v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1)-p.minFootPlotSize/2);
%     maxY = max(v.MouseTrack.LegLF.FootMaxY{MouseIndex}(N),v.MouseTrack.LegLF.Centroid{MouseIndex}(N,2)+p.minFootPlotSize/2);
%     maxX = max(v.MouseTrack.LegLF.FootMaxX{MouseIndex}(N),v.MouseTrack.LegLF.Centroid{MouseIndex}(N,1)+p.minFootPlotSize/2);
%     plot([minY minY minY+(maxY-minY)/D], [minX+(maxX-minX)/D minX minX],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY-(maxY-minY)/D maxY maxY], [minX minX minX+(maxX-minX)/D],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY maxY maxY-(maxY-minY)/D], [maxX-(maxX-minX)/D maxX maxX],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([minY+(maxY-minY)/D minY minY], [maxX maxX maxX-(maxX-minX)/D],'-', 'Color', p.colorFront, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     text(maxY+3,minX-3,'LF', 'Color', p.colorFront, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
  end;
  if v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1) ~= -1
    plot(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2),v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1),'o', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
    text(v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2)-p.MaxFingerDistance,v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1)-p.MaxFingerDistance,'LH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize,'HorizontalAlignment','center'); 
%     minY = min(v.MouseTrack.LegLH.FootMinY{MouseIndex}(N),v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2)-p.minFootPlotSize/2);
%     minX = min(v.MouseTrack.LegLH.FootMinX{MouseIndex}(N),v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1)-p.minFootPlotSize/2);
%     maxY = max(v.MouseTrack.LegLH.FootMaxY{MouseIndex}(N),v.MouseTrack.LegLH.Centroid{MouseIndex}(N,2)+p.minFootPlotSize/2);
%     maxX = max(v.MouseTrack.LegLH.FootMaxX{MouseIndex}(N),v.MouseTrack.LegLH.Centroid{MouseIndex}(N,1)+p.minFootPlotSize/2);
%     plot([minY minY minY+(maxY-minY)/D], [minX+(maxX-minX)/D minX minX],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY-(maxY-minY)/D maxY maxY], [minX minX minX+(maxX-minX)/D],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([maxY maxY maxY-(maxY-minY)/D], [maxX-(maxX-minX)/D maxX maxX],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     plot([minY+(maxY-minY)/D minY minY], [maxX maxX maxX-(maxX-minX)/D],'-', 'Color', p.colorHind, 'LineWidth', 2, 'MarkerSize', p.FootMarkerSize); 
%     text(maxY+3,minX-3,'LH', 'Color', p.colorHind, 'LineWidth', 2, 'FontSize', p.FootFontSize); 
  end;



return;