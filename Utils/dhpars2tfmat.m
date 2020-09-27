function tfmat = dhpars2tfmat(dhpars)
%DHPARS2TFMAT Compute a transformation given by Denavit-Hartenberg parameters.
%INPUT - dhpars - (X,4) Denavit-Hartenberg parameters first line is first
%joint of a group and last line is an end effector
%OUTPUT - tfmat - transformation matrix from end effector to the first
%joint of group.
    s = size(dhpars,1);
    % reshape dh table to third dimension
    dhpars = reshape(dhpars', 1,6,s);
    as = dhpars(1,1,:);
    ds = dhpars(1,2,:);
    als = dhpars(1,4,:);
    ths = dhpars(1,6,:);
    cos_als = cos(als);
    sin_als = sin(als);
    cos_ths = cos(ths);
    sin_ths = sin(ths);
    %% DH transformation matrix without last row
    tf = [ cos_ths, -sin_ths.*cos_als,  sin_ths.*sin_als, cos_ths.*as;
        sin_ths,  cos_ths.*cos_als, -cos_ths.*sin_als, sin_ths.*as;
        zeros(1,1,s),        sin_als,           cos_als,          ds];
    %% unrolled matrix multiplication
    q11 = tf(1);
    q21 = tf(2);
    q31 = tf(3);
    q12 = tf(4);
    q22 = tf(5);
    q32 = tf(6);
    q13 = tf(7);
    q23 = tf(8);
    q33 = tf(9);
    q14 = tf(10);
    q24 = tf(11);
    q34 = tf(12);
    c = 1;
    for i = 2:s
        c = c + 12;
        t12 = q11*tf(c+3) + q12*tf(c+4) + q13*tf(c+5);
        t22 = q21*tf(c+3) + q22*tf(c+4) + q23*tf(c+5);
        t32 = q31*tf(c+3) + q32*tf(c+4) + q33*tf(c+5);
        q14 = q11*tf(c+9) + q12*tf(c+10) + q13*tf(c+11)+q14;
        q24 = q21*tf(c+9) + q22*tf(c+10) + q23*tf(c+11)+q24;
        q34 = q31*tf(c+9) + q32*tf(c+10) + q33*tf(c+11)+q34;
        q13 = q11*tf(c+6) + q12*tf(c+7) + q13*tf(c+8);
        q23 = q21*tf(c+6) + q22*tf(c+7) + q23*tf(c+8);
        q33 = q31*tf(c+6) + q32*tf(c+7) + q33*tf(c+8);
        q11 = q11*tf(c) + q12*tf(c+1);
        q21 = q21*tf(c) + q22*tf(c+1);
        q31 = q31*tf(c) + q32*tf(c+1);
        q12 = t12;
        q22 = t22;
        q32 = t32;
    end
    tfmat = [q11, q12, q13,q14; q21, q22, q23, q24; q31, q32, q33, q34; 0,0,0,1];
end
