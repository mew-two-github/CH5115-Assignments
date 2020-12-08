close all;clear;
%% Generating data
theta0 = 2;
N = 500; R = 300;
%% Estimating theta for different sample sizes
bias = zeros(N,1); mse = bias; variance = bias;
bias_mle = bias;mse_mle = mse; variance_mle=  variance;
for n = 1:N
    Y = generate([R,n],theta0);
    % MLE estimate
    theta_hat_mle_vec = max(Y,[],2)/sqrt(2);
    theta_hat_mle = mean(theta_hat_mle_vec);
    bias_mle(n) = abs(theta0/sqrt(2)-theta_hat_mle);
    variance_mle(n) = var(theta_hat_mle_vec);
    mse_mle(n) = bias_mle(n)^2 + variance_mle(n);
    % Modified MLE (unbiased)
    theta_hat_vec = theta_hat_mle_vec*(2*n+1)/(2*n);
    theta_hat = mean(theta_hat_vec);
    bias(n) = abs(theta0/sqrt(2)-theta_hat);
    variance(n) = var(theta_hat_vec);
    mse(n) = bias(n)^2 + variance(n);
end
%% Plotting the graphs and observing 
%MLE
figure();
subplot(1,2,1);
plot(25:N,variance_mle(25:N));
ylabel('var($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking variance in $\hat{\theta}$ = $max(y_N)$/$\sqrt2$','fontsize',14,'fontweight','bold','interpreter','latex');
subplot(1,2,2);
plot(1:N,bias_mle);
ylabel('bias($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking bias in $\hat{\theta}$ = $max(y_N)$/$\sqrt2$','fontsize',14,'fontweight','bold','interpreter','latex');
figure();
plot(1:N,mse_mle);
ylabel('MSE($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking MSE in $\hat{\theta}$ = $max(y_N)$/$\sqrt2$','fontsize',14,'fontweight','bold','interpreter','latex');
figure();
hist(theta_hat_mle_vec);
title('Distribution of $\hat{\theta}$ = $max(y_N)$/$\sqrt2$','fontsize',14,'fontweight','bold','interpreter','latex');

% Modified MLE
figure();
subplot(1,2,1);
plot(25:N,variance(25:N));
ylabel('var($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking variance in $\hat{\theta}$ = $max(y_N)$/$\sqrt2$*(2N+1)/(2N)','fontsize',14,'fontweight','bold','interpreter','latex');
subplot(1,2,2);
plot(1:N,bias);
ylabel('bias($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking bias in $\hat{\theta}$ = $max(y_N)$/$\sqrt2$*(2N+1)/(2N)','fontsize',14,'fontweight','bold','interpreter','latex');
figure();
plot(1:N,mse);
ylabel('MSE($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking MSE in $\hat{\theta}$ = $max(y_N)$/$\sqrt2$*(2N+1)/(2N)','fontsize',14,'fontweight','bold','interpreter','latex');
figure();
hist(theta_hat_vec);
title('Distribution of $\hat{\theta}$ = $max(y_N)$/$\sqrt2$*(2N+1)/(2N)','fontsize',14,'fontweight','bold','interpreter','latex');
%% AD test to check normality of theta_hat_vec
[h1 p1] = adtest(theta_hat_vec);
[h_mle p_mle] = adtest(theta_hat_mle_vec);
%% Function to sample from the given PDF
% y is sampled using the 'inverse cdf' method. I analytically computed the
% inverse cdf and coded it in the 'inverse_cdf' function
function Y = generate(size,theta)
    X_uniform = rand(size);
    %X = fzero(@(y)actual_cdf(y,theta)-X,X);
    Y = inverse_cdf(X_uniform,theta);
end
function y = inverse_cdf(F,theta)
    y = sqrt(F)*theta; % 0<=F<=1, no need to check because supplying from U(0,1)
end