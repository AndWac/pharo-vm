in-line cacheing
inlineCacheTagForClass: classOop
	"Answer the relevant inline cache tag for a class.
	 c.f. inlineCacheTagForInstance:"
	^objectMemory ensureBehaviorHash: classOop