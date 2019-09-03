"
Usage: 
	--help
	[packages|users] --from=<URL> --package-filter=<REGEX>
	export   --from=<URL> --package-filter=<REGEX> --skip=<OFFSET> --to=<DIR> --user-map=<FILE> 
	
	--help    show this help message
	users     list all users of the source repository
	packages  list all packages in the source repository
	export    export the source repository to the git repository in <DIR>
	<URL>     url for a monticello source repository,
	          e.g. http://smalltalkhub.com/mc/UserName/ProjectName/main
	<DIR>     git repository directory to which the source repository is exported to.
	<FILE>    a line separate file wich maps the monticello users to full git users.
	          format: <Monticello user> <Git user>
	          e.g.: HomerSimpson Homer Simpson <homer@nuke.springfield.com>
	<REGEX>   A regular expression used to filter packages the are exported
	<OFFSET>  An integer indicating how many versions should be skipped
"
Class {
	#name : #FileTreeExporterCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'gofer',
		'userMap'
	],
	#category : #FileTreeExporter
}

{ #category : #accessing }
FileTreeExporterCommandLineHandler class >> commandName [
	^ 'filetree-exporter'
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler class >> description [
	^ 'Export a monticello repository to filetree format'
]

{ #category : #activation }
FileTreeExporterCommandLineHandler >> activate [
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
]

{ #category : #'action-export' }
FileTreeExporterCommandLineHandler >> destinationFolder [
	| folderPath |
	folderPath := self optionAt: 'to' ifAbsent: [ 
		self inform: 'using default export repository: export-repository'.
		'export-repository' ].
	^ folderPath asFileReference
]

{ #category : #'action-export' }
FileTreeExporterCommandLineHandler >> export [
	| versions destination |
	"initialize the lazy user map"
	self userMap.
	destination := self prepareLocalDestinationRepository.
	versions := self monticelloVersions 
		asSortedCollection: self mcVersionDateComparisonBlock.
		
	versions withIndexDo: [ :version :index | 
		self
			printProgressMessage: ('Exporting ', version info name)
			from: index + self versionSkip
			to: versions size + self versionSkip.	
		self stderr lf.
		self exportVersion: version to: destination ].
	
	self exitSuccess.

]

{ #category : #'action-export' }
FileTreeExporterCommandLineHandler >> exportVersion: version to: destination [
	| gitUser result commitFile |

	gitUser := self gitUserFromMCUser: version info author.

	commitFile := 'filetree-export-commit.txt' asFileReference.
	commitFile ensureDelete.
	commitFile writeStreamDo: [ :s |
		s nextPutAll: version info message ].

	"filetree export"
	destination storeVersion: version.
	"git commit"
	result := OSProcess waitForCommand: ('cd "', destination directory fullName,'" && ',
		'git add --all * .filetree && ',
		'git commit --allow-empty-message --allow-empty --author="', gitUser, '" --file="', commitFile fullName, '" --date="', version info timeStamp asString,'"')
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> filteredVersions [
	| versions regex |
	
	versions := self versions.
	regex := self optionAt: 'package-filter' ifAbsent: [ ^ versions ].
	[ regex := regex asRegex ]
		on: Error do: [
			self exitFailure: 'Could not parse package-regex: "', regex.'"' ].
	^ versions select: [ :each | regex search: each packageName ]
]

{ #category : #'action-export' }
FileTreeExporterCommandLineHandler >> gitUserFromMCUser: mcAuthorString [
	^ self userMap 
		at: mcAuthorString
		ifAbsent: [ 
			self inform: 'Missing Git Author! Using "', mcAuthorString,' <no@email.com>" instead'.
			mcAuthorString, ' <no@email.com>' ]
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> gofer [
	gofer ifNotNil: [ ^ gofer ].
	^ gofer := Gofer new
		url: self sourceUrl 
		username: (self optionAt: 'username' ifAbsent: [ '' ]) 
		password: (self optionAt: 'password' ifAbsent: [ '' ]);
		yourself
]

{ #category : #'action-listing' }
FileTreeExporterCommandLineHandler >> listPackages [
	
	self printUniqueVersionInformation: [ :each | each packageName ].
	
	self exitSuccess.
]

{ #category : #'action-listing' }
FileTreeExporterCommandLineHandler >> listUsers [
	self printUniqueVersionInformation: [ :each | each author ].
	self exitSuccess.
]

{ #category : #'action-export' }
FileTreeExporterCommandLineHandler >> mcVersionDateComparisonBlock [
	^ [ :a :b |
		a info timeStamp <= b info timeStamp ]
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> monticelloVersions [
	"convert all gofer references/version into the real monticello versions"
	| goferVersions versions skip |
	skip := self versionSkip.
	goferVersions := self versions.
	versions := Array new: goferVersions size.
	
	goferVersions withIndexDo: [ :each :index |
		self
			printProgressMessage: 'Fetching All Monticello Versions:' 
			from: index
			to: goferVersions size.
		versions at: index put: each version ].
	self stderr lf.
	
	skip > 0
		ifTrue: [ 
			self inform: 'Skipping ', skip asString, ' out of ', versions size asString, ' versions'.
			^ versions allButFirst: skip ].
	^ versions
]

{ #category : #'action-export' }
FileTreeExporterCommandLineHandler >> prepareLocalDestinationRepository [
	| destinationFolder result fileTreeFolder |
	
	destinationFolder := self destinationFolder.

	destinationFolder exists ifFalse: [
		destinationFolder ensureCreateDirectory.
	
		result := OSProcess waitForCommand: 'cd "', destinationFolder fullName, '" && git init'.
		result succeeded ifFalse: [ 
			^ self exitFailure: 'Could not initialize empty git repository in ', destinationFolder fullName ] ].
	
	fileTreeFolder := destinationFolder / 'repository'.
	fileTreeFolder ensureCreateDirectory.
	
	^ MCFileTreeRepository new
		directory: fileTreeFolder;
		yourself
]

{ #category : #'action-listing' }
FileTreeExporterCommandLineHandler >> printAsSortedCollection: list [
	
	list asSortedCollection 
		do: [ :each | self stdout << each ]
		separatedBy: [ self stdout lf ].
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> printProgressMessage: message from: index to: end [
	self stderr startOfLine; clearToEnd; yellow; 
		<< message; << ' [';
		print: index; << '/'; print: end; << ']';
		clear.
]

{ #category : #'action-listing' }
FileTreeExporterCommandLineHandler >> printUniqueVersionInformation: extractBlock [
	"Collect information from all versions in the source repository.
	Use the extractBlock to get the information string.
	The printed output is sorted and duplicates removed."
	| strings |
	
	strings := self filteredVersions collect: extractBlock as: Set.
	self printAsSortedCollection: strings.
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> sourceUrl [
	^ self 
		optionAt: 'from' 
		ifAbsent: [
			self exitFailure: 'Missing source repository [--from]' ]
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> userMap [
	| file |
	userMap ifNotNil: [ ^ userMap ].
	file := self userMapFile.
	userMap := Dictionary new.
	file readStream contents linesDo: [ :line | | tokens monticelloAuthor gitAuthor |
		tokens := line splitOn: [ :each | each isSeparator ].
		monticelloAuthor := tokens first.
		gitAuthor := (tokens allButFirst joinUsing: ' ') trimBoth.
		gitAuthor isEmpty
			ifFalse: [ userMap at: monticelloAuthor put: gitAuthor ]].
	^ userMap
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> userMapFile [
	^ (self
		optionAt: 'user-map'
		ifAbsent: [ 
			self exitFailure: 'Missing Option --user-map' ]) asFileReference
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> versionSkip [
	| skip |
	
	skip := self optionAt: 'skip' ifAbsent: [ ^ 0 ].
	skip asUnsignedInteger ifNil: [ 
		self exitFailure: 'Invalid argument for --skip, expected unsigned integer but got "', skip, '"' ].
	^ skip asUnsignedInteger
]

{ #category : #accessing }
FileTreeExporterCommandLineHandler >> versions [ 
	| gofer repository |
	gofer := self gofer.
	repository := gofer repositories last.
	self inform: 'Loading all versions from ', repository asString.
	^ gofer allResolvedIn: repository.
]
