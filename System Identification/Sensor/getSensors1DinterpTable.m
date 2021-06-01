%% testSensors.m
% Figure out if my sensors are actuing up by testing the getPos function
%% Setup
% Note: you must have already "started up" the project BaB

close all
clc

% if exist('connected') == 0
%     run('startup.m')
% end

interp.actBallPos = -20:5:20;
interp.actBallPos(10) = -28;
interp.actBallPos(11) = 28;
interp.adcL = zeros(size(interp.actBallPos));
interp.adcR = zeros(size(interp.actBallPos));
interpTable = table(interp.actBallPos', interp.adcL', interp.adcR', ...
    'VariableNames', {'Ball Position (cm)', 'LeftADC', 'RightADC'});

%% *** Hardcode ADC Values *** %
% Minus == Left
% Positive == Right

% Minus 20
interpTable.LeftADC(1) = 3.1649;
interpTable.RightADC(1) = 0.8088;

% Minus 15
interpTable.LeftADC(2) = 2.076;
interpTable.RightADC(2) = 0.8871;

% Minus 10
interpTable.LeftADC(3) = 1.5572;
interpTable.RightADC(3) = 0.97996;

% Minus 5
interpTable.LeftADC(4) = 1.2593;
interpTable.RightADC(4) = 1.0909;

% Zero
interpTable.LeftADC(5) = 1.1387;
interpTable.RightADC(5) = 1.1934;

% 5
interpTable.LeftADC(6) = 0.94917;
interpTable.RightADC(6) = 1.3495;

% 10
interpTable.LeftADC(7) = 0.88661;
interpTable.RightADC(7) = 1.593;

% 15
interpTable.LeftADC(8) = 0.77341;
interpTable.RightADC(8) = 2.0287;

% 20
interpTable.LeftADC(9) = 0.68368;
interpTable.RightADC(9) = 3.0636;

%% Getting boundary condition points

% Minus 28
interpTable.LeftADC(10) = 2.42;
interpTable.RightADC(10) = 0.97;

% Minus 28
interpTable.LeftADC(11) = 0.53;
interpTable.RightADC(11) = 2.36;

% % Run test
% 
% testLength = 50;
% [MeanADC_L, MeanADC_R] = SensorTestRoutine(cs, testLength);

% % 2D-Curve Fit
% x = interp.actBallPos;
% yLeft = interpTable.LeftADC;
% yRight = interpTable.RightADC;
 
% % [LeftFitResult, LeftGOF, LeftxData, LeftyData] = createFitLeftSensor(x, yRight);
% % [RightFitResult, RightGOF, RightxData, RightyData] = createFitRightSensor(x, yLeft);
% 
% % Plot
% figure();
% scatter(interpTable.('Ball Position (cm)'), interpTable.LeftADC, 'r')
% hold all
% scatter(interpTable.('Ball Position (cm)'), interpTable.RightADC, 'b')
% plotter(gcf,1)
% xlabel('Ball Position (cm)')
% ylabel('ADC Voltage')
% legend({'Left','Right'}, 'location', 'north')

% Change untidy name
interpTable.Properties.VariableNames{1} = 'pos';

interpTable = sortrows(interpTable,1:3,'ascend');

% Test for 40 cm
% [MeanADC_L, MeanADC_R] = SensorTestRoutine(cs, 200)
% 
% adc_40r = 2.36; % on right sensor, right adc
% adc_40l = 0.53; % on right sensor, left adc
% 
% adc_minus40r = 0.97; % on left sensor, right adc
% adc_minus40l = 2.42; % on left sensor, left adc
%% Make surface
% figure;plot3(interpTable.RightADC,interpTable.LeftADC,interpTable.pos);

x = interpTable.RightADC;
y = interpTable.LeftADC;
z = interpTable.pos;
[fitresult, gof] = createFit(x, y, z)

%%

fitresult(3, 1)

%% Test
% SensorTestRoutine(cs, 50)
function [MeanADC_L, MeanADC_R] = SensorTestRoutine(cs, testLength)

pos(1:testLength) = 0;
adcL(1:testLength) = 0;
adcR(1:testLength) =  0;
t(1:testLength) = 0;

h = figure();
h.WindowStyle = 'docked';
tic
for ii = 1:testLength
    [pos(ii), adcL(ii), adcR(ii)] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n, cs.fitresult);
    t(ii) = toc;
    subplot(2,1,1)
    scatter(t(1:ii), adcL(1:ii), 'r')
    hold all
    scatter(t(1:ii), adcR(1:ii), 'b')
    l_mean(ii) = mean(adcL(1:ii));
    yline(l_mean(ii), 'r--')
    r_mean(ii) = mean(adcR(1:ii));
    yline(r_mean(ii), 'b--')
    hold off
    subplot(2,1,2)
    plot(t(1:ii),l_mean(1:ii), 'r')
    hold all
    plot(t(1:ii),r_mean(1:ii), 'b')
%     ylim([0 3])
    title(['Left = ', num2str(l_mean(ii)), ' | Right = ', num2str(r_mean(ii))], 'FontSize', 20)
    hold off
end

MeanADC_L = l_mean(ii);
    
MeanADC_R = r_mean(ii);

end