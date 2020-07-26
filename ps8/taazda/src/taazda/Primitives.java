package taazda;

import java.util.ArrayList;

public class Primitives {
	private static void checkOperands(ArrayList<SVal> operands, int num,
			String prim) throws EvalError {
		if (operands.size() != num) {
			throw new EvalError(String.format(
					"Primitive %s expected %s operands, given %s: %s", prim,
					num, operands.size(), operands.toString()));
		}
	}

	private static void checkNumbers(ArrayList<SVal> operands, String op)
			throws EvalError {
		for (int i = 0; i < operands.size(); i++) {
			if (!operands.get(i).isInteger()) {
				throw new EvalError(
						String.format(
								"Primitive %s expects all operands to be Numbers, but operand %d is a %s",
								op, i, operands.get(i).getAType()));
			}
		}
	}

	public static SVal primitivePlus(ArrayList<SVal> operands) throws EvalError {
		checkNumbers(operands, "+");
		if (operands.size() == 0)
			return new SVal(0);
		else {
			return new SVal(operands.remove(0).integerValue()
					+ primitivePlus(operands).integerValue());
		}
	}

	public static SVal primitiveTimes(ArrayList<SVal> operands)
			throws EvalError {
		checkNumbers(operands, "*");
		if (operands.size() == 0)
			return new SVal(1);
		else {
			return new SVal(operands.remove(0).integerValue()
					* primitiveTimes(operands).integerValue());
		}
	}

	public static SVal primitiveMinus(ArrayList<SVal> operands)
			throws EvalError {
		checkNumbers(operands, "-");
		if (operands.size() == 1) {
			return new SVal(-1 * operands.get(0).integerValue());
		} else if (operands.size() == 2) {
			return new SVal(operands.get(0).integerValue()
					- operands.get(1).integerValue());
		} else {
			throw new EvalError(String.format(
					"Primitive - expects 1 or 2 operands, given %s: %s",
					operands.size(), operands.toString()));
		}
	}

	public static SVal primitiveEquals(ArrayList<SVal> operands)
			throws EvalError {
		checkOperands(operands, 2, "=");
		checkNumbers(operands, "=");
		return new SVal(operands.get(0).integerValue() == operands.get(1)
				.integerValue());
	}

	public static SVal primitiveZero(ArrayList<SVal> operands) throws EvalError {
		checkOperands(operands, 1, "zero?");
		if (operands.get(0).isInteger()) {
			return new SVal(operands.get(0).integerValue() == 0);
		} else {
			return new SVal(false);
		}
	}

	public static SVal primitiveGreater(ArrayList<SVal> operands)
			throws EvalError {
		checkOperands(operands, 2, ">");
		checkNumbers(operands, ">");
		return new SVal(operands.get(0).integerValue() > operands.get(1)
				.integerValue());
	}

	public static SVal primitiveLessThan(ArrayList<SVal> operands)
			throws EvalError {
		checkOperands(operands, 2, "<");
		checkNumbers(operands, "<");
		return new SVal(operands.get(0).integerValue() < operands.get(1)
				.integerValue());
	}

	public static SVal primitiveLessThanEquals(ArrayList<SVal> operands)
			throws EvalError {
		checkOperands(operands, 2, "<=");
		checkNumbers(operands, "<=");
		return new SVal(operands.get(0).integerValue() <= operands.get(1)
				.integerValue());
	}
}
