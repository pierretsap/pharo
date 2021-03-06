Class {
	#name : #KMCombinationTests,
	#superclass : #AbstractKeymappingTest,
	#category : #'Keymapping-Tests'
}

{ #category : #tests }
KMCombinationTests >> testCombinationOfSimpleShortcuts [
	| shortcut otherShortcut combination |
	shortcut := $a command.
	otherShortcut := $b ctrl.
	
	combination := shortcut | otherShortcut.
	
	self assert: (combination includes: shortcut).
	self assert: (combination includes: otherShortcut).
	
	self assert: ((combination collect: #platform) allSatisfy: [ :p | p = #all ]).
]

{ #category : #tests }
KMCombinationTests >> testCombinationSeveralShortcuts [
	| shortcut platforms |
	platforms := Set new.
	
	shortcut := $a command mac | $a ctrl win | $a ctrl unix | $a alt.
	shortcut combinationsDo: [ :c | platforms add: c platform ].
	self assert: (platforms includes: #MacOSX).
	self assert: (platforms includes: #Windows).
	self assert: (platforms includes: #Unix).
	self assert: (platforms includes: #all).
]

{ #category : #tests }
KMCombinationTests >> testMacDependentShortcut [
	| shortcut |
	shortcut := $a ctrl mac.
	
	self assert: (shortcut shortcut = $a ctrl).
	
	self assert: shortcut platform equals: #MacOSX.
]

{ #category : #tests }
KMCombinationTests >> testMacMetaShouldBeCmd [
	OSPlatform current isMacOS ifFalse: [ ^ self skip ].
	self assert: $n meta equals: $n command.
	self assert: $n command equals: $n meta.
	self assert: $n meta shift equals: $n command shift.
	self assert: $n command shift equals: $n meta shift
]

{ #category : #tests }
KMCombinationTests >> testPlatformDependentShortcut [
	| shortcut |
	shortcut := $a ctrl win.
	
	self assert: (shortcut shortcut = $a ctrl).
	
	self assert: shortcut platform equals: #Windows.
]

{ #category : #tests }
KMCombinationTests >> testShortcutIsSimpleCombination [
	| shortcut |
	shortcut := $a command.
	self assert: (shortcut includes: shortcut).
	self assert: shortcut shortcut equals: shortcut.
]

{ #category : #tests }
KMCombinationTests >> testUnixDependentShortcut [
	| shortcut |
	shortcut := $a ctrl unix.
	
	self assert: (shortcut shortcut = $a ctrl).
	
	self assert: shortcut platform equals: #Unix.
]

{ #category : #tests }
KMCombinationTests >> testWindowsAndUnixMetaShouldBeCtrl [
	OSPlatform current isMacOS ifTrue: [ ^ self skip ].
	self assert: $n meta equals: $n ctrl.
	self assert: $n ctrl equals: $n meta.
	self assert: $n meta shift equals: $n ctrl shift.
	self assert: $n ctrl shift equals: $n meta shift
]

{ #category : #tests }
KMCombinationTests >> testWindowsDependentShortcut [
	| shortcut |
	shortcut := $a ctrl win.
	
	self assert: (shortcut shortcut = $a ctrl).
	
	self assert: shortcut platform equals: #Windows.
]
