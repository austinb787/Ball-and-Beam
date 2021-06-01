%% Generate Results
% close all
reportType = 1; % 0 == No Report, 1 == HTML, 2 == PDF
plotType = 1; % 0 == QuickPlot, 1 == Individual, 2 == Both (Good for testing)
[diagnostics, R] = genResults(dataTable, reportType, results, cs, plotType);