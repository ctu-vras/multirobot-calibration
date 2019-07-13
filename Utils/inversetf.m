function itfmat = inversetf(tfmat)
%INVERSETF Invert transformation matrix tfmat
itfmat = [tfmat(1:3,1:3)', -tfmat(1:3,1:3)'*tfmat(1:3,4); 0, 0, 0, 1];
end

