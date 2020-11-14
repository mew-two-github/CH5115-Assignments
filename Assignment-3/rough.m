N = 30;
n = 29;
a = 0;
for k = 1:N
    for l = 1:k-1
        a = a + (cos(2*pi*n/N*(k-l)))^2;
    end
end
%a = a/2;
disp(a);
b= 0 ;
for k = 1:N
    for l = 1:k-1
        b = b + 1;
    end
end
sum_cos = sum(cos(2*pi*n/N.*(0:1:N-1)));
disp(b);
disp(a-b);
