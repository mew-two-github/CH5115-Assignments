% Samples and Realizations
N = 1000; R = 400;

% Data generation
a = 1; b = 2;
std_th = sqrt((b-a)^2/12);
yvec = unifrnd(a,b,N,R);

% Estimate bias
shatR = zeros(R,1);
for i = 1:R
    shatR(i) = median(abs(yvec(:,i) - median(yvec(:,i))));
end
err_shat = std_th - mean(shatR);

% Check for bias
if (abs(err_shat) < 1e-03) 
    bflag = 0;
else
    bflag = 1;
end

% Optimize alpha for MMSE
N2 = 1000;
alphavec = linspace(0.1,10,N2);

mseval = zeros(N2,1);
for i = 1:N2
    mseval(i) = (alphavec(i)*mean(shatR) - std_th)^2 + var(alphavec(i)*shatR);
end
[min_mse,ind_min] = min(mseval);

alphaopt = alphavec(ind_min)
