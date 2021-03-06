%% Algoritmos genéticos

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
load_system('Monza_borroso')

%% LUT - GA
% primeros individuos
ind = [.4 .3 .2 .1 .3 .2 .1 .3 .1 .1 0 0 .2 .1 .4 .2];
ind2 = [.4 .3 .2 .1 .3 .2 .1 .3 .1 .1 0 0 .1 .05 .4 .2];
ind3 = [.3 .3 .2 .1 .3 .2 .1 .3 .1 .1 0 0 .1 .05 .4 .2];

% población inicial
pop_parents = {ind ind2 ind3};
% mutación
pop_mut = mutation(pop_parents, 100 - length(pop_parents));
pop = [pop_parents pop_mut];

d = zeros(1, length(pop));

for i = 1:100
    for j = 1:length(pop)
        LUT =  LUT_from_ind(pop{j});
        [FSetError, FSetDError] = FSet_from_ind(pop{j});

        sim('Monza_borroso')
            
        y = yr(end-3, 2);
        x = xr(end-3, 2);

        d(j) = norm([x y] - [0 -0.1143], 1);
    end
    disp(i);

    % evaluación
    [~, idx_parents] = sort(d);
    % padres supervivientes (8 más altos)
    pop_parents = pop(idx_parents(1:8));
    % hijos por mutación
    pop_mut = mutation(pop_parents, 52);
    % hijos por cruce
    pop_cross = crossover(pop_parents, 40);

    pop = [pop_parents pop_mut pop_cross];
    
end

save GA_pop pop_parents

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

function pop2 = mutation(pop, n)
pop2 = cell(1,n);
l = length(pop);
li = length(pop{1});

for i = 1:n
    j = randi(l);
    nm = randi(4) + 2;
    r = randperm(li, nm);
    
    pop2{i} = pop{j};
    pop2{i}(r) = pop2{i}(r) + 0.4*rand(1,nm) - 0.2;
end
end

function pop2 = crossover(pop, n)
pop2 = cell(1,n);
l = length(pop);
li = length(pop{1});

for i = 1:n
    j(1) = randi(l);
    j(2) = randi(l);

    while j(1) == j(2)
        j(1) = randi(l);
        j(2) = randi(l);
    end
    r = randi(2, 1, li);
    
    pop2{i} = zeros(1, li);
    for k = 1:li
        pop2{i}(k) = pop{j(r(k))}(k);
    end
end
end