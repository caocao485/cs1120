package aazda;

import java.util.ArrayList;

public class Procedure {
	private ArrayList<String> params;
	private SExpr body;
	private Environment environment;

	public Procedure(SExpr p_params, SExpr p_body, Environment env) {
		params = new ArrayList<String>();
		if (!p_params.isList()) {
			throw new EvalError("Bad parameter list: " + p_params); 
		}
		for (SExpr p : p_params.getList()) {
			if (!p.isAtom()) {
				throw new EvalError("Bad parameter: " + p);
			}
			params.add(p.getAtom());
		}

		this.body = p_body;
		this.environment = env;
	}

	public ArrayList<String> getParams() {
		return params;
	}

	public SExpr getBody() {
		return body;
	}

	public Environment getEnvironment() {
		return environment;
	}

	@Override
	public String toString() {
		return String.format("<Procedure %s / %s>", this.params.toString(),
				this.body.toString());
	}
}
