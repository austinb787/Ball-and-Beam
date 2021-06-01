%% testFilter.m
%% Setup
% Note: you must have already "started up" the project BaB

close all
clc

if exist('cs') == 0
    cs.a = arduino();
    
    cs.servoPin = 'D9';
    configurePin(cs.a,cs.servoPin,'servo')
    cs.s = servo(cs.a, cs.servoPin);
    
    cs.sensorPin1 = 'A0';
    cs.sensorPin2 = 'A1';
else
    disp('Arduino is already connected')
    connected = 1;
end

%% Test Routine
startup = 1000;
testLength = 50;
total = startup;
pos_all(1:total) = 0;
pos_lp(1:total) = 0;
% adcL(1:total) = 0;
% adcR(1:total) =  0;
% adcL_lp(1:total) = 0;
% adcR_lp(1:total) =  0;
t(1:total) = 0;
omega0 = 0.13; % Normalized passband
interpTableAll = load('/Users/austinberg/MATLAB/projects/BaBworkFlow/System/SensorInterpTable.mat');
interpTable = interpTableAll.interpTable;

tic
for ii = 1:startup
    adcL = readVoltage(cs.a, cs.sensorPin1);
    adcR = readVoltage(cs.a, cs.sensorPin2);
    leftpos = interp1(interpTable.LeftADC,interpTable.pos,adcL);
    rightpos = interp1(interpTable.RightADC,interpTable.pos,adcR);
    pos_all(ii) = (leftpos*adcL + rightpos*adcR)/(adcL+adcR);
    t(ii) = toc;
end

disp(['Loop Frequency: ', num2str(startup/t(startup)), ' Hz'])

% for ii = startup:startup+testLength
%     adcL = readVoltage(cs.a, cs.sensorPin1);
%     adcR = readVoltage(cs.a, cs.sensorPin2);
%     leftpos = interp1(interpTable.LeftADC,interpTable.pos,adcL);
%     rightpos = interp1(interpTable.RightADC,interpTable.pos,adcR);
%     pos_all(ii) = (leftpos*adcL + rightpos*adcR)/(adcL+adcR);
%     pos_lp(1:ii) = lowpass(pos_all(1:ii),omega0);
%     t(ii) = toc;
% end
% 
% disp(['Loop Frequency: ', num2str(testLength/t(total)), ' Hz'])

%%
h = figure();
h.WindowStyle = 'docked';
plot(t, pos_all, t, pos_lp)
xlabel('Time (s)'); ylabel('Position (cm)');
legend({'Sensors', 'Lowpass'})
plotter(gcf,1)

%{
%%
h = figure();
h.WindowStyle = 'docked';
subplot(2,2,1); plot(t,adcL,'r-o');
ylim([0 4]); xlabel('Time (s)'); ylabel('ADC'); title('Left');
plotter(gcf,1)
subplot(2,2,2); plot(t,adcR,'b-o')
ylim([0 4]); xlabel('Time (s)'); ylabel('ADC'); title('Right');
plotter(gcf,1)
subplot(2,2,3); plot(t,adcL_lp,'r-o');
ylim([0 4]); xlabel('Time (s)'); ylabel('ADC'); title('Left LP');
plotter(gcf,1)
subplot(2,2,4); plot(t,adcR_lp,'b-o')
ylim([0 4]); xlabel('Time (s)'); ylabel('ADC'); title('Right LP');
plotter(gcf,1)

%%
h = figure();
h.WindowStyle = 'docked';
subplot(1,2,1)
plot(t, adcL, t, adcL_lp)
subplot(1,2,2)
plot(t, adcR, t, adcR_lp)
%}

%% PSD
y = pos_all;
pwr = sum(y.^2)/length(y) % in watts
% Fs = 44;
% NFFT = length(pos_all);
% SegmentLength = NFFT;
% 
% % Power spectrum is computed when you pass a 'power' flag input
% [P,F] = pwelch(y,ones(SegmentLength,1),0,NFFT,Fs,'power');
% 
% helperFrequencyAnalysisPlot2(F,10*log10(P),'Frequency in Hz',...
%   'Power spectrum (dBW)',[],[],[-0.5 200])

