clear; close all;
%% Model parameters
A1 = 1.2; A2=1.2;
Cv1 = 0.8; Cv2 = 0.8;
Fi = 2; Ts = 2; % Steady state values
n = 2; % number of states
%% Part-b)
% Continous time model
Ac = [-Cv1/A1 0;Cv1/A2 -Cv2/A2];
Bc = [1/A1 ; 0];
Cc = [0,1]; % If only Fo,2 is sensed
continous_model = ss(Ac,Bc,Cc,0);
% Discretising it
ts = 0.1;
discrete = c2d(continous_model,ts);
%% Part-c)
% In estimation terms, the question is basically asking us to find whether
% it is possible to esimate the states. (since, in this model, the states
% are the heights of the tank. We answer this using observability condition
A = discrete.A; B = discrete.B; C = discrete.C;
On = obsv(A,C);
if rank(On) == n
    fprintf('Both heights can be estimated using Fo,2 measurements alone\n');
else
    fprintf("Both heights can't be estimated using Fo,2 measurements alone\n");
end
% Yes, We can measure the heights using Fo,2 alone, because observability
% matrix is full rank
%% Part-d)
Q = diag([0.2,0.1]);
R = 0.1;
% Assuming initial state to be the steady state
X0 = A\(B*Fi);
N = 1275;
model = ss(A,[B eye(2,2) zeros(2,1)],C,[0 0 0 1],ts,'inputname',{'u' 'w1' 'w2' 'v'});
ut = idinput(N,'prbs',[0 0.2],[-1 1]);
rng(123);
w1k = randn(N,1)*sqrt(0.2);
w2k = randn(N,1)*sqrt(0.1)/sqrt(0.2);
wt = w1k/sqrt(0.2);
rng(1234);
vt = randn(N,1)*sqrt(0.1);
% Simulate the plant model
[Y,T,Xkmat] = lsim(model,[ut w1k w2k vt],0:ts:(N-1)*ts,X0);
%% Part-e)
% Declare the model in the form required by Kalman function
G = [1;1]; H = 0; D = 0;
kalm_model = ss(A,[B G],C,[D H],ts,'inputname',{'u' 'w'},'outputname',{'ym'});
Q = diag([0 240]);
% Generate the Kalman filter, the gains and steady-state covariances
[kalmf,Kp,P,Kf,Pf,Ky] = kalman(kalm_model,Q,R);
% Inputs are u, w and v; Outputs are noise-free outputs, measured output
Ap = A;
Bp = [B ones(2,1) zeros(2,1)];
Cp = [C ; C]; 
Dp = [0 0 0; 0 0 1];
% Declaring a model which outputs the noise-free as well as the measured
% output
Process1 = ss(Ap,Bp,Cp,Dp,ts,'statename',{'x1' 'x2'},'inputname',{'u' 'w' 'v'},'outputname',{'ynf' 'ym'});
% Model and estimator in parallel
sim = parallel(Process1,kalmf,1,1,[],[]);
% Feed back ym to the kalman estimator
sim2 = feedback(sim,4,2,1); %WHAT DOES 1 at the beg correspond to?
% Remove ym as an output
sim2 = sim2(1:5,[1 2 3]);
% Run the process and kalman filter simultaneously
[outmat,t,x] = lsim(sim2,[ut wt vt],0:ts:(N-1)*ts);
% Compute variance of state and output filtered estimates
var_xkhat = sum(var(outmat(:,4:5) - Xkmat(:,1:2)));
var_ykhat = var(outmat(:,1) - outmat(:,2));
fprintf(1,'Variance of state and output filtered estimates: [%4.2f %4.2f] \n',var_xkhat,var_ykhat);
% state_var = P;
% op_var = C*P*C';
%% Plots

figure
set(gcf,'Color',[1 1 1]);
subplot(211)
plot(outmat(:,4),'linewidth',2);
hold on
plot(Xkmat(:,1),'r--','linewidth',2);
set(gca,'fontsize',12,'fontweight','bold');
ylabel('State x_1')
xlabel('Time')
title('Kalman filtered estimates and true states')
box off
grid on
legend({'Filtered' ; 'True state'},'location','best')

subplot(212)
plot(outmat(:,5),'linewidth',2);
hold on
plot(Xkmat(:,2),'r--','linewidth',2);
set(gca,'fontsize',12,'fontweight','bold');
ylabel('State x_2')
xlabel('Time')
%title('Kalman filtered estimates and true states')
box off
grid on
%legend({'Filtered' ; 'Noise-free'},'location','best')
legend({'Filtered' ; 'True state'},'location','best')

% Compare the true and filtered outputs

figure
set(gcf,'Color',[1 1 1]);
hfig = plot(t,outmat(:,3),'-',t,outmat(:,2),'-.');
set(hfig,'LineWidth',2);
set(gca,'fontsize',12,'fontweight','bold');
ylabel('Output')
xlabel('Time')
%title('Kalman filtered and True (meas. noise-free) outputs')
title('Kalman filtered and Measured Output')
%legend({'Filtered estimate' ; 'Meas. Noise-free' },'location','best')
legend({'Filtered estimate' ; 'Measurement' },'location','best')
box off
grid on