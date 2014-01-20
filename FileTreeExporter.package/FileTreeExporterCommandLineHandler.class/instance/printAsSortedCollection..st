action-listing
printAsSortedCollection: list
	
	list asSortedCollection 
		do: [ :each | self stdout << each ]
		separatedBy: [ self stdout lf ].