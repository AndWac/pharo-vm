compile abstract instructions
ensureSpilledAt: baseOffset from: baseRegister
	| inst |
	<var: #inst type: #'AbstractInstruction *'>
	spilled ifTrue:
		[type = SSSpill ifTrue:
			[self assert: (offset = baseOffset and: [register = baseRegister]).
			 ^self]].
	self assert: type ~= SSSpill.
	cogit traceSpill: self.
	type = SSConstant
		ifTrue:
			[inst := cogit annotate: (cogit PushCw: constant) objRef: constant]
		ifFalse:
			[type = SSBaseOffset
				ifTrue:
					[cogit MoveMw: offset r: register R: TempReg.
					 inst := cogit PushR: TempReg]
				ifFalse:
					[self assert: type = SSRegister.
					 inst := cogit PushR: register].
			 type := SSSpill.
			 offset := baseOffset.
			 register := baseRegister].
	spilled := true.
	annotateUse ifTrue:
		[cogit annotateBytecode: inst.
		 annotateUse := false]