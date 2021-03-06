allocation
eeAllocate: byteSize headerSize: hdrSize h1: baseHeader h2: classOop h3: extendedSize
	"Allocate a new object of the given size and number of header words. (Note: byteSize already includes
	 space for the base header word.) Initialize the header fields of the new object.
	 Does *not* initialize the objects' fields. Will *not* cause a GC.  This version is for the execution engine's use only."

	| newObj |
	<inline: true>
	<asmLabel: false>
	newObj := self allocateInterpreterChunk: byteSize + (hdrSize - 1 * BytesPerWord).
	newObj = 0 ifTrue: [^newObj].
	hdrSize = 3 ifTrue:
		[self longAt: newObj put: (extendedSize bitOr: HeaderTypeSizeAndClass).
		 self longAt: newObj + BytesPerWord put: (classOop bitOr: HeaderTypeSizeAndClass).
		 self longAt: newObj + (BytesPerWord*2) put: (baseHeader bitOr: HeaderTypeSizeAndClass).
		 newObj := newObj + (BytesPerWord*2)].

	 hdrSize = 2 ifTrue:
		[self longAt: newObj put: (classOop bitOr: HeaderTypeClass).
		 self longAt: newObj + BytesPerWord put: (baseHeader bitOr: HeaderTypeClass).
		 newObj := newObj + BytesPerWord].

	 hdrSize = 1 ifTrue:
		[self longAt: newObj put: (baseHeader bitOr: HeaderTypeShort)].

	DoExpensiveAssertionChecks ifTrue:
		[self okayOop: newObj.
		 self oopHasOkayClass: newObj.
		 (self safeObjectAfter: newObj) = freeStart ifFalse:
			[self error: 'allocate bug: did not set header of new oop correctly']].

	^newObj