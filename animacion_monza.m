function animacion_monza(dificultad, t_pausa, giro_m, xs, ys)
%% ANIMACION_MONZA(dificultad, t_pausa, giro_m, xs, ys)
% Modificación del script "simulacion_monza_tfm.m" para convertirla en una
% función (usando variables locales) y que se vea bien. Debe ejecutarse en
% la misma carpeta (o haber añadido al path la carpeta correspondiente) que
% los archivos "dificultad1.mat", "dificultad2.mat", ..., "circulos.mat",
% así como anim_giro_pistas
% 
% dificultad: 1, 2, 3 o 4
% t_pausa: tiempo entre dos fotogramas seguidos. Para que se corresponda
% con el periodo de muestreo real, poner 5*Ts
% giro_m, xs, ys: son valores que da directamente al simularse

load("dificultad" + num2str(dificultad) + ".mat"); % PGP: así mejor
load("circulos.mat");
giro_simu=giro_m;
ma=cos(giro_simu);
mb=sin(giro_simu);


anim_giro_pistas;


%**************************************************************************
%***************GR�FICAS DE LAS CURVAS DE LA SIMULACI�N********************
%**************************************************************************
figure(100)
for j=1:length(xs)
    
    plot(mxp(j),myp(j)+0.01,'r*','lineWidth',15)
    
    hold on
    
    %*********RECTAS*********
    plot(mxl1(j,:),myl1(j,:),'b','lineWidth',2);
    plot(mxl2(j,:),myl2(j,:),'b','lineWidth',2);
    plot(mxl3(j,:),myl3(j,:),'b','lineWidth',2);
    plot(mxl4(j,:),myl4(j,:),'b','lineWidth',2); 
    %*******PARABOLAS***********
    plot(mx(j,:),my(j,:),'b','lineWidth',2);
    plot(mx1(j,:),my1(j,:),'b','lineWidth',2);
    plot(mx2(j,:),my2(j,:),'b','lineWidth',2);
    plot(mx3(j,:),my3(j,:),'b','lineWidth',2);
    plot(mx4(j,:),my4(j,:),'b','lineWidth',2);
    plot(mx5(j,:),my5(j,:),'b','lineWidth',2);
    plot(mx6(j,:),my6(j,:),'b','lineWidth',2);
    plot(mx7(j,:),my7(j,:),'b','lineWidth',2);
    
    % PGP: aquí había un lío que espero haber solucionado
    
    plot(r1,r2,'r');
    plot(r3,r4,'r');
    axis([-0.25 0.25 -0.25 0.25])
    title('SIMULADOR GRÁFICO PLATAFORMA PARA PRUEBA Y ENSAYO DE CONTROLADORES')
    
    pause(t_pausa) % PGP: pequeña pausa para que se vea bien
    hold off
end
end

