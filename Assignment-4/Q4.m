close all;%clear;
%% Loading the data
data = load('engine_thrust.mat');
phi = data.Phi;
y = data.y;
%% Perform regression using OLS method
io_corr = corr(phi,y);
reg_corr = corr(phi,phi);
% rank of phi matrix
r_phi = rank(phi);
% From the correlations we see that the first 5 regressors are heavily
% correlated between each other
mdl1 = fitlm(phi,y)
residuals = (mdl1.Residuals.raw);
% CF graph
cfgraph(residuals);
% lbqtest for whiteness
[h,pvalue] = lbqtest(residuals);
if h == 0
    fprintf("The null hypothesis that the noise is white is not rejected")
end
mean_res = mean(residuals);
% ADTest for Gaussianity
[h_dist,pval_dist] = adtest(residuals);
% R^2, adjusted R^2, and significance of regression reported
%% Part b): Eliminate terms and regress again
% We observe that the intercept term, x2, x3, x4 are insignificant
% (p-value>0.05)
fprintf('\nUpdated Model');
mdl2 = fitlm(phi,y,'y ~ x1 + x5 + x6 - x2 - x3 - x4 - 1');
[h2,pvalue2] = lbqtest(residuals);
if h2 == 0
    fprintf("\nThe null hypothesis that the noise is white is not rejected.\n")
end
mean_res2 = mean(residuals);
% Both AIC and BIC (obtained using mdl.ModelCriterion) agree that second
% model is the better model.(although it has higher mse, it uses fewer
% parameters.)
%% Part c): Perform stepwise regression to check which is the better model
mdl3 = stepwiselm(phi,y,'Upper','linear','PEnter',0.1,'PRemove',0.15);
% Criterion for addition and especially for removal bit relaxed so not
% getting model 2 exactly, but better than model 2
%% Part d): Plot residuals against regressors to check for non-linearities
residuals = (mdl3.Residuals.raw);
figure();
a = [1,3,5,6];
for i = 1:4
    subplot(2,2,i);
    plot(phi(:,a(i)),residuals,'x');
    title('x'+string(a(i)));
    ylabel('Residuals');
    xlabel('regressor');
end
% Regressors x1 & x5 may have some non-linear relationships.
%% Part e)
figure();
subplot(1,2,1);
x5 = phi(:,5);
x1 = phi(:,1);
p = polyfit(x5,residuals,2);
plot(linspace(min(x5),max(x5),40),polyval(p,linspace(min(x5),max(x5),40)),x5,residuals,'x');
title('quadratic fit for x5 vs residuals');ylabel('Residuals');xlabel('regressor');
subplot(1,2,2);
p2 = polyfit(x1,residuals,2);
plot(linspace(min(x1),max(x1),40),polyval(p2,linspace(min(x1),max(x1),40)),x1,residuals,'x');
title('quadratic fit for x1 vs residuals');ylabel('Residuals');xlabel('regressor');
mdl4 = stepwiselm(phi,y,'Upper','quadratic','PEnter',0.1,'PRemove',0.15);
mdl5 = fitlm(phi,y,'y ~ x1 + x5 + x6 + x3 + x1^2 + x5^2 - x2  - x4 - 1');
% x5^2 model has superior F statistic, p value, AIC & BIC