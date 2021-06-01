%% testServoSquare.m
% Setup
% Note: you must have already "started up" the project BaB
close all
clc
run('startup.m')
%% Square signal settings
clc

testTimeLength = 10;
amplitude = 6;
samplePeriod = 0.03;
f1 = 0.5;

t = 0:samplePeriod:testTimeLength;
y = square(f1*pi*t)*amplitude;
y_real = square(f1*pi*t)*amplitude;
input = 0.48+y/180;
plot(t,y, '-o')
plotter(gcf,1);

[pks,locs] = findpeaks(y,1:length(y));

%% Run Test
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

vidName = 'step_amp6_75v.mov';
[ImgProcessTable] = ProcessServoTestVideo(vidName);

%% Comparison Plot

plusNum = min(ImgProcessTable.Y);
minusNum = max(ImgProcessTable.Y);

ImgProcessTable.Time = linspace(0,9.7,length(ImgProcessTable.X))';
upTo = find(ImgProcessTable.Time>=9.7-0.01,1);
T = ImgProcessTable.Time(1:upTo);
X = ImgProcessTable.X(1:upTo);
Y = ImgProcessTable.Y(1:upTo);

SamplePoints = [minusNum, plusNum];
CorrespondingValues = [-8,8]; % get this by looking at video

beamAngle = interp1(SamplePoints,CorrespondingValues,Y);

h = figure();
h.WindowStyle = 'docked';
plot(t,y, 'c-')
hold all
plot(T,beamAngle,'-o')
xlabel('Time (s)');
ylabel('Beam Angle (deg)');
legend({'Input','Image Processed Angle'}, 'location', 'best')
title([num2str(f1), 'Hz'])
plotter(gcf,1)

figure;
plot(t,y,T,beamAngle)
xlabel('Time (s)');
ylabel('Beam Angle (deg)');
legend({'Input','Image Processed Angle'}, 'location', 'best')
plotter(gcf,1)

%%
% Creating timetables
inputTT = timetable(seconds(t)',y');
inputTT = lag(inputTT,2);
inputTT = inputTT(1:end,:);
outputTT = timetable(seconds(T),beamAngle);
outputTT = lag(outputTT,-1);
outputTT = outputTT(1:end,:);
systemID = synchronize(inputTT, outputTT, seconds(T)','linear');
% systemID = systemID(300:1275,:);

Time = seconds(systemID.Time);
Input = double(systemID{:,1});
Output = double(systemID{:,2});



figure;
plot(Time,Input,Time,Output)
xlabel('Time (s)');
ylabel('Beam Angle (deg)');
legend({'Input','Image Processed Angle'}, 'location', 'best')
plotter(gcf,1)

% figure;
% plot(t,y,T,beamAngle)
% xlabel('Time (s)');
% ylabel('Beam Angle (deg)');
% legend({'Input','Image Processed Angle'}, 'location', 'best')
% plotter(gcf,1)

%%

Input1 = double(systemID{492:977,1});
Output1 = double(systemID{492:977,2});

Input2 = double(systemID{977:1455,1});
Output2 = double(systemID{977:1455,2});

Input3 = double(systemID{1455:1939,1});
Output3 = double(systemID{1455:1939,2});