clear; close all;
%% Covariance matrix
%storing 100 realisations of the RV X; mu = 1, sigma^2 = 2;
X = randn([100,1])*sqrt(2)+1;
Y = 3.*X.^2 + 5.*X;
%Verification of my function
my_ans = covariance(X,Y);
matlab_ans = cov([X,Y],1);
%% Checking convergence of sigma xy upto 10^4 samples
n = 10^4;%sample size
sigxy = zeros(n,1);
N = zeros(n,1);
for i = 1:n
    Xs = randn([i,1])*sqrt(2)+1;
    Ys = 3.*Xs.^2 + 5.*Xs;
    mat = covariance(Xs,Ys);
    sigxy(i) = mat(2,1);
    N(i) = i;
end
plot(N,sigxy,N,(zeros(n,1))+22);
xlabel('Sample size');
ylabel('sigma xy');
%% Checking convergence in the range of 10^6 samples
%Sample size b/w 10^5-10^6 increased in steps of 10^5
n_vals = 10^5:10^5:10*10^6;
sigxy2 = zeros(length(n_vals),1);
for i=1:length(n_vals)
    Xs = randn([n_vals(i),1])*sqrt(2)+1;
    Ys = 3.*Xs.^2 + 5.*Xs;
    mat = covariance(Xs,Ys);
    sigxy2(i) = mat(2,1);
end
figure();
plot(n_vals,abs(sigxy2-22));
title('Deviation from true value');
xlabel('Sample size');
ylabel('deviation');
%% Values generated for writing in handwritten part
n_vals = [10,100,10^3,10^4,10^5,10^6,2*10^6,3*10^6];
sigxy3 = zeros(length(n_vals),1);
for i=1:length(n_vals)
    Xs = randn([n_vals(i),1])*sqrt(2)+1;
    Ys = 3.*Xs.^2 + 5.*Xs;
    mat = covariance(Xs,Ys);
    sigxy3(i) = mat(2,1);
end
del_est = abs(sigxy3-22);
% figure();
% plot(n_vals,sigxy2,'x');
% xlabel('Sample size');
% ylabel('sigma xy');
%% Covariance Matrix Function
function mat = covariance(x,y)
    sigxy = sum((x-mean(x)).*(y-mean(y)))./length(x);
    sigx = sum((x-mean(x)).^2)/length(x);
    sigy = sum((y-mean(y)).^2)/length(y);
    mat = [sigx sigxy; sigxy sigy];
end