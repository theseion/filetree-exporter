accessing
userMap
	| file |
	
	userMap ifNotNil: [ ^ userMap ].
	
	file := self userMapFile.
	userMap := Dictionary new.
	
	file readStream contents linesDo: [ :line |
		| tokens monticelloAuthor gitAuthor |
		tokens := line splitOn: [ :each | each isSeparator ].
		monticelloAuthor := tokens first.
		gitAuthor := (tokens allButFirst joinUsing: ' ') trimBoth.
		gitAuthor isEmpty
			ifFalse: [ userMap at: monticelloAuthor put: gitAuthor ]].
		
	^ userMap