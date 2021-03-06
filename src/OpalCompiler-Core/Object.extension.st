Extension { #name : #Object }

{ #category : #'*OpalCompiler-Core' }
Object >> mustBeBooleanDeOptimizeIn: context [
	"Permits to redefine methods inlined by compiler.
	Take the ast node corresponding to the mustBeBoolean error, compile it on the fly and executes it as a DoIt. Then resume the execution of the context."

	| sendNode methodNode method ret |

	"get the message send node that triggered mustBeBoolean"
	sendNode := context sourceNode sourceNodeForPC: context pc - 1.
	"Build doit node to perform send unoptimized"
	methodNode := sendNode copy asDoitForContext: context.
	"Rewrite non-local returns to return to the correct context from send"
	RBParseTreeRewriter new 
		replace: '^ ``@value' with: 'ThisContext home return: ``@value';
		executeTree: methodNode.
	"Keep same compilation context as the sender node's"
	methodNode compilationContext: sendNode methodNode compilationContext copy.
	"Disable inlining so the message send will be unoptimized"
	methodNode compilationContext compilerOptions: #(- optionInlineIf optionInlineAndOr optionInlineWhile).
	"Generate the method"	
	method := methodNode generate.
	"Execute the generated method with the pc still at the optimzized block so that the lookUp can read variables defined in the optimized block"
	ret := context receiver withArgs: {context} executeMethod: method.
   	"resume the context at the instruction following the send when returning from deoptimized code."
   context pc: sendNode irInstruction nextBytecodeOffsetAfterJump.	
	^ret.
]
