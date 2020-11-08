close all;
N = 500; % Max number of samples in a record
R = 300; % Number of records
u = randn(1,N); % Randomly Generate and fix uk
beta0 = 2; % True value of beta
var_e = 1; % Variance in the error term
mserror = zeros(N-1,1); % Vector for storing the MSE at each sample size
beta_vec = zeros(R,1); % Vector for storing beta estimate from each record
for n = 2:N
    e_mat = sqrt(var_e)*randn(R,n); % Each row represents one record
    for r = 1:R
        y = u(1:n)/beta0 + e_mat(r,:);
        % Estimate beta for record r
        beta_vec(r) = sum(u(1:n).^2)./sum(u(1:n).*y);
    end
    beta_hat = mean(beta_vec);
    mserror(n-1)  = var(beta_vec) + ((mean(beta_vec)-beta0)^2);
end
plot((2:N),mserror);
set(gca,'fontsize',12,'fontweight','bold','xlim',[1 N]);
ylabel('MSE(ybar)','fontsize',14,'fontweight','bold');
title('Tracking MSE in $\beta$ along $N$ for GWN e(k)','fontsize',14,'fontweight','bold','interpreter','latex');
figure();
plot((50:N),mserror(49:end));
set(gca,'fontsize',12,'fontweight','bold','xlim',[50 N]);
ylabel('MSE(ybar)','fontsize',14,'fontweight','bold');
xlabel('Number of Samples per record','fontsize',14,'fontweight','bold');
title('Tracking MSE in $\hat{\beta}$ along $N$, zooming to the high N values','fontsize',14,'fontweight','bold','interpreter','latex');
