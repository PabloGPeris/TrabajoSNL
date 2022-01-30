function Trayectoria(dificultad, xs, ys, varargin)
%TRAYECTORIA Summary of this function goes here
%   Detailed explanation goes here
% giro_m
load("dificultad" + num2str(dificultad) + ".mat"); % PGP: así mejor
load("circulos.mat");

%**************************************************************************
%***************GRAFICAS DE LAS CURVAS DE LA SIMULACION********************
%**************************************************************************

plot(xs,ys+0.01, varargin{:});
hold on


%*********RECTAS*********
plot(xl1,yl1,'b','lineWidth',2);
plot(xl2,yl2,'b','lineWidth',2);
plot(xl3,yl3,'b','lineWidth',2);
plot(xl4,yl4,'b','lineWidth',2); 
%*******PARABOLAS***********
plot(xp,yp,'b','lineWidth',2);
plot(xp1,yp1,'b','lineWidth',2);
plot(xp2,yp2,'b','lineWidth',2);
plot(xp3,yp3,'b','lineWidth',2);
plot(xp4,yp4,'b','lineWidth',2);
plot(xp5,yp5,'b','lineWidth',2);
plot(xp6,yp6,'b','lineWidth',2);
plot(xp7,yp7,'b','lineWidth',2);

plot(r1,r2,'r');
plot(r3,r4,'r');
axis([-0.25 0.25 -0.25 0.25])
% title('SIMULADOR GRÁFICO PLATAFORMA PARA PRUEBA Y ENSAYO DE CONTROLADORES')
hold off
end