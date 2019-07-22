function tfmat = dhpars2tfmat(dhpars)
%DHPARS2TFMAT Compute a transformation from end effector to base frame of a manipulator given by (4,X) Denavit-Hartenberg parameter matrix.

tfmat = eye(4);
as = dhpars(:,1);
ds = dhpars(:,2);
cos_als = cos(dhpars(:,3));
sin_als = sin(dhpars(:,3));
cos_ths = cos(dhpars(:,4));
sin_ths = sin(dhpars(:,4));

for i = 1:size(dhpars, 1)
    tf = [ cos_ths(i), -sin_ths(i)*cos_als(i),  sin_ths(i)*sin_als(i), cos_ths(i)*as(i);
           sin_ths(i),  cos_ths(i)*cos_als(i), -cos_ths(i)*sin_als(i), sin_ths(i)*as(i);
                    0,             sin_als(i),             cos_als(i),            ds(i);
                    0,                    0,                    0,                   1];
    tfmat = tfmat * tf;
end
end

