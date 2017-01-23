module main;

import injiki.app;


fn main(args: string[]) i32
{
	app := new App();
	if (args.length > 1) {
		app.loadFile(args[1]);
	}
	return app.run();
}
