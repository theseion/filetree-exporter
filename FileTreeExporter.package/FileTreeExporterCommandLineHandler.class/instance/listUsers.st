action-users
listUsers
	| users |
	"print the list of all uesrs of the given source repository"
	users := self versions collect: [ :each | each author ] as: Set.
	"print sorted list of users"
	users asSortedCollection 
		do: [ :each | self stdout << each ]
		separatedBy: [ self stdout lf ].
	self exitSuccess.