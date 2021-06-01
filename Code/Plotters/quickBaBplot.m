function quickBaBplot(dataTable, avgResponse, varResponse, aes, diagnostics)
h = figure();
h.Tag = 'quickPlot';
docked = 1;
%% Position
subplot(2,2,1)
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
xlabel('Time (s)')
ylabel('Position (cm)')
yline(0)
ylim([-35 35])

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

set(gcf,'color','w');
%% Input
subplot(2,2,2)
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
%% Velocity
% Position SD
%{
subplot(2,2,3)
area(avgResponse.mean_t,varResponse.std_pos,...
    'FaceColor', [53/255,  79/255,  254/255],...
    'FaceAlpha', 0.5);
xlabel('Time (s)')
ylabel('Variance in Position (cm^2)')
yline(0)
ylim([0 inf])
xlim([0 max(avgResponse.mean_t)])
%}

subplot(2,2,3)
for trial = 1:max(dataTable.trial)
    G = groupfilter(dataTable,'trial',@(x) all(x == trial),'trial');
    scatter(G.t(G.inactiveController),G.vel(G.inactiveController),...
        'MarkerFaceColor',aes.inactiveColor, 'MarkerEdgeColor', 'b',...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
    hold all
    scatter(G.t(~G.inactiveController),G.vel(~G.inactiveController),...
        'MarkerFaceColor',aes.activeColor, 'MarkerEdgeColor', [0.2 0.8 0.2],...
        'MarkerFaceAlpha', aes.faceAlpha, 'MarkerEdgeAlpha', aes.edgeAlpha)
end
plot(avgResponse.mean_t,avgResponse.mean_vel, 'color', [146/255,  0/255,  239/255]);
xlabel('Time (s)')
ylabel('Velocity (cm/s)')
yline(0)

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
%% Time Histogram
subplot(2,2,4)
%{
area(avgResponse.mean_t,varResponse.std_inputDeg,...
    'FaceColor', [255/255, 83/255,  0],...
    'FaceAlpha', 0.5);
xlabel('Time (s)')
ylabel('Variance in Beam Angle (deg^2)')
yline(0)
ylim([0 inf])
xlim([0 max(avgResponse.mean_t)])
%}

box on

for ii = 2:max(dataTable.interval)
deltaT(ii) = dataTable.t(ii)-dataTable.t(ii-1);
end
histogram(deltaT, 'FaceColor', [53,  79,  254]/255)
xlabel('Loop Time (s)')

% Grahpics
newcolors = [53,  79,  254;
    255, 83,  0;
    15,  200, 154;
    146, 0,   239]   /255;

colororder(newcolors);

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

set(gcf,'color','w');

% % Graphics
% newcolors = [53,  79,  254;
%     255, 83,  0;
%     15,  200, 154;
%     146, 0,   239]   /255;
% 
% colororder(newcolors);
% 
% grid on
% grid minor
% box on
% 
% % Set title, axes labels, and legend font size
% set(findall(gcf,'Type','text'),...
%     'FontSize',11,...
%     'FontWeight', 'bold')
% 
% % Set data line width and color
% set(findall(gcf,'Type','line'),...
%     'LineWidth',3)
% 
% % Set axes tick label font size, color, and line width
% set(findall(gcf,'Type','axes'),...
%     'FontSize',18,...
%     'LineWidth',1.5,...
%     'XColor','black',...
%     'YColor','black')

% % Set data points type and color
% set(findall(gcf,'Type','Scatter'),...
%     'Marker','o',...
%     'MarkerFaceColor', [15/255,  200/255, 154/255],...
%     'MarkerEdgeColor','none',...
%     'SizeData',75)

% set(gcf,'color','w');
%% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end
end

