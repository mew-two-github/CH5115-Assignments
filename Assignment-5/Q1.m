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
%% Part c)
modelc = recursiveLS(numParams,'History','Finite','WindowLength',15,'InputProcessing','Frame-Based');
thetaest_vec1 = [0 0 0 0 0]';
cov_track2 = zeros(numParams,N-3);
n = 15;
for i = 1:(N-4)/n
    theta = modelc(yk(n*(i-1)+4:n*(i)+3),H(n*(i-1)+1:n*i,:));
    Ptheta2 = modelc.ParameterCovariance;
    cov_track2(1:numParams,i) = diag(Ptheta2);
    thetaest_vec1(:,i) = theta;
end
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
