clear; close all; % clc;
%% Load Data
data = load('stack_loss.mat');
phi = [data.psi1vec data.psi2vec data.psi3vec];
y = data.yvec;
%% Part a) determining correlation of regressor with output
correlation = corr(phi,y);
for i = 1:3
    fprintf('correlation between regressor %1i and y is %4.4f\n',i,correlation(i));
end
% Regressors 1 & 2 are reasonably correlated with y(close to 0.9). The
% third regressor is poorly correlated with y (0.4)
%% Part b) fit model and compute goodness of fit measures
model = fitlm(phi,y);
fprintf('R-squared = %.4f, Adjusted R-squared = %.4f',model.Rsquared.Ordinary,model.Rsquared.Adjusted);
[p,F] = coefTest(model);
fprintf('\np value for significance of regression = %e',p);
fprintf('\n');
histfit(model.Residuals.raw,5);
title('Residuals Distribution');
[h_res,p_res] = adtest(model.Residuals.raw);
% R squared = 0.914, Adjusted R-Squared = 0.898
% p ~ 10^-9. So p << alpha. So, the null hypothesis that the regression is
% insignificant is rejected.
%% Part c) significance of each coefficient
sign_coeff = table(model.CoefficientNames',model.Coefficients.pValue);
sign_coeff.test_result = sign_coeff.Var2<=0.05;
sign_coeff.Properties.VariableNames = {'Coefficient_Name' 'pValue' 'Hypothesis_test'};
disp(sign_coeff);
%% Part d) Prediction of y for given psi and getting CI
psi0 = [80 25 90];
[ypred1,CI] = predict(model,psi0,'Alpha',0.05,'Prediction','curve')
%% Part e) Getting prediction interval at the same psi
[ypred2,PI] = predict(model,psi0,'Alpha',0.05,'Prediction','observation')
% As expected the PI is larger than CI.
%% Extra
corr_regressors = corr(phi,phi);
mdl2 = fitlm(phi(:,1:2),y);
better_model = (mdl2.ModelCriterion.AIC < model.ModelCriterion.AIC) + 1;