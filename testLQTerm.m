function tests = testLQTerm
tests = functiontests(localfunctions);
end

function testCreate(tc)
    t = LQTerm(1);
    verifyEqual(tc, t.c, 1);
    verifyEmpty(tc, t.v1);
    verifyEmpty(tc, t.v2);
end

function testMultConstant(tc)
    t = LQTerm(2) .* 3;
    verifyEqual(tc, t.c, 6);
    verifyTrue(tc, isConstant(t));
    
    t = (2 .* Variable) .* 3;
    verifyEqual(tc, t.c, 6);
    verifyTrue(tc, isLinear(t));
    
    t = (2 .* Variable .* Variable) .* 3;
    verifyEqual(tc, t.c, 6);
    verifyTrue(tc, isQuadratic(t));
end

function testMultLinear(tc)
    t = (2 .* Variable) .* (3 .* Variable);
    verifyEqual(tc, t.c, 6);
    verifyTrue(tc, isQuadratic(t));
end

function testMultQuadratic(tc)
    q = Variable .* Variable;
    verifyError(tc, @(x) q .* Variable, ...
                'SIMPL:LQTerm:nonlinear');
    verifyError(tc, @(x) q .* q, ...
                'SIMPL:LQTerm:nonlinear');
end
    
function testToString(tc)
    verifyMatches(tc,toString(LQTerm(1)),'1');
    verifyMatches(tc,toString(LQTerm(-1)),'-1');
    v = Variable('v');
    verifyMatches(tc,toString(LQTerm(v)),'v');
    verifyMatches(tc,toString(1.*v),'v');
    verifyMatches(tc,toString(-1.*v),'-v');
    verifyMatches(tc,toString(2.*v),'2*v');
    verifyTrue(tc, strcmp(toString(-2.*v),'-2*v'));
    verifyMatches(tc,toString(v.*v),'v\^2');
    x = Variable('x');
    verifyMatches(tc,toString(v.*x),'v\*x');
end

