Ts = 0.033; % no cambiar este valor porque nos dicen que no lo hagamos 
dificultad = 2;
tsim = 30;
doTraining = True;

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
actionInfo.Name = 'tau';

% Definición del entorno
env = rlSimulinkEnv(mdl,agentblk,observationInfo,actionInfo);

% Randomización de la referencia
env.ResetFcn = @(in)localResetfcn(in);

obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);

rng = (0)

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