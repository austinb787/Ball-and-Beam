function [pos, adcL, adcR] = getPos(a, sensorPin1, sensorPin2, n, fitresult)
%getPos Get the mean position reading of the ball using both sensors 
%   Average of n readings

posAll(1:n)= 0;
for ii = 1:n
adcL = readVoltage(a, sensorPin1);
adcR = readVoltage(a, sensorPin2);

% Sensor adc-to-position Interpolation Functions
% leftpos = adcL^3 * -0.0000006 + 0.0009 * adcL^2 - 0.4802 * adcL + 68.273;
% rightpos = adcR^3 * 0.0000005 - 0.0008 * adcR^2 - 0.4539 * adcR - 68.243;

% leftpos = interp1(interpTable.LeftADC,interpTable.pos,adcL);
% rightpos = interp1(interpTable.RightADC,interpTable.pos,adcR);

posAll(ii) = fitresult(adcR, adcL);

% Position Function
% weighted for adc value to increase resolution near endpoints
% posAll(ii) = (leftpos*adcL + rightpos*adcR)/(adcL+adcR); % centimeters
end

pos = mean(posAll);
end

