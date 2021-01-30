function x = liqlstatetrans_fun(x,u)

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

Ac = 1; Cv = 3; Ts = 0.1; Qtrue = 0.01;

% Euler integration of continuous-time dynamics x'=f(x) with sample time Ts
wk = Qtrue*randn(1,1);
x = x + LiqLevelContinuous(x,u,Cv,Ac)*Ts + wk;
end

function dxdt = LiqLevelContinuous(x,u,Cv,Ac)

% ODE for liquid level dynamics
dxdt = (u/Ac) - (Cv/Ac)*sqrt(x);
end