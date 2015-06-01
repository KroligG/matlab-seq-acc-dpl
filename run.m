X0 = [1;1];
outlierProb = 0;
missingProb = 0;
imputeMissing = true;
minObservations = 20;
hopLimit = 0;
a = 0.01;
b = a;
% A=((1-b)/a);
% B=(b/(1-a));
A=log((1-b)/a);
B=log(b/(1-a));
% A = log(14.243);
% B = log(0.001);
vectorStates = vectorOrder([2,2]);
mc2 = markovChain([...
    0.2, 0.3, 0.1, 0.4;...
    0.3, 0.1, 0.2, 0.4;...
    0.3, 0.2, 0.4, 0.1;...
    0.4, 0.1, 0.3, 0.2;...
], vectorStates);
mc1 = markovChain([...    
    0.3, 0.1, 0.2, 0.4;...
    0.2, 0.3, 0.1, 0.4;...    
    0.4, 0.1, 0.3, 0.2;...
    0.3, 0.2, 0.4, 0.1;...
], vectorStates);

tic
    retriesCount = 100;
    [ERR, Average_n] = seqAcc(X0, mc1, mc2, A, B, outlierProb, missingProb, imputeMissing, minObservations, hopLimit, retriesCount)
toc

% tic
% N = 1000;
% [ netX, netY, netC0, netC1, closestVal, closestIndex] =...
%     findExactCriticalValues( -5, 3, 0.001, a, b, X0, theta0, theta1, mu, S, corrMatr, point, eps, imputeMissing, minObservations, hopLimit, N );
% display(strcat('index=',num2str(closestIndex),' (',num2str(netX(closestIndex)),',',num2str(netY(closestIndex)),')=',...
%     '(',num2str(netC0(closestIndex)/N),',',num2str(netC1(closestIndex)/N),')'));
% toc