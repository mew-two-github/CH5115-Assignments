clear; close all;
load ltvdata1.mat;
N = length(uk);
%% Parts a) and b) Formulating and identifying switching times and model parameters
H = [yk(3:N-1) yk(2:N-2) uk(3:N-1) uk(2:N-2) uk(1:N-3)];
% theta should be a1/a1, a2, b1, b2, b3
numParams = 5;
model1 = recursiveLS(numParams,'ForgettingFactor',0.97);
thetaest_vec = zeros(numParams,N-3);
cov_track = zeros(numParams,N-3);
for i = 4:N
    theta = model1(yk(i),H(i-3,:)');
    Ptheta1 = model1.ParameterCovariance;
    cov_track(1:numParams,i) = diag(Ptheta1);
    thetaest_vec(:,i-3) = theta;
end
a1_1 = mean(thetaest_vec(1,[1:1:490,904:1:1272]));
a1_2 = mean(thetaest_vec(1,500:800));
a2 = mean(thetaest_vec(2,500:800));
b1 = mean(thetaest_vec(3,[1:1:490,904:1:1272]));
b2 = mean(thetaest_vec(4,:));
b3 = mean(thetaest_vec(5,500:800));
theta1 = [a1_1 b1 b2]';
theta2 = [a1_2 a2 b2 b3]';
mse = (sum((H([1:1:490,904:1:1272],[1 3 4])*theta1).^2) + sum((H(500:800,[1 2 4 5])*theta2).^2))/N;
%% Plots for parts a) & b)
figure();
plot(thetaest_vec(4,:));
title('Estimate of b_2'); xlabel('Number of Observations'); ylabel('Estimate')
figure();
subplot(2,2,1);
plot(thetaest_vec(1,:));
title('Estimate of a_1'); xlabel('Number of Observations'); ylabel('Estimate')
subplot(2,2,2);
plot(thetaest_vec(2,:));
title('Estimate of a_2'); xlabel('Number of Observations'); ylabel('Estimate')
subplot(2,2,3);
plot(thetaest_vec(3,:));
title('Estimate of b_1'); xlabel('Number of Observations'); ylabel('Estimate')
subplot(2,2,4);
plot(thetaest_vec(5,:));
title('Estimate of b_3'); xlabel('Number of Observations'); ylabel('Estimate')
