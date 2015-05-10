classdef markovChain
    %MARKOVCHAIN Any order markov chain class
    
    properties
        P  %Transition probabilities
        pi %Initial state
        Xt %Observations
        states %States count
        order %Chain order
    end
    
    methods
        function obj=markovChain(P)
            obj.P = P;
            obj.order = ndims(P) - 1;
            obj.Xt = [];
            obj.states = size(P, 1);
        end
        
        function p = getNextStateProbaArray(obj, Xt)
            index = num2cell(Xt(end-obj.order+1:end));
            p = obj.P(index{:}, :);
        end
        
        function p = getProba(obj, Xt)
            p = obj.getNextStateProbaArray(Xt(1:end-1));
            p = p(Xt(end));
        end
        
        function x = next(obj, Xt)
            p = obj.getNextStateProbaArray(Xt);
            x = randsample(1:obj.states, 1, true, p);
        end
        
        function l = likehood(obj, Xt)
            index = eval(['[' sprintf('%d:%d;', [1:length(Xt)-obj.order ; 1+obj.order:length(Xt)]) ']']);
            cells = num2cell(Xt(index), 2);
            result = cellfun(@obj.getProba, cells);
            l = prod(result);
        end
        
        function hi(obj)
            display(strcat('Hi ', obj.order, '!'));
        end
    end    
end