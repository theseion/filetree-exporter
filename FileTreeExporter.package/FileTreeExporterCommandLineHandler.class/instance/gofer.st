accessing
gofer
	gofer ifNotNil: [ ^ gofer ].
	^ gofer := Gofer new
		url: self sourceUrl 
		username: (self optionAt: 'username' ifAbsent: [ '' ]) 
		password: (self optionAt: 'password' ifAbsent: [ '' ]);
		yourself