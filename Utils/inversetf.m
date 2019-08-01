function itfmat = inversetf(tfmat)
%INVERSETF Invert transformation matrix
%INPUT - tfmat - transformation matrix to be inverted
%OUTPUT - itfmat - inverted transformation matrix
itfmat = [tfmat(1:3,1:3)', -tfmat(1:3,1:3)'*tfmat(1:3,4); 0, 0, 0, 1];
end

