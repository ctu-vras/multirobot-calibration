function structure=getIndexes(structure, link)
% GETINDEXES computes indexes and parents needed to find transformations
%   INPUT - structure - structure where new fields will be added/updated
%         - link - link object for which we want find the informations
%   OUTPUT - structure - updated input variable
    gr = link.group;
    name=link.name;
    idx = [];
    id=1;
    while isobject(link) 
        while strcmp(link.group,gr) && ~strcmp(link.type,types.base) % save indexes into kinematics table for all links of the group
           idx(id)=link.DHindex;
           id=id+1;
           link=link.parent;
        end
        structure.DHindexes.(name).(gr) = idx(end:-1:1);
        structure.parents.(gr) = link; % link.group differs from gr
        gr = link.group;
        idx = link.DHindex; 
        id=2;
        link=link.parent; 
    end
end