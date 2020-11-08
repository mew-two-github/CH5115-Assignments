clear;
N = 500;
%variance of u
var_u = 2;
% Generate known signal u
u = randn(N,1)*sqrt(var_u);
f0 = 0.5; b0 = 2;
%variance of y*
var_signal = var_u*b0^2/(1-f0^2);
%variance of noise
var_noise = 10/var_signal;
% Generate noise
e = randn(N,1)*sqrt(var_noise);
% Generate signal
signal = zeros(N,1);
for k=3:N
    signal(k) = b0*(u(k-2)) -f0*signal(k-1);
end
%Generate measured signal
y = signal + e;
% Estimating the variance, acvf and cross-covariance
var_y_hat = var(y);
[sample_acvf lags1] = xcov(y,1,'unbiased');
acvf_1_hat = sample_acvf(3);
[sample_ccv1 lags2] = xcov(y,u,1,'unbiased');
ccv_1_hat = sample_ccv1(3);
[sample_ccv2 lags3] = xcov(y,u,2,'unbiased');
ccv_2_hat = sample_ccv2(5);
% true values
var_y = var_noise + var_signal;
acvf_1 = -f0*var_signal;
ccv_1 = 0;
ccv_2 = b0*var_u;

