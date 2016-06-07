module main;

import watt.io;

import ved.core.textbuffer;

i32 main(string[] args) {
	buf := new TextBuffer("ABCabcABC");

	writefln("Before:\n---");
	writef("%s", buf.getText());
	writefln("\n---");

	buf.setCursor(1);
	buf.addText("-TTEXT HS BEEN INSERTED-");
	buf.setCursor(3);
	buf.addText("HIS ");
	buf.setCursor(13);
	buf.addText("A");
	buf.setCursor(buf.getEffectiveSize());
	buf.addText("すごいです！");

	writefln("\nAfter:\n---");
	writef("%s", buf.getText());
	writefln("\n---");

	return 0;
}
