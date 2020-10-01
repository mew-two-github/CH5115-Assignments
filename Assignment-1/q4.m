clear; close all;
%Part a
%Number of Records
R = 200;
%Number of samples per record
N = 10000;
%Degrees of freedom
dof = 10;
%Generating R records of size N
X = chi2rnd(dof,[N,R]);
%Uncomment the next line to visualise sample distribution
%hist(X(:,1),1:1:max(max(X)))

%Guess values for the estimate
x_hat_vec = 8:0.001:11;
L = length(x_hat_vec);
%Array to store the costs
Jvals = zeros(L,1);
for i = 1:L
    %Cost function evaluation, sums up all the deviations and is normalised
    %by the total number of samples(which is N*R)
    Jvals(i) = sum(sum(abs(X-x_hat_vec(i))))/(N*R);
end
%Locating the minimum
[min_J, pos] = min(Jvals);
% Plot of J
plot(x_hat_vec,Jvals);
title('Cost Function');
xlabel('X hat');
ylabel('J');
x_hat = x_hat_vec(pos);
% Part b
% Required probabilities computed as mentioned in the hand-written solution
Pr_x_star = chi2cdf(1.1*x_hat,10) - chi2cdf(0.9*x_hat,10);
% Obtaining the mean and variance of the chi-squared distribution
[M,V] = chi2stat(10);
Pr_x = chi2cdf(1.1*M,10) - chi2cdf(0.9*M,10);