package aazda;

import java.util.ArrayList;

public class Tokenizer {
	public static ArrayList<String> tokenize(String s) {
		String current = "";
		ArrayList<String> tokens = new ArrayList<String>();
		for (int index = 0; index < s.length(); index++) {
			Character c = s.charAt(index);
			if (c.equals(' ')) {
				if (current.length() > 0) {
					tokens.add(current);
					current = "";
				}
			} else if (c.equals('(') | c.equals(')')) {
				if (current.length() > 0) {
					tokens.add(current);
					current = "";
				}
				tokens.add(c.toString());
			} else {
				current = current + c.toString();
			}
		}
		if (current.length() > 0)
			tokens.add(current);
		return tokens;
	}
}