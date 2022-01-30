%% Pruebas iniciales

addpath ..\MONZA_SIMULACIÓN
addpath ..\

global riel %#ok<*NUSED>

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 1;
tsim = 30;
dibujos = 0;
animacion = 1;

mdl = 'Monza_controlado';
agentblk = 'Monza_controlado/RL Agent';

%load('agente_1.mat') % Tipo II
load('agente_2.mat') % Tipo I

%% Creación interfaz de entorno
numObservations = 5;
observationInfo = rlNumericSpec([numObservations 1]);
observationInfo.Name = 'observations';
observationInfo.Description = 'informacion del error';

% Información de la acción
numActions = 1;
actionInfo = rlNumericSpec([numActions 1],'LowerLimit', -1.5708/4, 'UpperLimit', 1.5708/4);
actionInfo.Name = 'action';

% Definición del entorno
env = rlSimulinkEnv(mdl,agentblk,observationInfo,actionInfo);

% Función de reset
env.ResetFcn = @(in)localResetfcn(in);

% Riel
load("riel" + num2str(dificultad) + ".mat");

%% Simulación
warning('off','all')

sim('Monza_controlado')

%% Animación
if dibujos
    %% Dibujar gráficas de velocidad y posición
    figure(1); %#ok<*UNRCH>
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
    figure(2);
    plot(err(:,2), derr(:,2), 'b.-');
    hold on
    xlabel('error (m)');
    ylabel('error velocity (m/s)');
    grid on
end

if animacion
    animacion_monza(dificultad, Ts, giro_m, xs, ys)
    Trayectoria(dificultad, xr(:,2), yr(:,2),'m','Marker','x')
end