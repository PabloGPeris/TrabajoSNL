%% Pruebas iniciales

addpath MONZA_SIMULACIÓN
addpath Fuzzy
global riel %#ok<*NUSED>

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 1;
tsim = 6;

%% Diseño de controlador
% Conjuntos borrosos
reglasError = {-0.02 -0.01 0 0.01 0.02}; 
reglasDError = {-0.04 -0.02 0 0.02 0.04};

% LUT de salidas 
% |  -> error NB NS Z PS PB
% v derivada
% NB
% NS
% Z
% PS
% PB

% Valor positivo de giro, gira a la izda -> disminuye x -> aumenta error

LUT = [.5 .3    .2  .1   0;
       .3 .2    .1   0 -.1;
       .2 .1     0 -.1 -.2;
       .1  0   -.1 -.2 -.3;
        0  -.1 -.2 -.3 -.5]*0.5;




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
animacion_monza(dificultad, Ts, giro_m, xs, ys)
hold on
