function PlotCenterAndDirection(Centroid, Orientation, p, Color)
% plot a central blob and a line giving the direction
    plot(Centroid(2)+sind(Orientation)*p.DirectionBarLength/2*[-1 1], Centroid(1)+cosd(Orientation)*p.DirectionBarLength/2*[-1 1], '-', 'Color', Color, 'LineWidth', p.DirectionBarWidth)
    plot(Centroid(2), Centroid(1), 'o', 'Color', Color, 'MarkerFaceColor', Color, 'MarkerSize', p.CentroidMarkerSize);
return;