function [ plane ] = getPlane( points )
%GETPLANE Compute a plane fitted to set of given points using svd.
%INPUT - points - (4,X) or (3,X) row vector of points
%OUTPUT - plane - fitted plane
    points = points(1:3,:);
    % compute centroid
    t = sum(points,2)/length(points);
    centered_points = points - t;
    [U,~,~] = svd(centered_points);
    plane = [U(:,3).' -t' * U(:,3)];
end

