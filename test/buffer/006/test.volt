module test;

import injiki.text.buffer;

fn main() i32
{
	buf := new Buffer();

	buf.putc('A');
	buf.putc('雨');
	buf.putc('ひ');
	buf.putc('日');
	buf.seekRaw(1);
	buf.wc('B');
	buf.seekRaw(0);
	if (buf.getc() != 'A') {
		return 1;
	}
	if (buf.getc() != 'B') {
		return 2;
	}
	if (buf.getc() != 'ひ') {
		return 3;
	}
	if (buf.getc() != '日') {
		return 4;
	}

	return buf.toString() == "ABひ日" ? 0 : 5;
}
