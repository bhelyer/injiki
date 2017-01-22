module test;

import injiki.text.buffer;
import injiki.text.util;

fn main() i32
{
	buf := new Buffer();

	buf.putc('H');
	buf.putc('i');
	buf.putc(' ');
	buf.putc('世');
	buf.putc('界');
	if (buf.toString() != "Hi 世界") {
		return 1;
	}

	buf.seekRaw(1);
	buf.ins("aのb");
	if (buf.toString() != "Haのbi 世界") {
		return 2;
	}
	
	buf.seekRaw(2 + utf8bytes('の') + 3 + utf8bytes('世'));
	buf.ins("化-x");
	if (buf.toString() != "Haのbi 世化-x界") {
		return 3;
	}

	return 0;
}
