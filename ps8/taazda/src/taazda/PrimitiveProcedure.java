package taazda;

import java.util.ArrayList;

public abstract class PrimitiveProcedure {
	private AType type;
	private String name;
	
	public PrimitiveProcedure(String p_name, AType p_type) {
		name = p_name;
		type = p_type;
	}
	
	public AType getAType() {
		return type;
	}
	
	public String getName() {
		return name;
	}
	
	public String toString() {
		return "<Primitive Procedure: " + name + ": " + type + ">";
	}
	
	public abstract SVal apply(ArrayList<SVal> operands);
}
