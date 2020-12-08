close all;clear;
%% Loading the data
data = load('qdist_data.mat');
Ydata = data.Ydata;
% Observing the data, we can see that the distribution is most likely to be
% continous.
%% Plotting the histogram and plotting Cullen-Frey Graph
BW = 5;
h = histogram(Ydata,'BinWidth',BW);
title('Histogram of the given data');xlabel('Yvalue');ylabel('Counts')
% From the histogram we observe all data are positive the distribution
% looks like a chi^2/Rayleigh distribution
stats_sk = cfgraph(Ydata);
% From the CF graph- Other aspirants: Beta, Rayleigh, Weibull and Gamma
% Not beta because it is defined only in 0 to 1
%% Distribution fitting
nParams = [2,2,1];
NLL = zeros(3,1);
PD1 = fitdist(Ydata,'gamma');
NLL(1) = negloglik(PD1);
PD2 = fitdist(Ydata,'wbl');
NLL(2) = negloglik(PD2);
PD3 = fitdist(Ydata,'rayleigh');
NLL(3) = negloglik(PD3);
[aic,bic] = aicbic(-1*NLL,nParams,85);
%% Using histfit
figure();
histfit(Ydata,h.NumBins,'rayleigh');
title('Rayleigh Distribution fit using histfit');xlabel('Yvalue');ylabel('Counts')
legend('Data','Fit Distribution');
%% Conclusion
% The lowest score in terms of AIC as well as BIC is given by the Rayleigh
% distribution, so it is the winner!
Params = PD2;
[h,p] = adtest(Ydata,'Distribution','weibull');
% Since Rayleigh is a type of Weibull. h=0, null hypothesis is not rejected
% so this further establishes that the distribution is indeed Weibull