%% Pruebas iniciales

addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel  %#ok<*GVMIS,*NUSED>

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 1;
tsim = 1;
dibujos = 1;
tray = 1;
imax = 15;

%% Entrada
u = -0.2;
x0 = -0.11;
v0 = 0.05;
% mu = 0.2;
% mu_s = 0.3;

%% Simulación
warning('off','all')
load_system('Monza_modelo')
sim('Monza_modelo')

%% Comparativa
% animacion_monza(dificultad, Ts, giro_m, xs, ys)



xs = xr(:,2);
ys = yr(:,2);
xm = x_modelado(:,2);
t = xr(:,1);


if tray
    figure(101);
    Trayectoria(dificultad, xs, ys, 'r*-','lineWidth',1);
    hold on
    Trayectoria(dificultad, x_modelado(:,2), ys, 'c*-','lineWidth',1);
end


if dibujos
    %% Dibujar gráficas de velocidad y posición
    figure(11); %#ok<*UNRCH>
%     subplot(1,2,1)
    plot(t(1:imax), xs(1:imax), 'r*-', t(1:imax), xm(1:imax), 'c*-','lineWidth',1);
    xlabel('time (s)');
    ylabel('position (m)');
    grid on

end