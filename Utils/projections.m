function camera_points = projections(points, eyes, cameras)
%PROJECTIONS Project points to the cameras
% Project points given by 4x4xN transformation matrices array tfs to the cameras
%INPUT - points - jacobian obtained via optimization process
%      - eyes - cameras intrinsic parameters (dist coeffs and camera matrix)
%      - cameras - number of poses in poses set
%OUTPUT - camera_points - row vector of projection coords (u,v)
    dc = eyes.dist; % radial distortion coeffs
    tdc = eyes.tandist; % tangential distortion coeffs
    mat = eyes.matrix(1:2,:,:); % camera matrix
    cameras = cameras.*[1,2]; % convert logical array to array of used cameras
    cameras = reshape(cameras',[],1);
    cameras(cameras==0) = [];

    %% compute distorted coords
    x_ = points(1:2,:)./points(3,:);
    r_sq = sum(x_.^2);
    x_ = [x_.*((1 + dc(1,cameras).*r_sq + dc(2,cameras).*r_sq.^2 + dc(3,cameras).*r_sq.^3) ./ ...
            (1 + dc(4,cameras).*r_sq + dc(5,cameras).*r_sq.^2 + dc(6,cameras).*r_sq.^3)) ...
            + [2*tdc(1,cameras).*x_(1,:).*x_(2,:) + tdc(2,cameras).*(r_sq + 2*x_(1,:).^2);...
            tdc(1,cameras).*(r_sq + 2*x_(2,:).^2) + 2*tdc(2,cameras).*x_(1,:).*x_(2,:)]; ...
            ones(1,size(points,2))];
    %% compute the projection from distorted coords
    camera_points = squeeze(sum(mat(:,:,cameras).*reshape(x_,1,3,[]),2));
end
