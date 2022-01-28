%% Pruebas iniciales

addpath ..\MONZA_SIMULACIÓN
addpath ..\
addpath ..\Fuzzy
global riel %#ok<*NUSED>

%% Parámetros de simulación
Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 2;
tsim = 30;
dibujos = 0;
animacion = 1;

doTraining = true;

mdl = 'Monza_controlado';
agentblk = 'Monza_controlado/RL Agent';

%% Creación interfaz de entorno
numObservations = 4;
observationInfo = rlNumericSpec([numObservations 1]);
observationInfo.Name = 'observations';
observationInfo.Description = 'informacion del error';

% Información de la acción
numActions = 1;
actionInfo = rlNumericSpec([numActions 1]);
actionInfo.Name = 'action';

% Definición del entorno
env = rlSimulinkEnv(mdl,agentblk,observationInfo,actionInfo);

% Función de reset
env.ResetFcn = @(in)localResetfcn(in);

save entorno env

obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

%% Create DQN Agent
dnn = [
    featureInputLayer(3,'Normalization','none','Name','state')
    fullyConnectedLayer(24,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(48,'Name','CriticStateFC2')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(3,'Name','output')];

figure
plot(layerGraph(dnn))

criticOpts = rlRepresentationOptions('LearnRate',0.001,'GradientThreshold',1);

critic = rlQValueRepresentation(dnn,obsInfo,actInfo,'Observation',{'state'},criticOpts);

agentOptions = rlDQNAgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',3000,... 
    'UseDoubleDQN',false,...
    'DiscountFactor',0.9,...
    'MiniBatchSize',64);

agent = rlDQNAgent(critic,agentOptions);

%% Entrenamiento
trainingOptions = rlTrainingOptions(...
    'MaxEpisodes',1000,...
    'MaxStepsPerEpisode',500,...
    'ScoreAveragingWindowLength',5,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',-1100,...
    'SaveAgentCriteria','EpisodeReward',...
    'SaveAgentValue',-1100);

if doTraining
    % Train the agent.
    trainingStats = train(agent,env,trainingOptions);
else
    % Load the pretrained agent for the example.
    %load('SimulinkPendulumDQNMulti.mat','agent');
end


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