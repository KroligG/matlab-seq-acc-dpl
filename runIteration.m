function [T, Xt, L] = runIteration( nextObservFunc, mc1, mc2, T, Xt, imputeMissing, minObservations, hopLimit, L )

    [t, xt] = nextObservFunc();
    
%     missingIndex = find(isnan(xt));
%     if missingIndex
%         [sizeX_n, sizeX_p] = size(Xt');
%         if imputeMissing && (~minObservations || sizeX_n > minObservations) && sizeX_n > sizeX_p + 1 
%             xt = implantMissingData(xt, Xt);
%         else
%             theta_0=-1; theta_1=-1;
%             return;
%         end
%     end

    T(:,end+1)=t;
    Xt(:,end+1)=xt;
    
    L_0 = mc1.likehood(Xt);
    L_1 = mc2.likehood(Xt);

    prevL = L;
    L = log(L_1/L_0);
    hop = L - prevL;
    if hopLimit && abs(hop) > hopLimit
        L = prevL + sign(hop) * hopLimit;
    end

end

