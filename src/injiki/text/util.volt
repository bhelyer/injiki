module injiki.text.util;

import core.exception;


/*!
 * Given a character, return how many bytes it will take
 * when encoded as UTF-8.
 */
fn utf8bytes(c: dchar) size_t
{
	cval := cast(uint) c;

	if (cval <= 0x7F) {
		return 1;
	} else if (cval >= 0x80 && cval <= 0x7FF) {
		return 2;
	} else if (cval >= 0x800 && cval <= 0xFFFF) {
		return 3;
	} else if (cval >= 0x10000 && cval <= 0x1FFFFF) {
		return 4;
	} else if (cval >= 0x200000 && cval <= 0x3FFFFFF) {
		return 5;
	} else if (cval >= 0x4000000 && cval <= 0x7FFFFFFF) {
		return 6;
	} else {
		throw new MalformedUTF8Exception("unsupported codepoint range");
	}
}
