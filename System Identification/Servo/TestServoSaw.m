%% testServoSaw.m
% Setup
% Note: you must have already "started up" the project BaB
close all
clc
run('startup.m')
%% Sawtooth signal settings
clc
% Time settings
testTimeLength = 20;
samplePeriod = 0.03;
t = 0:samplePeriod:testTimeLength;

% Sawtooth settings
t1 = testTimeLength;
amplitude = 8; % degrees
f1 = 0.25;
y = sawtooth(2*pi*f1*t, 0.5)*-amplitude;
input = 0.48+y/180;

% Discrete-time check
Fs = 1/samplePeriod;
NyquistRate = 2*f1;
if Fs<NyquistRate
    warning('f1 is too large and downshifting will occur')
end

% Plot
tab = [t',y'];
subplot(2,1,1);
plot(t,y,'-o');
xlabel('Time (s)');
ylabel('Input Angle (degrees)');
title(['f1 = ', num2str(f1)]); 
plotter(gcf,1);
timestamp(1:length(y)) = 0;
subplot(2,1,2);
frequencyVtime = linspace(f1,f1,length(y));
plot(t,frequencyVtime,'-o')
xlabel('Time (s)');
ylabel('Frequency (Hz)');
plotter(gcf,1)
writePosition(cs.s,0.48+amplitude/180);
pause(1);

[pks,locs] = findpeaks(y,1:length(y));
% Run Test
writePosition(cs.s,input(1));
pause(3);
disp('Test Begun')
lightstart(cs);
for ii = 1:length(y)
    tic
    writePosition(cs.s,input(ii));
    if ismember(ii,locs) == 1
        lightpeak(cs);
    end
    while toc<=0.03
    end
    timestamp(ii) = toc;
end
lightend(cs);
writePosition(cs.s,0.48-amplitude/180);
fprintf('\n');
disp(['Test Done in ', num2str(sum(timestamp))]);
fprintf('\n');
disp('**Timestamp Diagnostics**')
disp(['Mean Timestamp: ', num2str(mean(timestamp))]);
disp(['SD Timestamp: ', num2str(std(timestamp))]);

%% Load Left Pin Position vs Time from ProcessServoTestVideo.m
% I used image processing in MATLAB
% load('ImgProcessTable_Chirp_5deg_10Hz.mat')

vidName = 'saw_amp8_f025_75v.mov';
[ImgProcessTable] = ProcessServoTestVideo(vidName);
%% Data Manipulation and Plotting

%{
% scatter(X,Y)
% xlabel('X')
% ylabel('Y')
% plotter(gcf,1)
% axis equal
% 
% plot(T,Y)
% xlabel('Time (s)')
% ylabel('Y')
% plotter(gcf,1)
%}
% load('Saw4.mat')
% f1 = 4

plus5 = min(ImgProcessTable.Y);
minus5 = max(ImgProcessTable.Y);

ImgProcessTable.Time = linspace(0,18.8,length(ImgProcessTable.X))';
upTo = find(ImgProcessTable.Time>=18.8-0.01,1);

T = ImgProcessTable.Time(1:upTo);
X = ImgProcessTable.X(1:upTo);
Y = ImgProcessTable.Y(1:upTo);

SamplePoints = [minus5, plus5];
CorrespondingValues = [-10,12];

beamAngle = interp1(SamplePoints,CorrespondingValues,Y);

% Plotting Process
figure()
subplot(3,1,1)
plot(T,Y)
xlabel('Time (s)')
ylabel('Tracked Image Position')
subplot(3,1,2)
plot(T,beamAngle)
xlabel('Time (s)')
ylabel('Beam Angle (deg)')
plotter(gcf,1)
subplot(3,1,3)
plot(t,y,'-o');
xlabel('Time (s)');
ylabel('Input Angle (degrees)');
title(['f1 = ', num2str(f1)]); 
plotter(gcf,1)
sgtitle('Using the Image Processing Toolbox to Find Beam Angle')

% Comparison Plot
h = figure();
h.WindowStyle = 'docked';
plot(t,y, 'b-')
hold all
plot(T,beamAngle,'-')
xlabel('Time (s)');
ylabel('Beam Angle (deg)');
legend({'Input','Image Processed Angle'}, 'location', 'best')
title([num2str(f1), 'Hz'])
plotter(gcf,1)

%% Creating timetables
inputTT = timetable(seconds(t)',y');
outputTT = timetable(seconds(T),beamAngle);
systemID = synchronize(inputTT,outputTT,seconds(T)','linear');
systemID = head(systemID, 3000)
Input = double(systemID{:,1});
Output = double(systemID{:,2});

%%
h = figure();
h.WindowStyle = 'docked';
scatter(Input, Output, 'd',...
    'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'b',...
    'MarkerFaceAlpha', 0.2, 'MarkerEdgeAlpha', 0.1);
hold all
yline(0, 'k', 'linewidth', 1);
xline(0, 'k', 'linewidth', 1);
plot(linspace(-10,10), linspace(-10,10), 'k--');
xlabel('Input Angle (degrees)');
ylabel('Actual Beam Angle (degrees)');
legend({['Correlation = ', num2str(corr(Input, Output))]}, 'location', 'best')
[t,s] = title(['Sawtooth Test with f = ', num2str(f1), ' Hz'], 'Continuous signal + discrete commands (f = 33 Hz)')
plotter(gcf,1)



