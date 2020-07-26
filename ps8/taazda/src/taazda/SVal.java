package taazda;

public class SVal {
	private Object value;
	static Object VoidObject = new Object();

	public SVal(int v) {
		value = new Integer(v);
	}

	public SVal(boolean b) {
		value = new Boolean(b);
	}

	public SVal(PrimitiveProcedure p) {
		value = p;
	}
	
	public SVal(Procedure p) {
		value = p;
	}

	public SVal() {
		value = VoidObject; // represents void value (no value)
	}

	
	public AType getAType() {
		if (value instanceof Boolean) {
			return AType.Boolean;
		} else if (value instanceof Number) {
			return AType.Number;
		} else if (value instanceof Procedure) {
			return ((Procedure) value).getAType();
		} else if (value instanceof PrimitiveProcedure) {
			return ((PrimitiveProcedure) value).getAType();
		} else if (value instanceof SExpr) {
			return AType.Error; //!
		} else {
			return AType.Error;
		}
	}
	
	public SExpr getSExpr() {
		assert value instanceof SExpr;
		return (SExpr) value;
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

	public boolean isPrimitiveProcedure() {
		return value != null && value instanceof PrimitiveProcedure;
	}

	public Procedure getProcedure() {
		assert isProcedure();
		return (Procedure) value;
	}
	
	public PrimitiveProcedure getPrimitiveProcedure() {
		assert isPrimitiveProcedure();
		return (PrimitiveProcedure) value;
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
