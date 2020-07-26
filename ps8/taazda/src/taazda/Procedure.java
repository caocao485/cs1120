package taazda;

import java.util.ArrayList;

class Param {
	String name;
	AType type;
	
	public Param(String p_name, AType p_type) {
		name = p_name;
		type = p_type;
	}

	public String toString() {
		return name + ": " + type.toString();
	}
}

public class Procedure {
	private ArrayList<Param> params;
	private SExpr body;
	private AType type;
	private Environment environment;

	public Procedure(SExpr p_params, SExpr p_body, AType p_type, Environment env) throws EvalError {
		params = new ArrayList<Param>();
		if (!p_params.isList()) {
			throw new EvalError("Bad parameter list: " + p_params); 
		}
		for (SExpr p : p_params.getList()) {			
			if (!p.isList()) {
				throw new EvalError("Bad parameter: " + p);
			}
			ArrayList<SExpr> decl = p.getList();
			if (decl.size() != 3) {
				throw new EvalError("Bad parameter declaration: " + p.toString());
			} 
			if (!decl.get(0).isAtom()) {
				throw new EvalError("Bad parameter declaration, missing name: " + p.toString());
			}
			String name = decl.get(0).getAtom();
			if (!(decl.get(1).isAtom () && decl.get(1).getAtom().equals(":"))) {
				throw new EvalError("Bad parameter type declaration: " + p.toString());
			}
			AType type = AType.parseType(decl.get(2));
			params.add(new Param(name, type));
		}

		this.body = p_body;
		this.type = p_type;
		this.environment = env;
	}

	public ArrayList<Param> getParams() {
		return params;
	}

	public SExpr getBody() {
		return body;
	}

	public Environment getEnvironment() {
		return environment;
	}

	public AType getAType() {
		return type;
	}

	@Override
	public String toString() {
		return String.format("<Procedure %s / %s>", this.params.toString(),
				this.body.toString());
	}

}
