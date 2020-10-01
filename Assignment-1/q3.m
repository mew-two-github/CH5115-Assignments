%clear;
%Verifying the correlation matrix obtained using hand calculations
A  = [4 1 2;1 9 -3;2 -3 25];
pho = corrcov(A);
%The second part is done analytically in the handwritten solutions