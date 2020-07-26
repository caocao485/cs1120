package aazda;

import java.util.ArrayList;

public class SExpr {
	/**
	 * SExpr represents an S-Expression (either an atom (String), or a list of
	 * S-Expressions)
	 */
	private String atom;
	private ArrayList<SExpr> list;

	public SExpr(String s) {
		atom = s;
		list = null;
	}

	public SExpr(ArrayList<SExpr> l) {
		atom = null;
		list = l;
	}

	public boolean isAtom() {
		return atom != null;
	}

	public boolean isList() {
		return list != null;
	}
	
	public String getAtom() {
		assert list == null;
		return atom;
	}
	
	public ArrayList<SExpr> getList() {
		assert atom == null;
		return list;
	}

	public String toString() {
		if (atom != null) {
			assert list == null;
			return atom;
		} else {
			// we use the mutable StringBuffer to avoid copying Strings
			StringBuffer res = new StringBuffer("(");
			boolean first = true;
			for (SExpr s : list) {
				if (!first) {
					res.append(" ");
				} else {
					first = false;
				}
				res.append(s.toString());
			}
			res.append(")");
			return new String(res);
		}
	}
}
