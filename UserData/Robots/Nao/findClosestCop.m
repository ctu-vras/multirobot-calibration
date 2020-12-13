function [ minCop1, minCop2, difs, actMin ] = findClosestCop(cops1,cops2 )
    % FINDCLOSESTCOP returns one COP on each chain with lowest Euclidean
    %   distance between them
    %   INPUT - cops1, cops2 - Nx3 array of COP (N does not have to the same for both)
    %   OUTPUT - minCop1, minCop2 - 1x3 array
    %          - actMin - double distance between COPs
    %          - difs - 1x3 array with distances in each coordinate (x,y,z)
    
    %Variables init
    actMin=inf;
    minCop1=zeros(1,3);
    minCop2=zeros(1,3);
    minId1=0;
    minId2=0;
    difs=zeros(1,3);
    %Iterate over all cops on chain1
    for i=1:size(cops1,1)
       cop1=cops1(i,:);
       %iterate over all cops on chain2
       for j=1:size(cops2,1)
           cop2=cops2(j,:);
           %find distance between them
           if norm(cop1-cop2,2)<actMin
              %if distance is lower than 'actMin', update variables
              actMin(:)=norm(cop1-cop2,2);
              minCop1(:)=cop1;
              minCop2(:)=cop2;
              minId1(:)=i;
              minId2(:)=j;
              %Difference in each coord
              difs(:)=[abs(cop1(1)-cop2(1)),abs(cop1(2)-cop2(2)),abs(cop1(3)-cop2(3))];
           end
       end
    end
end     
