function [theta fval] = minimizeB( b0, Xt, X0, invS, T, A, B, eps, order )

options = optimset('Display', 'off', 'Algorithm', 'active-set');
[theta fval] = fmincon(@(b) funcToMin(b, Xt, X0, invS, T),b0,[],[],[],[],[],[],@(b) constrFunc(b, A, B, X0, eps, order), options);

end

function f = funcToMin (b, Xt, X0, invS, T)
    f = 0;
    n=length(T);
    
    for i = 1:n     
        f = f + (Xt(:,i) - X0 - b*T(i))'*invS*(Xt(:,i) - X0 - b*T(i));        
    end

end

function [c ceq] = constrFunc (b, A, B, X0, eps, order)

    c = order * ( (X0-A)'*B*(X0-A) - ((b'*B*(A-X0))^2)/(b'*B*b)-eps^2 );
    ceq = [];

end