Class {
	#name : #BaselineOfFileTreeExporter,
	#superclass : #BaselineOf,
	#category : #BaselineOfFileTreeExporter
}

{ #category : #baselines }
BaselineOfFileTreeExporter >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec
				project: 'OSProcess'
				with: [
					spec repository: 'githu://dtlewis290/OSProcess-Tonel:master' ].
			
			spec
				package: 'FileTreeExporter' with:[
					spec requires: #('OSProcess') ];
				group: 'default' with: #('FileTreeExporter') ]
]
