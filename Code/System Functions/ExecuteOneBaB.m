%% ExecuteBaB.m
% Executes nTrials on the ball and beam system and generates a report
if exist('connected') == 0
    run('startup.m')
end

run('ControlSet.mlx')
cs.nTrials = 1;

% Run on Hardware
[dataTable, results] = runMultipleTrials(cs);

close all
reportType = 0; % 0 == No Report, 1 == HTML, 2 == PDF
plotType = 0; % 0 == QuickPlot, 1 == Individual, 2 == Both (Good for testing)
[diagnostics, R] = genResults(dataTable, reportType, results, cs, plotType);