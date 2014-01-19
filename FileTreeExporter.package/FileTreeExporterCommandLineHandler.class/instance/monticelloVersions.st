accessing
monticelloVersions
	"convert all gofer references/version into the real monticello versions"
	^ self versions collect: [ :each | each version ]