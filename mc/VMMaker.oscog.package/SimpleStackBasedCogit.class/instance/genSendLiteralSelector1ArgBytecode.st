bytecode generators
genSendLiteralSelector1ArgBytecode
	^self genSend: (self getLiteral: (byte0 bitAnd: 15)) numArgs: 1