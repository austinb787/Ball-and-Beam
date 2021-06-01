close all
clc

%% Connect Arduino

% Make sure Arduino is connected
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

%% Test Sensors

testLength = 1000;
interpTableAll = load('SensorInterpTable.mat');
interpTable = interpTableAll.interpTable;

pos(1:testLength) = 0;
adcL(1:testLength) = 0;
adcR(1:testLength) =  0;
t(1:testLength) = 0;

h = figure();
h.WindowStyle = 'docked';
tic
for ii = 1:100
    [pos(ii), adcL(ii), adcR(ii)] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, 1, cs.fitresult);
    t(ii) = toc;
end
for ii = 101:testLength
    [pos(ii), adcL(ii), adcR(ii)] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, 1, cs.fitresult);
    t(ii) = toc;
    subplot(3,1,1)
    ylabel('Left')
    plot(t(ii-100:ii), adcL(ii-100:ii), 'r-o')
    subplot(3,1,2)
    ylabel('Right')
    plot(t(ii-100:ii), adcR(ii-100:ii), 'b-o')
    subplot(3,1,3)
    ylabel('Position')
    plot(t(ii-100:ii),pos(ii-100:ii))
end

disp(['Loop Frequency: ', num2str(testLength/t(testLength)), ' Hz'])