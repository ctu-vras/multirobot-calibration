function showGraphModel(r)
    close all;
%     structure=struct();
%     for joint=r.joints
%         %joint{1}
%         if ~isfield(structure,joint{1}.name)
%             structure.(joint{1}.name).children={};
%         end
%         if ~isobject(joint{1}.parent)
%             structure.(joint{1}.name).root=1;
%         end
%         joint=joint{1};
%         while isobject(joint.parent)%~isnan(joint{1}.parent)
%            if ~any(strcmp(structure.(joint.parent.name).children,joint.name))
%                structure.(joint.parent.name).children{end+1}=joint.name;
%            end
%            joint=joint.parent;
%         end
%     end
%     figure()
%     axis([0 1 0 1.2])
%     hold on
%     fnames=fieldnames(structure);
%     for joint=fnames
%         if isfield(structure.(joint{1}),'root')
%             scatter(0.5,1)
%             text(0.52,1,joint{1})
%             
%             break
%         end
%     end
    treeVector=[];
    for joint=r.jointStructure
       
       if isnan(joint{1}{3})
           treeVector(end+1)=0;
       else
           treeVector(end+1)=joint{1}{3};
       end
    end
    [x,y]=treelayout(treeVector);
    treeplot(treeVector);
    for i=1:length(x)
        if r.jointStructure{i}{2}~=types.triangle
            text(x(i)+0.015,y(i),r.jointStructure{i}{1});
        end
    end
    title(sprintf('Structure of %s robot',r.name))
    xlabel('');
    xticks([])
    yticks([])
end

