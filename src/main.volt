module main;

import watt.io;

import injiki.text.buffer;

fn main(args: string[]) i32
{
	buffer := new Buffer();
	buffer.loadFile(args[1]);
	writeln(buffer.toString());
	return 0;
}