generate machine code
concretizePopR
	<inline: true>
	machineCode at: 0 put: 16r58 + (self concreteRegister: (operands at: 0)).
	^machineCodeSize := 1