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

A = 1.2; Cv = 0.8; Ts = 0.1; Qtrue = diag([0.2,0.1]);

% Euler integration of continuous-time dynamics x'=f(x) with sample time Ts
wk1 = sqrt(Qtrue(1,1)).*randn(1,1);
wk2 = sqrt(Qtrue(2,2)).*randn(1,1);
x = x + (LiqLevelContinuous(x,u,Cv,A))*Ts+[wk1;wk2];
% I think the noise term should also be multiplies by Ts, but I am not
% doing so because, the demo example says otherwise.

end

function dxdt = LiqLevelContinuous(x,u,Cv,A)

% ODE for liquid level dynamics

dxdt = [(u/A) - (Cv/A)*sqrt(x(1));(Cv/A)*sqrt(x(1))-(Cv/A)*sqrt(x(2))];

end

