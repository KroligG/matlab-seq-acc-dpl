classdef vectorOrder
    properties
        states
        calc
        size
    end
    
    methods
        function obj=vectorOrder(states)
            obj.states = states;
            obj.calc = cat(2, states, 1);
            obj.calc = cumprod(obj.calc(end:-1:1));
            obj.calc = obj.calc(end-1:-1:1);
            obj.size = length(states);
        end
        
        function order = order(obj, vector)
            order = obj.calc*vector + 1;
        end
        
        function vector = vector(obj, order)
            order = order - 1;
            vector = zeros(obj.size, length(order));
            for i=1:obj.size
                vector(i,:) = floor(order/obj.calc(i));
                order = rem(order, obj.calc(i));
            end
        end
    end

end

