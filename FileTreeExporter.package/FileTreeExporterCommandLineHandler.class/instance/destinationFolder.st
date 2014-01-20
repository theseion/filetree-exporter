action-export
destinationFolder
	| folderPath |
	folderPath := self optionAt: 'to' ifAbsent: [ 
		self inform: 'using default export repository: export-repository'.
		'export-repository' ].
	^ folderPath asFileReference