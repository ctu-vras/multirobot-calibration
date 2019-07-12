function [ output_args ] = plot_projections(points, points2, plot_title, legends )
%PLOT_PROJECTIONS Summary of this function goes here
%   Detailed explanation goes here
size(points2)
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
title(plot_title)
end

