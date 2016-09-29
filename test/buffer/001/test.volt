//T dependency:../../../src/injiki/text/buffer.volt
module test;

import injiki.text.buffer;

fn main() i32
{
	buf := new Buffer();
	buf.wc('A');
	return buf.rc() == 'A' ? 0 : 1;
}
