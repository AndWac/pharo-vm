utilities
booleanCheatFalse
	"cheat the interpreter out of the pleasure of handling the next bytecode IFF it is a jump-on-boolean. Which it is, often enough when the current bytecode is something like bytecodePrimEqual"
	<sharedCodeNamed: 'booleanCheatFalse' inCase: #bytecodePrimGreaterThan>
	| bytecode offset |

	bytecode := self fetchByte.  "assume next bytecode is jumpIfFalse (99%)"
	self internalPop: 2.
	(bytecode < 160 and: [bytecode > 151]) ifTrue:  "short jumpIfFalse"
		[^self jump: bytecode - 151].

	bytecode = 172 ifTrue:  "long jumpIfFalse"
		[offset := self fetchByte.
		^self jump: offset].

	"not followed by a jumpIfFalse; (un)do instruction fetch and push boolean result"
	currentBytecode := bytecode.
	self internalPush: falseObj