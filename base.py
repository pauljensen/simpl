
def encapsulate(e):
    if not isinstance(e, Expression):
        return Constant(e)
    else:
        return e


class Expression(object):
    def __add__(self, other):
        return LQSum([self, other])

    def __radd__(self, other):
        return self.__add__(other)

    def __mul__(self, other):
        pass

    def __rmul__(self, other):
        return self.__mul__(other)


class Constant(Expression):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return str(self.value)


class Variable(Expression):
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return "${{{name}}}".format(name=self.name)


class Cons(Expression):
    def __init__(self, operator, e1, e2):
        self.operator = operator
        self.expressions = [e1, e2]

    @property
    def left(self):
        return self.expressions[0]

    @property
    def right(self):
        return self.expressions[1]

    def __str__(self):
        expr_list = (' ' + self.operator + ' ').join([str(e) for e in self.expressions])
        return "({expr_list})".format(expr_list=expr_list)


class Function(Expression):
    def __init__(self, function, e):
        self.function = function
        self.expression = e

    def __str__(self):
        return "{function}({expression})".format(function=self.function, expression=self.expression)




# ========================== Linear and Quadratic Programming ==========================

class LQExpression(Expression):
    pass


class LQTerm(LQExpression):
    def __init__(self, expression, coefficient=1):
        self.expression = expression
        self.coefficient = coefficient

    @property
    def coefficient_str(self):
        if abs(self.coefficient) == 1:
            return "-" if self.coefficient < 0 else ""
        else:
            return str(self.coefficient) + "*"

    @property
    def coefficient_display_str(self):
        s = " - " if self.coefficient < 0 else " + "
        if self.coefficient != 1:
            s += str(self.coefficient) + "*"
        return s


class VarTerm(LQTerm):
    def same_base(self, other):
        return (isinstance(other, VarTerm) and
                len(self.variables) == len(other.variables) and
                all([var in self.variables for var in other.variables]))

    @property
    def variable_str(self):
        if len(self.variables) == 1:
            return str(self.variables[0])
        if len(self.variables) == 2:
            if self.variables[0] == self.variables[1]:
                return str(self.variables[0]) + "^2"
            else:
                return "*".join([str(var) for var in self.variables])

    @property
    def display_str(self, first=False):
        return self.coefficient_display_str + self.variable_str

    def __str__(self):
        return self.coefficient_str + self.variable_str


class LinearTerm(LQExpression):
    def __init__(self, variable, coefficient=1):
        self.variable = variable
        self.coefficient = coefficient

    @property
    def variables(self):
        # used by __str__ in Term
        return [self.variable]


class QuadraticTerm(LQExpression):
    def __init__(self, variable1, variable2, coefficient=1):
        self.variable1 = variable1
        self.variable2 = variable2
        self.coefficient = coefficient

    @property
    def variables(self):
        return [self.variable1, self.variable2]


class LQSum(LQExpression):
    def __init__(self, terms):
        self.linear_terms = []
        self.quadratic_terms = []
        self.constant = None
        self.nonlinear_terms = []

    def _append_term(self, term, terms):
        if

    def add_linear_term(self, term):
        pass




if __name__ == "__main__":
    a = Variable('a')
    b = Variable('b')
    c = Variable('c')

    #print a + b
    #print a + b * c + 3 + Not(c)
    #print a | b

    la = LinearTerm(a)
    print a + b
    print la + b
    print b + la





