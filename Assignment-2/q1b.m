clear; close all;
% Number of records
n = 100;
% Position of signal
k = 100;
% Declare a n*k e~GWN(0,1)
e = randn(n,k);
% storing variance of 100 positions
v_variance = zeros(100,1);
% random walk process
v = zeros(100,100);
for i = 1:k
    v(:,i) = sum(e(:,1:i),2); %summing along each row
    v_variance(i) = var(v(:,i));
end
%plotting variance across positions
plot(1:1:k,v_variance);
title('Variance estimates of the signal');
xlabel('time');ylabel('variance');
% Result: We get a steadily increasing variance as expected