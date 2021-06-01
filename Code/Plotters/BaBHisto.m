function BaBHisto(dataTable, diagnostics)
%% Start
G = groupfilter(dataTable,'t',@(x) all(and(x >= 0, x < 1)),'t');
h = figure();
h.Tag = 'StartHist';
docked = 1;

box on

subplot(2,2,1)
histogram(G.pos, 'FaceColor', [53,  79,  254]/255)
xlabel('Position (cm)')
xlim([-20 20])

subplot(2,2,2)
histogram(G.vel, 'FaceColor', [255, 83,  0]/255)
xlabel('Velocity (cm/s)'); xlim([-1000 1000])

subplot(2,2,3)
histogram(G.inputDeg, 'FaceColor', [15,  200, 154]/255)
xlabel('Controller Input (deg)'); xlim([-8 8])

subplot(2,2,4)
histogram(G.t, 'FaceColor', 'white', 'LineWidth', 1.25)
xlabel('Time (s)'); xlim([0 max(dataTable.t)])
sgtitle('Start of Trial', 'FontSize', 24, 'FontWeight', 'bold')

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

% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end
%% Overshoot Period
G = groupfilter(dataTable,'t',@(x) all(and(x > diagnostics.trialData.overshoot_time-0.2, x < diagnostics.trialData.overshoot_time+0.2)),'t');
h = figure();
h.Tag = 'OvereshootHist';
docked = 1;

box on

subplot(2,2,1)
histogram(G.pos, 'FaceColor', [53,  79,  254]/255)
xlabel('Position (cm)'); xlim([-20 20]) 

subplot(2,2,2)
histogram(G.vel, 'FaceColor', [255, 83,  0]/255)
xlabel('Velocity (cm/s)'); xlim([-1000 1000])

subplot(2,2,3)
histogram(G.inputDeg, 'FaceColor', [15,  200, 154]/255)
xlabel('Controller Input (deg)'); xlim([-8 8])

subplot(2,2,4)
histogram(G.t, 'FaceColor', 'white', 'LineWidth', 1.25)
xlabel('Time (s)'); xlim([0 max(dataTable.t)])
sgtitle('Overshoot +/- 0.2 second', 'FontSize', 24, 'FontWeight', 'bold')

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

% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end
%% Rebound Period
G = groupfilter(dataTable,'t',@(x) all(and(x > diagnostics.trialData.rebound_time-0.2, x < diagnostics.trialData.rebound_time+0.2)),'t');
h = figure();
h.Tag = 'ReboundHist';
docked = 1;

box on

subplot(2,2,1)
histogram(G.pos, 'FaceColor', [53,  79,  254]/255)
xlabel('Position (cm)'); xlim([-20 20]) 

subplot(2,2,2)
histogram(G.vel, 'FaceColor', [255, 83,  0]/255)
xlabel('Velocity (cm/s)'); xlim([-1000 1000])

subplot(2,2,3)
histogram(G.inputDeg, 'FaceColor', [15,  200, 154]/255)
xlabel('Controller Input (deg)'); xlim([-8 8])

subplot(2,2,4)
histogram(G.t, 'FaceColor', 'white', 'LineWidth', 1.25)
xlabel('Time (s)'); xlim([0 max(dataTable.t)])
sgtitle('Rebound +/- 0.2 second', 'FontSize', 24, 'FontWeight', 'bold')

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

% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end
%% End Period
G = groupfilter(dataTable,'interval',@(x) all(x > max(dataTable.interval)*0.9),'interval');
h = figure();
h.Tag = 'EndHist';
docked = 1;

box on

subplot(2,2,1)
histogram(G.pos, 'FaceColor', [53,  79,  254]/255)
xlabel('Position (cm)'); xlim([-20 20]) 

subplot(2,2,2)
histogram(G.vel, 'FaceColor', [255, 83,  0]/255)
xlabel('Velocity (cm/s)'); xlim([-1000 1000])

subplot(2,2,3)
histogram(G.inputDeg, 'FaceColor', [15,  200, 154]/255)
xlabel('Controller Input (deg)'); xlim([-8 8])

subplot(2,2,4)
histogram(G.t, 'FaceColor', 'white', 'LineWidth', 1.25)
xlabel('Time (s)'); xlim([0 max(dataTable.t)])
sgtitle('End of Trial', 'FontSize', 24, 'FontWeight', 'bold')

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

% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end
%% Total
G = dataTable;
h = figure();
h.Tag = 'TotalHist';
docked = 1;

box on

subplot(2,2,1)
histogram(G.pos, 'FaceColor', [53,  79,  254]/255)
xlabel('Position (cm)'); xlim([-20 20]) 

subplot(2,2,2)
histogram(G.vel, 'FaceColor', [255, 83,  0]/255)
xlabel('Velocity (cm/s)'); xlim([-1000 1000])

subplot(2,2,3)
histogram(G.inputDeg, 'FaceColor', [15,  200, 154]/255)
xlabel('Controller Input (deg)'); xlim([-8 8])

subplot(2,2,4)
histogram(G.t, 'FaceColor', 'white', 'LineWidth', 1.25, 'BinWidth', 1)
xlabel('Time (s)'); xlim([0 max(dataTable.t)])
sgtitle('All Times', 'FontSize', 24, 'FontWeight', 'bold')

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

% Docking
if docked == 1
    set(gcf, 'WindowStyle', 'docked')
end
end