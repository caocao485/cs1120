package aazda;

public class ConsCell {
	private SVal first, second;

	public ConsCell(SVal p_first, SVal p_second) {
		first = p_first;
		second = p_second;
	}

	public SVal getFirst() {
		return first;
	}

	public SVal getSecond() {
		return second;
	}

	private String listToString() {
		if (second.isNull())
			return first.toString();
		else if (second.isCons()) {
			return first.toString() + " " + second.consValue().listToString();
		} else {
			throw new EvalError("Expected cell to be a list");
		}
	}

	public String toString() {
		if (isList()) {
			try {
				return "(" + listToString() + ")";
			} catch (EvalError e) {
				return "error";
			}
		} else {
			return "(" + first.toString() + " . " + second.toString() + ")";
		}
	}

	private boolean isList() {
		if (getSecond().isNull()) {
			return true;
		} else {
			return (getSecond().isCons() && getSecond().consValue().isList());
		}
	}
}
