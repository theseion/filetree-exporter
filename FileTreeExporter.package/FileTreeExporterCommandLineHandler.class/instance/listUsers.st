actions
listUsers
	| gofer repository allVersions users |
	"print the list of all uesrs of the given source repository"
	gofer := self gofer.
	repository := gofer repositories last.
	self inform: 'Loading all versions from ', repository asString.
	allVersions := gofer allResolvedIn: repository.
	users := allVersions collect: [ :each | each author ] as: Set.
	"print sorted list of users"
	users asSortedCollection 
		do: [ :each | self stdout << each ]
		separatedBy: [ self stdout lf ].
	self exitSuccess.