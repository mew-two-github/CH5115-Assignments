uk = 1;
x = [10;10];
states = x;
for i = 1:1000
    if x(1) < 0 || x(2) < 0
    fprintf('Complex roots occurs in pairs\n');
    break
    end
    x = liqlstatetrans_fun1(x,uk);
    states = [states x];
end
function x = liqlstatetrans_fun1(x,u)

% Discrete-time approximation of the state transition function 
% for liquid level system
% Example state transition function for discrete-time nonlinear state
% estimators.
%
% Inputs:
%    x - Present state x[k]
%    u - Present input
%
% Outputs:
%   Propagated states x[k+1]
%
% See also extendedKalmanFilter, unscentedKalmanFilter

% Get parameters from Model Workspace
% coder.extrinsic('get_param')
% coder.extrinsic('get');
% 
% hws = get_param('extkalmfilt_simdemo','modelworkspace');

% Qtrue = hws.getVariable('Qtrue');
%Ts = hws.getVariable('Ts');
%Cv = hws.getVariable('Cv');
%Ac = hws.getVariable('Ac');

A = 1.2; Cv = 0.8; Ts = 0.01; Qtrue = diag([0.2,0.1]);

% Euler integration of continuous-time dynamics x'=f(x) with sample time Ts
wk = sqrt(diag(Qtrue)).*randn(2,1);
x = x + LiqLevelContinuous(x,u,Cv,A)*Ts + wk;

end

function dxdt = LiqLevelContinuous(x,u,Cv,A)

% ODE for liquid level dynamics

dxdt = [(u/A) - (Cv/A)*sqrt(x(1));(Cv/A)*sqrt(x(1))-(Cv/A)*sqrt(x(2))];

end

