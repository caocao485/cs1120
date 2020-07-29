###
### Chapter 11: Interpreters
### Charme Interpreter Code
###
### David Evans, March 2009
### Updated for cs1120 Fall 2011, Problem Set 7
###
### You should modify this file to answer the questions
### for PS7.  For some of the questions, write your
### answers at the beginning of this file.  For others,
### you will need to find the right places to modify
### in the provided code:
###
###
### Name(s): _______________________
###
### Email ID(s): ______
###

authors = ['*** your email id ***', '*** partner email id (if applicable) ***']

### Question 1:

question1 = """
    <enter your answer here>
"""

### Question 2:

charmeFactorialDefinition = """
   (define fact (lambda(n)(if(= n 1)1(* n (fact (- n 1))))))
   """

### Questions 3-8:
### Modify the provided interpreter code below
## question 3
def primitiveLessThanOrEquals (operands):
    checkOperands (operands, 2, '<=')
    return operands[0] <= operands[1]

## question 4
class Cons:
    def __init__(self,first,second):
        self._first = first
        self._second = second
    
    def getFirst(self):
        return self._first
    
    def getSecond(self):
        return self._second
    
    def __str__(self):
        return "(" + str(self._first) + " . " + str(self._second) + ")"
    
def primitiveCons (operands):
    checkOperands (operands, 2, 'cons')
    return Cons(operands[0],operands[1])

def primitiveCar (operands):
    checkOperands (operands, 1, 'car')
    return operands[0].getFirst()

def primitiveCdr (operands):
    checkOperands (operands, 1, 'cdr')
    return operands[0].getSecond()

## question 5
def primitiveTestNull(operands):
    checkOperands (operands, 1, 'null?')
    return operands[0] is  None

## question 6
class List:
    def __init__(self,args):
        self._elements = args
    
    def getFirst(self):
        return self._elements[0]
    
    def getSecond(self):
        rest = self._elements[1:]
        if len(rest) == 0:
            return None
        else: 
            return List(rest)
    
    def __str__(self):
        listString = "("
        for element in self._elements:
            listString += str(element) + " "
        return listString.strip() + ")"

def primitiveList(operands):
    if len(operands) == 0:
        return None
    else:
        return List(operands)

## question 7
def isCond(expr):
    return isSpecialForm(expr, 'cond')

def evalCond(expr,env):
    assert isCond(expr)
    if len(expr) == 1:
        return None
    elif len(expr[1]) != 2:
        evalError ('Bad if expression: %s' % str(expr))
    else:
        if meval(expr[1][0], env) != False:
            return meval(expr[1][1], env)
        else:
            rest = expr[2:]
            rest.insert(0,'cond')
            return meval(rest,env)

### Question 9:

pleased = """
Replace this with text explaining what you are most pleased about this course.
"""

displeased = """ 
Replace this with text explaining what you are most displeased about this course.
"""

hopetolearn = """
Replace this with text explaining what specific things you hope to learn in the remainder of the course.
"""

### Question 10:
### a. (mark your modifications in the interpreter clearly)

def isOr(expr):
    return isSpecialForm(expr, 'or')

def evalOr(expr,env):
    assert isOr(expr)
    if len(expr) < 3:
        evalError ('Bad if expression: %s' % str(expr))
    if len(expr) == 3:
        return meval(expr[1],env) or meval(expr[2],env)
    else:
        rest = expr[2:]
        rest.insert(0,'or')
        return meval(expr[1],env) or meval(rest,env)

def isAnd(expr):
    return isSpecialForm(expr, 'and')

def evalAnd(expr,env):
    assert isAnd(expr)
    if len(expr) < 3:
        evalError ('Bad And expression: %s' % str(expr))
    if len(expr) == 3:
        return meval(expr[1],env) and meval(expr[2],env)
    else:
        rest = expr[2:]
        rest.insert(0,'and')
        return meval(expr[1],env) and meval(rest,env)

def isFor(expr):
    return isSpecialForm(expr,'for')

def evalFor(expr,env):
    assert isFor(expr)
    if len(expr) != 5:
         evalError ('Bad For expression: %s' % str(expr))
    name = expr[1]
    if isinstance(name, str) and expr[2] == 'in' :
        value = meval(expr[3], env)
        if value is None:
            return None
        if isinstance(value,List):
            resultList = []
            newenv = Environment(env)
            newenv.addVariable(name, None)
            for val in value._elements:
                newenv.addVariable(name,val)
                resultList.append(meval(expr[4],newenv))
            return List(resultList)
        else:
            evalError ('Bad For expression: %s' % str(expr))
    else:
        evalError ('Bad For expression: %s' % str(expr))




editDistanceDefinition = """


"""

### b.

editDistanceCharmeAnalysis = """

"""

### c.

editDistanceSchemeAnalysis = """

"""

###
### Charme Interpreter
### This is the code from Chapter 11 of the course book.
###
    
    
def tokenize(s): # starts a comment until the end of the line
    current = ''  # initialize current to the empty string(two single quotes)
    tokens = []  # initialize tokens to the empty list
    for c in s:  # for each character , c , in the string s
        if c.isspace():  # if c is a whitespace
            if len(current) > 0:  # if the current token is non-empty
                tokens.append(current) # add it to the list
                current = ''  # reset current token to empty string
        elif c in '()':  # otherwise if c is a parenthesis
            if len(current) > 0:  # end the current token
                tokens.append(current) # add it to the tokens list
                current = '' # add reset current to the empty string
            tokens.append(c) # add the parenthesis to the token list
        else:  # otherwise (it is an alphanumeric)
            current = current + c # add the character to the current token
    # end of the for loop
    if len(current) > 0: # if there is a current token
        tokens.append(current) # add it to the token list
    return tokens  # the result is the list of tokens

def parse(s):
    def parsetokens(tokens, inner):
       res = []
       while len(tokens) > 0:
          current = tokens.pop(0)
          if current == '(':
             res.append (parsetokens(tokens, True))
          elif current == ')':
             if inner:
                return res
             else:
                parseError('Unmatched close paren: ' + s)
                return None
          else:
             res.append(current)
        
       if inner:
          parseError ('Unmatched open paren: ' + s)
          return None
       else:
          return res

    return parsetokens(tokenize(s), False)

###
### Evaluator
###

def meval(expr, env):
    if isPrimitive(expr):
       return evalPrimitive(expr)
    elif isIf(expr):             
        return evalIf(expr, env) 
    elif isCond(expr):
        return evalCond(expr,env)
    elif isOr(expr):
        return evalOr(expr,env)
    elif isAnd(expr):
        return evalAnd(expr,env)
    elif isFor(expr):
        return evalFor(expr,env)
    elif isDefinition(expr):                
       evalDefinition(expr, env)
    elif isName(expr):
       return evalName(expr, env)
    elif isLambda(expr):
       return evalLambda(expr, env)
    elif isApplication(expr):
       return evalApplication(expr, env)
    else:
       evalError ('Unknown expression type: ' + str(expr))

### Primitives

def isPrimitive(expr):
    return (isNumber(expr) or isPrimitiveProcedure(expr))

def isNumber(expr):
    return isinstance(expr, str) and expr.isdigit()

def evalPrimitive(expr):
    if isNumber(expr):
        return int(expr)
    else:
        return expr

def isPrimitiveProcedure(expr):
    return callable(expr)

def primitivePlus (operands):
    if (len(operands) == 0):
       return 0
    else:
       return operands[0] + primitivePlus (operands[1:])

def primitiveTimes (operands):
    if (len(operands) == 0):
       return 1
    else:
       return operands[0] * primitiveTimes (operands[1:])
    
def primitiveMinus (operands):
    if (len(operands) == 1):
       return -1 * operands[0]
    elif len(operands) == 2:
       return operands[0] - operands[1]
    else:
       evalError('- expects 1 or 2 operands, given %s: %s' % (len(operands), str(operands)))

def primitiveEquals (operands):
    checkOperands (operands, 2, '=')
    return operands[0] == operands[1]

def primitiveZero (operands):
    checkOperands (operands, 1, 'zero?')
    return operands[0] == 0

def primitiveGreater (operands):
    checkOperands (operands, 2, '>')
    return operands[0] > operands[1]

def primitiveLessThan (operands):
    checkOperands (operands, 2, '<')
    return operands[0] < operands[1]

def checkOperands(operands, num, prim):
    if (len(operands) != num):
       evalError('Primitive %s expected %s operands, given %s: %s' 
                 % (prim, num, len(operands), str(operands)))

### Special Forms
       
def isSpecialForm(expr, keyword):
    return isinstance(expr, list) and len(expr) > 0 and expr[0] == keyword

def isIf(expr):
    return isSpecialForm(expr, 'if')

def evalIf(expr,env):
    assert isIf(expr)
    if len(expr) != 4:
        evalError ('Bad if expression: %s' % str(expr))
    if meval(expr[1], env) != False:
        return meval(expr[2],env)
    else:
        return meval(expr[3],env)

### Definitions and Names

class Environment:
    def __init__(self, parent):
        self._parent = parent
        self._frame = {}
    def addVariable(self, name, value):
        self._frame[name] = value
    def lookupVariable(self, name):
        if self._frame.has_key(name):
            return self._frame[name]
        elif (self._parent):
            return self._parent.lookupVariable(name)
        else:
            evalError('Undefined name: %s' % (name))

def isDefinition(expr):
    return isSpecialForm(expr, 'define')

def evalDefinition(expr, env):
    assert isDefinition(expr)
    if len(expr) != 3:
        evalError ('Bad definition: %s' % str(expr))
    name = expr[1]
    if isinstance(name, str):
        value = meval(expr[2], env)
        env.addVariable(name, value)
    else:
        evalError ('Bad definition: %s' % str(expr))

def isName(expr):
    return isinstance(expr, str)

def evalName(expr, env):
    assert isName(expr)
    return env.lookupVariable(expr)

### Procedures

class Procedure:
    def __init__(self, params, body, env):
        self._params = params
        self._body = body
        self._env = env
    def getParams(self):
        return self._params
    def getBody(self):
        return self._body
    def getEnvironment(self):
        return self._env        
    def __str__(self):
        return '<Procedure %s / %s>' % (str(self._params), str(self._body))

def isLambda(expr):
    return isSpecialForm(expr, 'lambda')

def evalLambda(expr,env):
    assert isLambda(expr)
    if len(expr) != 3:
        evalError ('Bad lambda expression: %s' % str(expr))
    return Procedure(expr[1], expr[2], env)

### Applications
                   
def isApplication(expr): # requires: all special forms checked first
    return isinstance(expr, list)
   
def evalApplication(expr, env):
    subexprs = expr
    subexprvals = map (lambda sexpr: meval(sexpr, env), subexprs)
    return mapply(subexprvals[0], subexprvals[1:])

def mapply(proc, operands):
    if (isPrimitiveProcedure(proc)):
        return proc(operands)
    elif isinstance(proc, Procedure):
        key = str(proc) + str(operands)
        if tables.has_key(key):
            return tables[key]
        else:
            params = proc.getParams()
            newenv = Environment(proc.getEnvironment())
            if len(params) != len(operands):
                evalError ('Parameter length mismatch: %s given operands %s' 
                       % (str(proc), str(operands)))
            for i in range(0, len(params)):
                newenv.addVariable(params[i], operands[i])     
            tables[key] = meval(proc.getBody(), newenv)        
            return tables[key]      
    else:
        evalError('Application of non-procedure: %s' % (proc))

### Eval-Loop

def initializeGlobalEnvironment():
    global globalEnvironment
    global tables 
    tables = {}
    globalEnvironment = Environment(None)
    globalEnvironment.addVariable('true', True)
    globalEnvironment.addVariable('false', False)
    globalEnvironment.addVariable('null',None)
    globalEnvironment.addVariable('+', primitivePlus)
    globalEnvironment.addVariable('-', primitiveMinus)
    globalEnvironment.addVariable('*', primitiveTimes)
    globalEnvironment.addVariable('=', primitiveEquals)
    globalEnvironment.addVariable('zero?', primitiveZero)
    globalEnvironment.addVariable('>', primitiveGreater)
    globalEnvironment.addVariable('<', primitiveLessThan)
    globalEnvironment.addVariable('<=',primitiveLessThanOrEquals)
    globalEnvironment.addVariable('cons',primitiveCons)
    globalEnvironment.addVariable('car',primitiveCar)
    globalEnvironment.addVariable('cdr',primitiveCdr)
    globalEnvironment.addVariable('null?',primitiveTestNull)
    globalEnvironment.addVariable('list',primitiveList)
    globalEnvironment.addVariable('min',min)

def evalError(msg): # not in book
    print ("Evaluation Error: " + msg    )
    
def parseError(msg): # not in book
    print("Parse Error: " + msg)

def evalLoop():
    initializeGlobalEnvironment()
    while True:
        inv = raw_input('Charme> ')
        if inv == 'quit': break
        for expr in parse(inv):
            print(str(meval(expr, globalEnvironment)))

def evalInGlobal(expr):
    #initializeGlobalEnvironment()
    return meval(parse(expr)[0], globalEnvironment)

#initializeGlobalEnvironment()
#meval('23', globalEnvironment)
#meval(['+', '1', '2'], globalEnvironment)