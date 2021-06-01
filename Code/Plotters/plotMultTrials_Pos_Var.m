function plotMultTrials_Pos_Var(avgResponse,varResponse)
%PLOTTER This function edits figure aesthetics
%   Set desired properties below

h = figure();
h.Tag = 'TimeResponseVar';
docked = 1;

area(avgResponse.mean_t,varResponse.std_pos,...
    'FaceColor', [53/255,  79/255,  254/255],...
    'FaceAlpha', 0.5,...
    'EdgeAlpha', 0);
xlabel('Time (s)')
ylabel('SD in Position (cm)')
yline(0)
ylim([0 inf])
xlim([0 max(avgResponse.mean_t)])

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

