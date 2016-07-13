module injiki.exception;

import core.exception;

class InjikiException : Exception {
	this(string msg) {
		super(msg);
	}
}
