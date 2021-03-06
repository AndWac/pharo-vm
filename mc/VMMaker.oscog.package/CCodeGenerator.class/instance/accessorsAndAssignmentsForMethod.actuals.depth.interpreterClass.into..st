spur primitive compilation
accessorsAndAssignmentsForMethod: method actuals: actualParameters depth: depth interpreterClass: interpreterClass into: aTrinaryBlock
	"Evaluate aTrinaryBlock with the root accessor sends, accessor sends and assignments in the method."
	| accessors assignments roots |
	accessors := Set new.
	assignments := Set new.
	roots := Set new.
	actualParameters with: method args do:
		[:actual :argName|
		 (actual isVariable or: [actual isSend]) ifTrue:
			[assignments add: (TAssignmentNode new
									setVariable: (TVariableNode new setName: argName)
									expression: actual)]].
	method parseTree nodesDo:
		[:node|
		node isSend ifTrue:
			[(interpreterClass isStackAccessor: node selector) ifTrue:
				[roots add: node].
			 (interpreterClass isObjectAccessor: node selector) ifTrue:
				[accessors add: node].
			 (self accessorDepthDeterminationFollowsSelfSends
			  and: [node receiver isVariable
			  and: [node receiver name = 'self'
			  and: [roots isEmpty
				or: [node args anySatisfy:
					[:arg|
					 (roots includes: arg)
					 or: [(accessors includes: arg)
					 or: [assignments anySatisfy: [:assignment| assignment variable isSameAs: arg]]]]]]]]) ifTrue:
				[self accessorsAndAssignmentsForSubMethodNamed: node selector
					actuals: node args
					depth: depth + 1
					interpreterClass: interpreterClass
					into: [:subRoots :subAccessors :subAssignments|
						(subRoots isEmpty and: [subAccessors isEmpty and: [subAssignments isEmpty]]) ifFalse:
							[roots addAll: subRoots.
							 accessors add: node.
							 accessors addAll: subAccessors.
							 assignments addAll: subAssignments]]]].
		(node isAssignment
		 and: [(roots includes: node expression)
			or: [(accessors includes: node expression)
			or: [node expression isVariable and: [node expression name ~= 'nil']]]]) ifTrue:
			[assignments add: node]].
	^aTrinaryBlock
		value: roots
		value: accessors
		value: assignments