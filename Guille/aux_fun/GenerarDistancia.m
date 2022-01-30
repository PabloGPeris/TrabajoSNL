function d = GenerarDistancia(x,y, riel)
%ref = GENERARREFERENCIA(y, riel)
%   Detailed explanation goes here
xo = 0;
yo = riel(7,2);

d = sqrt((x-xo)^2+(y-yo)^2);
end
