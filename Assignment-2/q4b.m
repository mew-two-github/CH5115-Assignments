clear; close all;
mu = 5;
sigma = 2;
%Number of observations
N = 100;
X = randn(N,1)*sigma + mu;
e = randn(N,1);
a=2;
b=3;
Y = a*X+b+e;
a_hat_vec = 1:0.01:3;
b_hat_vec = 2:0.01:4;
[A,B] = meshgrid(a_hat_vec,b_hat_vec);
L=zeros(201);
for i = 1:length(X)
    L = L + ((Y(i)-A.*X(i)-B).^2/2);
end
surf(A,B,L);
title('Likelihood function'); % should have been negative log lh
xlabel('a value'); ylabel('b value'); zlabel('Likelihood');
val = min(min(L));
pos = find(L==val);
a_hat = A(pos);
b_hat = B(pos);
%2D graphs
figure();
plot(a_hat_vec,sum((Y-a_hat_vec.*X-b_hat).^2/2));
title('Likelihood function at b-estimate');
xlabel('a value'); ylabel('Likelihood');
figure();
plot(b_hat_vec,sum((Y-a_hat.*X-b_hat_vec).^2/2));
title('Likelihood function at a-estimate');
xlabel('b value'); ylabel('Likelihood');
% figure();
% plot(b_hat,L);  
% Analytical method
A_matrix = [sum(X.^2) sum(X);sum(X) N];
C = [sum(X.*Y);sum(Y)];
Soln = A_matrix\C;