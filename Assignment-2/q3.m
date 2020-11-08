clear;close all;
%% Load the data
data = load('a2_q3.mat');
vk = data.vk;
N = length(vk);
figure();
plot(1:1:length(vk),vk);
title('Plot of the time series data'); xlabel('time'); ylabel('vk');
%% Estimate and plot ACFs and PACFs
% Estimate ACF
[acf_vk,lags,bounds] = autocorr(vk,'NumLags',20);
% Plot sample ACF
figure();
subplot(1,2,1);
autocorr(vk,'NumLags',20);
set(gca,'fontsize',12,'fontweight','bold');
hca = gca;
set(hca.Children(4),'LineWidth',2)
box off;
% Estimate sample PACF
pacf_vk = parcorr(vk,'NumLags',20);
%plot sample PACF
subplot(1,2,2);
parcorr(vk,'NumLags',20);
box off;
% ACF decays very very slowly, while PACF[1] is 1; These indicate presence 
% random walk effect
%% ADF test 
[h,pval] = adftest(vk);
disp('ADF Test');
disp('h = ');
disp(h);
disp('pval = ');
disp(pval);
% we obtain a high pvalue of 0.845>alpha=0.05. This implies the null
% hypothesis of a unit root in the time series is rejected
% Therefore the series contains random walk effects.
%% Finding the order of the differenced series; guess-1: it is first order
vdf = diff(vk);
figure();
plot(vdf);
ylabel('Differenced Value');xlabel('Time');
title('Differenced Series');
% Sample ACFs and PACFs
figure();
subplot(1,2,1);
autocorr(vdf,'NumLags',20);
title('ACF of differenced series');
subplot(1,2,2);
parcorr(vdf,'NumLags',20);
title('PACF of differenced series');
% We can see an exponential decay of ACF indicating AR component and
% no abrupt change to 0 in PACF indicating MA component.
% Conduct the ADF test on the differenced series
[h2,pval2] = adftest(vdf);
disp('ADF test on differenced series');
disp('h = ');
disp(h2);
disp('pval = ');
disp(pval2);
% pvalue = 0.001<alpha => Null hypothesis is not rejected. Therefore, we
% can say that the differenced series doesn't contain random walk effects
%% Building ARIMA model
% We know that the difference is 1. Let's try an arima(1,1,1) model
model1 = arima(1,1,1);
model1.Constant = 0;%vk(1) = 0
model1_est = estimate(model1,vk);
% Residual analysis
% Residual computation
[res1,~,logL] = infer(model1_est,vk);
% ACF of residuals
figure();
autocorr(res1,'NumLags',20)
title('ACF of residuals from ARIMA(1,1,1) model')
box off;
% PACF of residuals
figure();
parcorr(res1,'NumLags',20)
title('PACF of residuals from ARIMA(1,1,1) model')
box off;
% Whiteness test
[h_model1,pval_model1] = lbqtest(res1);
disp('Whiteness Test for Residuals results');
disp(h_model1);disp(pval_model1);
summarize(model1_est);
% Not passing the whiteness test, lets try increasing the AR component
%% Model 2
model2 = arima(2,1,1);
model2.Constant = 0;%vk(1) = 0
model2_est = estimate(model2,vk);
% Residual analysis
% Residual computation
[res2,~,logL] = infer(model2_est,vk);
% ACF of residuals
figure();
autocorr(res2,'NumLags',20)
title('ACF of residuals from ARIMA(2,1,1) model')
box off
% PACF of residuals
figure();
parcorr(res2,'NumLags',20)
title('PACF of residuals from ARIMA(2,1,1) model')
box off;
% Whiteness test
[h_model2,pval_model2] = lbqtest(res2);
disp('Whiteness Test for Residuals results');
disp(h_model2);disp(pval_model2);
% Model clears the whiteness test!
summarize(model2_est);
% From the pvalues, we can see that all the model parameters are relevant.
% Also AIC_model2 < AIC_model1=> Model2 is the better model