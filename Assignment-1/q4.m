clear; close all;
%Part a
R = 200;
N = 5000;
dof = 10;
X = chi2rnd(dof,[N,R]);
hist(X(:,1),1:1:max(max(X)))
x_hat_vec = 8:0.01:11;
L = length(x_hat_vec);
Jvals = zeros(L,1);
for i = 1:L
    Jvals(i) = norm(X-x_hat_vec(i),1)/(N);
end
[min_J, pos] = min(Jvals);
plot(x_hat_vec,Jvals);
x_hat = x_hat_vec(pos);
%Part b
Pr_x_star = chi2cdf(1.1*x_hat,10) - chi2cdf(0.9*x_hat,10);
[M,V] = chi2stat(10);
Pr_x = chi2cdf(1.1*M,10) - chi2cdf(0.9*M,10);