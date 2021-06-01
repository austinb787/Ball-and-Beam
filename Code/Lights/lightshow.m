function lightshow(cs)

% turn all off
writeDigitalPin(cs.a, cs.bulb.red, 0);
writeDigitalPin(cs.a, cs.bulb.green, 0);
writeDigitalPin(cs.a, cs.bulb.blue, 0);

% test
writeDigitalPin(cs.a, cs.bulb.red, 1);
pause(0.1);
writeDigitalPin(cs.a, cs.bulb.green, 1);
pause(0.1);
writeDigitalPin(cs.a, cs.bulb.blue, 1);
pause(0.1);

% turn all off
writeDigitalPin(cs.a, cs.bulb.red, 0);
writeDigitalPin(cs.a, cs.bulb.green, 0);
writeDigitalPin(cs.a, cs.bulb.blue, 0);

end