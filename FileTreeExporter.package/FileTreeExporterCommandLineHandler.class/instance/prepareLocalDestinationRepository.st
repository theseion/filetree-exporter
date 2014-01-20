action-export
prepareLocalDestinationRepository
	| destinationFolder result fileTreeFolder |
	
	destinationFolder := self destinationFolder.
	destinationFolder exists 
		ifTrue: [ 
			^ self exitFailure: 'export folder ', destinationFolder fullName, ' exists already' ].

	destinationFolder ensureCreateDirectory.
	fileTreeFolder := destinationFolder / 'repository'.
	fileTreeFolder ensureCreateDirectory.
	
	result := OSProcess waitForCommand: 'cd "', destinationFolder fullName, '" && git init'.
	result succeeded ifFalse: [ 
		^ self exitFailure: 'Could not initialize empty git repository in ', destinationFolder fullName ].
	
	^ MCFileTreeRepository new
		directory: fileTreeFolder;
		yourself