function [pos, vel, input,t] = runTrial(cs)
%
% * Contains simple PD controller loop
% * Easily changeable settings
% * Custom warnings in failure cases
% * Maximize loop frequency
% * Easily changeable settings
%

%% initialize logged variables
input(1:cs.interv) = cs.balanced;
pos(1:cs.interv) = 0;
vel(1:cs.interv) = 0;
t(1:cs.interv) = 0;
% [pos(1), ~, ~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n_startup, cs.interp.interpTable);
[pos(1), ~, ~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n_startup, cs.fitresult);
stopSmoothIndex = 100;
delta = 1/((stopSmoothIndex-2)/(cs.weightOldPos-0.99));

%% Loop
lightstart(cs);
tic
for ii = 2:cs.interv
%     [pos1,~,~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n, cs.interp.interpTable);
    [pos1,~,~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n, cs.fitresult);
    if ii<=stopSmoothIndex
        cswold = 0.99+(ii-2)*delta;
        cswnew = 1-cswold;
        pos(ii) = cswold*pos(ii-1)+cswnew*pos1;
    else
        pos(ii) = cs.weightOldPos*pos(ii-1) + cs.weightNewPos*pos1;
    end
    t(ii) = toc;
    vel(ii) = cs.weightOldVel*vel(ii-1) + cs.weightNewVel*(pos(ii)-pos(ii-1))/(t(ii)-t(ii-1));
    input(ii) = cs.weightOldInput*input(ii-1) + cs.weightNewInput*min(cs.max, max(cs.min, cs.balanced-cs.kp*pos(ii)-cs.kd*vel(ii)));
    if ii > cs.dataPoints
        if max(abs(pos((ii-cs.dataPoints):ii)))<cs.posTol && abs(mean(vel((ii-cs.dataPoints):ii)))<cs.velTol
            input(ii) = cs.balanced;
        end
    end
    writePosition(cs.s,input(ii));
end
lightend(cs);
end



