package taazda;

import java.util.ArrayList;
import java.util.Scanner;

// Read-Eval-Print Loop
public class REPL {		
	public static void main(String args[]) {
		System.out.println("Welcome to Taazda [Version 0.01]");
		evalLoop();
	}

	public static void evalLoop() {
		Environment env = new Environment(null);
		env.initializeGlobalEnvironment();
		while (true) {
			System.out.print("Taazda> ");
			Scanner input = new Scanner(System.in);
			String code = input.nextLine();
			if (code.equals("quit")) {
				System.out.println("Goodbye!");
				return;
			}
			try {
				ArrayList<SExpr> parseResult = Parser.parse(code);

				for (int i = 0; i < parseResult.size(); i++) {
					SVal res = Evaluator.meval(parseResult.get(i), env);
					if (res != null && !res.isVoid()) {
						System.out.println(res);
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
	}
}
