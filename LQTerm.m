classdef LQTerm
    properties
        c
        v1
        v2
    end
    
    methods
        function obj = LQTerm(varargin)
            if nargin == 0
                return
            end
            
            % shortcut case
            if length(varargin) == 1 && isa(varargin{1},'LQTerm')
                obj = varargin{1};
                return
            end
            
            obj.c = 1;
            for i = 1:length(varargin)
                arg = varargin{i};
                if isempty(arg)
                    error('SIMPL:LQTerm:empty', ...
                          'cannot create LQTerm from empty term');
                elseif isnumeric(arg)
                    obj.c = obj.c * arg;
                elseif isa(arg,'Variable')
                    if isempty(obj.v1)
                        obj.v1 = arg;
                    elseif isempty(obj.v2)
                        obj.v2 = arg;
                    else
                        error('SIMPL:LQTerm:nonlinear', ...
                              'cannot construct nonlinear LQTerm');
                    end
                elseif isa(arg,'LQTerm')
                    if order(obj) + order(arg) > 2
                        error('SIMPL:LQTerm:nonlinear', ...
                              'cannot construct nonlinear LQTerm');
                    else
                        obj.c = obj.c * arg.c;
                        if ~isempty(arg.v1)
                            if isempty(obj.v1)
                                obj.v1 = arg.v1;
                            else
                                obj.v2 = arg.v1;
                            end
                        end
                        if ~isempty(arg.v2)
                            obj.v2 = arg.v2;
                        end
                    end
                else
                    error('SIMPL:LQTerm:noconvert', ...
                          ['invalid object of type ' class(arg)]);
                end
            end
        end
        
        function tf = isConstant(obj)
            tf = isempty(obj.v1) && isempty(obj.v2);
        end
        
        function tf = isLinear(obj)
            tf = isempty(obj.v2);
        end
        
        function tf = isQuadratic(obj)
            tf = ~isempty(obj.v2);
        end
        
        function ordr = order(obj)
            if isConstant(obj)
                ordr = 0;
            elseif isLinear(obj)
                ordr = 1;
            elseif isQuadratic(obj)
                ordr = 2;
            end
        end
        
        function new = times(a,b)
            new = LQTerm(a,b);
        end
        
        function new = plus(a,b)
            new = LQSum([LQTerm(a) LQTerm(b)]);
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
            fprintf(' LQTerm\n\n    %s\n\n',toString(obj));
        end
    end
end
        
        
                
            