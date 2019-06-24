function G = evalDHMatrixTest(a, d, alph, thet);

% Transl (a) along x + rot (alph) about x
% G = [       1, 			0,  		0,   a;
%             0,  cos(alph), -sin(alph),   0;
%             0,  sin(alph),  cos(alph),   0;
%             0,          0,          0,   1];

% Transl (d) along z + rot (thet) about  z
% G = G * [ cos(thet), -sin(thet),    0,   0;
% 		  sin(thet),  cos(thet),    0,   0;
% 		  		  0,  	      0,    1,   d;
% 		  		  0, 		  0,    0,   1;];


G = [ 			 cos(thet), 	     -sin(thet),  	      0,  		    a;
       cos(alph)*sin(thet), cos(alph)*cos(thet), -sin(alph), -sin(alph)*d;
       sin(alph)*sin(thet), sin(alph)*cos(thet),  cos(alph),  cos(alph)*d;
            			 0,          		  0,          0,   			1];
