addpath ..\MONZA_SIMULACIÓN
addpath ..\
global riel %#ok<*NUSED>



%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 4;
tsim = 30;
dibujos = 0;
animacion = 0;

% Riel
load("riel" + num2str(dificultad) + ".mat");

%% Simulación
warning('off','all')
load_system('Monza_controlado')
sim('Monza_controlado')

reglasError = { -0.2 -0.1 0 0.1 0.2 }; 
reglasDError = {-0.4 -0.2 0 0.2 0.4};

%% Valores para controlador
% Conjuntos borrosos
reglasErrorF = FuzzySet.format(reglasError{:});
reglasDErrorF = FuzzySet.format(reglasDError{:});

FSetError = FuzzySet(reglasErrorF{:});
FSetDError = FuzzySet(reglasDErrorF{:});


warning('off','all')
load_system('Monza_controlado')

%% LUT - GA
a = [.4 .3 .2 .1 .3 .2 .1 .3 .1 .1 0 0];
LUT =  [a(1) a(2) a(3) a(4) a(11);
        a(5) a(6) a(7) a(12) -a(10);
        a(8) a(9) 0 -a(9) -a(8);
        a(10) -a(12) -a(7) -a(6) -a(5);
        -a(11) -a(4) -a(3) -a(2) -a(1)];

% LUT = [.4  .3  .2  .1   0;
%        .3  .2  .1   0 -.1;
%        .3  .1   0 -.1 -.2;
%        .1   0 -.1 -.2 -.3;
%         0 -.1 -.2 -.3 -.4];

a_min = a;

d = inf;
d_min = inf;


for i = 1:10000
    sim('Monza_controlado')

    y = yr(end-5, 2);
    x = xr(end-5, 2);
    d = norm([0.2*x y] - [0 -0.1143], 1);
    if d < d_min
        d_min = d;
        a_min = a;
        disp('nuevo_min')
    end

    a = a_min + rand(1, 12)*0.2 - 0.1;
    LUT =  [a(1) a(2) a(3) a(4) a(11);
            a(5) a(6) a(7) a(12) -a(10);
            a(8) a(9) 0 -a(9) -a(8);
            a(10) -a(12) -a(7) -a(6) -a(5);
            -a(11) -a(4) -a(3) -a(2) -a(1)];

end

a = a_min;

LUT =  [a(1) a(2) a(3) a(4) 0;
        a(5) a(6) a(7) 0 -a(10);
        a(8) a(9) 0 -a(9) -a(8);
        a(10) 0 -a(7) -a(6) -a(5);
        0 -a(4) -a(3) -a(2) -a(1)];




