%% Part a): Declare the model
nx= 3;
A =[0.9 0 0;1 1.2 -0.5916;0 0.5916 0];
B = [1;0;0];
C = [2 0.8 -0.6761];
D = 0;
model = ss(A,B,C,D,1);
isCtrb = rank(ctrb(A,B))==nx;
isObsv = rank(obsv(A,C))==nx;
%% Part b): Observer design
L = place(A',C',[0.1,0.2,0.3])';
N = 2555;
est = estim(model,L,1,1);
ukvec = idinput(N,'prbs',[0 0.2],[-1 1]);
X0 = zeros(3,1);
[Y,T,X] = lsim(model,ukvec,0:1:N-1,X0);
[Ypred,Tpred,Xpred] = lsim(est,[ukvec Y],0:1:N-1,X0);
abs_errors = (sum(abs(Xpred-X)))/N;
%% Part c): Implement observer with noise
model_noise = ss(A,[B ones(3,1) zeros(3,1)],C,[D 0 1],1,'inputname',{'u' 'w' 'v'});
Q = 0.1;R=1;
wkvec = sqrt(Q)*randn(N,1);
vkvec = sqrt(R)*randn(N,1);
[Ynoise,T,X_n] = lsim(model_noise,[ukvec wkvec vkvec],0:1:N-1,X0);
[Ypred_n,Tpred,Xpred_n] = lsim(est,[ukvec Y],0:1:N-1,X0);
abs_errors_noise = (sum(abs(Xpred-X_n)))/N;