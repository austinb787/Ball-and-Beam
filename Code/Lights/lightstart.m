function lightstart(cs)

% turn all off
writeDigitalPin(cs.a, cs.bulb.green, 0);

% turn green on
writeDigitalPin(cs.a, cs.bulb.green, 1);
pause(0.1);

% turn all off
writeDigitalPin(cs.a, cs.bulb.green, 0);

end