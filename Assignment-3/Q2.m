close all; clear;
%% Given parameters
N = 1000;
R = 300;
n = 20 + 1;
f = n/N; %the chosen frequency
gamma_true = 1; %PSD
%% Generate vk and get an & bn
vk_mat = randn(R,N);
cos_vec = cos(2*pi*f*(0:1:N-1));
sin_vec = sin(2*pi*f*(0:1:N-1));
an = sum(vk_mat.*cos_vec,2);
bn = -1*sum(vk_mat.*sin_vec,2);
% Perform the Lilliefors test at the default 95% significance, h = 0
% indicates the null hypothesis that the distribution is normal can't be
% rejected
h1 = lillietest(an);
h2 = lillietest(bn);
histogram(an);
set(gca,'fontsize',12,'fontweight','bold');
title('Distribution of a_n'); xlabel('Values of a_n');
figure();
histogram(bn);
set(gca,'fontsize',12,'fontweight','bold');
title('Distribution of b_n'); xlabel('Values of b_n');
%% Checking the consistency of the estimator
P = zeros(N,1); %Estimate of gamma at each n
mse = zeros(N,1); vars = zeros(N,1); bias = zeros(N,1);
for n = 1:N
    vk_mat = randn(R,n); %Generate vk
    an_ = sum(vk_mat(:,1:n).*cos_vec(1:n),2);
    bn_ = -1*sum(vk_mat(:,1:n).*sin_vec(1:n),2);
    preds = (an_.^2+bn_.^2)/n; %Predictions
    P(n) = mean(preds); %Averaging the prediction over records
    bias(n) = abs(gamma_true-P(n));
    vars(n) = var(preds);
    mse(n) = bias(n)^2 + vars(n);
end
%% Plot the graph
figure();
plot(1:N,mse);
set(gca,'fontsize',12,'fontweight','bold','xlim',[1 N]);
ylabel('MSE($\gamma$)','fontsize',14,'fontweight','bold','interpreter','latex');
title('Tracking MSE in $\gamma$ along $N$ for GWN process','fontsize',14,'fontweight','bold','interpreter','latex');
