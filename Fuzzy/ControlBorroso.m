%% Pruebas iniciales

addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel %#ok<*NUSED>

load GA_pop

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 3;
tsim = 30;
dibujos = 1;
animacion = 1;

%% Diseño de controlador
% Conjuntos borrosos
% reglasError = { -0.1 -0.05 0 0.05 0.1 }; 
% reglasDError = {-0.4 -0.2 0 0.2 0.4};

% LUT de salidas 
% |  -> derror NB NS Z PS PB
% v error
% NB
% NS
% Z
% PS
% PB

% Valor positivo de giro, gira a la izda -> disminuye x -> aumenta error

% LUT = [.3 .3    .2  .1   0;
%        .3 .2    .1   0 -.1;
%        .3 .1     0 -.1 -.3;
%        .1  0   -.1 -.2 -.3;
%         0  -.1 -.2 -.3 -.3];


% LUT = [ones(5,1)*.45 LUT -ones(5,1)*.45];



%% Valores para controlador
% Conjuntos borrosos
% reglasErrorF = FuzzySet.format(reglasError{:});
% reglasDErrorF = FuzzySet.format(reglasDError{:});
% 
% FSetError = FuzzySet(reglasErrorF{:});
% FSetDError = FuzzySet(reglasDErrorF{:});

LUT =  LUT_from_ind(pop_parents{1})
[FSetError, FSetDError] = FSet_from_ind(pop_parents{1});




% Riel
load("riel" + num2str(dificultad) + ".mat");

%% Simulación
warning('off','all')
load_system('Monza_borroso')
sim('Monza_borroso')

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
%     figure(2);
%     plot(err(:,2), derr(:,2), 'b.-');
%     hold on
%     for i = 1:length(reglasError)
%         plot([reglasError{i} reglasError{i}], ylim, 'r')
%     end
%     for i = 1:length(reglasDError)
%         plot(xlim, [reglasDError{i} reglasDError{i}], 'r')
%     end
%     xlabel('error (m)');
%     ylabel('error velocity (m/s)');
%     grid on

    %% Trayectoria
    figure(11)
    Trayectoria(dificultad,  xr(:,2), yr(:,2), 'r*-','lineWidth',1);

end

if animacion
    animacion_monza(dificultad, Ts, giro_m, xs, ys)
end


%% ***** FUNCIONES *******

function LUT = LUT_from_ind(ind)
LUT =  [ind(1)   ind(2)   ind(3)  ind(4)  -ind(12);
        ind(5)   ind(6)   ind(7) -ind(11) -ind(10);
        ind(8)   ind(9)   0      -ind(9)  -ind(8);
        ind(10)  ind(11) -ind(7) -ind(6)  -ind(5);
        ind(12) -ind(4)  -ind(3) -ind(2)  -ind(1)];
end

function [FSetError, FSetDError] = FSet_from_ind(ind)
if abs(ind(14)) > abs(ind(13))
    k = ind(14);
    ind(14) = ind(13);
    ind(13) = k;
end
if abs(ind(16)) > abs(ind(15))
    k = ind(16);
    ind(16) = ind(15);
    ind(15) = k;
end

reglasError = {-abs(ind(13)) -abs(ind(14)) 0 abs(ind(14)) abs(ind(13))}; 
reglasDError = {-abs(ind(15)) -abs(ind(16)) 0 abs(ind(16)) abs(ind(15))};

% Conjuntos borrosos
reglasErrorF = FuzzySet.format(reglasError{:});
reglasDErrorF = FuzzySet.format(reglasDError{:});

FSetError = FuzzySet(reglasErrorF{:});
FSetDError = FuzzySet(reglasDErrorF{:});
end