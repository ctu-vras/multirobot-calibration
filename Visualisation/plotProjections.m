function plotProjections(points, points2, plotTitle, legends )
%PLOTPROJECTIONS Function for plotting projections
%INPUT - points - Nx2 vector of points
%      - points2 - Nx2 or Nx4 vector of points or pair of points
%      - plotTitle - plot title
%      - legends - cell array of legend labels
    if(~isempty(points))
    scatter(points(1:2:end,1), points(1:2:end,2), 'filled', 'b');
    hold on;
    end
    if(~isempty(points2))
    scatter(points2(1:2:end,1), points2(1:2:end,2), 'filled', 'r');
    hold on;
    if(size(points2,2) > 2)
    scatter(points2(1:2:end,3), points2(1:2:end,4), 'filled', 'g');
    end
    end
    grid on;
    legend(legends,'Location','east');
    title(plotTitle)
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
end

