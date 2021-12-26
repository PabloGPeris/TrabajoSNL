function u = ControlBorrosoErrorLUT(error, derror, LUT, FSetError, FSetDError)
%u = CONTROLBORROSOERRORLUT(Yr, Yk, U, FSetError, FsetDError)

%% Fuzzification
mu_error = Fuzzification(FSetError, error);
mu_derror = Fuzzification(FSetDError, derror);

%% Inferencia
w = mu_derror' * mu_error;

%% Controlador
reglas = w.*LUT;

%% Defuzzification
u = sum(sum(reglas));

end