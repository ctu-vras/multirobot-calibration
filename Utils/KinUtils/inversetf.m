function itfmat = inversetf(tfmat)
%INVERSETF Invert transformation matrix
%INPUT - tfmat - transformation matrix to be inverted
%OUTPUT - itfmat - inverted transformation matrix
    size3 = size(tfmat,3);
    if(size3 == 1)
        itfmat = [tfmat(1:3,1:3)', -tfmat(1:3,1:3)'*tfmat(1:3,4); 0, 0, 0, 1];
    else
        itfmat = [permute(tfmat(1:3,1:3,:),[2,1,3]), -reshape(squeeze(sum(permute(tfmat(1:3,1:3,:),[2,1,3]).*reshape(tfmat(1:3,4,:),1,3,size3),2)),3,1,size3); zeros(1,3,size3), ones(1,1,size3)];
    end
end

