function [ ERR, Average_n, Xt, T] = seqAcc( X0, mc1, mc2, A, B, ...
        outlierProb, missingProb, imputeMissing, minObservations, hopLimit, retriesCount )
   
count=0;
err_count=0;

parfor i=1:retriesCount
%     try
        Xt=X0; T=zeros([1 length(X0)]); L=0;
        nextObservFunc = getNextObservationFunc(X0, mc1, mc2, outlierProb, missingProb);
%         display(strcat('iteration ',num2str(i)));
        while true
            count = count+1;           
            [T, Xt, L] = runIteration(nextObservFunc, mc1, mc2, T, Xt, imputeMissing, minObservations, hopLimit, L);
            
            if L>=A
                err_count=err_count+1;
                break
            elseif L<=B
                break
            end
        end
%     catch err
%         display(err.identifier);
%     end
end

ERR=err_count/retriesCount;
Average_n=count/retriesCount;

end

function func = getNextObservationFunc(X0, mc1, mc2, outlierProb, missingProb)

Xt = X0;
currentT = 0;

func = @nextObservationFunc;

    function [t, xt] = nextObservationFunc()
        currentT = currentT + 1;
        if rand() < outlierProb
            xt = mc2.next(Xt);
        else
            xt = mc1.next(Xt);
        end
        t = currentT;
        if rand() < missingProb
            removeIndex = ceil(rand() * length(X0));            
            xt(removeIndex) = NaN;
        end
    end
end

