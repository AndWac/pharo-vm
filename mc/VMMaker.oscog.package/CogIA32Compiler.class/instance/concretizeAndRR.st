generate machine code
concretizeAndRR
	"Will get inlined into concretizeAt: switch."
	<inline: true>
	| regLHS regRHS |
	regLHS := self concreteRegister: (operands at: 0).
	regRHS := self concreteRegister: (operands at: 1).
	machineCode
		at: 0 put: 16r23;
		at: 1 put: (self mod: ModReg RM: regLHS RO: regRHS).
	^machineCodeSize := 2