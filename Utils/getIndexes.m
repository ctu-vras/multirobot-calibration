function structure=getIndexes(structure, joint)
% GETINDEXES computes indexes and parents needed to find transformations
%   INPUT - structure - structure where new fields will be added/updated
%         - joint - Joint object for which we want find the informations
%   OUTPUT - structure - updated input variable
    gr = joint.group;
    name=joint.name;
    idx = [];
    id=1;
    while isobject(joint) 
        while strcmp(joint.group,gr) && ~strcmp(joint.type,types.base) % save indexes into DH table for all joints of the group
           idx(id)=joint.DHindex;
           id=id+1;
           joint=joint.parent;
        end
        structure.DHindexes.(name).(gr) = idx(end:-1:1);
        structure.parents.(gr) = joint; % joint.group differs from gr
        gr = joint.group;
        idx = joint.DHindex; 
        id=2;
        joint=joint.parent; 
    end
end