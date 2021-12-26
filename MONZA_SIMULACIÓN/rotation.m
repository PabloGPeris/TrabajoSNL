function [x2, y2] = rotation(x1, y1, theta)
%%[x2, y2] = ROTATION(x1, y1, theta)
% Rota el punto (o puntos) [x1, y1] en torno al origen un ángulo theta.

x2 = x1*cos(theta) - y1*sin(theta);
y2 = x1*sin(theta) + y1*cos(theta);

end