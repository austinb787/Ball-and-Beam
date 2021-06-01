function plotMultTrials_Pos(dataTable, avgResponse, aes, diagnostics)
%PLOTTER This function edits figure aesthetics
%   Set desired properties below

h = figure();
h.Tag = 'TimeResponse';
docked = 1;

for trial = 1:max(dataTable.trial)
    G = groupfilter(dataTable,'trial',@(x) all(x == trial),'trial');
    scatter(G.t(G.inactiveController),G.pos(G.inactiveController),...
        'MarkerFaceColor',aes.inactiveColor, 'MarkerEdgeColor', 'b',...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
    hold all
    scatter(G.t(~G.inactiveController),G.pos(~G.inactiveController),...
        'MarkerFaceColor',aes.activeColor, 'MarkerEdgeColor', [0.2 0.8 0.2],...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
end
plot(avgResponse.mean_t,avgResponse.mean_pos, 'color', [53/255,  79/255,  254/255]);
hold all
plot([diagnostics.trialData.overshoot_time diagnostics.trialData.overshoot_time], [0 diagnostics.trialData.AvgOvershoot], 'r','LineWidth', 4);
xlabel('Time (s)')
ylabel('Position (cm)')
yline(0)
ylim([-25 25])

%% Graphics
newcolors = [53,  79,  254;
    255, 83,  0;
    15,  200, 154;
    146, 0,   239]   /255;

colororder(newcolors);

grid on
grid minor
box on

% Set title, axes labels, and legend font size
set(findall(gcf,'Type','text'),...
    'FontSize',11,...
    'FontWeight', 'bold')

% Set data line width and color
set(findall(gcf,'Type','line'),...
    'LineWidth',3)

% Set axes tick label font size, color, and line width
set(findall(gcf,'Type','axes'),...
    'FontSize',18,...
    'LineWidth',1.5,...
    'XColor','black',...
    'YColor','black')

% % Set data points type and color
% set(findall(gcf,'Type','Scatter'),...
%     'Marker','o',...
%     'MarkerFaceColor', [15/255,  200/255, 154/255],...
%     'MarkerEdgeColor','none',...
%     'SizeData',75)

set(gcf,'color','w');

%% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end

end

