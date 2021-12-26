%% Pruebas iniciales

addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel %#ok<*NUSED>

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 3;
tsim = 30;
dibujos = 0;
animacion = 0;

% im = [...
%     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%     0 0 1 0 0 0 1 0 0 1 0 0 1 0 0 0 1 0 0 1 1 1 1 1 0 0 1 0 0 0 0 0 0 1 1 1 1 1 0 0;
%     0 0 1 1 0 0 1 0 0 0 0 0 1 1 0 1 1 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0;
%     0 0 1 0 1 0 1 0 0 1 0 0 0 1 0 1 0 0 0 1 1 1 1 1 0 0 1 0 0 0 0 0 0 0 1 1 1 0 0 0;
%     0 0 1 0 0 1 1 0 0 1 0 0 0 1 1 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 0;
%     0 0 1 0 0 0 1 0 0 1 0 0 0 0 1 0 0 0 0 1 1 1 1 1 0 0 1 1 1 1 1 0 0 1 1 1 1 1 0 0;
%     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% 
% figure;
% imshow(kron(im, ones(20, 20)));



%% Diseño de controlador
% Conjuntos borrosos
reglasError = {-0.1 -0.05 0 0.05 0.1}; 
reglasDError = {-0.4 -0.2 0 0.2 0.4};

% LUT de salidas 
% |  -> error NB NS Z PS PB
% v derivada
% NB
% NS
% Z
% PS
% PB

% Valor positivo de giro, gira a la izda -> disminuye x -> aumenta error

LUT = [.3 .3    .2  .1   0;
       .3 .2    .1   0 -.1;
       .3 .1     0 -.1 -.3;
       .1  0   -.1 -.2 -.3;
        0  -.1 -.2 -.3 -.3];


%% Valores para controlador
% Conjuntos borrosos
reglasError = FuzzySet.format(reglasError{:});
reglasDError = FuzzySet.format(reglasDError{:});

FSetError = FuzzySet(reglasError{:});
FSetDError = FuzzySet(reglasDError{:});

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
