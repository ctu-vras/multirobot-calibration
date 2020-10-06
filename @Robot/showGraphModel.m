function showGraphModel(r)
    % SHOWGRAPHMODEL shows tree-based graph of given robot
    
    %close all;
    % init vector and to each index assing its parent
    treeVector=[];
    for joint=r.joints
       if isnan(joint{1}.parentId)
           treeVector(end+1)=0; %parent of root is 0
       else
           treeVector(end+1)=joint{1}.parentId; %from Joint.parent
       end
    end
    %Disp tree
    [x,y]=treelayout(treeVector);
    treeplot(treeVector);
    % Add names of each node
    for i=1:length(x)
        if ~strcmp(r.joints{i}.type,types.triangle) && ~strcmp(r.joints{i}.type,types.taxel) %do not display for triangles, because there are too many of them
            text(x(i)+0.015,y(i),r.joints{i}.name);
        end
    end
    title(sprintf('Structure of %s robot',r.name))
    xlabel('');
    xticks([])
    yticks([])
end

