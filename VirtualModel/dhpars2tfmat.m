function tfmat = dhpars2tfmat(dhpars)
%DHPARS2TFMAT Compute a transformation from end effector to base frame of a manipulator given by (4,X) Denavit-Hartenberg parameter matrix.

tfmat = eye(4);
as = dhpars(1,:);
ds = dhpars(2,:);
cos_als = cos(dhpars(3,:));
sin_als = sin(dhpars(3,:));
cos_ths = cos(dhpars(4,:));
sin_ths = sin(dhpars(4,:));

for i = 1:size(dhpars, 2)
    zi = [cos_ths(i), -sin_ths(i), 0,     0;
          sin_ths(i),  cos_ths(i), 0,     0;
                   0,           0, 1, ds(i);
                   0,           0, 0,     1];
               
    ai = [1,          0,           0, as(i);
          0, cos_als(i), -sin_als(i),     0;
          0, sin_als(i),  cos_als(i),     0;
          0,           0,          0,    1];
    tfmat = tfmat * zi * ai;
end
end

