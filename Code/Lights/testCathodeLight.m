%% Test lightbulbs

cs.bulb.red = 'D6';
cs.bulb.green = 'D5';
cs.bulb.blue = 'D3';

% turn all off
writeDigitalPin(cs.a, cs.bulb.red, 0);
writeDigitalPin(cs.a, cs.bulb.green, 0);
writeDigitalPin(cs.a, cs.bulb.blue, 0);

% test
writeDigitalPin(cs.a, cs.bulb.red, 1);
pause(1);
writeDigitalPin(cs.a, cs.bulb.green, 1);
pause(1);
writeDigitalPin(cs.a, cs.bulb.blue, 1);

writeDigitalPin(cs.a, cs.bulb.red, 0);
writeDigitalPin(cs.a, cs.bulb.green, 0);
writeDigitalPin(cs.a, cs.bulb.blue, 0);

% see all the colors
% there are 3! combinations
for r = 0:1
    for g = 0:1
        for b = 0:1
            writeDigitalPin(cs.a, cs.bulb.red, r);
            pause(0.1);
            writeDigitalPin(cs.a, cs.bulb.green, g);
            pause(0.1);
            writeDigitalPin(cs.a, cs.bulb.blue, b);
            pause(0.1);
        end
    end
end

writeDigitalPin(cs.a, cs.bulb.red, 0);
writeDigitalPin(cs.a, cs.bulb.green, 0);
writeDigitalPin(cs.a, cs.bulb.blue, 0);