% plotSensorNoise.m

load('/Users/austinberg/Files/BaB/Sensor/SensorNoise.mat')

figure();
subplot(1,2,1);
plot(pos_all);
ylim([-3 3]);
xline(0);
xlabel('Sensor Reading')
ylabel('Position(cm)')
plotter(gcf,0);
yline(mean(pos_all), 'LineWidth', 3);
subplot(1,2,2);
histogram(pos_all, 'FaceAlpha', 0.95);
xline(mean(pos_all), 'LineWidth', 3);
xlabel('Position (cm)')
ylabel('Occurences')
plotter(gcf,1);

