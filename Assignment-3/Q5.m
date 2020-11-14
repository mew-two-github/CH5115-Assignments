clear; close all;
theta = 1; %True theta
N = 1000; %Number of samples per record
R = 300; %Number of records
%% Verifying the generating function
X_uniform = rand(500,1);
vk_mat = generate([R,N],theta);
%Uncomment to plot the histogram and verify that the given PDF is followed
%hist(vk_mat(1,:)); 
%% Comparing the estimators
%Computing the variance for different sample sizes
vars1 = zeros(N,1); vars2 = zeros(N,1); vars3 = zeros(N,1);
%Evaluating bias just to do a loosely check whether the estimators are unbiased
bias1 = zeros(N,1); bias2 = zeros(N,1); bias3 = zeros(N,1);
preds1 = zeros(R,1); preds2 = zeros(R,1); preds3 = zeros(R,1);
for n = 1:N
    vk_mat = generate([R,n],theta); % Generate random records
    preds1 = min(vk_mat,[],2)-1/n; % The MVUE TN' estimator
    preds2 = mean(vk_mat,2)-1; % The ybar - 1 estimator
    preds3 = median(vk_mat,2)-log(2); % The median(y) - ln(2) estimator
    bias1(n) = abs(mean(preds1) - theta);
    bias2(n) = abs(mean(preds2) - theta);
    bias3(n) = abs(mean(preds3) - theta);
    vars1(n) = var(preds1);
    vars2(n) = var(preds2);
    vars3(n) = var(preds3);
end
final = [mean(preds1) mean(preds2) mean(preds3)]; % Predictions using N samples
%% Plotting the graphs
figure();
subplot(1,2,1);
plot(25:N,vars1(25:N));
ylabel('var($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking variance in $\hat{\theta}$ = $min(y_N)$-$\frac{1}{N}$','fontsize',14,'fontweight','bold','interpreter','latex');
subplot(1,2,2);
plot(1:N,bias1);
ylabel('bias($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking bias in $\hat{\theta}$ = $min(y_N)$-$\frac{1}{N}$','fontsize',14,'fontweight','bold','interpreter','latex');
figure();
subplot(1,2,1);
plot(25:N,vars2(25:N));
ylabel('var($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking variance in $\hat{\theta}$ = $\bar{y}$-1','fontsize',14,'fontweight','bold','interpreter','latex');
subplot(1,2,2);
plot(1:N,bias2);
ylabel('bias($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking bias in $\hat{\theta}$ = $\bar{y}$-1','fontsize',14,'fontweight','bold','interpreter','latex');
figure();
subplot(1,2,1);
plot(25:N,vars3(25:N));
ylabel('var($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking variance in $\hat{\theta}$ = $\tilde{y}$-ln(2)','fontsize',14,'fontweight','bold','interpreter','latex');
subplot(1,2,2);
plot(1:N,bias3);
ylabel('bias($\hat{\theta}$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking bias in $\hat{\theta}$ = $\tilde{y}$-ln(2)','fontsize',14,'fontweight','bold','interpreter','latex');
%% Function to sample from the given PDF
% y is sampled using the 'inverse cdf' method. I analytically computed the
% inverse cdf and coded it in the 'inverse_cdf' function
function Y = generate(size,theta)
    X_uniform = rand(size);
    %X = fzero(@(y)actual_cdf(y,theta)-X,X);
    Y = inverse_cdf(X_uniform,theta);
end
function F = actual_cdf(y,theta)
    if y < theta
        F  = 0;
    else
        F =  1 - exp(theta-y);
    end
end
function y = inverse_cdf(F,theta)
    y = log(1./(1-F)) + theta; % 0<=F<=1, no need to check because supplying from U(0,1)
end