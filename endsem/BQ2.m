A = [-10 0 -10 0;0 -0.7 9 0;0 -1 -0.7 0;1 0 0 0];
B = [20 2.8;0 -3.13;0 0;0 0];
% Cn = ctrb(A,B);
% rank(Cn)
% B = [20 0;0 0;0 0;0 0];
% Cn = ctrb(A,B);
% rank(Cn)
B = [0 2.8;0 -3.13;0 0;0 0];
Cn = ctrb(A,B);
rank(Cn)
C = [0 0 0 1];
On = obsv(A,C);
rank(On)