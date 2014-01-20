accessing
versions 
	| gofer repository |
	gofer := self gofer.
	repository := gofer repositories last.
	self inform: 'Loading all versions from ', repository asString.
	^ gofer allResolvedIn: repository.