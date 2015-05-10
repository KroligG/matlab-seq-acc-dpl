function [ netX, netY, netC0, netC1, closestVal, closestIndex] =...
    findExactCriticalValues( a, b, step, alpha, beta, X0, theta0, theta1, mu, S, corrMatr, point, eps, imputeMissing, minObservations, hopLimit, N )

invS = inv(S); 
errorFunc = getErrorFunc(mu, S);
[netX, netY] = createNet(a,b,step);
totalPoints = length(netX);
save crtVlsNet.mat netX netY;

netC0 = zeros(totalPoints, 1);
netC1 = zeros(totalPoints, 1);

for index=1:N            
    try
        display(strcat('iteration ',num2str(index)));

        handledPoints0 = 0;
        thisTimeNet0 = zeros(totalPoints,1);    
        nextObservFuncH0 = getNextObservationFunc(X0, theta0, errorFunc);    
        Xt=[]; T=[]; L=0;
        while handledPoints0 < totalPoints
            [ t, T, Xt, L] = runIteration( nextObservFuncH0, theta0, T, Xt, X0, S, invS, point, eps, corrMatr, imputeMissing, minObservations, hopLimit, L );        

            if t>300
                display('omg!');
                break;
            end

            for i=1:totalPoints
                if ~thisTimeNet0(i)
                    if L >= netY(i)
                        netC0(i) = netC0(i) + 1;
                        thisTimeNet0(i) = 1;
                        handledPoints0 = handledPoints0 + 1;                    
                    elseif L <= netX(i)
                        thisTimeNet0(i) = 1;
                        handledPoints0 = handledPoints0 + 1;
                    end
                end
            end
        end    

        handledPoints1 = 0;
        thisTimeNet1 = zeros(totalPoints,1);    
        nextObservFuncH1 = getNextObservationFunc(X0, theta1, errorFunc);
        Xt=[]; T=[]; L=0;
        while handledPoints1 < totalPoints
            [ t, T, Xt, L] = runIteration( nextObservFuncH1, theta1, T, Xt, X0, S, invS, point, eps, corrMatr, imputeMissing, minObservations, hopLimit, L );        

            if t>300
                display('omg!');
                break;
            end

            for i=1:totalPoints
                if ~thisTimeNet1(i)
                    if L >= netY(i)                    
                        thisTimeNet1(i) = 1;
                        handledPoints1 = handledPoints1 + 1;                    
                    elseif L <= netX(i)
                        netC1(i) = netC1(i) + 1;
                        thisTimeNet1(i) = 1;
                        handledPoints1 = handledPoints1 + 1;
                    end
                end
            end
        end 
    catch err
        display(err.identifier);
    end
    save crtVls.mat netC0 netC1 index;
end

[closestVal, closestIndex] = min((netC0/N - alpha).^2+(netC1/N - beta).^2);

% [closestVal0, closestIndex0] = min(abs(netC0/N - alpha));
% [closestVal1, closestIndex1] = min(abs(netC1/N - beta));

end

function [x, y, c] = createNet(a,b,step)
    x = []; y = []; c = [];
    for c0=a:step:b
        for c1=c0+step:step:b
            x(end+1) = c0;
            y(end+1) = c1;
            c(end+1) = 0;
        end
    end
end

function func = getNextObservationFunc(X0, realTheta, errorFunc)

currentT = 0;

func = @nextObservationFunc;

    function [t, xt] = nextObservationFunc()
        currentT = currentT + 1;
        xt = X0 + realTheta*currentT + errorFunc();
        t = currentT;
    end
end

function func = getErrorFunc(mu, S) 

R = chol(S);

func = @errorFunc;
    
    function f = errorFunc()
        f = mu + R'*randn(2,1);
    end
end
