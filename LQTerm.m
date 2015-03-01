classdef LQTerm
    properties
        c
        v1
        v2
    end
    
    methods
        function obj = LQTerm(term)
            if nargin == 0
                return
            end
            
            [m,n] = size(term);
            obj(m,n) = LQTerm;
            for j = 1:n
                for i = 1:m
                    if isa(term,'LQTerm')
                        obj(i,j) = term(i,j);
                    elseif isa(term,'numeric')
                        obj(i,j).c = term(i,j);
                    elseif isa(term,'Variable')
                        obj(i,j).c = 1;
                        obj(i,j).v1 = term(i,j);
                    else
                        error('SIMPL:LQTerm:noconvert', ...
                              ['cannot create LQTerm from ',class(term)]);
                    end
                end
            end
        end
        
        function tf = isConstant(obj)
            f = @(x) isempty(x.v1) && isempty(x.v2);
            tf = vectorize(f,obj,@false);
        end
        
        function tf = isLinear(obj)
            f = @(x) ~isempty(x.v1) && isempty(x.v2);
            tf = vectorize(f,obj,@false);
        end
        
        function tf = isQuadratic(obj)
            f = @(x) ~isempty(x.v2);
            tf = vectorize(f,obj,@false);
        end
        
        function ordr = order(obj)
            function o = f(x)
                if isConstant(x)
                    o = 0;
                elseif isLinear(x)
                    o = 1;
                elseif isQuadratic(x)
                    o = 2;
                end
            end
            ordr = vectorize(@f,obj);
        end
        
        function new = times(A,B)
            function y = aux(a,b)
                [a,b] = ordered(LQTerm(a),LQTerm(b));
                y = LQTerm(a);
                y.c = y.c * b.c;
                if order(a) + order(b) > 2
                    error('SIMPL:LQTerm:nonlinear', ...
                          'cannot construct nonlinear LQTerm');
                end
                if isLinear(b)
                    y.v2 = b.v1;
                end
            end
            new = binaryVectorize(@aux,A,B,@LQTerm);
        end
        
        function new = mtimes(a,b)
            % temporary fix
            new = times(a,b);
        end
        
        function new = plus(A,B)
            f = @(a,b) LQSum([LQTerm(a) LQTerm(b)]);
            new = binaryVectorize(f,A,B,@LQSum);
        end
        
        function str = toString(obj)
            if isConstant(obj)
                str = num2str(obj.c);
            	return
            end
            
            str = '';
            if obj.c < 0
                str = [str '-'];
            end
            if abs(obj.c) ~= 1
                str = [str num2str(abs(obj.c)) '*'];
            end
            if order(obj) > 0
                str = [str toString(obj.v1)];
            end
            if isQuadratic(obj)
                if isequal(obj.v1,obj.v2)
                    str = [str '^2'];
                else
                    str = [str '*' toString(obj.v2)];
                end
            end
        end
        
        function disp(obj)
            defaultDisplay(obj);
        end
    end
end
        
        
                
            