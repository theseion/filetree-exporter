accessing
userMap
	| file map |
	file := (self optionAt: 'user-map') asFileReference.
	map := Dictionary new.
	file readStream contents linesDo: [ :line | | tokens monticelloAuthor gitAuthor |
		tokens := line splitOn: [ :each | each isSeparator ].
		monticelloAuthor := tokens first.
		gitAuthor := tokens allButFirst joinUsing: ' '.
		map at: monticelloAuthor put: gitAuthor ].
	^ map