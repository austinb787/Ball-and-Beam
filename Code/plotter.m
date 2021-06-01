function plotter(gcf, docked)
%PLOTTER This function edits figure aesthetics
%   Set desired properties below

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
    'LineWidth',2)

% Set axes tick label font size, color, and line width
set(findall(gcf,'Type','axes'),...
    'FontSize',18,...
    'LineWidth',1.5,...
    'XColor','black',...
    'YColor','black')

% Set data points type and color
set(findall(gcf,'Type','Scatter'),...
    'Marker','d',...
    'MarkerEdgeColor','black')

if docked == 1
set(gcf, 'WindowStyle', 'docked')
end
    
end

