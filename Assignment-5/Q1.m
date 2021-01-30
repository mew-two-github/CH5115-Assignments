clear; close all;
load ltvdata1.mat;
stairs(uk);
stairs(1:1:1275,yk);
obj = recursiveLS(4,'History','Finite');
obj.History = 'Finite';
