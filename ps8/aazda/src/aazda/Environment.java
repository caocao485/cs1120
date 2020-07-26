/*
** cs1120 Fall 2011
** Problem Set 8
**
** You will need to make changes to this file.  Mark the changes you make clearly
** with comments.  
*/

package aazda;

import java.util.HashMap;

public class Environment {
	private Environment parent;
	private HashMap<String, SVal> frame;

	public Environment(Environment p_parent) {
		parent = p_parent;
		frame = new HashMap<String, SVal>();
		addVariable("true", new SVal(true));
		addVariable("false", new SVal(false));
	}

	public void addVariable(String name, SVal value) {
		frame.put(name, value);
	}

	public boolean hasVariable(String name) {
		if (frame.containsKey(name)) {
			return true; 
		} else {
			return parent.hasVariable(name);
		}
	}

	public void setVariable(String name, SVal value){
		if(frame.containsKey(name)){
			frame.put(name, value);
		}else {
			parent.setVariable(name,value);
		}
	}
	
	public SVal lookupVariable(String name) {
		if (frame.containsKey(name)) {
			return frame.get(name);
		} else if (parent != null) {
			return parent.lookupVariable(name);
		} else {
			throw new EvalError("Undefined name " + name);
		}
	}
}
