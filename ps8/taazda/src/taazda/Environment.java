package taazda;

import java.util.ArrayList;
import java.util.HashMap;

class Place {
	// Place has a type and value
	AType type;
	SVal val;
	
	public Place(AType p_type, SVal p_val) {
		type = p_type;
		val = p_val;
	}
}

public class Environment {
	private Environment parent;
	private HashMap<String, Place> frame;

	public Environment(Environment p_parent) {
		parent = p_parent;
		frame = new HashMap<String, Place>();
	}

	public void addVariable(String name, AType type) {
		// No value, just a type declaration
		//这是type place
		frame.put(name, new Place(type, null));
	}

	public void addVariable(String name, AType type, SVal value) {
		assert value.getAType().match(type);
		frame.put(name, new Place(type, value));
	}

	public boolean hasVariable(String name) {
		if (frame.containsKey(name)) {
			return true; 
		} else {
			return parent.hasVariable(name);
		}
	}
	
	public void updateVariable(String name, SVal val) {
		if (frame.containsKey(name)) {
			Place p = frame.get(name);
			if (val.getAType().match(p.type)) {
				p.val = val;
			} else {
				throw new EvalError("Type mismatch: place type is " + p.type + ", cannot hold " + val.getAType());
			}
		} else {
			parent.updateVariable(name, val);
		}
	}
		
	private Place lookupPlace (String name) throws EvalError {		
		if (frame.containsKey(name)) {
			return frame.get(name);
		} else if (parent != null) {
			return parent.lookupPlace(name);
		} else {
			throw new EvalError("Undefined name " + name);
		}
	}

	public SVal lookupVariable(String name) throws EvalError {
		Place p = lookupPlace(name);
		assert (p.val != null);
		return p.val;
	}

	public AType lookupVariableType(String name) throws EvalError {
		return lookupPlace(name).type;
	}

	public void addPrimitiveProcedure(PrimitiveProcedure p) {
		addVariable(p.getName(), p.getAType(), new SVal(p));
	}
	
	public void initializeGlobalEnvironment() {
		addVariable("true", AType.Boolean, new SVal(true));
		addVariable("false", AType.Boolean, new SVal(false));
		
		// Java doesn't provide first class procedures, so there is no easy way to just
		// associate the methods for implementing primitive procedures with their names.
		// Instead, we use inner classes to define an appropriate apply method for each 
		// primitive.

		addPrimitiveProcedure(					
				new PrimitiveProcedure("+", AType.parseType("((Number Number) -> Number)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitivePlus(ops);	
						}	
					});

		addPrimitiveProcedure(					
				new PrimitiveProcedure("-", AType.parseType("((Number Number) -> Number)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitiveMinus(ops);	
						}	
					});

		addPrimitiveProcedure(					
				new PrimitiveProcedure("*", AType.parseType("((Number Number) -> Number)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitiveTimes(ops);	
						}	
					});

		addPrimitiveProcedure(					
				new PrimitiveProcedure("=", AType.parseType("((Number Number) -> Boolean)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitiveEquals(ops);	
						}	
					});

		addPrimitiveProcedure(					
				new PrimitiveProcedure("zero?", AType.parseType("((Number) -> Boolean)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitiveZero(ops);	
						}	
					});

		addPrimitiveProcedure(					
				new PrimitiveProcedure("<", AType.parseType("((Number Number) -> Boolean)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitiveLessThan(ops);	
						}	
					});

		addPrimitiveProcedure(					
				new PrimitiveProcedure(">", AType.parseType("((Number Number) -> Boolean)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitiveGreater(ops);	
						}	
					});

		addPrimitiveProcedure(					
				new PrimitiveProcedure("<", AType.parseType("((Number Number) -> Boolean)")) {
						public SVal apply(ArrayList<SVal> ops) {
							return Primitives.primitiveLessThanEquals(ops);	
						}	
					});
	}
}
