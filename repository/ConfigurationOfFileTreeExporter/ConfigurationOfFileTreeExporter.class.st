"
Copy me to create a new configuration or edit and evaluate the following doits.

        ""Create configuration class and initial baseline method""

        MetacelloToolBox 
                createBaseline: '1.0-baseline'
                for: 'MyProject'
                repository: 'http://www.example.com/MyProjectRepository'
                requiredProjects: #('Gofer')
                packages: #('MyProject-Core' 'MyProject-Tests')
                dependencies:
                        {('MyProject-Core' -> #('Gofer')).
                         ('MyProject-Tests' -> #('MyProject-Core'))}
                groups:
                        {('default' -> #('Core')).
                        ('Core' -> #('MyProject-Core')).
                        ('Tests' -> #('MyProject-Tests'))}.

	   ""create initial development method from the baseline""

         MetacelloToolBox
               createDevelopment: '1.0'
               for: 'MyProject'
                importFromBaseline: '1.0-baseline'
                description: 'initial version'.

"
Class {
	#name : #ConfigurationOfFileTreeExporter,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : 'ConfigurationOfFileTreeExporter'
}

{ #category : #'development support' }
ConfigurationOfFileTreeExporter class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfFileTreeExporter class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #private }
ConfigurationOfFileTreeExporter class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfFileTreeExporter class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfFileTreeExporter class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfFileTreeExporter class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfFileTreeExporter class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfFileTreeExporter class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfFileTreeExporter class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfFileTreeExporter class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfFileTreeExporter >> baseline10: spec [
	<version: '1.0-baseline'>

	spec for: #common do: [	
		spec blessing: #baseline.
		spec repository: 'filetree:github.com/camillobruni/filetree-exporter'.
	
		self 
			osProcess: spec.
		
		spec
			package: 'FiletreeExporter' with: [ 
				spec requires: #('OSProcess')].
			
		spec 
			group: 'default' with: #('FiletreeExporter')]
]

{ #category : #accessing }
ConfigurationOfFileTreeExporter >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #tags }
ConfigurationOfFileTreeExporter >> development: spec [
	<symbolicVersion: #development >
	
	spec for: #'common' version: 'dev'.

]

{ #category : #'external projects' }
ConfigurationOfFileTreeExporter >> fuelMetalevel: spec [

	"Specify a dependency on an external project which has it's own configuration.
	The given project name can be chosen freely, for simplicity use the same name as the configuration or the conditional group you load."
	spec project: 'FuelMetalevel' with: [
		spec 
			repository: 'http://ss3.gemstone.com/ss/Fuel';
			className: 'ConfigurationOfFuel';
			"if you want to load by default a special group usse the #loads: message plus a group name of the external configuration"
			loads: #FuelMetalevel ].
]

{ #category : #'external projects' }
ConfigurationOfFileTreeExporter >> osProcess: spec [
	spec project: 'OSProcess' with: [
		spec
			repository: 'http://www.squeaksource.com/MetacelloRepository';
			className: 'ConfigurationOfOSProcess';
			version: #stable ].
]

{ #category : #accessing }
ConfigurationOfFileTreeExporter >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #tags }
ConfigurationOfFileTreeExporter >> stable: spec [
	"Symbolic versions can be used to introduce an indirection to a version number.
	The real name used by Metacello is only defined by the following pragma:"
	<symbolicVersion: #stable >
	
	"If another version is stable for a differen Smalltalk use a specific name"
	"spec for: #'pharo1.4.x' version: '0.9'"
	
	"Specfiy which exact version you want to load"
	spec for: #'common' version: '1.0'.
	
]

{ #category : #versions }
ConfigurationOfFileTreeExporter >> versionDevelopment: spec [
	<version: 'dev' imports: #('1.0-baseline') >
	
	spec for: #common do: [		
		spec
			package: 'ConfigurationOfFileTreeExporter'  with: 'ConfigurationOfFileTreeExporter';
			package: 'FileTreeExporter' with: 'FileTreeExporter.173';
			project: 'OSProcess'   with: #stable ].
]
