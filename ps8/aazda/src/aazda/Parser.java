package aazda;

import java.util.ArrayList;

public class Parser {
	public static ArrayList<SExpr> parse(String s) throws ParseError {
		return parseTokens(Tokenizer.tokenize(s), false);
	}

	private static ArrayList<SExpr> parseTokens(ArrayList<String> tokens,
			boolean inner) throws ParseError {
		ArrayList<SExpr> cs = new ArrayList<SExpr> ();
		while (tokens.size() > 0) {
			String current = tokens.get(0);
			tokens.remove(0);
			if (current.equals("(")) {
				cs.add(new SExpr(parseTokens(tokens, true)));
			} else if (current.equals(")")) {
				if (inner) {
					return cs;
				} else {
					throw new ParseError("Unmatched close paren");
				}
			} else {
				cs.add(new SExpr(current));
			}
		}
		if (inner) {
			throw new ParseError("Unmatched open paren");
		} else {
			return cs;
		}
	}
}
