package com.vnetpublishing.java.abcl.abclp;

import org.armedbear.lisp.Cons;
import org.armedbear.lisp.Interpreter;
import org.armedbear.lisp.Lisp;
import org.armedbear.lisp.Symbol;
import org.armedbear.lisp.Function;
import org.armedbear.lisp.LispObject;
import org.armedbear.lisp.Packages;
import org.armedbear.lisp.ProcessingTerminated;
import org.armedbear.lisp.Load;
import org.armedbear.lisp.Package;

public class Main 
{

	public static void main (final String[] argv) {
		Runnable r = new Runnable () {
			public void run() {
				try
				{
					LispObject cmdline = Lisp.NIL;
					for (String arg : argv)
						cmdline = new Cons (arg, cmdline);
					cmdline.nreverse ();
					Lisp._COMMAND_LINE_ARGUMENT_LIST_.setSymbolValue (cmdline);
 
					Interpreter.createInstance ();
					//Load.load ("abclp.lisp");
					Load.loadSystemFile ("/abclp.lisp", false, false, false);
					Package abclpPackage = Packages.findPackage("ABCLP");
					Symbol mainFunctionSym =
							abclpPackage.findAccessibleSymbol("MAIN");
					
					Function mainFunction =
							(Function) mainFunctionSym.getSymbolFunction();
					mainFunction.execute(cmdline);
				} catch (ProcessingTerminated e) {
					e.printStackTrace();
					System.exit (e.getStatus ());
				}
			}
		};
		new Thread (null, r, "interpreter", 4194304L).start();
	}
}
