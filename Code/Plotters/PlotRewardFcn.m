close all;

pos_reward_fcn = @(x) exp(-0.08*(70*x).^2);
cw_reward_fcn = @(x) -1+exp((x.^2)*-0.08);

POS = linspace(-0.28, 0.28);
pos_reward = pos_reward_fcn(POS);

CW = linspace(-2.5, 2.5);
cw_reward = cw_reward_fcn(CW);

figure();
subplot(1,2,1);
area(POS, pos_reward, 'FaceColor', [0.1 0.8 0.1], 'FaceAlpha', 0.7);
ylabel('Reward')
xlabel('Position (m)')
ylim([-1 1]);
plotter(gcf,1);

subplot(1,2,2);
area(CW, cw_reward, 'FaceColor', [0.8 0.1 0.1], 'FaceAlpha', 0.7);
xlabel('Derivative of Servo Command (rad/s)');
ylim([-1 1]);
plotter(gcf,1);
sgtitle('Reward Functions', 'FontSize',18, 'FontWeight', 'bold');



