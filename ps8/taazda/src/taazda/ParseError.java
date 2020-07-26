package taazda;

@SuppressWarnings("serial")
public class ParseError extends RuntimeException {

	public ParseError(String string) {
		super(string);
	}
}
