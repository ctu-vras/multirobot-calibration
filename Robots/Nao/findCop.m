function finalCops= findCop(points,maxDist)
    % FINDCOP returns COPs calculated from input points
    %   INPUT - points - Mx3 array of points
    %          - maxDist - double, max distance between two taxels in one COP
    %   OUTPUT - finalCops - Nx3 array of calculated COPs
    cops={};
    % Iterate over all points
    for i=1:size(points,1)
        point=points(i,1:3);
        %inRange of 'maxDist'
        inRange=0;
        %iterate over all currently found COPs
        for j=1:size(cops,2)
           cop=cops{j};
           %iterate over all points in given COP
           for k=1:size(cop,2)
               %if distance of point to any taxel in COP is lower than
               %'maxDist' => point belongs to this COP
                if norm(point-cop{k},2)<maxDist
                    %Assing point to COP
                    cops{j}{end+1}=point;
                    %Set inRange to 1
                    inRange=1;
                    break;
                end
           end
           %if inRange == assigned to already known COP, break loop over
           %COPS
           if inRange
               break;
           end
        end
        % If iteration over COP ended and inRange==0, point does not belong
        % to any COP => add new COP
        if ~inRange
            cops{end+1}={point};
        end
    end
    
    finalCops=zeros(size(cops,2),3);
    %Iterate over all found COPs
    for i=1:size(cops,2)
       cop=cops{i};
       x=zeros(size(cop,2),1);
       y=zeros(size(cop,2),1);
       z=zeros(size(cop,2),1);
       %Iterate over points in COP and save their components
       %PŘEPSAT MATLABOVSKY
       for j=1:size(cop,2)
          c=cop{j};
          x(j)=c(1);
          y(j)=c(2);
          z(j)=c(3);
       end
       % output COP is mean of all points in it
       finalCops(i,:)=[mean(x),mean(y),mean(z)];
    end
end