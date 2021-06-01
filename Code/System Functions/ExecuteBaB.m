%% ExecuteBaB.m
% Executes nTrials on the ball and beam system and generates a report
if exist('connected') == 0
    run('startup.m')
end

run('ControlSet.mlx')

% Run on Hardware
[dataTable, results] = runMultipleTrials(cs);