activation
activate
	self activateHelp
		ifTrue: [  ^ self ].
	
	(self arguments first = 'users')
		ifTrue: [ ^ self listUsers ].
		
	(self arguments first = 'export')
		ifFalse: [ ^ self export ].
	
	self error: 'Invalid subcommand provided'