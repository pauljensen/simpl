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
    
    t = LQTerm(2,Variable) .* 3;
    verifyEqual(tc, t.c, 6);
    verifyTrue(tc, isLinear(t));
    
    t = LQTerm(2,Variable,Variable) .* 3;
    verifyEqual(tc, t.c, 6);
    verifyTrue(tc, isQuadratic(t));
end

function testMultLinear(tc)
    t = LQTerm(2,Variable) .* LQTerm(3,Variable);
    verifyEqual(tc, t.c, 6);
    verifyTrue(tc, isQuadratic(t));
end

function testMultQuadratic(tc)
    q = LQTerm(1,Variable,Variable);
    verifyError(tc, @(x) q .* LQTerm(1,Variable), ...
                'SIMPL:LQTerm:nonlinear');
    verifyError(tc, @(x) q .* q, ...
                'SIMPL:LQTerm:nonlinear');
end
    
function testToString(tc)
    verifyMatches(tc,toString(LQTerm(1)),'1');
    verifyMatches(tc,toString(LQTerm(-1)),'-1');
    v = Variable('v');
    verifyMatches(tc,toString(LQTerm(v)),'v');
    verifyMatches(tc,toString(LQTerm(1,v)),'v');
    verifyMatches(tc,toString(LQTerm(-1,v)),'-v');
    verifyMatches(tc,toString(LQTerm(2,v)),'2*v');
    verifyTrue(tc, strcmp(toString(LQTerm(-2,v)),'-2*v'));
    verifyMatches(tc,toString(LQTerm(1,v,v)),'v\^2');
    x = Variable('x');
    verifyMatches(tc,toString(LQTerm(1,v,x)),'v\*x');
end

