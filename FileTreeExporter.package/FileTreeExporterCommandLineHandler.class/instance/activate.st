activation
activate
	| subCommand |
	self activateHelp
		ifTrue: [  ^ self ].
	
	subCommand := self arguments first.
	
	(subCommand = 'users')
		ifTrue: [ ^ self listUsers ].
		
	(subCommand = 'packages')
		ifTrue: [ ^ self listPackages].
		
	(subCommand = 'export')
		ifTrue: [ ^ self export ].
	
	self error: 'Invalid subcommand provided'