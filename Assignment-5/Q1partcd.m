clear; close all;
clear; close all;
load ltvdata1.mat;
N = length(uk);
%% Plots for parts c) & d)
H = [yk(3:N-1) yk(2:N-2) uk(3:N-1) uk(2:N-2) uk(1:N-3)];
% theta should be a1/a1, a2, b1, b2, b3
numParams = 5;
modelc = recursiveLS(numParams,'History','Finite','WindowLength',27);
cov_track2 = zeros(numParams,N-3);
for i = 4:N
    theta = modelc(yk(i),H(i-3,:)');
    Ptheta2 = modelc.ParameterCovariance;
    cov_track2(1:numParams,i) = diag(Ptheta2);
    thetaest_vec1(:,i) = theta;
end
a1_1 = mean(thetaest_vec1(1,[1:1:491,822:1:1272]));
a1_2 = mean(thetaest_vec1(1,503:797));
a2 = mean(thetaest_vec1(2,503:797));
b1 = mean(thetaest_vec1(3,[1:1:491,822:1:1272]));
b2 = mean(thetaest_vec1(4,:));
b3 = mean(thetaest_vec1(5,503:797));
theta1 = [a1_1 b1 b2]';
theta2 = [a1_2 a2 b2 b3]';
mse = (sum((H([1:1:491,822:1:1272],[1 3 4])*theta1).^2) + sum((H(503:797,[1 2 4 5])*theta2).^2))/N;
%% Plots for parts c) & d)
figure();
plot(thetaest_vec1(4,:));
title('Estimate of b_2'); xlabel('Number of Observations'); ylabel('Estimate')
figure();
subplot(2,2,1);
plot(thetaest_vec1(1,:));
title('Estimate of a_1'); xlabel('Number of Observations'); ylabel('Estimate')
subplot(2,2,2);
plot(thetaest_vec1(2,:));
title('Estimate of a_2'); xlabel('Number of Observations'); ylabel('Estimate')
subplot(2,2,3);
plot(thetaest_vec1(3,:));
title('Estimate of b_1'); xlabel('Number of Observations'); ylabel('Estimate')
subplot(2,2,4);
plot(thetaest_vec1(5,:));
title('Estimate of b_3'); xlabel('Number of Observations'); ylabel('Estimate')