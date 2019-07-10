function [ minCop1, minCop2 ] = findClosestCop(cops1,cops2 )
    actMin=inf;
    minCop1=zeros(1,3);
    minCop2=zeros(1,3);
    minId1=0;
    minId2=0;
    difs=zeros(1,3);
    for i=1:size(cops1,1)
       cop1=cops1(i,:);
       for j=1:size(cops2,1)
           cop2=cops2(j,:);
           if norm(cop1-cop2,2)<actMin
              actMin(:)=norm(cop1-cop2,2);
              minCop1(:)=cop1;
              minCop2(:)=cop2;
              minId1(:)=i;
              minId2(:)=j;
              difs(:)=[abs(cop1(1)-cop2(1)),abs(cop1(2)-cop2(2)),abs(cop1(3)-cop2(3))];
           end
       end
    end
end     
% avgDiffs["x"].append(difs["x"])
% avgDiffs["y"].append(difs["y"])
% avgDiffs["z"].append(difs["z"])
% mins.append(min)