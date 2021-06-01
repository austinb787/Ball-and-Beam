function [pos, vel, input,t] = RL_runTrial(cs)
%
% * Contains RL Agent controller loop
% * Easily changeable settings
% * Custom warnings in failure cases
% * Maximize loop frequency
% * Easily changeable settings
%

%% initialize logged variables
input(1:cs.interv) = cs.balanced;
pos(1:cs.interv) = 0;
vel(1:cs.interv) = 0;
observation(1:2, 1, 1) = [pos(1) vel(1)];
t(1:cs.interv) = 0;
[pos(1), ~, ~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n_startup, cs.fitresult);

%% Loop
lightstart(cs);
tic
for ii = 2:cs.interv
    [pos1, ~, ~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n, cs.fitresult);
    pos(ii) = cs.weightOldPos*pos(ii-1) + cs.weightNewPos*pos1;
    t(ii) = toc;
    vel(ii) = cs.weightOldVel*vel(ii-1) + cs.weightNewVel*(pos(ii)-pos(ii-1))/(t(ii)-t(ii-1));
    observation(1:2, 1, 1) = [pos(ii) vel(ii)];
    new_input = cs.balanced + (evaluatePolicy_itWorked1(observation))/2;
    input(ii) = cs.weightOldInput*input(ii-1) + cs.weightNewInput*new_input;
%     if ii > cs.dataPoints
%         if max(abs(pos((ii-cs.dataPoints):ii)))<cs.posTol && abs(mean(vel((ii-cs.dataPoints):ii)))<cs.velTol
%             input(ii) = cs.balanced;
%         end
%     end
    writePosition(cs.s,input(ii));
end
lightend(cs);
end



