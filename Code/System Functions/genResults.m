function [diagnostics,R] = genResults(dataTable, reportType,  results,  cs, plotType)
% Display pertinent Loop and Response Statistics to Command Window in an easily readable fashion
% SDiable named “output” is a data structure containing:
%
% * a table of response data named: “ResponseData”
% * a branch with response statistics (averages and SDiances)
% * a branch containing ”cs.”
% * a branch containing theoretical response information
%
% Can save output to: ”Response_{Kp}_{Kd}_{Filter}_{Setpoint}_{nTrials}.mat”
% Automatically generate a report if Report = 1

%% Aes
aes.edgeAlpha = 0.45;
aes.faceAlpha = 0.2;
aes.inactiveColor = 'c';
aes.activeColor = 'g';

%% Plot Generation
avgResponse = grpstats(dataTable,'interval');
SDResponse = grpstats(dataTable,'interval', 'std');

diagnostics.trialData.AvgOvershoot = min(avgResponse.mean_pos);
diagnostics.trialData.overshoot_time = avgResponse.mean_t(find(avgResponse.mean_pos == diagnostics.trialData.AvgOvershoot));
diagnostics.trialData.PO = -100*diagnostics.trialData.AvgOvershoot/21;

if plotType == 1
    plotMultTrials_Pos(dataTable, avgResponse, aes, diagnostics);
    plotMultTrials_Input(dataTable, avgResponse, aes);
    plotMultTrials_Pos_Var(avgResponse,SDResponse);
    plotMultTrials_Input_Var(avgResponse,SDResponse);
elseif plotType == 0
    quickBaBplot(dataTable, avgResponse, SDResponse, aes, diagnostics)
else
    plotMultTrials_Pos(dataTable, avgResponse, aes, diagnostics);
    plotMultTrials_Input(dataTable, avgResponse, aes);
    plotMultTrials_Pos_Var(avgResponse,SDResponse);
    plotMultTrials_Input_Var(avgResponse,SDResponse);
    quickBaBplot(dataTable, avgResponse, SDResponse, aes, diagnostics)
end

%% Diagnostics
G_rebound = groupfilter(avgResponse,'mean_t',@(x) all(x > diagnostics.trialData.overshoot_time),'mean_t');
diagnostics.trialData.AvgRebound = max(G_rebound.mean_pos);
diagnostics.trialData.rebound_time = avgResponse.mean_t(find(G_rebound.mean_pos == diagnostics.trialData.AvgRebound))+diagnostics.trialData.overshoot_time;
diagnostics.trialData.P_rebound = 100*diagnostics.trialData.AvgRebound/diagnostics.trialData.AvgOvershoot;

fprintf('\n')
disp(['%%% Diagnostics %%%'])
fprintf('\n')
disp(['Average PO = ', num2str(diagnostics.trialData.PO), '% occuring at ', num2str(diagnostics.trialData.overshoot_time), ' seconds from start']);

diagnostics.settings.kp = cs.kp;
diagnostics.settings.kd = cs.kd;
diagnostics.settings.intervals = cs.interv;
diagnostics.settings.n_sample = cs.n;
diagnostics.settings.maxInput = cs.max;
diagnostics.settings.minInput = cs.min;
% diagnostics.settings.HistWeightFactor = cs.weightOld;
diagnostics.settings.nTrials = cs.nTrials;

diagnostics.efficiency.AvgLoopTime = mean(results.trialData.avgLoopTime);
diagnostics.efficiency.AvgLoopFrequency = mean(results.trialData.avgLoopFrequency);

fprintf('\n')
disp(['Average Loop Time = ', num2str(diagnostics.efficiency.AvgLoopTime ), ' seconds']);
disp(['Average Loop Frequency = ', num2str(diagnostics.efficiency.AvgLoopFrequency), ' cycles/second']);
fprintf('\n')

diagnostics.trialData.inactiveControlPercentage = mean(dataTable.inactiveController);
% diagnostics.trialData.Position = groupsummary(dataTable,'trial', {'all'}, 'pos');
% diagnostics.trialData.Input = groupsummary(dataTable,'trial', {'all'}, 'inputDeg');
G = groupfilter(dataTable,'interval',@(x) all(x == cs.interv),'interval');
diagnostics.trialData.meanLastPosition = mean(G.pos);
diagnostics.trialData.SDLastPosition = std(G.pos);
% diagnostics.trialData.meanCILastPosition = grpstats(G,'none','meanci')

disp(['Mean Last Position = ', num2str(diagnostics.trialData.meanLastPosition), ' cm']);
disp(['SD in Last Position = ', num2str(diagnostics.trialData.SDLastPosition), ' cm']);
fprintf('\n')
% disp(['95% CI for Last Position = ', num2str(diagnostics.trialData.meanCILastPosition), ' cm']);
disp(['Controller Inactive for ', num2str(diagnostics.trialData.inactiveControlPercentage*100), '% of total run time']);
fprintf('\n')

if plotType == 1
BaBHisto(dataTable, diagnostics);
BaBscatter(dataTable,aes);
end

%% Report
if reportType == 1
    [R] = buildReportGenerator;
elseif reportType == 2
    [R] = buildReportGeneratorPDF;
else
    R = 'Report was not requested'
end

end

