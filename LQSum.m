classdef LQSum
    properties
        terms
    end
    
    methods
        function obj = LQSum(terms)
            if nargin ~= 0
                obj.terms = genfun(@LQTerm,terms);
            end
        end
        
        function new = plus(a,b)
            if isa(b,'LQSum')
                temp = b;
                b = a;
                a = temp;
            end
            
            if isnumeric(b)
                new = LQSum([a.terms LQTerm(b)]);
            elseif isa(b,'LQSum')
                new = LQSum([a.terms b.terms]);
            else
                new = LQSum([a.terms b]);
            end
        end
        
        function str = toString(obj)
            strs = arrayfun(@toString,obj.terms,'Uniform',false);
            str = strjoin(strs,' + ');
        end
        
        function disp(obj)
            fprintf(' LQSum\n\n    %s\n\n',toString(obj));
        end
    end
end
