function [Oxyz ] = DrawRefFrame(G,num,size,showText, varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Draw reference frames attached to the centers of mass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
length = size;
width = 2;

Origin1 = G*[0 0 0 1]';

x_axis_1 = G*[length 0 0 1]';
h = quiver3(Origin1(1), Origin1(2), Origin1(3), x_axis_1(1) - Origin1(1), x_axis_1(2) - Origin1(2), x_axis_1(3) - Origin1(3), 0);
if nargin>=5
	if varargin{1} == 'hat'
		set(h, 'Color', 'm', 'LineWidth', width, 'MaxHeadSize', 4, 'ShowArrowHead', 'off')
	else
		set(h, 'Color', 'r', 'LineWidth', width, 'MaxHeadSize', 4, 'ShowArrowHead', 'off')
	end
else
	set(h, 'Color', 'r', 'LineWidth', width, 'MaxHeadSize', 4, 'ShowArrowHead', 'off')
end
set(h, 'ShowArrowHead', 'on')


y_axis_1 = G*[0 length 0 1]';
h = quiver3(Origin1(1), Origin1(2), Origin1(3), y_axis_1(1) - Origin1(1), y_axis_1(2) - Origin1(2), y_axis_1(3) - Origin1(3), 0);
if nargin>=5
	if varargin{1} == 'hat'
		set(h, 'Color', 'c', 'LineWidth', width, 'MaxHeadSize', 4, 'ShowArrowHead', 'off')
	else
		set(h, 'Color', 'g', 'LineWidth', width, 'MaxHeadSize', 4, 'ShowArrowHead', 'off')
	end
else
	set(h, 'Color', 'g', 'LineWidth', width, 'MaxHeadSize', 4, 'ShowArrowHead', 'off')
end
set(h, 'ShowArrowHead', 'on')


z_axis_1 = G*[0 0 length 1]';
h = quiver3(Origin1(1), Origin1(2), Origin1(3), z_axis_1(1) - Origin1(1), z_axis_1(2) - Origin1(2), z_axis_1(3) - Origin1(3), 0);
set(h, 'Color', 'b', 'LineWidth', width, 'MaxHeadSize', 4, 'ShowArrowHead', 'off')
set(h, 'ShowArrowHead', 'on')


% we put the labels at 1/3 of the z-axis
label_x = Origin1(1) + (z_axis_1(1) - Origin1(1))/3;
label_y = Origin1(2) + (z_axis_1(2) - Origin1(2))/3;
label_z = Origin1(3) + (z_axis_1(3) - Origin1(3))/3;
h=[];
if (showText)
    if nargin>=5
        if nargin==5
            if strcmp(varargin{1}, 'hat')
                h = text(label_x, label_y, label_z, strcat(' (frame ', num2str(num-1),')'));
            elseif strcmp(varargin{1}, 'noh') 
                h = text(label_x, label_y, label_z, strcat(' (frame ', num2str(num-1), ')'));
            end
        elseif nargin>=6
                h = text(label_x, label_y, label_z, strcat(varargin{2},' (frame ', num2str(num-1), ')'));
        end
    else
        h = text(label_x, label_y, label_z, strcat('z_{', num2str(num-1), '}'));
    end
end

if ~isempty(h)
    set(h, 'FontSize', 8)
end
O = G*[0 0 0 1]'; O(end) = []; O = O';
x = G*[1 0 0 0]'; x(end) = []; x = x';
y = G*[0 1 0 0]'; y(end) = []; y = y';
z = G*[0 0 1 0]'; z(end) = []; z = z';

Oxyz = [O; x; y; z]; Oxyz = Oxyz';