%% BALL

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
    
%% MOTOR

motor.J = 3.2284E-6;
motor.b = 3.5077E-6;
motor.K = 0.0274;
motor.R = 4;
motor.L = 2.75E-6;
s = tf('s');
motor.P = motor.K/(s*((motor.J*s+motor.b)*...
    (motor.L*s+motor.R)+motor.K^2));

%% ARDUINO

if exist('cs') == 0
    cs.a = arduino();

cs.servoPin = 'D9';
configurePin(cs.a,cs.servoPin,'servo')
cs.s = servo(cs.a, cs.servoPin);

cs.sensorPin1 = 'A0';
cs.sensorPin2 = 'A1';
else
    disp('Arduino is already connected')
    connected = 1;
end

%% Sensor Interpolation Table

% Sensor interpolation table
cs.interp = load('SensorInterpTable.mat');

load('sensorFitFunction.mat')
cs.fitresult = fitresult;
%% Light Show

cs.bulb.red = 'D6';
cs.bulb.green = 'D5';
cs.bulb.blue = 'D3';

% turn all off
writeDigitalPin(cs.a, cs.bulb.red, 0);
writeDigitalPin(cs.a, cs.bulb.green, 0);
writeDigitalPin(cs.a, cs.bulb.blue, 0);

% test
writeDigitalPin(cs.a, cs.bulb.red, 1);
pause(0.2);
writeDigitalPin(cs.a, cs.bulb.green, 1);
pause(0.2);
writeDigitalPin(cs.a, cs.bulb.blue, 1);

% turn all off
writeDigitalPin(cs.a, cs.bulb.red, 0);
writeDigitalPin(cs.a, cs.bulb.green, 0);
writeDigitalPin(cs.a, cs.bulb.blue, 0);

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
% load('agent3_worked.mat')
% load('DDPG_agent_5000.mat')   
load('agent_20210514_itWorked1.mat')
load('agentData.mat')
