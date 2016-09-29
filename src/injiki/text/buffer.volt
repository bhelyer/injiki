/* The code in this module was loosely adapted from the post
 * from Joseph H Allen on the comp.editors newsgroup, posted
 * September 10th, 1989.
 * "Do whatever you want with this but leave my name on it"
 */
module injiki.text.buffer;

import watt.text.utf;

/**
 * A Buffer represents a series of characters able to be modified at any point.
 *
 * Implemented using a buffer gap.
 * In short, the buffer has three parts: the beginning, a hole, and the end.
 * Text is inserted into the hole, without moving large amounts of data if
 * the point (usually the cursor; where text is being inserted) isn't moved.
 */
class Buffer {
	enum HOLESIZE = 16384;  //< The amount the hole grows by.

	/// Initialises an empty buffer, ready for insertion.
	this() {
		mBuffer = new char[](HOLESIZE);
		mPoint = mBuffer.ptr;
		mHole = mBuffer;
	}

	/// Return the character at the point.
	fn rc() dchar {
		return 'A';
	}

	/// Write a character at the point.
	fn wc(c: dchar) {
	}

	/// Return the character at the point and advance it.
	fn getc() dchar {
		return 'A';
	}

	/// Write a character at the point and advance it.
	fn putc(c: dchar) {
	}

	/// Insert a character at the point.
	fn ins(c: dchar) {
	}

	/// Insert a string at the point.
	fn ins(s: string) {
	}

	/// Delete n characters, beginning at the point.
	fn del(n: size_t) {
	}

	/// Return the number of characters in the file.
	fn size() size_t {
		return 0;
	}

	/// Returns true if we're at the end of file.
	fn eof() bool {
		return false;
	}

	/// Set the point to n characters from the beginning of the file.
	fn point(n: size_t) {
	}

	/// Returns 0 if the string matches the one under the point.
	fn cmp(s: string) i32 {
		return 0;
	}

	/// Returns 0 if the string matches the one under the point, ignoring case.
	fn icmp(s: string) i32 {
		return 0;
	}

	private mBuffer: char[];  //< The entire block of memory.
	private mHole:   char[];  //< Where text is inserted. A slice of mBuffer. 
	private mPoint:  char*;   //< Insertion point.
}
