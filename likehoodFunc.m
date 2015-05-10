function L = likehoodFunc( Xt, X0, b, T, S, invS )

n = length(T);
N = length(X0);

sum = 0;
n=length(T);
for i = 1:n
    sum = sum + (Xt(:,i) - X0 - b*T(i))'*invS*(Xt(:,i) - X0 - b*T(i));
end

L = 1/((2*pi)^(n*N/2) * sqrt(det(S))) * exp(-sum/2); 

end

