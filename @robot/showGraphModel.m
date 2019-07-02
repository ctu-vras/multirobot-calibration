function showGraphModel(r)
    close all;
    treeVector=[];
    for joint=r.joints
       if isnan(joint{1}.parentId)
           treeVector(end+1)=0;
       else
           treeVector(end+1)=joint{1}.parentId;
       end
    end
    [x,y]=treelayout(treeVector);
    treeplot(treeVector);
    for i=1:length(x)
        if ~strcmp(r.joints{i}.type,types.triangle)
            text(x(i)+0.015,y(i),r.joints{i}.name);
        end
    end
    title(sprintf('Structure of %s robot',r.name))
    xlabel('');
    xticks([])
    yticks([])
end

