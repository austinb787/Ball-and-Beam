clear all
close all
clc

%% servo
load('tf4_75v.mat')
%% sensor
load('SensorNoise.mat')

load('sensorFitFunction.mat')
cs.fitresult = fitresult;

sensor.pos_all = pos_all;
clear pos_all
sensor.pos_all_cm = sensor.pos_all/100; % convert to meters
sensor.var_pos_all_cm = var(sensor.pos_all_cm)*2; 
sensor.SampleTime = 0.03;
sensor.NoisePower = sensor.var_pos_all_cm*sensor.SampleTime;

sensor.R = 100000; % Ohms
sensor.C = 1*10^-6;
sensor.f0 = 1/(2*pi*sensor.R*sensor.C);

s = tf('s');

sensor.tf = 1/(sensor.R*sensor.C*s+1);

sensor.b = sensor.tf.Numerator;
sensor.a = sensor.tf.Denominator;
[sensor.ss.A, sensor.ss.B, sensor.ss.C, sensor.ss.D] = tf2ss([0 1], [sensor.R*sensor.C 1]);
%% theory
theory.m = 2.7/1000;
theory.R = 0.02;
theory.g = -9.8;
theory.L = 0.5;
theory.J = (2/3)*theory.m*theory.R^2;

theory.H = -theory.m*theory.g/(theory.J/(theory.R^2)+theory.m);
theory.A = [0 1; 0 0];
theory.B = [0 1]';
theory.C = [1 0];
theory.D = [0];

theory.P_ball = -theory.m*theory.g/(theory.J/theory.R^2+theory.m)/s^2;

theory.ball_ss = ss(theory.A,theory.B,theory.C,theory.D);

theory.m = 2.7/1000;
theory.R = 0.02;
theory.g = -9.8;
theory.L = 0.5;
theory.J = (2/3)*theory.m*theory.R^2;

theory.H = -theory.m*theory.g/(theory.J/(theory.R^2)+theory.m);
theory.A = [0 1; 0 0];
theory.B = [0 1]';
theory.C = [1 0];
theory.D = [0];

s = tf('s');
theory.P_ball = -theory.m*theory.g/(theory.J/theory.R^2+theory.m)/s^2;

theory.ball_ss = ss(theory.A,theory.B,theory.C,theory.D); 

%% motor
motor.J = 3.2284E-6;
motor.b = 3.5077E-6;
motor.K = 0.0274;
motor.R = 4;
motor.L = 2.75E-6;
s = tf('s');
motor.P = motor.K/(s*((motor.J*s+motor.b)*...
    (motor.L*s+motor.R)+motor.K^2));

motor.R = 100000; % Ohms
motor.C = 0.22*10^-6;
motor.f0 = 1/(2*pi*motor.R*motor.C);

%% cs
cs.kp = 21/10000;
cs.kd = 585/(10000*30);

theory.sys_cl.InputDelay = 0.1;
theory.sys_cl.OutputDelay = 0.1;
theory.C = pid(cs.kp*180/pi,0,cs.kd*180/pi);
theory.sys_cl = feedback(theory.C*theory.P_ball,1);
theory.sys_cl_d = c2d(theory.sys_cl, 0.05);

opt = stepDataOptions;
opt.InputOffset = 20;
opt.StepAmplitude = -20;

% step(theory.sys_cl_d, opt,9)
% ylim([-25,25])
% plotter(gcf,1)

cs.nTrials = 20;
cs.interv = 300;
cs.avgloopFreq = 32;
cs.RestartTime = 4;
cs.TotalRunTimeEstimate = (1/cs.avgloopFreq)*cs.interv*cs.nTrials + cs.nTrials*cs.RestartTime;
cs.n = 1; % Normal sensor readings
cs.n_startup = 10;

% Exponentially-Weighted Moving Average Weight Factors
% alpha for position; 0.5 works well
cs.weightNewPos = 0.5; % alpha
cs.weightOldPos = 1-cs.weightNewPos; % 1-alpha

% alpha for controller input; 0.5 works well
cs.weightNewInput = 0.5; % alpha
cs.weightOldInput = 1-cs.weightNewInput; % 1-alpha

% alpha for velocity; 0.4 works well
cs.weightNewVel = 0.4; % alpha
cs.weightOldVel = 1-cs.weightNewVel; % 1-alpha

cs.MaxInput = 0.08;
% Balanced beam servo input
cs.balanced = 0.46;

% Maximum and minimum beam angles
cs.max = cs.balanced+cs.MaxInput;
cs.min = cs.balanced-cs.MaxInput;
cs.tolerance = 0.0048;

fprintf('\n')
cs.posTol = 2;
cs.velTol = 0.35*30;
cs.dataPoints = 6;

%% Simulink
cs.Ts = 0.03;
IC = 0.2;   

% interpSim = flip([
% 20	670	140;
% 15	490	155;
% 10	375	170;
% 5	325	195;
% 0	290	215;
% -5	268	268;
% -10	255	335;
% -15	245	445;
% -20	210	650]);
% 
% interpPosRight = interpSim(:,1)/100;
% interpRight = interpSim(:,2);
% 
% interpPosLeft = flip(interpSim(:,1))/100;
% interpLeft = flip(interpSim(:,3));


% load('agent2_Trained947.mat')
% load('agent_noisyTD3.mat')
% load('DDPG_agent_5000.mat','agent')   
% load('agent_20210514_itWorked1.mat')
load('agentData.mat')