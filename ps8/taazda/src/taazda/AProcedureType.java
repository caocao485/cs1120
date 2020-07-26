package taazda;

import java.util.ArrayList;

public class AProcedureType extends AType {
	private AType result; 
	private ArrayList<AType> params; 
	
	public AProcedureType(AType p_result, ArrayList<AType> p_params) {
		result = p_result;
		params = p_params;		
	}
	
	public ArrayList<AType> getParameterTypes() {
		return params;
	}
	
	public AType getResultType() {
		return result;
	}
	
	public boolean match(AType t) {
		if (t instanceof AProcedureType) {
			AProcedureType pt = (AProcedureType) t;
			if (result.match(pt.result)) {
				if (params.size() != pt.params.size()) {
					return false;
				} else {
					for (int i = 0; i < params.size(); i++) {
						if (!params.get(i).match(pt.params.get(i))) {
							return false;
						}
					} // all matched!
					return true;
				}
			} else {
				return false; // return types don't match
			}
		} else {
			return false; // not a procedure 
		}
	}
	
	public String toString() {
		String res = "((";
		boolean first = true;
		for (AType param : params) {
			if (first) {
				first = false;
			} else {
				res = res + " ";
			}
			res = res + param.toString();
		}
		res = res + ") -> " + result.toString() + ")";
		return res;
	}
}
