N = 1000;
R = 400;
a = 1;
b = 2;
y = a+(b-a)*(rand(N,R));
sigma_hat = zeros(1,R);
for i = 1:R
    sigma_hat(i) = median(abs(y(:,i)-median(y(:,i))));
end
sigma_pred = sum(abs(sigma_hat))/R;
sigma_true = sqrt((b-a)^2/12);
%plot(sigma_hat);
bflag = 1;
if abs(sigma_pred-sigma_true) < 0.001
    bflag = 0;
end
alpha = 0:0.0001:2;
err = zeros(length(alpha),1);
for i = 1 : length(alpha)
    err(i) = sum((alpha(i)*mean(sigma_hat)- sigma_true).^2)+var(alpha(i)*sigma_hat);
end
[minval,pos] = min(err);
%figure();
plot(alpha,err);
alphaopt = alpha(pos);