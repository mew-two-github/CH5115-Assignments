%% Part -1
datagen1_final;
N = length(ykvec);
phi = [ykvec(2:N-1),ukvec(2:N-1),ukvec(1:N-2)];
model = fitlm(phi,ykvec(3:N),'y~x1+x2+x3-1');
%Parameter estimates
Thetahat = model.Coefficients.Estimate;
Thetahat(1) = -1*Thetahat(1); % reporting as -a1
Thetahat
% error variance
ekvec= model.Residuals.Raw;
lbqtest(ekvec)
varek_hat = var(ekvec);
mean(ekvec)
%% Part-2
% PArameter covariance
covparest = model.CoefficientCovariance;
%% Part-3
datagen2_final;
n = 75;
N2 = length(ukvec_2);
phi2 = [ykvec_2(2:n-1),ukvec_2(2:n-1),ukvec_2(1:n-2)];
mdl2 = fitlm(phi2,ykvec_2(3:n),'y~x1+x2+x3-1');
model; % Model and mdl2 are almost equal
ekvec_2 = mdl2.Residuals.Raw;
% mean(ekvec)
% var(ekvec)
% mean(ekvec_2)
% var(ekvec_2)
phi2_full = [ykvec_2(2:N2-1),ukvec_2(2:N2-1),ukvec_2(1:N2-2)];
plot(3:1:N2,predict(mdl2,phi2_full)-ykvec_2(3:N2));
% From the error plot we see error oscillating around zero, but suddenly shoots up in an interval in the middle.
% err = predict(mdl2,phi2_full(300,:))-ykvec_2(300)
% [pred,CI] = predict(mdl2,phi2_full(300,:))
% CI-pred
% Assuming 95% CI
fault_start = 0; err_save1 = 0;
fault_end = 0; err_save2 = 0;
% mean(abs(ekvec_2))
% mdl2
[val,pos] = max(ekvec_2);
for i = 3:N2
    [pred,CI] = predict(mdl2,phi2_full);
    err = predict(mdl2,phi2_full(i-2,:))-ykvec_2(i);
    if fault_start == 0 & err>max(ekvec_2) % If fault has not started and suddenly a fault appears
        fault_start = i;
        err_save1 = err;
    elseif fault_start & err<max(ekvec_2) % If fault has started and a faultless data appears 
        fault_end = i;
        err_save2 = err;
    end
end
fault_start;
fault_end;
err_save1;
err_save2;
% plot(ykvec(75:N),predict(model,))
%% Part-4
A = [0 0;1 0.7998];
B = [0.6044;1.0044];
C = [0 2];
D = 0;
G = [0;0.3998];
H = 1;
sys = ss(A,[B G],C,[D H],1,'inputname',{'u' 'w'});
Q = varek_hat*G'*G;
R = varek_hat; %Since w is white noise
[KEST,L,P] = kalman(sys,Q,R);
Kp = L; 