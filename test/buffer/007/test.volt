//T dependency:../../../src/injiki/text/buffer.volt
//T dependency:../../../src/injiki/text/util.volt
module test;

import injiki.text.buffer;
import injiki.text.util;
import watt.io;
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
	buf.ins('の');
	if (buf.toString() != "Hのi 世界") {
		return 2;
	}
	
	buf.seekRaw(1 + utf8bytes('の') + 2 + utf8bytes('世'));
	//buf.seek(5);
	buf.ins('-');
	if (buf.toString() != "Hのi 世-界") {
		return 3;
	}

	return 0;
}
