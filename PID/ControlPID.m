%% Pruebas iniciales

addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel %#ok<*NUSED>

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 4;
tsim = 30;
dibujos = 0;
animacion = 1;
piso = 0;

rate = 3;
kp = -1.37;
kd = -0.57;
ki = 0;

% Riel
load("riel" + num2str(dificultad) + ".mat");

%% Simulación
warning('off','all')
load_system('Monza_controlado')
sim('Monza_controlado')

%% Animación
if animacion
    animacion_monza(dificultad, Ts, giro_m, xs, ys)
end

if dibujos
    %% Dibujar gráficas de velocidad y posición
    figure; %#ok<*UNRCH>
    subplot(2,2,1)
    plot(xr(:,1), xr(:,2));
    xlabel('time (s)');
    ylabel('position (m)');
    grid on

    subplot(2,2,2)
    plot(dxr(:,1), dxr(:,2));
    xlabel('time (s)');
    ylabel('velocity (m/s');
    grid on

    subplot(2,2,3)
    plot(err(:,1), err(:,2));
    xlabel('time (s)');
    ylabel('error (m)');
    grid on

    subplot(2,2,4)
    plot(derr(:,1), derr(:,2));
    xlabel('time (s)');
    ylabel('error velocity (m/s)');
    grid on

    %% Error
    figure;
    plot(err(:,2), derr(:,2));
    xlabel('error (m)');
    ylabel('error velocity (m/s)');
    grid on
end
