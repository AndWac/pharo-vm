debug printing
printCallStackOf: aContextOrProcessOrFrame
	<api>
	| context |
	<inline: false>
	(stackPages couldBeFramePointer: aContextOrProcessOrFrame) ifTrue:
		[^self printCallStackFP: (self cCoerceSimple: aContextOrProcessOrFrame to: #'char *')].
	((objectMemory isContext: aContextOrProcessOrFrame) not
	and: [(objectMemory lengthOf: aContextOrProcessOrFrame) > MyListIndex
	and: [objectMemory isContext: (objectMemory
									fetchPointer: SuspendedContextIndex
									ofObject: aContextOrProcessOrFrame)]]) ifTrue:
		[^self printCallStackOf: (objectMemory
									fetchPointer: SuspendedContextIndex
									ofObject: aContextOrProcessOrFrame)].
	context := aContextOrProcessOrFrame.
	[context = objectMemory nilObject] whileFalse:
		[(self isMarriedOrWidowedContext: context)
			ifTrue:
				[(self checkIsStillMarriedContext: context currentFP: framePointer) ifFalse:
					[self shortPrintContext: context.
					 ^nil].
				 context := self shortReversePrintFrameAndCallers: (self frameOfMarriedContext: context)]
			ifFalse:
				[context := self printContextCallStackOf: context]]