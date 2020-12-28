% Run the data generation script
datagen_ts
N = length(yk);
%% Finding the probability
[Fest,Yest] = ecdf(yk);
% find values in Yest closest to a and b
[val1, ind1] = min(abs(Yest-a));
[val2, ind2] = min(abs(Yest-b));
prob_est = Fest(ind2)-Fest(ind1) 
%% Building the AR model
% plot sample pacf
figure();
parcorr(yk,'NumLags',20);
box off;
% AR p = 4 seems to be a good guess upon observing the PACFs
% Changed to 5 because lbqtest not passed AR(4)
model = arima(5,0,0);
model.Constant = 0;
model_est = estimate(model,yk);
[res,~,logL] = infer(model_est,yk);
% ACF of residuals
figure();
subplot(1,2,1);
autocorr(res,'NumLags',20)
title('ACF of residuals from ARIMA(4,0,0) model')
box off;
% PACF of residuals
subplot(1,2,2);
parcorr(res,'NumLags',20);
title('PACF of residuals from ARIMA(4,0,0) model')
box off;
disp('Whiteness Test for Residuals results');
[h_model,pval_model] = lbqtest(res)
%% Building an LR model for yk-ek
Y = yk - res;
Y = Y(4:N);
phi = zeros(N-3,3);
phi(1:N-3,1) = res(3:N-1);
phi(1:N-3,2) = res(2:N-2);
phi(1:N-3,3) = res(1:N-3);
LM = fitlm(phi,Y,'Intercept',false)%The intercept term was found to be ineffective pvalue>alpha, so was removed
tbl = LM.Coefficients;
Chat = tbl.Estimate
Cflags = [true true true]' %pvalue extremely close to zero for all parameters
%% Conditional vs Unconditional probability
prob_ans = 1;
% Yes, because from the autocorrelation plot we can see that at lag 1 there is strong correlation. So y[k-1] would have strong information on y[k]