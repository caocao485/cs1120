package aazda;

public class SVal {
	private Object value;
	static Object VoidObject = new Object();

	public SVal(Object o) {
		value = o;
	}

	public SVal(int v) {
		value = new Integer(v);
	}

	public SVal(boolean b) {
		value = new Boolean(b);
	}

	public SVal() {
		value = VoidObject; // represents void value (no value)
	}

	public SExpr getSExpr() {
		assert value instanceof SExpr;
		return (SExpr) value;
	}

	public boolean isCons() {
		return value instanceof ConsCell;
	}

	public ConsCell consValue() {
		assert isCons();
		return (ConsCell) value;
	}

	public boolean isInteger() {
		return value instanceof Integer;
	}

	public int integerValue() {
		assert isInteger();
		return ((Integer) value).intValue();
	}

	public boolean isFalse() {
		return value instanceof Boolean && !((Boolean) value).booleanValue();
	}

	public boolean isVoid() {
		return value == VoidObject;
	}

	public String getType() {
		if (value instanceof Boolean) {
			return "Boolean";
		} else if (value instanceof Integer) {
			return "Number";
		} else if (value instanceof SExpr) {
			return "SExpr";
		} else {
			return "Unknown";
		}
	}

	public boolean isNull() {
		return value == null;
	}

	public boolean isString() {
		return value != null && value instanceof String;
	}

	public String getString() {
		assert value instanceof String;
		return (String) value;
	}

	public boolean isProcedure() {
		return value != null && value instanceof Procedure;
	}

	public Procedure getProcedure() {
		assert isProcedure();
		return (Procedure) value;
	}

	@Override
	public String toString() {
		if (isNull()) {
			return "null";
		} else if (isString()) {
			return getString(); 
		} else if (isProcedure()) {
			return getProcedure().toString();
		} else if (isVoid()) {
			return "<void>";
		} else {
			return value.toString();
		}
	}
}
