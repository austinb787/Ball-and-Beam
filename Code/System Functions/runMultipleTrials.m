function [dataTable, results] = runMultipleTrials(cs)
%runMultipleTrials Execute and summarize multiple ball and beam trials
%   Uses controller settings and desired number of trials ran

%% initialize logged variables
l = (cs.interv*cs.nTrials);
input(1:l) = cs.balanced;
vel(1:l) = 0;
pos(1:l) = 0;
t(1:l) = 0;
trialNum(1:l) = 0;

disp(['%%% Trials Being Run %%%'])
fprintf('\n')

tic
%% Run Trials
for trial = 1:cs.nTrials
    
    % Define indices
    indexStart = ((trial-1)*cs.interv)+1;
    indexEnd = indexStart+cs.interv-1;
    
    % Run 1 Trial
    if cs.type == "PD"
        [pos(indexStart:indexEnd),VEL(indexStart:indexEnd),inputNominal(indexStart:indexEnd),t(indexStart:indexEnd)] = runTrial(cs);
    elseif cs.type == "RL"
        [pos(indexStart:indexEnd),VEL(indexStart:indexEnd),inputNominal(indexStart:indexEnd),t(indexStart:indexEnd)] = RL_runTrial(cs);
    end
    run('BallRestartRoutine')
    
    inputDeg(indexStart:indexEnd) = (inputNominal(indexStart:indexEnd)-cs.balanced)*180;
    trialNum(indexStart:indexEnd) = trial;
    inactiveController(indexStart:indexEnd) = inputDeg(indexStart:indexEnd)==0;
    
    intervNum(indexStart:indexEnd) = 1:cs.interv;
    
    results.trialData.avgLoopTime(trial) = t(indexEnd)/cs.interv;
    results.trialData.avgLoopFrequency(trial) = 1/results.trialData.avgLoopTime(trial);
    
    for ii = (indexStart+1):indexEnd
        vel(ii) = VEL(ii)/(t(ii)-t(ii-1));
    end
    
    
    disp(['Trial ', num2str(trial), ' completed at ', num2str(results.trialData.avgLoopFrequency(trial)), ' Hz']);
end

%% Data Table

dataTable = table(trialNum', intervNum', t', pos', vel', inputNominal', inputDeg', inactiveController',...
    'VariableNames', {'trial', 'interval', 't', 'pos', 'vel', 'inputNominal', 'inputDeg', 'inactiveController'});

toc
end

