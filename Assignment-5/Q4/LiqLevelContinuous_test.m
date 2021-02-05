A = 1.2; Cv = 0.8; Ts = 0.1; Qtrue = diag([0.2,0.1]);
u = 1;
% Euler integration of continuous-time dynamics x'=f(x) with sample time Ts
wk = sqrt(diag(Qtrue)).*randn(2,1);
x = [6.25;6.25];
cer = LiqLevelContinuous(x,u,Cv,A);
x = x + LiqLevelContinuous(x,u,Cv,A)*Ts + wk;
function dxdt = LiqLevelContinuous(x,u,Cv,A)

% ODE for liquid level dynamics

dxdt = [(u/A) - (Cv/A)*sqrt(x(1));(Cv/A)*sqrt(x(1))-(Cv/A)*sqrt(x(2))];

end