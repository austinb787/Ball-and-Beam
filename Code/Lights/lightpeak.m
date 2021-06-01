function lightpeak(cs)

% turn all off
writeDigitalPin(cs.a, cs.bulb.blue, 0);

% turn green on
writeDigitalPin(cs.a, cs.bulb.blue, 1);
pause(0.1);

% turn all off
writeDigitalPin(cs.a, cs.bulb.blue, 0);

end