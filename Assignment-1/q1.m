p = integral(@fun,0.2,0.4);
function f = fun(y)
    f = (1-exp(-1./y)).*exp(-y);
end