fun = @(x)(f([3 randn(2,1)],x));
[y,t,~] = integrate(fun,0,1);
function [a,b] = f(u,x)
a = (u(1)/0.8) - (1.2/0.8)*sqrt(x(1)) + u(2);
b = (1.2/0.8)*sqrt(x(1)) - (1.2/0.8)*sqrt(x(2))+ u(3);
end