/* The code in this module was (loosely) adapted from the post
 * from Joseph H Allen on the comp.editors newsgroup, posted
 * September 10th, 1989.
 * "Do whatever you want with this but leave my name on it"
 */
module injiki.text.buffer;

import watt.io;
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
		mPoint = 0;
		mHole = mBuffer;
		mHoleIndex = 0;
	}

	/// Return the character at the point.
	fn rc() dchar {
		i: size_t;
		return decode(cast(string)mBuffer[mPoint .. $], ref i);
	}

	/// Write a character at the point.
	fn wc(c: dchar) {
		fn dgt(s: scope const(char)[]) {
			expand(s.length);
			for (i: size_t = 0; i < s.length; ++i) {
				mBuffer[i + mPoint] = s[i];
			}
		}
		encode(dgt, c);
	}

	/// Return the character at the point and advance it.
	fn getc() dchar {
		i: size_t;
		c := decode(cast(string)mBuffer[mPoint .. $], ref i);
		mPoint += i;
		return c;
	}

	/// Write a character at the point and advance it.
	fn putc(c: dchar) {
		fn dgt(s: scope const(char)[]) {
			expand(s.length);
			for (i: size_t = 0; i < s.length; ++i) {
				mBuffer[i + mPoint] = s[i];
			}
			mPoint += s.length;
		}
		encode(dgt, c);
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

	/// Returns 0 if the string matches the one under the point.
	fn cmp(s: string) i32 {
		return 0;
	}

	/// Returns 0 if the string matches the one under the point, ignoring case.
	fn icmp(s: string) i32 {
		return 0;
	}

	/// Shrink the hole by n bytes. Grow buffer if needed.
	fn expand(n: size_t) {
		mHoleIndex += n;
	}

	fn seek(i: size_t) {
		mPoint = i;
	}

	private mBuffer:    char[];  //< The entire block of memory.
	private mHole:      char[];  //< Where text is inserted. A slice of mBuffer.
	private mHoleIndex: size_t;  //< Where the hole starts in the buffer.
	private mPoint:     size_t;  //< Insertion point.
	private mChanged:   bool;    //< Set when the buffer has been changed.
}
