function dhpars = tfmat2dhpars(tfmat)

R = tfmat(1:3,1:3);
t = tfmat(1:3,4);
%%
% t = [-0.308, -0.2, 1.785];
% R =    [ 0.0516   -0.7661    0.6407;
%    -0.9968   -0.0000    0.0802;
%    -0.0615   -0.6428   -0.7636];
% eul = matrix2euler(R, 'SZXZ');
eul = [-2.4419, 0.0615, -1.5191];
theta = eul(3);
alpha = eul(2);
theta_2 = eul(1);

Q = [-R(2,3)/sqrt(R(1,3)^2 + R(2,3)^2), R(1,3); R(1,3)/sqrt(R(1,3)^2 + R(2,3)^2), R(2,3)];

if cond(Q) < 10^10
        pq = Q\[t(1); t(2)];   
else
    pq = [sqrt(t(1)^2 + t(2)^2);0];
    theta = atan2(t(2), t(1));
    alpha = sign(R(3,3)) * pi;
    theta_2 = atan2(sign(R(3,3))*R(2,1), R(1,1)) - sign(R(3,3))*atan2(t(2), t(1));
end

if pq(1) < 0
    theta = theta - sign(theta) * pi;
    alpha = - alpha;
    theta_2 = theta_2 - sign(theta_2) * pi;
end

theta = real(theta);
d = t(3) - pq(2)*R(3,3);
a = abs(pq(1));
alpha = real(alpha);
next_theta = real(theta_2);
next_d = pq(2);

dhpars = [a, d, alpha, theta; 0, next_d, 0, next_theta]
