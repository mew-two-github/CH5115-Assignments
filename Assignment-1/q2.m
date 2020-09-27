clear; close all;
%storing 100 realisations of the RV X; mu = 1, sigma = 2;
X = randn([100,1])*2+1;
Y = 3.*X.^2 + 5.*X;
%Verification of my function
my_ans = covariance(X,Y);
matlab_ans = cov([X,Y],1);
%Checking converegnce of sigma xy
n = 10^4;%sample size
sigxy = zeros(n,1);
N = zeros(n,1);
for i = 1:n
    Xs = randn([i,1])*2+1;
    Ys = 3.*Xs.^2 + 5.*Xs;
    mat = covariance(Xs,Ys);
    sigxy(i) = mat(2,1);
    N(i) = i;
end
plot(N,sigxy,N,(zeros(n,1))+44);
xlabel('Sample size');
ylabel('sigma xy');
function mat = covariance(x,y)
    sigxy = sum((x-mean(x)).*(y-mean(y)))./length(x);
    sigx = sum((x-mean(x)).^2)/length(x);
    sigy = sum((y-mean(y)).^2)/length(y);
    mat = [sigx sigxy; sigxy sigy];
end