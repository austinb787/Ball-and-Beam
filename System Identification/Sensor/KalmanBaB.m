%% KalmanBaB.m
% Testing to see whether or not the filter will work real time
%% Live Run no Filters
cs.interv = 200;

input(1:cs.interv) = cs.balanced;
pos(1:cs.interv) = 0; 
t(1:cs.interv) = 0; 
[pos(1), ~, ~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, cs.n_startup, cs.interp.interpTable);

cs.weightNew = 1;
cs.weightOld = 0;
tic
for ii = 2:cs.interv
%     writePosition(cs.s,input(ii));
    [pos1,~,~] = getPos(cs.a, cs.sensorPin1, cs.sensorPin2, 1, cs.interp.interpTable);
    pos(ii) = cs.weightOld*pos(ii-1) + cs.weightNew*pos1;
    vel = pos(ii)-pos(ii-1);
    input(ii) = cs.weightOld*input(ii-1) + cs.weightNew*min(cs.max, max(cs.min, cs.balanced-cs.kp*pos(ii)-cs.kd*vel));
    if abs(mean([input(ii-1),input(ii)])-cs.balanced)<cs.tolerance
        input(ii) = cs.balanced;
    end
    writePosition(cs.s,input(ii));
    t(ii) = toc;
end

%% Kalman Filtering
% This example shows how to perform Kalman filtering. First, you design a steady-state 
% filter using the |kalman| command. Then, you simulate the system to show how 
% it reduces error from measurement noise. This example also shows how to implement 
% a time-varying filter, which can be useful for systems with nonstationary noise 
% sources.
%% Steady-State Kalman Filter
% Consider the following discrete plant with Gaussian noise _w_ on the input 
% and measurement noise _v_ on the output:
% 
% $$\[\begin{array}{c}x\left[ {n + 1} \right] = Ax\left[ n \right] + Bu\left[ 
% n \right] + Gw\left[ n \right]\\y\left[ n \right] = Cx\left[ n \right] + Du\left[ 
% n \right] + Hu\left[ n \right] + v\left[ n \right]\end{array}\]$$
% 
% The goal is to design a Kalman filter to estimate the true plant output $y_t 
% \left\lbrack n\right\rbrack =y\left\lbrack n\right\rbrack -v\left\lbrack n\right\rbrack$ 
% based on the noisy measurements $y\left\lbrack n\right\rbrack$. This steady-state 
% Kalman filter uses the following equations for this estimation. 
% 
% Time update: 
% 
% $$\hat{x} \left\lbrack n+1\left|n\right.\right\rbrack =A\hat{x} \left\lbrack 
% n\left|n-1\right.\right\rbrack +\textrm{Bu}\left\lbrack n\right\rbrack +\textrm{Gw}\left\lbrack 
% n\right\rbrack$$
% 
% Measurement update:  
% 
% $$\[\begin{array}{l}\hat x\left[ {n|n} \right] = \hat x\left[ {n|n - 1} \right] 
% + {M_x}\left( {y\left[ n \right] - C\hat x\left[ {n|n - 1} \right] - Du\left[ 
% n \right]} \right)\\\hat y\left[ {n|n} \right] = C\hat x\left[ {n|n - 1} \right] 
% + Du\left[ n \right] + {M_y}\left( {y\left[ n \right] - C\hat x\left[ {n|n - 
% 1} \right] - Du\left[ n \right]} \right)\end{array}\]$$
% 
% Here, 
%% 
% * $\hat{x} \left\lbrack n\left|n-1\right.\right\rbrack$ is the estimate of 
% $x\left\lbrack n\right\rbrack$, given past measurements up to $y\left\lbrack 
% n-1\right\rbrack$. 
% * $\hat{x} \left\lbrack n\left|n\right.\right\rbrack$and $\hat{y} \left\lbrack 
% n\left|n\right.\right\rbrack$ are the estimated state values and measurement, 
% updated based on the last measurement $y\left\lbrack n\right\rbrack$.
% * $M_x$ and $M_y$ are the optimal innovation gains, chosen to minimize the 
% steady-state covariance of the estimation error, given the noise covariances 
% $E\left(w\left\lbrack n\right\rbrack {w\left\lbrack n\right\rbrack }^T \right)=Q\;$, 
% $E\left(v\left\lbrack n\right\rbrack {v\left\lbrack n\right\rbrack }^T \right)=R$, 
% and $N=E\left(w\left\lbrack n\right\rbrack {v\left\lbrack n\right\rbrack }^T 
% \right)=0$. (For details about how these gains are chosen, see <docid:control_ref.f1-208573 
% |kalman|>.) 
%% 
% (These update equations describe a |current| type estimator. For information 
% about the difference between |current| estimators and |delayed| estimators, 
% see <docid:control_ref.f1-208573 |kalman|>.)
%% Design the Filter
% You can use the |kalman| function to design this steady-state Kalman filter. 
% This function determines the optimal steady-state filter gain _M_ for a particular 
% plant based on the process noise covariance _Q_ and the sensor noise covariance 
% _R_ that you provide. For this example, use the following values for the state-space 
% matrices of the plant.

A = [1.1269   -0.4940    0.1129 
     1.0000         0         0 
          0    1.0000         0];

B = [-0.3832
      0.5919
      0.5191];

C = [1 0 0];

D = 0;


%% 
% For this example, set _G_ = _B_, meaning that the process noise _w_ is additive 
% input noise. Also, set _H_ = 0, meaning that the input noise _w_ has no direct 
% effect on the output _y_. These assumptions yield a simpler plant model: 
% 
% $$\[\begin{array}{c}x\left[ {n + 1} \right] = Ax\left[ n \right] + Bu\left[ 
% n \right] + Bw\left[ n \right]\\y\left[ n \right] = Cx\left[ n \right] + v\left[ 
% n \right]\end{array}\]$$
% 
% When _H_ = 0, it can be shown that $M_y =CM_x$ (see <docid:control_ref.f1-208573 
% |kalman|>). Together, these assumptions also simplify the update equations for 
% the Kalman filter.
% 
% Time update: 
% 
% $$\hat{x} \left\lbrack n+1\left|n\right.\right\rbrack =A\hat{x} \left\lbrack 
% n\left|n-1\right.\right\rbrack +\textrm{Bu}\left\lbrack n\right\rbrack +\textrm{Bw}\left\lbrack 
% n\right\rbrack$$
% 
% Measurement update:  
% 
% $$\[\begin{array}{l}\hat x\left[ {n|n} \right] = \hat x\left[ {n|n - 1} \right] 
% + {M_x}\left( {y\left[ n \right] - C\hat x\left[ {n|n - 1} \right]} \right)\\\hat 
% y\left[ {n|n} \right] = C\hat x\left[ {n|n} \right]\end{array}\]$$
% 
% To design this filter, first create the plant model with an input for |w|. 
% Set the sample time to |-1| to mark the plant as discrete (without a specific 
% sample time).

Ts = -1;
sys = ss(A,[B B],C,D,Ts,'InputName',{'u' 'w'},'OutputName','y');  % Plant dynamics and additive input noise w

sys1 = theory.ball_ss;
%%
clear sys
sys = sys1;
sys.Ts = 0.05;
sys.InputName = 'u';
sys.OutputName = 'y';
%% 
% The process noise covariance |Q| and the sensor noise covariance |R| are values 
% greater than zero that you typically obtain from studies or measurements of 
% your system. For this example, specify the following values.  

Q = 2.3; 
R = 1; 
%% 
% Use the |kalman| command to design the filter.

[kalmf,L,~,Mx,Z] = kalman(sys,Q,R)
%% 
% This command designs the Kalman filter, |kalmf|, a state-space model that 
% implements the time-update and measurement-update equations. The filter inputs 
% are the plant input _u_ and the noisy plant output _y_. The first output of 
% |kalmf| is the estimate $\hat{y}$ of the true plant output, and the remaining 
% outputs are the state estimates $\hat{x}$. 
% 
% 
% 
% For this example, discard the state estimates and keep only the first output, 
% $\hat{y}$.

% kalmf = kalmf(1,:)
%% Use the Filter
% To see how this filter works, generate some data and compare the filtered 
% response with the true plant response. The complete system is shown in the following 
% diagram. 
% 
% 
% 
% 
% 
% To simulate this system, use a |sumblk| to create an input for the measurement 
% noise |v|. Then, use |connect| to join |sys| and the Kalman filter together 
% such that |u| is a shared input and the noisy plant output |y| feeds into the 
% other filter input. The result is a simulation model with inputs |w|, |v|, and 
% |u| and outputs |yt| (true response) and |ye| (the filtered or estimated response 
% $\hat{y}$). The signals |yt| and |ye| are the outputs of the plant and the filter, 
% respectively.

sys.InputName = {'u'};
sys.OutputName = {'yt'};
vIn = sumblk('y=yt+v');

kalmf.InputName = {'u'};
kalmf.OutputName = 'ye';

SimModel = connect(sys,vIn,kalmf,{'u','v'},{'yt','ye'});
%% 
% To simulate the filter behavior, generate a known sinusoidal input vector.
t = t;
u = pos';
% 
% Generate process noise and sensor noise vectors using the same noise covariance 
% values |Q| and |R| that you used to design the filter.

rng(10,'twister');
w = sqrt(Q)*randn(length(t),1);
v = sqrt(R)*randn(length(t),1);
%
% Finally, simulate the response using |lsim|. 
tic
out = lsim(SimModel,[u,v]);
% 
% |lsim| generates the response at the outputs |yt| and ye to the inputs applied 
% at |w|, |v|, and |u|. Extract the |yt| and ye channels and compute the measured 
% response.

yt = out(:,1);   % true response
ye = out(:,2);  % filtered response
y = yt + v;     % measured response
toc
%
% Compare the true response with the filtered response.

clf
subplot(211), plot(t,yt,'b',t,ye,'r--'), 
xlabel('Number of Samples'), ylabel('Output')
title('Kalman Filter Response')
legend('True','Filtered')
subplot(212), plot(t,yt-y,'g',t,yt-ye,'r--'),
xlabel('Number of Samples'), ylabel('Error')
legend('True - measured','True - filtered')
%
% As the second plot shows, the Kalman filter reduces the error |yt - y| due 
% to measurement noise. To confirm this reduction, compute the covariance of the 
% error before filtering (measurement error covariance) and after filtering (estimation 
% error covariance). 

MeasErr = yt-yt;
MeasErrCov = sum(MeasErr.*MeasErr)/length(MeasErr)
EstErr = yt-ye;
EstErrCov = sum(EstErr.*EstErr)/length(EstErr)