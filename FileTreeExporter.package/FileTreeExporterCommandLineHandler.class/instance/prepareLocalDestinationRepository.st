action-export
prepareLocalDestinationRepository
	| destinationFolder result fileTreeFolder |
	
	destinationFolder := self destinationFolder.
	destinationFolder exists 
		ifTrue: [ 
			^ self exitFailure: 'export folder ', destinationFolder asString, ' exists already' ].

	destinationFolder ensureCreateDirectory.
	fileTreeFolder := destinationFolder / 'repository'.
	fileTreeFolder ensureCreateDirectory.
	
	result := OSProcess waitForCommand: 'cd ', destinationFolder asString, ' && git init'.
	result succeeded ifFalse: [ 
		^ self exitFailure: 'Could not initialize empty git repository in ', destinationFolder asString ].
	
	^ MCFileTreeRepository new
		directory: fileTreeFolder fullName;
		yourself