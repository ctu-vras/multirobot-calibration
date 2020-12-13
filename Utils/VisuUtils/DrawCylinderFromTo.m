function HandleCyl = DrawCylinderFromTo(strtv, endv, Color, NumberOfFaces, TransparencyFactor, varargin)

%Genova 17/04/2013
%Edited by Alessandro Roncone
%
% This function draws a cylinder from a 3d starting point
% to a 3d ending point, with the optional ratio between
% height and radius (by default 2/7).
% NB ratio has to be a double in order for it to be properly acquired

if nargin>=6
	if isa(varargin{1},'double')
		ratio = varargin{1};
	else
		ratio = 1/7;
	end
else
	ratio = 1/7;
end

ljnt = norm(strtv-endv);
rjnt = ratio * ljnt;

z = ((endv+0.000000001)-strtv)/norm((endv+0.000000001)-strtv); %Little offset to draw links, which are on the same position on robot,but not in DH 

if isnan(z)
	HandleCyl = []
	return
end

% Eq. plane normal to z and passing through strtv:
% z(1) x + z(2) y + z(3) z = 0

% let's put y=0, z=1 -> fist vector is
% x1 = -z(3)/z(1)
% y1 = 0
% z1 = 1
% x = [-z(3)/z(1), 0, 1]

if z(1) ~= 0 
	x = [-z(3)/z(1), 0, 1]'; 	x = x/norm(x);
	y = -cross(x,z);			y = y/norm(y);
elseif z(2) ~= 0
	x = [-z(3)/z(2), 1, 0]'; 	x = x/norm(x);
	y = -cross(x,z);			y = y/norm(y);
else
	x = [z(3), 0, 0]'; 			x = x/norm(x);
	y = -cross(x,z);			y = y/norm(y);
end

Rot = cat(2,x,y,z);

RotoTrasl = cat(2,Rot,strtv);
RotoTrasl = cat(1,RotoTrasl,[0 0 0 1]);

HandleCyl = DrawCylinder(ljnt, rjnt, RotoTrasl, Color, NumberOfFaces, TransparencyFactor);