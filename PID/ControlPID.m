%% Pruebas iniciales
clc
addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel 

%% Parámetros de simulación
dibujos = 0;
animacion = 1;
dificultad = 3;


Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
tsim = 30;
piso = 0;

% Carga Riel
load("riel" + num2str(dificultad) + ".mat");

% Cambio parametros PID según nivel
switch dificultad
    case 1
        kp = -1.6;
        kd = -0.3;
        ki = -1;
    case 2
        kp = -1.37;
        kd = -0.7;
        ki = 0;
    case 3
        kp = -1.7;
        kd = -0.7;
        ki = 0;
    case 4
        kp = -1.21;
        kd = -0.97;
        ki = 0;
        % Cambio de la última referencia, si no no lo consigue
        riel(5,1) = 0.0818;

end
%Para el nivel 4 modificar en la fila 5 del riel el valor de x a 0.0818


%% Simulación
warning('off','all')
load_system('Monza_controlado_PID')
sim('Monza_controlado_PID')

%% Animación
if animacion
    animacion_monza(dificultad, Ts, giro_m, xs, ys)
    Trayectoria(dificultad,xri,yri, 'r*-','lineWidth',1);
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
