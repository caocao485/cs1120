package taazda;

public class APrimitiveType extends AType {
	private String tname;
	
	public APrimitiveType(String p_name) {
		tname = p_name;
	}
	
	public boolean match(AType t) {
		if (t instanceof APrimitiveType) {
			APrimitiveType pt = (APrimitiveType) t;
			return tname.equals(pt.tname);
		} else {
			return false;
		}
	}
	
	public String toString() {
		return tname;
	}
}
