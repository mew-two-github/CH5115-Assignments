function y = liqlmeas_fun(x)

% Measurement function for liquid level system
% To be used with EKF

% For CH5115: Parameter and State Estimation
% Arun K. Tangirala
% January 08, 2021


% Get parameters from Model Workspace
% coder.extrinsic('get_param');
% coder.extrinsic('get');
% 
% hws = get_param('extkalmfilt_simdemo','modelworkspace')

%Cv = hws.getVariable('Cv');
Cv = 3;

y = Cv*sqrt(x);