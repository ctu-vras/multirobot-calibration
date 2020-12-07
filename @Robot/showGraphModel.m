function showGraphModel(r, ax)
    % SHOWGRAPHMODEL shows tree-based graph of given robot
    if(nargin < 2)
        ax = gca;
    end
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
    [x,y] = tplot(ax,treeVector);
    % Add names of each node
    for i=1:length(x)
        if ~strcmp(r.joints{i}.type,types.triangle) && ~strcmp(r.joints{i}.type,types.taxel) ...
                && ~strcmp(r.joints{i}.group, group.leftMarkers) && ~strcmp(r.joints{i}.group, group.rightMarkers) %do not display for triangles, because there are too many of them
            text(ax,x(i)+0.015,y(i),r.joints{i}.name);
        end
    end
    title(ax,sprintf('Structure of %s robot',r.name))
    xticks(ax,[])
    yticks(ax,[])
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
end


function [x,y] = tplot(ax,p,c,d)
%TREEPLOT Plot picture of tree.
%   TREEPLOT(p) plots a picture of a tree given a row vector of
%   parent pointers, with p(i) == 0 for a root. 
%
%   TREEPLOT(P,nodeSpec,edgeSpec) allows optional parameters nodeSpec
%   and edgeSpec to set the node or edge color, marker, and linestyle.
%   Use '' to omit one or both.
%
%   Example:
%      treeplot([2 4 2 0 6 4 6])
%   returns a complete binary tree.
%
%   See also ETREE, TREELAYOUT, ETREEPLOT.

%   Copyright 1984-2013 The MathWorks, Inc. 

[x,y,~]=treelayout(p);
f = find(p~=0);
pp = p(f);
X = [x(f); x(pp); NaN(size(f))];
Y = [y(f); y(pp); NaN(size(f))];

X = X(:);
Y = Y(:);

if nargin == 2
    n = length(p);
    if n < 500
        plot (ax,x, y, 'ro', X, Y, 'r-');
    else
        plot (ax,X, Y, 'r-');
    end
else
    [~, clen] = size(c);
    if nargin < 3
        if clen > 1
            d = [c(1:clen-1) '-']; 
        else
            d = 'r-';
        end
    end
    [~, dlen] = size(d);
    if clen>0 && dlen>0
        plot (ax,x, y, c, X, Y, d);
    elseif clen>0
        plot (ax,x, y, c);
    elseif dlen>0
        plot (ax,X, Y, d);
    else
    end
end
end
