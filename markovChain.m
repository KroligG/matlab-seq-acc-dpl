classdef markovChain
    %MARKOVCHAIN Any order markov chain class
    
    properties
        P  %Transition probabilities
        states %States count
        order %Chain order
        vectorStates %vectorOrder object
    end
    
    methods
        function obj=markovChain(P, vectorStates)
            obj.P = P;
            obj.order = ndims(P) - 1;
            obj.states = size(P, 1);
            obj.vectorStates = vectorStates;
        end
        
        function p = getNextStateProbaArray(obj, Xt)
            index = num2cell(obj.vectorStates.order(Xt(:,end-obj.order+1:end)));
            p = obj.P(index{:}, :);
        end
        
        function p = getProba(obj, Xt)
            p = obj.getNextStateProbaArray(Xt(:,1:end-1));
            p = p(obj.vectorStates.order(Xt(:,end)));
        end
        
        function x = next(obj, Xt)
            p = obj.getNextStateProbaArray(Xt);
            x = obj.vectorStates.vector(randsample(1:obj.states, 1, true, p));
        end
        
        function l = likehood(obj, Xt)
            len = size(Xt,2)-obj.order;
            dim = size(Xt, 1);
            index = zeros(dim,obj.order+1,len);
            for i = 1:len                
                index(:,:,i) = eval(['[' sprintf('%d:%d;', [(i-1)*dim + 1:dim:(i+obj.order-1)*dim+1; i*dim:dim:(i+obj.order)*dim]) ']''']);
            end
            cells = num2cell(Xt(index), [1,2]);
            result = cellfun(@obj.getProba, cells);
            l = prod(result);
        end
        
        function hi(obj)
            display(strcat('Hi ', obj.order, '!'));
        end
    end    
end
