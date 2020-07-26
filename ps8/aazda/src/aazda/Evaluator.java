/*
 ** cs1120 Fall 2011
 ** Problem Set 8
 **
 ** You will need to make changes to this file.  Mark the changes you make clearly
 ** with comments.
 */

// Your name: _____________________________

package aazda;

import java.util.ArrayList;

public class Evaluator {
    public static SVal meval(SExpr expr, Environment env) {
        if (isPrimitive(expr)) {
            return evalPrimitive(expr);
        } else if (isName(expr)) {
            return evalName(expr, env);
        } else if (isIf(expr)) {
            return evalIf(expr, env);
        } else if (isCond(expr)) {
            return evalCond(expr, env);
        } else if (isDefinition(expr)) {
            evalDefinition(expr, env);
            return null;
        } else if (isLambda(expr)) {
            return evalLambda(expr, env);
        } else if (isAssigment(expr)) {
            evalAssigment(expr, env);
            return null;
        } else if (isBegin(expr)) {
            return evalBegin(expr, env);
        } else if (isApplication(expr)) {
            return evalApplication(expr, env);
        } else {
            throw new EvalError("Unknown expression type: " + expr.toString());
        }
    }

    private static boolean isPrimitive(SExpr expr) {
        return (isNumber(expr) || isPrimitiveProcedure(expr) || isNull(expr));
    }

    private static boolean isNumber(SExpr expr) {
        if (expr.isAtom()) {
            try {
                // Integer.parseInt attempts to interpret a String at an
                // integer.
                // If it is invalid, it throws a NumberFormatException, so we
                // return false.
                // If it succeeds, we return true.
                Integer.parseInt(expr.getAtom());
                return true;
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return false;
    }

    private static boolean isNull(SExpr expr) {
        return expr.isAtom() && expr.getAtom().equals("null");
    }

    private static boolean isPrimitiveProcedure(SExpr sexpr) {
        return sexpr.isAtom() && isPrimitiveProcedure(sexpr.getAtom());
    }

    private static boolean isPrimitiveProcedure(String nexpr) {
        return (nexpr.equals("+") || nexpr.equals("*") || nexpr.equals("-")
                || nexpr.equals("=") || nexpr.equals("zero?")
                || nexpr.equals("<") || nexpr.equals(">") || nexpr.equals("<=")
                || nexpr.equals("cons") || nexpr.equals("car")
                || nexpr.equals("cdr") || nexpr.equals("null?")
                || nexpr.equals("list"));
    }

    public static boolean isSpecialForm(SExpr expr, String keyword) {
        return (expr.isList() && expr.getList().size() > 0
                && expr.getList().get(0).isAtom()
                && expr.getList().get(0).getAtom().equals(keyword));
    }

    public static boolean isIf(SExpr expr) {
        return isSpecialForm(expr, "if");
    }

    public static boolean isCond(SExpr expr) {
        return isSpecialForm(expr, "cond");
    }

    public static boolean isLambda(SExpr expr) {
        return isSpecialForm(expr, "lambda");
    }

    public static boolean isDefinition(SExpr expr) {
        return isSpecialForm(expr, "define");
    }

    public static boolean isApplication(SExpr expr) {
        // Requires expr is not a special form (must be checked first)
        return expr.isList();
    }

    public static boolean isName(SExpr expr) {
        // Requires expr is not a primitive
        return expr.isAtom();
    }

    public static boolean isAssigment(SExpr expr) {
        return isSpecialForm(expr, "set!");
    }

    public static boolean isBegin(SExpr expr){
    	return isSpecialForm(expr,"begin");
	}

    public static SVal evalPrimitive(SExpr expr) {
        if (isNumber(expr)) {
            return new SVal(Integer.parseInt(expr.getAtom()));
        } else if (isNull(expr)) {
            return new SVal(null);
        } else {
            assert isPrimitiveProcedure(expr);
            return new SVal(expr.getAtom());
        }
    }

    public static SVal evalIf(SExpr expr, Environment env) {
        assert (isIf(expr));
        ArrayList<SExpr> ifExpr = expr.getList();
        if (ifExpr.size() != 4) {
            throw new EvalError("Bad if expression: " + expr.toString());
        }
        if (!meval(ifExpr.get(1), env).isFalse()) {
            return meval(ifExpr.get(2), env);
        } else {
            return meval(ifExpr.get(3), env);
        }
    }

    public static void evalDefinition(SExpr expr, Environment env) {
        assert isDefinition(expr);
        ArrayList<SExpr> def = expr.getList();
        if (def.size() != 3) {
            throw new EvalError("Bad definition " + expr.toString());
        }
        if (!def.get(1).isAtom()) {
            throw new EvalError("Bad definition: name must be a string: "
                    + expr.toString());
        }

        String name = def.get(1).getAtom();
        SVal value = meval(def.get(2), env);
        env.addVariable(name, value);
    }

    public static void evalAssigment(SExpr expr, Environment env) {
        assert isAssigment(expr);
        ArrayList<SExpr> assignments = expr.getList();
        if (assignments.size() != 3) {
            throw new EvalError("Bad assigment " + expr.toString());
        }
        if (!assignments.get(1).isAtom()) {
            throw new EvalError("Bad assigment: name must be a string: "
                    + expr.toString());
        }

        String name = assignments.get(1).getAtom();
        SVal value = meval(assignments.get(2), env);
        if (env.lookupVariable(name) != null) {
            env.setVariable(name, value);
        }
    }

	public static SVal evalBegin(SExpr expr, Environment env) {
		assert isBegin(expr);
		ArrayList<SExpr> evalList = expr.getList();
		int evalListSize = evalList.size();
		SVal returnValue = new SVal() ;
		if (evalListSize < 2) {
			throw new EvalError("Bad begin " + expr.toString());
		}


		for (int i = 1; i <= evalListSize -1 ; i++) {
			if(i == evalListSize -1){
				returnValue = meval(evalList.get(i), env);
			}else{
				meval(evalList.get(i), env);
			}
		}
		return  returnValue;
	}

    public static SVal evalName(SExpr expr, Environment env) {
        assert isName(expr);
        return env.lookupVariable(expr.getAtom());
    }

    public static SVal evalApplication(SExpr expr, Environment env) {
        assert isApplication(expr);
        ArrayList<SExpr> sexpr = expr.getList();
        SVal pval = meval(sexpr.get(0), env);

        ArrayList<SVal> operands = new ArrayList<SVal>();
        for (SExpr op : sexpr.subList(1, sexpr.size())) {
            operands.add(meval(op, env));
        }

        if (pval.isProcedure()) {
            return mapply(pval.getProcedure(), operands);
        } else if (pval.isString() && isPrimitiveProcedure(pval.getString())) {
            return applyPrimitive(pval.getString(), operands);
        } else {
            throw new EvalError("Application of non-procedure: " + pval);
        }
    }

    public static SVal applyPrimitive(String pname, ArrayList<SVal> operands) {
        if (pname.equals("+")) {
            return Primitives.primitivePlus(operands);
        } else if (pname.equals("-")) {
            return Primitives.primitiveMinus(operands);
        } else if (pname.equals("*")) {
            return Primitives.primitiveTimes(operands);
        } else if (pname.equals("=")) {
            return Primitives.primitiveEquals(operands);
        } else if (pname.equals("cons")) {
            return Primitives.primitiveCons(operands);
        } else if (pname.equals("car")) {
            return Primitives.primitiveCar(operands);
        } else if (pname.equals("cdr")) {
            return Primitives.primitiveCdr(operands);
        } else if (pname.equals("zero?")) {
            return Primitives.primitiveZero(operands);
        } else if (pname.equals("null?")) {
            return Primitives.primitiveNullTest(operands);
        } else if (pname.equals("list")) {
            return Primitives.primitiveList(operands);
        } else if (pname.equals("<")) {
            return Primitives.primitiveLessThan(operands);
        } else if (pname.equals(">")) {
            return Primitives.primitiveGreater(operands);
        } else if (pname.equals("<=")) {
            return Primitives.primitiveLessThanEquals(operands);
        } else {
            throw new EvalError("Unknown primitive procedure: " + pname);
        }
    }

    public static SVal mapply(Procedure proc, ArrayList<SVal> operands) {
        ArrayList<String> params = proc.getParams();
        Environment newenv = new Environment(proc.getEnvironment());
        if (params.size() != operands.size()) {
            throw new EvalError("Parameter length mismatch: " + proc.toString()
                    + " given operands " + operands.toString() + " expected "
                    + params.size() + " operands");
        }
        for (int i = 0; i < operands.size(); i++) {
            newenv.addVariable(params.get(i), operands.get(i));
        }
        return meval(proc.getBody(), newenv);
    }

    public static SVal evalCond(SExpr expr, Environment env) {
        assert (isCond(expr));

        for (SExpr clause : expr.getList().subList(1, expr.getList().size())) {
            if (!clause.isList()) {
                throw new EvalError("Bad cond clause: " + clause);
            }
            ArrayList<SExpr> clpair = clause.getList();
            if (clpair.size() != 2) {
                throw new EvalError("Bad cond clause: " + clause);
            }
            if (!meval(clpair.get(0), env).isFalse()) {
                return meval(clpair.get(1), env);
            }
        }
        return new SVal();
    }

    public static SVal evalLambda(SExpr expr, Environment env) {
        assert (isLambda(expr));
        ArrayList<SExpr> lambdaExpr = expr.getList();
        if (lambdaExpr.size() != 3) {
            throw new EvalError("Bad lambda expression: " + expr.toString());
        }
        return new SVal(
                new Procedure(lambdaExpr.get(1), lambdaExpr.get(2), env));
    }
}