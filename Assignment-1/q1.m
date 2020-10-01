%Question 1, part iii), Calculating the y integral
p = integral(@fun,0.2,0.4);
function f = fun(y)
    f = (1-exp(-1./y)).*exp(-y);
end
%Other parts of the question and other integrals are hand-calculated in the
%hand written solution