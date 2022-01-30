%% Simulación del control borroso

addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel %#ok<*NUSED>



%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 4;
tsim = 30;
dibujos = 0;
animacion = 0;
dibujos_funciones_de_pertenencia = 0;

%% Diseño de controlador

if dificultad ~= 4

    % Conjuntos borrosos
    reglasError = {-0.1 -0.05 0 0.05 0.1}; 
    reglasDError = {-0.4 -0.2 0 0.2 0.4};
    
    % LUT de valores de entrada u 
    % |  -> derror NB NS Z PS PB
    % v error
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


    % Escribe las reglas en otro formato entendible para el constructor de
    % FuzzySet
    reglasErrorF = FuzzySet.format(reglasError{:});
    reglasDErrorF = FuzzySet.format(reglasDError{:});
    
    %Conjunto borroso
    FSetError = FuzzySet(reglasErrorF{:});
    FSetDError = FuzzySet(reglasDErrorF{:});
else
    % Resultados de los algoritmos genéticos
    load GA_pop
    ind = 7;
    LUT = LUT_from_ind(pop_parents{ind});
    [FSetError, FSetDError] = FSet_from_ind(pop_parents{ind});
end


%% Simulación
% Riel
load("riel" + num2str(dificultad) + ".mat");

warning('off','all')
load_system('Monza_borroso')
sim('Monza_borroso')

disp("Tiempo = " + num2str(xr(end,1)) + "s");


%% Animación
if dibujos
    %% Dibujar gráficas de velocidad y posición
    figure(1); %#ok<*UNRCH>
    subplot(2,2,1)
    plot(xr(:,1), xr(:,2), 'LineWidth', 1.5);
    xlabel('time (s)');
    ylabel('posición (m)');
    grid on

    subplot(2,2,2)
    plot(dxr(:,1), dxr(:,2), 'LineWidth', 1.5);
    xlabel('time (s)');
    ylabel('velocidad (m/s');
    grid on

    subplot(2,2,3)
    plot(err(:,1), err(:,2), 'LineWidth', 1.5);
    xlabel('time (s)');
    ylabel('error (m)');
    grid on

    subplot(2,2,4)
    plot(derr(:,1), derr(:,2), 'LineWidth', 1.5);
    xlabel('time (s)');
    ylabel('derivada del error (m/s)');
    grid on

    %% Diagrama de fase
    figure(2);
    plot(err(:,2), derr(:,2), '-*r', 'LineWidth', 0.5);
    hold on
    for i = 1:length(reglasError)
        for j = 1:length(reglasDError)
            plot(FSetError.vertex(i), FSetDError.vertex(j), 'xg', 'MarkerSize', 15, 'LineWidth', 3)
        end
    end
    xlabel('error (m)');
    ylabel('derivada del error (m/s)');
    grid on

    %% Trayectoria
    figure(11)
    Trayectoria(dificultad,  xr(:,2), yr(:,2), 'r*-','lineWidth',0.5);
end

if animacion
    animacion_monza(dificultad, Ts, giro_m, xs, ys)
end

if dibujos_funciones_de_pertenencia
    figure(12);
    err = -0.3:0.01:0.3;
    derr = -0.5:0.02:0.5;
    S = zeros(length(derr), length(err));
    for i = 1:length(err)
        for j = 1:length(derr)

            % Fuzzification
            mu_error = Fuzzification(FSetError, err(i));
            mu_derror = Fuzzification(FSetDError, derr(j));

            % Inferencia
            w = mu_derror' * mu_error;
            S(j,i) = max(w(:));
        end
    end

    surf(err, derr, S)
    xlabel('error (m)')
    ylabel('derivada del error (m/s)')
    zlabel("w_{j_1 j_2}(error, error'")
    view(45,65)

    et_lin = ["NB", "NS", "Z", "PS", "PB"];

    figure(13);
    subplot(2,1,1)
    FSPlot(FSetError, -0.3:0.01:0.3, 'LineWidth', 1.5)
    for i = 1:FSLength(FSetError)
        text(FSetError.vertex(i)-0.01, 0.5, et_lin(i))
    end
    xlabel('error (m)')
    ylabel('\mu_{1, j_1}(error)')

    subplot(2,1,2)
    FSPlot(FSetDError, -0.5:0.02:0.5, 'LineWidth', 1.5)
    for i = 1:FSLength(FSetDError)
        text(FSetDError.vertex(i)-0.01, 0.5, et_lin(i))
    end
    xlabel('derivada del error (m/s)')
    ylabel("\mu_{2, j_2}(error')")

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