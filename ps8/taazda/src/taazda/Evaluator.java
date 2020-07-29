/*
 * Typed AAzda evaluator
 * cs1120 Fall 2011 - Problem Set 8 (Part 2)
 */
package taazda;

import java.util.ArrayList;

public class Evaluator {	
	public static SVal meval(SExpr expr, Environment env) throws EvalError, TypeError {
		// Before evaluating, check types:
		typeCheck(expr, env);
		
		if (isPrimitive(expr)) {
			return evalPrimitive(expr);
		} else if (isName(expr)) {
			return evalName(expr, env);
		} else if (isIf(expr)) {
			return evalIf(expr, env);
		} else if (isCond(expr)) {
			return evalCond(expr, env);
		} else if (isAssignment(expr)) {
			evalAssignment(expr, env);
			return null;
		} else if (isDefinition(expr)) {
			evalDefinition(expr, env);
			return null;
		} else if (isLambda(expr)) {
			return evalLambda(expr, env);
		} else if (isBegin(expr)) {
			return evalBegin(expr, env);
		} else if (isApplication(expr)) {
			return evalApplication(expr, env);
		} else {
			throw new EvalError("Unknown expression type: " + expr.toString());
		}
	}

	public static AType typeCheck(SExpr expr, Environment env) {
		if (isPrimitive(expr)) {
			return typePrimitive(expr);
		} else if (isName(expr)) {
			return typeName(expr, env);
		} else if (isIf(expr)) {
			return typeIf(expr, env);
		} else if (isCond(expr)) {
			return typeCond(expr, env);
		} else if (isAssignment(expr)) {
			typeAssignment(expr, env);
			return AType.Void;
		} else if (isDefinition(expr)) {
			typeDefinition(expr, env);
			return AType.Void;
		} else if (isLambda(expr)) {
			return typeLambda(expr, env);
		} else if (isBegin(expr)) {
			return typeBegin(expr, env);
		} else if (isApplication(expr)) {
			return typeApplication(expr, env);
		} else {
			throw new TypeError("Unknown expression type: " + expr.toString());
		}
	}

	private static boolean isPrimitive(SExpr expr) {
		return (isNumber(expr)); 
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

	public static boolean isAssignment(SExpr expr) {
		return isSpecialForm(expr, "set!");
	}
	
	public static boolean isBegin(SExpr expr) {
		return isSpecialForm(expr, "begin");
	}

	public static boolean isApplication(SExpr expr) {
		// Requires expr is not a special form (must be checked first)
		return expr.isList();
	}

	public static boolean isName(SExpr expr) {
		// Requires expr is not a primitive
		return expr.isAtom();
	}

	public static SVal evalPrimitive(SExpr expr) {
		if (isNumber(expr)) {
			return new SVal(Integer.parseInt(expr.getAtom()));
		} else {
			throw new EvalError("Bad primitive: " + expr);
		}
	}

	public static AType typePrimitive(SExpr expr) {
		if (isNumber(expr)) {
			return AType.Number;
		} else {
			return AType.Error;  
		}
	}

	public static SVal evalIf(SExpr expr, Environment env) throws EvalError {
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

	public static AType typeIf(SExpr expr, Environment env) throws EvalError {
		assert (isIf(expr));
		ArrayList<SExpr> ifExpr = expr.getList();
		if (ifExpr.size() != 4) {
			throw new EvalError("Bad if expression: " + expr.toString());
		}
		
		// Check the predicate is a Boolean
		AType predType = typeCheck(ifExpr.get(1), env);
		if (!predType.isBoolean()) {
			throw new TypeError("Predicate for an in expression must be a Boolean.  Type is: " 
					+ predType); 
		}
		
		// Check both clauses have the same type
		AType consequentType = typeCheck(ifExpr.get(2), env);
		AType alternateType = typeCheck(ifExpr.get(3), env);
	
		if (consequentType.match(alternateType)) {
			return consequentType;
		} else {
			throw new TypeError("Clauses for if must have matching types.  Types are: " 
					+ consequentType.toString() + " / " + alternateType.toString());
		}
	}

	public static void evalDefinition(SExpr expr, Environment env)
			throws EvalError {
		assert isDefinition(expr);
		ArrayList<SExpr> def = expr.getList();
		if (def.size() != 5) {
			throw new EvalError("Bad definition " + expr.toString());
		}
		if (!def.get(1).isAtom()) {
			throw new EvalError("Bad definition: name must be a string: "
					+ expr.toString());
		}

		if (!(def.get(2).isAtom() && def.get(2).getAtom().equals(":"))) {
			throw new EvalError("Bad definition: missing type specification colon: " + expr.toString());
		}

		String name = def.get(1).getAtom();
		AType type = AType.parseType(def.get(3));
		env.addVariable(name, type);		
		SVal value = meval(def.get(4), env);
		assert value != null;
		assert (type.match(value.getAType()));
		env.updateVariable(name, value);
	}

	public static void typeDefinition(SExpr expr, Environment env)
			throws EvalError {
		assert isDefinition(expr);
		ArrayList<SExpr> def = expr.getList();
		if (def.size() != 5) {
			throw new EvalError("Bad definition " + expr.toString());
		}
		if (!def.get(1).isAtom()) {
			throw new EvalError("Bad definition: name must be a string: "
					+ expr.toString());
		}

		if (!(def.get(2).isAtom() && def.get(2).getAtom().equals(":"))) {
			throw new EvalError("Bad definition: missing type specification colon: " + expr.toString());
		}

		String name = def.get(1).getAtom();
		AType type = AType.parseType(def.get(3));
		Environment newEnv = new Environment(env);
		newEnv.addVariable(name,type);
		AType valtype = typeCheck(def.get(4), newEnv);

		if (!type.match(valtype)) {
			throw new TypeError("Type mismatch.  Definition of " + name + " value " + def.get(4) + " has type "
					+ valtype.toString() + ", but declared with type " + type);
		}
	}

	public static void evalAssignment(SExpr expr, Environment env)
			throws EvalError {
		assert isAssignment(expr);
		ArrayList<SExpr> def = expr.getList();
		if (def.size() != 3) {
			throw new EvalError("Bad assignment: " + expr.toString());
		}
		if (!def.get(1).isAtom()) {
			throw new EvalError("Bad assignment: name must be a string: "
					+ expr.toString());
		}

		String name = def.get(1).getAtom();
		
		if (!env.hasVariable(name)) {
			throw new EvalError("Bad assignment: name must be defined: "
					+ expr.toString());
		}
		
		SVal value = meval(def.get(2), env);
		env.updateVariable(name, value);
	}

	public static void typeAssignment(SExpr expr, Environment env) throws TypeError {
		/* Complete this for Problem 1 (Hint: start by copying evalAssignment) */
		ArrayList<SExpr> def = expr.getList();
		if (def.size() != 3) {
			throw new TypeError("Bad assignment: " + expr.toString());
		}
		if (!def.get(1).isAtom()) {
			throw new TypeError("Bad assignment: name must be a string: "
					+ expr.toString());
		}

		String name = def.get(1).getAtom();

		if (!env.hasVariable(name)) {
			throw new TypeError("Bad assignment: name must be defined: "
					+ expr.toString());
		}

		AType type = env.lookupVariableType(name); //不是lookupVariable

		AType valtype = typeCheck(def.get(2), env);

		if (!type.match(valtype)) {
			throw new TypeError("Assignment type mismatch: place " + name + " has type " + type + ", but value "
					+ def.get(2) + " has type " + valtype);
		}
	}

	public static SVal evalName(SExpr expr, Environment env) throws EvalError {
		assert isName(expr);
		return env.lookupVariable(expr.getAtom());
	}

	public static AType typeName(SExpr expr, Environment env) throws TypeError {
		assert isName(expr);
		return env.lookupVariableType(expr.getAtom());
	}

	public static SVal evalApplication(SExpr expr, Environment env)
			throws EvalError {
		assert isApplication(expr);
		ArrayList<SExpr> sexpr = expr.getList();
		SVal pval = meval(sexpr.get(0), env);

		ArrayList<SVal> operands = new ArrayList<SVal>();
		for (SExpr op : sexpr.subList(1, sexpr.size())) {
			operands.add(meval(op, env));
		}

		if (pval.isProcedure()) {
			return mapply(pval.getProcedure(), operands);
		} else if (pval.isPrimitiveProcedure()) {
			return pval.getPrimitiveProcedure().apply(operands); 
		} else {
			throw new EvalError("Application of non-procedure: " + pval);
		}
	}

	public static AType typeApplication(SExpr expr, Environment env) {
		assert isApplication(expr);
		ArrayList<SExpr> sexpr = expr.getList();
		AType ptype = typeCheck(sexpr.get(0), env);

		ArrayList<AType> optypes = new ArrayList<AType>();
		for (SExpr op : sexpr.subList(1, sexpr.size())) {
			optypes.add(typeCheck(op, env));
		}

		if (ptype instanceof AProcedureType) {
			AProcedureType proctype = (AProcedureType) ptype;
			ArrayList<AType> ptypes = proctype.getParameterTypes();
			
			if (ptypes.size() != optypes.size()) {
				throw new TypeError("Procedure " + sexpr.get(0) + " expects " 
						+ ptypes.size() + " inputs, but given " + optypes);
			}
			
			for (int i = 0; i < ptypes.size(); i++) {
				if (!optypes.get(i).match(ptypes.get(i))) {
					throw new TypeError ("Parameter type mismatch: input " + (i + 1) + 
							" for " + sexpr.get(0) + " expects type " + ptypes.get(i)
							+ " given type " + optypes.get(i));
				}
			}

			return proctype.getResultType();
		} else {
			throw new TypeError("Application of non-procedure: " + ptype);
		}
	}

	public static SVal mapply(Procedure proc, ArrayList<SVal> operands)
			throws EvalError {
		ArrayList<Param> params = proc.getParams();
		Environment newenv = new Environment(proc.getEnvironment());
		if (params.size() != operands.size()) {
			throw new EvalError("Parameter length mismatch: " + proc.toString()
					+ " given operands " + operands.toString() + " expected "
					+ params.size() + " operands");
		}
		for (int i = 0; i < operands.size(); i++) {
			newenv.addVariable(params.get(i).name, params.get(i).type, operands.get(i));
		}
		return meval(proc.getBody(), newenv);
	}

	public static SVal evalBegin(SExpr expr, Environment env) throws EvalError {
		assert (isBegin(expr));
		SVal res = null;
		for (SExpr s : expr.getList().subList(1, expr.getList().size())) {
			res = meval(s, env);
		}
		return res;
	}

	public static AType typeBegin(SExpr expr, Environment env) throws EvalError {
		/* Define for Problem 2 */
		assert (isBegin(expr));
		AType returnType = null;
		for (SExpr s : expr.getList().subList(1, expr.getList().size())) {
			returnType = typeCheck(s, env);;
		}
		return returnType;
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
		return null; 
		// this was a bug in the part 1 version: return new SVal()
		// it should return null since (cond) has no value. 
	}

	public static AType typeCond(SExpr expr, Environment env) {
		/* Define for Problem 3 */
		assert (isCond(expr));
		AType returnType = null;

		if(expr.getList().size() == 1){
			return AType.Void;
		}

		for (SExpr clause : expr.getList().subList(1, expr.getList().size())) {
			if (!clause.isList()) {
				throw new TypeError("Bad cond clause: " + clause);
			}
			ArrayList<SExpr> clpair = clause.getList();
			if (clpair.size() != 2) {
				throw new TypeError("Bad cond clause: " + clause);
			}

			if (!typeCheck(clpair.get(0), env).isBoolean()) {
				throw new TypeError("Cond clause is not a Boolean: " + clpair.get(0));
			}
			AType clauseType = typeCheck(clpair.get(1),env);

			if(returnType == null){
				returnType = clauseType;
			}else{
				if(!returnType.match(clauseType)){
					throw new TypeError("Cond clauses have inconsistent types: first clause has type "
							+ returnType +
							" but clause " + clpair.get(1) + " has type "+ clauseType);
				}
			}
		}
		return returnType;
	}
	
	public static SVal evalLambda(SExpr expr, Environment env) {
		assert (isLambda(expr));
		ArrayList<SExpr> lambdaExpr = expr.getList();
		if (lambdaExpr.size() != 3) {
			throw new EvalError("Bad lambda expression: " + expr.toString());
		}
		AType ptype = typeLambda(expr, env);
		SVal res = new SVal(new Procedure(lambdaExpr.get(1), lambdaExpr.get(2), ptype, env));
		return res;
	}

	public static AType typeLambda(SExpr expr, Environment env) {
		assert (isLambda(expr));
		ArrayList<SExpr> lambdaExpr = expr.getList();
		if (lambdaExpr.size() != 3) {
			throw new TypeError("Bad lambda expression: " + expr.toString());
		}

		ArrayList<AType> ptypes = new ArrayList<AType> ();
		Environment bodyEnv = new Environment(env);
		
		if (!lambdaExpr.get(1).isList()) {
			throw new TypeError("Bad lambda parameters: " + lambdaExpr.get(1).toString());
		}
		
		ArrayList<SExpr> params = lambdaExpr.get(1).getList();
		for (SExpr param : params) {
			if (!param.isList()) {
				throw new TypeError("Bad lambda parameter (should be list): " + param);
			}
			ArrayList<SExpr> plist = param.getList();
			if (!(plist.size() == 3)) {
				throw new TypeError("Bad lambda parameter (wrong size): " + param);
			}

			if (plist.get(1).equals(":")) {
				throw new TypeError("Bad lambda parameter (missing :): " + param);
			}
			if (!plist.get(0).isAtom()) {
				throw new TypeError("Bad lambda parameter name: " + param);
			}
			String pname = plist.get(0).getAtom();
			AType ptype = AType.parseType(plist.get(2));
			ptypes.add(ptype);
			bodyEnv.addVariable(pname, ptype);
		}

		AType btype = typeCheck(lambdaExpr.get(2), bodyEnv);
		
		return new AProcedureType(btype, ptypes);
	}
}