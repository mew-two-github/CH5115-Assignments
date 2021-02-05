clear;close all;
%% Part a): Declare the model
nx= 3;
A =[0.9 0 0;1 1.2 -0.5916;0 0.5916 0];
B = [1;0;0];
C = [2 0.8 -0.6761];
D = 0;
model = ss(A,B,C,D,1);
isCtrb = rank(ctrb(A,B))==nx;
isObsv = rank(obsv(A,C))==nx;
%% Part b)and c): Observer design and implementation
L = place(A',C',[0.1,0.2,0.3])';
N = 2555;
est = estim(model,L,1,1);
ukvec = idinput(N,'prbs',[0 0.2],[-1 1]);
X0 = zeros(3,1);
[Y,T,X] = lsim(model,ukvec,0:1:N-1,X0);
X0_for_obs = X0+randn(3,1);
[Ypred,Tpred,Xpred] = lsim(est,[ukvec Y],0:1:N-1,X0_for_obs);
abs_errors = (sum(abs(Xpred-X)))/N;
disp('Mean Absolute Error in the absence of noise = ');
disp(abs_errors);
plot(50:1:N,Xpred(50:N,1)-X(50:N,1)); xlabel('Sample no.');ylabel('Error');
title('Estimation error in xhat1 in the absence of noise')
%% Part d): Implement observer with noise
model_noise = ss(A,[B ones(3,1) zeros(3,1)],C,[D 0 1],1,'inputname',{'u' 'w' 'v'});
Q = 0.1;R=1;
wkvec = sqrt(Q)*randn(N,1);
vkvec = sqrt(R)*randn(N,1);
[Ynoise,T,X_n] = lsim(model_noise,[ukvec wkvec vkvec],0:1:N-1,X0);
[Ypred_n,Tpred,Xpred_n] = lsim(est,[ukvec Ynoise],0:1:N-1,X0_for_obs);
abs_errors_noise = (sum(abs(Xpred_n-X_n)))/N;
disp('Mean Absolute Errors in the presence of noise = ');disp(abs_errors_noise);
figure();
plot(50:1:N,Xpred_n(50:N,1)-X_n(50:N,1)); xlabel('Sample no.');ylabel('Error');
title('Estimation error in xhat1 in the presence of noise');
% We can see that the error has increased in the presence of noise
%% Part d) Low and high eigen values
% Qualitatively we can say that lower eigen values will give more
% weightage to the measurements, and higher eigen value gives more weight
% to the initial esimate. Our initial estimate can be wrong and because of
% noise, the measurement available is a corrupted form of the output so we
% need to strike a balance
% High eigen value
L2 = place(A',C',[0.912,0.99,0.999])';
est2 = estim(model,L2,1,1);
[Ypred_n1,Tpred1,Xpred_n1] = lsim(est2,[ukvec Ynoise],0:1:N-1,X0_for_obs);
mae2 = (sum(abs(Xpred_n1-X_n)))/N;
disp('Mean Absolute Errors(high eigen value case) = ');disp(mae2);
% Low eigen value
L3 = place(A',C',[0.05,0.055,0.059])';
est3 = estim(model,L3,1,1);
[Ypred_n2,Tpred2,Xpred_n2] = lsim(est3,[ukvec Ynoise],0:1:N-1,X0_for_obs);
mae3 = (sum(abs(Xpred_n2-X_n)))/N;
disp('Mean Absolute Errors(low eigen value case) = ');disp(mae3);
% Low eigen value works better. This is because I fed a noisy input to the
% observer, high eigen value give less weightage to the measurements. This
% results in high mae