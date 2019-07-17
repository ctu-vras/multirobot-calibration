function [ plane ] = getPlane( points )
%GETPLANE Summary of this function goes here
%   Detailed explanation goes here
    points = points(1:3,:);
    t = sum(points,2)/length(points);
    centered_points = points - t;
    [U,~,~] = svd(centered_points);
    plane = [U(:,3).' -t' * U(:,3)];
end

