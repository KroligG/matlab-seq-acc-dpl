function result = implantMissingData( xt, Xt )    
    missingIndex = find(isnan(xt));
    theta = robustfit(Xt(1:end~=missingIndex,:)',Xt(missingIndex,:)', 'andrews', 1.339, 'off');
    result = xt;
    result(missingIndex) = theta' * xt(1:end~=missingIndex); 
end

