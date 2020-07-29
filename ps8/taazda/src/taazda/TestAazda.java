package taazda;

public class TestAazda {

	public static void testEval(String test, Environment env, String res) {
		System.out.println("Test: " + test);
		try {
			SVal val = Evaluator.meval(Parser.parseOne(test), env);

			if (val == null) {
				if (res == null) {
					System.out.println("Passed!");
				} else {
					System.out.println("Failed: (expected result: " + res
							+ ", actual result: null");
				}
			} else {
				if (val.toString().equals(res)) {
					System.out.println("Passed!");
				} else {
					System.out.println("Failed --- expected result: " + res
							+ ", actual result: " + val);
				}
			}
		} catch (TypeError t) {
			String terror = t.getMessage();
			if (terror.equals(res)) {
				System.out.println("Passed!");
			} else {
				System.out.println("Failed --- expected result: " + res
						+ ", actual result: " + t);
			}
		} catch (Exception e) {
			System.out.println("Failed --- expected result: " + res
					+ ", actual result: " + e);
		}
	}

	static String compose = "(define compose : ((((Number) -> Number) ((Number) -> Number)) -> ((Number) -> Number))"
			+ "   (lambda ((f : ((Number) -> Number))"
			+ "            (g : ((Number) -> Number)))"
			+ "       (lambda ((x : Number)) (g (f x)))))";

	static String square = "(define square : ((Number) -> Number) (lambda ((x : Number)) (* x x)))";

	public static void testIf() {
		Environment env = new Environment(null);
		env.initializeGlobalEnvironment();

		testEval("(if (> 3 4) 3 2)", env, "2");		
		testEval("(if (> 3 4) true 2)", env, "Clauses for if must have matching types.  Types are: Boolean / Number");
		testEval("(if (+ 3 4) 3 2)", env, "Predicate for an in expression must be a Boolean.  Type is: Number");
	}
	
	public static void testAssignment() {
		Environment env = new Environment(null);
		env.initializeGlobalEnvironment();
	
		testEval("(define a : Number 3)", env, null);
		testEval("(set! a 4)", env, null);
		testEval("a", env, "4");
		testEval("(set! a true)", env, "Assignment type mismatch: place a has type Number, but value true has type Boolean");
		
		testEval("(define f : ((Boolean) -> Void) (lambda ((a : Boolean)) (set! a false)))", env, null);
		testEval("(define g : ((Boolean) -> Void) (lambda ((b : Boolean)) (set! a false)))", env, "Assignment type mismatch: place a has type Number, but value false has type Boolean");
	}

	public static void testBegin() {
		Environment env = new Environment(null);
		env.initializeGlobalEnvironment();
	
		testEval("(begin 3 4)", env, "4");
		testEval("(define a : Number 3)", env, null);
		testEval("(define update! : (() -> Number) (lambda () (begin (set! a (+ a 1)) a)))", env, null);
		testEval("(update!)", env, "4");
		testEval("(define bad-update! : (() -> Number) (lambda () (begin (set! a (+ a 1)))))", env, 
				"Type mismatch.  Definition of bad-update! value (lambda () (begin (set! a (+ a 1)))) has type (() -> Void), but declared with type (() -> Number)");
		testEval("(define b : Number 3)", env, null);
		testEval("(define update-both! : (() -> Number) (lambda () (begin (set! a (+ a 1)) (set! b (+ b 1)) (+ a b))))", env, null);
		testEval("(update-both!)", env, "9");		
	}

	public static void testCond() {
		Environment env = new Environment(null);
		env.initializeGlobalEnvironment();
		testEval("(cond)", env, null);
		testEval("(cond (true 1))", env, "1");
		testEval("(cond (false 2) (true false))", env, "Cond clauses have inconsistent types: first clause has type Number but clause false has type Boolean");
		testEval("(cond ((> 5 4) 2) ((+ 2 3) 4))", env, "Cond clause is not a Boolean: (+ 2 3)");
	}
	
	public static void testCompose() {
		Environment env = new Environment(null);
		env.initializeGlobalEnvironment();

		testEval(compose, env, null);
		testEval(square, env, null);
		testEval("((compose square square) 2)", env, "16");
		testEval("(define badtype : ((Number) -> Number) (lambda ((x : Number)) (compose + square)))",
				 env, 
				 "Parameter type mismatch: input 1 for compose expects type ((Number) -> Number) given type ((Number Number) -> Number)");
	}

	public static void testFactorial() {
		Environment env = new Environment(null);
		env.initializeGlobalEnvironment();
		testEval("(define factorial : ((Number) -> Number) (lambda ((n : Number)) (if (= n 0) 1 (* n (factorial (- n 1))))))", env, null);
		testEval("(factorial 5)", env, "120");
		testEval("(factorial 10)", env, "3628800");
	}
	
	public static void main(String[] args) {
		testIf();
		testCompose();
		
		// These tests are commented out for now, since they will fail with the provided interpreter.
		// As you answer the problems, uncomment each test.
		
		testAssignment(); // will fail until Problem 1
		testBegin(); // will fail until Problem 2
		testCond(); // will fail until Problem 3

		testFactorial(); // will fail until Problem 4
	}
}
