function result = ezwraptopi(angle_rad)
%EZWRAPTOPI Easily wrap a vector or matrix of angles to [-pi; pi]
result = angle_rad - 2*pi*floor( (angle_rad+pi)/(2*pi) ); 
end

