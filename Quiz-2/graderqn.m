R = 300;
N=400;
% Part 1
N = 400;
runs_mat = zeros(R,N);
for i = 1:R
    runs_mat(i,:) = sample_cuspdf(theta_e,N);
end
y_mean_vec = mean(runs_mat,2);
var_mean = 4*var(y_mean_vec)
y_median_vec = median(runs_mat,2);
var_median = 16*var(y_median_vec)
estflag = 2;%1 + (var_mean>var_median)

% Part 2
datagen_quiz2;
mu_hat = 4*median(ykvec)
% mu_hat = 2*mean(ykvec);%meanhat
% Part 3
N = length(ykvec);
sigma = sqrt(var(ykvec)/N);
theta_0
cdf = 
z = norminv(0.975);
L = -z*sigma + mu_hat
U = z*sigma + mu_hat

% Part 4
%Theta0 doesnt lie between L and U so we reject H0
hflag = 0
