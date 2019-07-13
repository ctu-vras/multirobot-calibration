function camera_points = projections(points, eyes, cameras)
%PROJECTIONS(points, eyes, cameras) Project points given by 4x4xN transformation 
%matrices array tfs to the cameras

dc = eyes.dist;
tdc = eyes.tandist;
mat = eyes.matrix(1:2,:,:);
cameras = cameras.*[1,2];
cameras = reshape(cameras',[],1);
cameras(cameras==0) = [];
x_ = points(1:2,:)./points(3,:);
r_sq = sum(x_.^2);

x_ = [x_.*((1 + dc(1,cameras).*r_sq + dc(2,cameras).*r_sq.^2 + dc(3,cameras).*r_sq.^3) ./ ...
        (1 + dc(4,cameras).*r_sq + dc(5,cameras).*r_sq.^2 + dc(6,cameras).*r_sq.^3)) ...
        + [2*tdc(1,cameras).*x_(1,:).*x_(2,:) + tdc(2,cameras).*(r_sq + 2*x_(1,:).^2);...
        tdc(1,cameras).*(r_sq + 2*x_(2,:).^2) + 2*tdc(2,cameras).*x_(1,:).*x_(2,:)]; ...
        ones(1,size(points,2))];

camera_points = squeeze(sum(mat(:,:,cameras).*reshape(x_,1,3,[]),2));
end
