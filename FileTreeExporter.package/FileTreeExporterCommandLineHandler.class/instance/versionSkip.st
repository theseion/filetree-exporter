accessing
versionSkip
	| skip |
	
	skip := self optionAt: 'skip' ifAbsent: [ ^ 0 ].
	skip asUnsignedInteger ifNil: [ 
		self exitFailure: 'Invalid argument for --skip, expected unsigned integer but got "', skip, '"' ].
	^ skip asUnsignedInteger