%% testServoChirp.m
% Setup
% Note: you must have already "started up" the project BaB
close all
clc
run('startup.m')
%% Chirp signal settings
clc
% Time settings
testTimeLength = 10;
samplePeriod = 0.03;
t = 0:samplePeriod:testTimeLength;

% Chirp settings
t1 = testTimeLength;
f0 = 0.1;
f1 = 5;
amplitude = 5; % degrees
y = chirp(t,f0,t1,f1)*amplitude;
input = 0.48+y/180;

% Discrete-time check
Fs = 1/0.03;
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
title(['f0 = ', num2str(f0), ' Hz, f1 = ', num2str(f1)]); 
plotter(gcf,1);
timestamp(1:length(y)) = 0;
subplot(2,1,2);
frequencyVtime = linspace(f0,f1,length(y));
plot(t,frequencyVtime,'-o')
xlabel('Time (s)');
ylabel('Frequency (Hz)');
plotter(gcf,1)

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
disp(['Test Done in ', num2str(sum(timestamp))]);
fprintf('\n');
disp('**Timestamp Diagnostics**')
disp(['Mean Timestamp: ', num2str(mean(timestamp))]);
disp(['SD Timestamp: ', num2str(std(timestamp))]);

%% Load Left Pin Position vs Time from ProcessServoTestVideo.m
% I used image processing in MATLAB
% load('ImgProcessTable_Chirp_5deg_10Hz.mat')

vidName = 'chirp_amp5_75v.mov';
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

ImgProcessTable.Time = linspace(0,8.3,length(ImgProcessTable.X))';
upTo = find(ImgProcessTable.Time>=8.3-0.01,1);

T = ImgProcessTable.Time(1:upTo);
X = ImgProcessTable.X(1:upTo);
Y = ImgProcessTable.Y(1:upTo);

SamplePoints = [minus5, plus5];
CorrespondingValues = [-8,8];

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
plot(t,y, 'c-')
hold all
plot(T,beamAngle,'-')
xlabel('Time (s)');
ylabel('Beam Angle (deg)');
legend({'Input','Image Processed Angle'}, 'location', 'best')
title([num2str(f1), 'Hz'])
plotter(gcf,1)

figure;
plot(t(round(1:length(t))),y(round(1:length(t))),T,beamAngle)
xlabel('Time (s)');
ylabel('Beam Angle (deg)');
legend({'Input','Image Processed Angle'}, 'location', 'best')
plotter(gcf,1)

%% Creating timetables
inputTT = timetable(seconds(t)',y');
outputTT = timetable(seconds(T),beamAngle);
systemID = synchronize(inputTT,outputTT,seconds(t)','linear');
Input = double(systemID{:,1});
Output = double(systemID{:,2});

%%
figure(14);
xlabel('Time (s)');
ylabel('Beam Angle (deg)');
%%
comet(T,beamAngle);



