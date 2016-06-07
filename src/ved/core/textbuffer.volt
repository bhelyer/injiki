module ved.core.textbuffer;

import watt.algorithm;

import ved.exception;

/**
 * A buffer specialised in inserting text.
 *
 * A very naive implementation atm. This should be a gap buffer, or a rope.
 */
class TextBuffer {
	/**
	 * Construct a new GapBuffer with the contents 'txt'.
	 */
	this(string txt) {
		mBuffer = txt;
		mInsertionIndex = 0;
	}

	/**
	 * Get the size of all the text in the buffer.
	 */
	size_t getEffectiveSize() {
		return mBuffer.length;
	}

	/**
	 * Get the current text of the buffer.
	 */
	string getText() {
		return mBuffer;
	}

	/**
	 * Insert the given text at the current position.
	 */
	void addText(string txt) {
		mBuffer = mBuffer[0 .. mInsertionIndex] ~ txt ~ mBuffer[mInsertionIndex .. $];
	}

	/**
	 * Set the cursor at 'offset' characters from the beginning
	 * of the file.
	 * Throws: VedException if 'offset' is out-of-bounds.
	 */
	void setCursor(size_t offset) {
		if (offset > getEffectiveSize()) {
			throw new VedException("setCursor out-of-bounds");
		}
		mInsertionIndex = offset;
	}

	protected string mBuffer;
	protected size_t mInsertionIndex;
}
