module test;

import injiki.text.buffer;

fn main() i32
{
	buf := new Buffer();

	foreach (i; 0 .. Buffer.HOLESIZE) {
		buf.putc('A');
		buf.putc('B');
		buf.putc('ひ');
		buf.putc('日');
	}

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
	buf.seekRaw(Buffer.HOLESIZE+1U);
	if (buf.getc() != 'B') {
		return 6;
	}
	if (buf.getc() != 'ひ') {
		return 7;
	}
	if (buf.getc() != '日') {
		return 8;
	}

	return 0;
}
