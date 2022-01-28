function ddx = mov_riel(x,u,dx)
%MOV_RIEL Summary of this function goes here
%   Detailed explanation goes here

k = 1;
g = 9.81;
theta = atan(-1.08*x) + u;

% if abs(theta) > 0.02
%     ddx = -g*sin(theta) - 0.0223/0.007*dx;
% else
    ddx = -g*sin(theta)/(1+k);
% end

end

