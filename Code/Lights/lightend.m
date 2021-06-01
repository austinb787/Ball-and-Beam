function lightend(cs)

% turn all off
writeDigitalPin(cs.a, cs.bulb.red, 0);

% turn green on
writeDigitalPin(cs.a, cs.bulb.red, 1);
pause(0.1);

% turn all off
writeDigitalPin(cs.a, cs.bulb.red, 0);

end