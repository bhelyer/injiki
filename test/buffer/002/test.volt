module test;

import injiki.text.buffer;

fn main() i32
{
	buf := new Buffer();

	buf.putc('A');
	buf.putc('B');
	buf.putc('ひ');
	buf.putc('日');

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

	return 0;
}
