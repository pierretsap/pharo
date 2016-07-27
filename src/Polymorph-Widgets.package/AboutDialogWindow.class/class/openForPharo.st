instance creation
openForPharo
	<script>
	| text dialog width |
	text := Smalltalk systemInformationString withCRs.
	width := 0.
	text
		linesDo: [ :l | 
			width := width
				max: (Smalltalk ui theme textFont widthOfStringOrText: l) ].
	dialog := self new entryText: text.
	dialog iconMorph image: (Smalltalk ui icons iconNamed: #pharoIcon).
	dialog title: 'About Pharo'.
	dialog open.
	dialog textMorph
		minWidth: 20;
		minHeight: 20.
	dialog width: (width + 120 min: Display width - 50).
	dialog position: 25 @ 25