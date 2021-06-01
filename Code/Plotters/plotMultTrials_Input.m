function plotMultTrials_Input(dataTable, avgResponse, aes,diagnostics)
%PLOTTER This function edits figure aesthetics
%   Set desired properties below

h = figure();
h.Tag = 'ControllerResponse';
docked = 1;

for trial = 1:max(dataTable.trial)
    G = groupfilter(dataTable,'trial',@(x) all(x == trial),'trial');
    scatter(G.t(G.inactiveController),G.inputDeg(G.inactiveController),...
        'MarkerFaceColor', aes.inactiveColor, 'MarkerEdgeColor', 'b',...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
    hold all
    scatter(G.t(~G.inactiveController),G.inputDeg(~G.inactiveController),...
        'MarkerFaceColor',aes.activeColor, 'MarkerEdgeColor', [0.2 0.8 0.2],...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
end
plot(avgResponse.mean_t,avgResponse.mean_inputDeg,'color', [255/255, 83/255,  0]);
xlabel('Time (s)')
ylabel('Controller Input {\theta} (deg)')
yline(0)
ylim([-10 10])

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

% Set axes tick label font size, color, and line width
set(findall(gcf,'Type','axes'),...
    'FontSize',18,...
    'LineWidth',1.5,...
    'XColor','black',...
    'YColor','black')

% Set data line width and color
set(findall(gcf,'Type','line'),...
    'LineWidth',3)

% % Set data points type and color
% set(findall(gcf,'Type','Scatter'),...
%     'Marker','o',...
%     'MarkerFaceColor','green',...
%     'MarkerEdgeColor','none',...
%     'SizeData',75)

set(gcf,'color','w');

%% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end

end

