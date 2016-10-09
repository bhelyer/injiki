module main;

import injiki.app;

fn main(args: string[]) i32
{
	app := new App();
	return app.run();
}