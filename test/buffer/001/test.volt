//T dependency:../../../src/injiki/text/buffer.volt
//T dependency:../../../src/injiki/text/util.volt
module test;

import injiki.text.buffer;

fn main() i32
{
	buf := new Buffer();
	buf.wc('A');
	if (buf.rc() != 'A') {
		return 1;
	}
	buf.wc('B');
	if (buf.rc() != 'B') {
		return 2;
	}
	buf.wc('ひ');
	if (buf.rc() != 'ひ') {
		return 3;
	}
	buf.wc('日');
	if (buf.rc() != '日') {
		return 4;
	}
	return buf.toString() == "日" ? 0 : 5;
}
