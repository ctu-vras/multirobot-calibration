function drawsphere(pos, radius, code)
%DRAWSPHERE draw sphere
[a,b,c] = sphere;

surf(a*radius + pos(1), b*radius + pos(2), c*radius + pos(3), 'FaceColor', code, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end

