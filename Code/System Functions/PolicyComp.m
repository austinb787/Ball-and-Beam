%% RL Agent Policy
testpos = (-28:1:28)/100;
testvel = (-200:10:200)/100;
clear RLaction
RLaction(1:length(testpos), 1:length(testvel)) = 0;
for ii = 1:length(testpos)
    for jj = 1:length(testvel)
RLaction(ii,jj) = evaluatePolicy_first([testpos(ii) testvel(jj)]);
    end
end
%%
h = figure();
surf(testvel, testpos, RLaction, 'EdgeColor', 'none')
xlabel('Velocity (m/s)');
ylabel('Position (m)');
zlabel('Beam Angle Input (degree)')
title('RL Agent Policy');
plotter(gcf,1)

%% RL Agent Policy Slow
testpos = (-28:1:28)/100;
testvel = (-200:10:200)/100;
clear RLaction
RLaction(1:length(testpos), 1:length(testvel)) = 0;
for ii = 1:length(testpos)
    for jj = 1:length(testvel)
RLaction(ii,jj) = evaluatePolicy_slowController([testpos(ii) testvel(jj)]);
    end
end
%%
h = figure();
surf(testvel, testpos, RLaction, 'EdgeColor', 'none')
xlabel('Velocity (m/s)');
ylabel('Position (m)');
zlabel('Beam Angle Input (degree)')
title('RL Agent Policy - Slow Controller');
plotter(gcf,1)

%% PD Controller Policy
testpos = (-.28:.005:.28);
testvel = (-10:0.1:10);
cs.kp = 21/10000;
cs.kd = 21/10000;
clear PDcontrol
PDcontrol(1:length(testpos), 1:length(testvel)) = 0;
for ii = 1:length(testpos)
    for jj = 1:length(testvel)
% RLaction(ii,jj) = evaluatePolicy([testpos(ii) testvel(jj)]);
PDcontrol(ii,jj) = -cs.kp*(testpos(ii)) - cs.kd*(testvel(jj));
    end
end
%%
h = figure();
surf(testvel, testpos, PDcontrol, 'EdgeColor', 'none')
xlabel('Velocity (m/s)');
ylabel('Position (m)');
zlabel('Beam Angle Input (degree)')
title('PID Controller');
colorbar
plotter(gcf,1)

%% RL Agent Policy Slow
testpos = (-.28:.01:.28);
testvel = (-10:0.1:10);
clear RLaction
RLaction(1:length(testpos), 1:length(testvel)) = 0;
for ii = 1:length(testpos)
    for jj = 1:length(testvel)
RLaction(ii,jj) = evaluatePolicy_monday([testpos(ii) testvel(jj)]);
    end
end
%% RL Agent itWorked1
testpos = (-.28:.005:.28);
testvel = (-10:0.1:10);
clear RLaction
RLaction(1:length(testpos), 1:length(testvel)) = 0;
for ii = 1:length(testpos)
    for jj = 1:length(testvel)
        observation(1:2, 1, 1) = [testpos(ii) testvel(jj)];
        RLaction(ii,jj) = evaluatePolicy_itWorked1(observation(1:2, 1, 1));
    end
end

%%
h = figure();
surf(testvel, testpos, RLaction, 'EdgeColor', 'none')
ylabel('Velocity (m/s)');
xlabel('Position (m)');
zlabel('Beam Angle Input');
colorbar;
plotter(gcf,1)



h = figure();
contour(testvel, testpos, RLaction)
ylabel('Velocity (m/s)');
xlabel('Position (m)');
zlabel('Beam Angle Input');
plotter(gcf,1)

