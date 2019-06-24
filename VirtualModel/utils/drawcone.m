function drawcone(pos, dir, length, radius, code)
%DRAWCONE Draw a cone
[x, y, z] = cylinder(0:0.05*radius:radius, 20);
coords = [reshape(x, 1, []); reshape(y, 1, []); reshape(z*length, 1, [])];
[u,~,v] = svd([0, 0, dir(1); 0, 0, dir(2); 0, 0, dir(3)]);
rmat = u * v';
coords = rmat * coords;
x = reshape(coords(1,:), 21, []);
y = reshape(coords(2,:), 21, []);
z = reshape(coords(3,:), 21, []);

surf(x + pos(1), y + pos(2), z + pos(3), 'FaceColor', code, 'FaceAlpha', 0.2, 'EdgeColor', 'none');
end

