module main;

import watt.io.file;

import ved.gui;

i32 main(string[] args) {
	win := new Window(cast(string)read("src/main.volt"));
	runGui();
	return 0;
}

