/* The code in this module was (loosely) adapted from the post
 * from Joseph H Allen on the comp.editors newsgroup, posted
 * September 10th, 1989.
 * "Do whatever you want with this but leave my name on it"
 */
module injiki.text.buffer;

import core.exception;
import watt.io;
import watt.io.streams;
import watt.text.utf;

import injiki.text.util;

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

	this() {
		reset();
	}

	/// Initialises an empty buffer, ready for insertion.
	fn reset() {
		mBuffer = new char[](HOLESIZE);
		mPoint = 0;
		mHoleIndex = 0;
		mHoleSize = mBuffer.length;
	}

	/// Open a file
	fn loadFile(fname: string) {
		ifs := new InputFileStream(fname);
		if (ifs.handle is null) {
			throw new Exception("couldn't open file");
		}
		while (!ifs.eof()) {
			c := ifs.get();
			if (ifs.eof()) {
				break;
			}
			putc(c);
		}
		ifs.close();
	}

	/// Return the character at the point.
	fn rc() dchar {
		if (mPoint == mHoleIndex) {
			mPoint = mHoleIndex+mHoleSize;
		}
		i: size_t;
		return decode(cast(string)mBuffer[mPoint .. $], ref i);
	}

	/// Write a character at the point.
	fn wc(c: dchar) {
		newSize := utf8bytes(c);
		existingSize: size_t;
		replacing := (mPoint < mHoleIndex || mPoint >= mHoleIndex + mHoleSize) &&
			mPoint < mBuffer.length;
		if (replacing) {
			existingSize = utf8bytes(rc());
		}
		moveHole(mPoint);

		if (!replacing) {
			expand(newSize);
		} else if (newSize < existingSize) {
			mHoleIndex += newSize;
			mHoleSize += (existingSize - newSize);
		} else if (newSize > existingSize) {
			expand(newSize);
			mHoleSize += existingSize;
		} else {
			mHoleIndex += newSize;
		}

		fn dgt(s: scope const(char)[]) {
			for (i: size_t = 0; i < s.length; ++i) {
				mBuffer[i + mPoint] = s[i];
			}
		}
		encode(dgt, c);
	}

	/// Return the character at the point and advance it.
	fn getc() dchar {
		if (mPoint == mHoleIndex) {
			mPoint = mHoleIndex+mHoleSize;
		}
		i: size_t;
		c := decode(cast(string)mBuffer[mPoint .. $], ref i);
		mPoint += i;
		return c;
	}

	/// Call dgt with getc's result until 'c' is at the point, or EOF is reached.
	fn getUntil(c: dchar, dgt: dg(dchar)) {
		while (!eof() && rc() != c) {
			dgt(getc());
		}
	}

	/// Write a character at the point and advance it.
	fn putc(c: dchar) {
		size := utf8bytes(c);
		wc(c);
		mPoint += size;
	}

	/// Insert a character at the point.
	fn ins(c: dchar) {
		moveHole(mPoint);
		fn dgt(s: scope const(char)[]) {
			expand(s.length);
			for (i: size_t = 0; i < s.length; ++i) {
				mBuffer[i + mPoint] = s[i];
			}
		}
		encode(dgt, c);
	}

	/// Insert a string at the point.
	fn ins(s: string) {
		// ins(c) will keep inserting at the same point, so insert the string backwards.
		foreach_reverse (c: dchar; s) {
			ins(c);
		}
	}

	/// Delete n characters, beginning at the point.
	fn del(n: size_t) {
	}

	/// Return the number of characters in the file.
	fn size() size_t {
		return count(toString());
	}

	/// Returns true if we're at the end of file.
	fn eof() bool {
		if (mPoint < mHoleIndex) {
			return false;
		}
		return (mHoleIndex + mHoleSize) >= mBuffer.length;
	}

	/// Returns 0 if the string matches the one under the point.
	fn cmp(s: string) i32 {
		return 0;
	}

	/// Returns 0 if the string matches the one under the point, ignoring case.
	fn icmp(s: string) i32 {
		return 0;
	}

	/// Set the point to i. Not checked, may jump into the middle of a codepoint, etc.
	fn seekRaw(i: size_t) {
		mPoint = i;
	}

	override fn toString() string {
		return cast(string)(mBuffer[0 .. mHoleIndex] ~ mBuffer[mHoleIndex+mHoleSize .. $]);
	}

	/// Prepare to write n bytes at the point.
	private fn expand(n: size_t) {
		if (mPoint != mHoleIndex) {
			moveHole(mPoint);
		}
		if (mHoleSize < n) {
			newBuffer := new char[](mBuffer.length + HOLESIZE);
			newBuffer[0 .. mHoleIndex] = mBuffer[0 .. mHoleIndex];
			oldHoleEnd := mHoleIndex+mHoleSize;
			mHoleSize += HOLESIZE;
			holeEnd := mHoleIndex+mHoleSize;
			newBuffer[holeEnd .. holeEnd + mBuffer.length - oldHoleEnd] = mBuffer[oldHoleEnd .. $];
			mBuffer = newBuffer;
		}
		mHoleIndex += n;
		mHoleSize -= n;
	}

	/// Move the hole to the index i.
	private fn moveHole(i: size_t) {
		endOfHole := mHoleIndex + mHoleSize;
		if (i > mHoleIndex) {
			d := i - mHoleIndex;
			beginning := mBuffer[0 .. mHoleIndex] ~ mBuffer[endOfHole .. endOfHole + d];
			end := mBuffer[endOfHole + d .. $];
			mBuffer[0 .. mHoleIndex + d] = beginning;
			mBuffer[endOfHole + d .. $] = end;
		} else if (i < mHoleIndex) {
			d := mHoleIndex - i;
			beginning := mBuffer[0 .. mHoleIndex - d];
			end := mBuffer[mHoleIndex - d .. mHoleIndex] ~ mBuffer[endOfHole .. $];
			mBuffer[0 .. mHoleIndex - d] = beginning;
			mBuffer[endOfHole - d .. $] = end;
		}
		mHoleIndex = i;
	}

	private mBuffer:    char[];  //< The entire block of memory.
	private mHoleIndex: size_t;  //< Where the hole starts in the buffer.
	private mHoleSize:  size_t;  //< How many bytes long the hole is.
	private mPoint:     size_t;  //< Insertion point.
}
