package taazda;

import java.util.ArrayList;

public abstract class AType {
	public static AType Boolean = new APrimitiveType("Boolean");
	public static AType Number = new APrimitiveType("Number");
	public static AType Void = new APrimitiveType("Void");
	public static AType Error = new APrimitiveType("ERROR");
	
	public static AType parseType(SExpr s) {
		if (s.isAtom()) {
			// Could just accept any string, but this is defensive to check it is a valid type name.
			if (s.getAtom().equals("Boolean")) {
				return Boolean;
			} else if (s.getAtom().equals("Number")) {
				return Number;	
			} else if (s.getAtom().equals("Void")) {
				return Void;
			} else {
				throw new EvalError("Unrecognized type name: " + s.getAtom());
			}
		} else {
			//分析( ProductType -> Type) 即函数类型
			ArrayList<SExpr> ptype = s.getList(); 
			if (ptype.size() == 3 && ptype.get(1).isAtom() && ptype.get(1).getAtom().equals("->")) { // valid procedure type
				ArrayList<AType> params = new ArrayList<AType>();
				if (!ptype.get(0).isList()) {
					throw new EvalError("Parameter type must be a list of types: " + ptype.get(2).toString());
				}
				ArrayList<SExpr> pspec = ptype.get(0).getList();
				for (SExpr param : pspec) {
					params.add(parseType(param));
				}
				return new AProcedureType (parseType(ptype.get(2)), params);
			} else {
				throw new EvalError("Unparsable type: " + s.toString());
			}
		}
		
	}

	public static AType parseType(String s) {
		return parseType(Parser.parseOne(s));
	}

	public boolean isBoolean() {
		return match(AType.Boolean);
	}

	public boolean isVoid() {
		return match(AType.Void);
	}

	public abstract boolean match(AType p_t);
	
	// This is just for testing
	public static void main(String[] args) {
		AType composetype = AType.parseType("((((Number) -> Number) ((Number) -> Number)) -> ((Number) -> Number))");
		AType returnType = new AProcedureType(Number,new ArrayList<AType>(){{add(Number);}});
		ArrayList<AType> params = new ArrayList<AType>(){{add(returnType); add(returnType);}};
		AType mytype = new AProcedureType (returnType, params);	// Define a matching type without using parseType
		assert composetype.match(mytype);
		System.out.println(composetype.match(mytype));
	}
}
