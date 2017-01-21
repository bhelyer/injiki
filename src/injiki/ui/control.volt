module injiki.ui.control;

import watt.conv;
import watt.io;

import injiki.ui.console;


class Control
{
public:
	fn onText(c: Console, str: scope const(char)[])
	{
		colour: Console.Colour;
		c.putc(0, 0, colour, colour, cast(u8)str[0]);
	}
}
