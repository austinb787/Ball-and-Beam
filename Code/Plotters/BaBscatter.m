function BaBscatter(dataTable,aes)

%% Scatter Position verus Controller Input
h = figure();
h.Tag = 'ScatterPos';
docked = 1;
subplot(1,3,1)
for trial = 1:max(dataTable.trial)
    G = groupfilter(dataTable,'trial',@(x) all(x == trial),'trial');
    scatter(G.inputDeg(G.inactiveController),G.pos(G.inactiveController),...
        'MarkerFaceColor',aes.inactiveColor, 'MarkerEdgeColor', 'b',...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
    hold all
    scatter(G.inputDeg(~G.inactiveController),G.pos(~G.inactiveController),...
        'MarkerFaceColor',aes.activeColor, 'MarkerEdgeColor', [0.1 0.6 0.1],...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
end
xlabel('Controller Input (Deg)')
ylabel('Position (cm)')
yline(0); xline(0)
ylim([-25 25])

% Graphics
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


%% Scatter Velocity verus Controller Input
subplot(1,3,2)

for trial = 1:max(dataTable.trial)
    G = groupfilter(dataTable,'trial',@(x) all(x == trial),'trial');
    scatter(G.inputDeg(G.inactiveController),G.vel(G.inactiveController),...
        'MarkerFaceColor',aes.inactiveColor, 'MarkerEdgeColor', 'b',...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
    hold all
    scatter(G.inputDeg(~G.inactiveController),G.vel(~G.inactiveController),...
        'MarkerFaceColor',aes.activeColor, 'MarkerEdgeColor', [0.1 0.6 0.1],...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
end
xlabel('Controller Input (Deg)')
ylabel('Velocity (cm/s)')
yline(0); xline(0)

% Graphics
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

%% Scatter Velocity verus Position
subplot(1,3,3)

for trial = 1:max(dataTable.trial)
    G = groupfilter(dataTable,'trial',@(x) all(x == trial),'trial');
    scatter(G.vel(G.inactiveController),G.pos(G.inactiveController),...
        'MarkerFaceColor',aes.inactiveColor, 'MarkerEdgeColor', 'b',...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
    hold all
    scatter(G.vel(~G.inactiveController),G.pos(~G.inactiveController),...
        'MarkerFaceColor',aes.activeColor, 'MarkerEdgeColor', [0.1 0.6 0.1],...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
end
xlabel('Velocity (cm/s)')
ylabel('Position (cm)')
yline(0); xline(0)
ylim([-25 25])

% Graphics
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
% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end
end
