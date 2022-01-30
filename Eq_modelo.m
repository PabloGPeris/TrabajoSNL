% Movimiento por el riel parabólico
g=9.8;
M=0.007;
c=c_v; %0.01 (coeficiente viscoso)
d2xt=(M*g*-sin(atan(-1.08*x1)+giro)-c*dxt)/(M);
dyt=-1.08*x1*dxt;