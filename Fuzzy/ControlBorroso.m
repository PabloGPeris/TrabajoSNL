%% Pruebas iniciales

addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel %#ok<*NUSED>

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 3;
tsim = 30;
dibujos = 0;
animacion = 1;

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
reglasError = { -0.2 -0.1 0 0.1 0.2 }; 
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

LUT = [.4  .3  .2  .1   0;
       .3  .2  .1   0 -.1;
       .3  .1   0 -.1 -.2;
       .1   0 -.1 -.2 -.3;
        0 -.1 -.2 -.3 -.4];

% LUT = [ones(5,1)*.45 LUT -ones(5,1)*.45];


%% Valores para controlador
% Conjuntos borrosos
reglasErrorF = FuzzySet.format(reglasError{:});
reglasDErrorF = FuzzySet.format(reglasDError{:});

FSetError = FuzzySet(reglasErrorF{:});
FSetDError = FuzzySet(reglasDErrorF{:});

% Riel
load("riel" + num2str(dificultad) + ".mat");

%% Simulación
warning('off','all')
load_system('Monza_controlado')
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
    for i = 1:length(reglasError)
        plot([reglasError{i} reglasError{i}], ylim, 'r')
    end
    for i = 1:length(reglasDError)
        plot(xlim, [reglasDError{i} reglasDError{i}], 'r')
    end
    xlabel('error (m)');
    ylabel('error velocity (m/s)');
    grid on
end

if animacion
    animacion_monza(dificultad, Ts, giro_m, xs, ys)
end
