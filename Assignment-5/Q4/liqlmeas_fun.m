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
Cv2 = 0.8;

y = Cv2*sqrt(x(2));