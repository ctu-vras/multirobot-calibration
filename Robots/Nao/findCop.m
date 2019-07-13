function finalCops= findCop(points,maxDist)
    cops={};
    for i=1:size(points,1)
        point=points(i,1:3);
        inRange=0;
        for j=1:size(cops,2)
           cop=cops{j};
           for k=1:size(cop,2)
                if norm(point-cop{k},2)<maxDist
                    cops{j}{end+1}=point;
                    inRange=1;
                    break;
                end
           end
           if inRange
               break;
           end
        end
        if ~inRange
            cops{end+1}={point};
        end
    end
    finalCops=zeros(size(cops,2),3);
    for i=1:size(cops,2)
       cop=cops{i};
       x=zeros(size(cop,2),1);
       y=zeros(size(cop,2),1);
       z=zeros(size(cop,2),1);
       for j=1:size(cop,2)
          c=cop{j};
          x(j)=c(1);
          y(j)=c(2);
          z(j)=c(3);
       end
       finalCops(i,:)=[mean(x),mean(y),mean(z)];
    end
end