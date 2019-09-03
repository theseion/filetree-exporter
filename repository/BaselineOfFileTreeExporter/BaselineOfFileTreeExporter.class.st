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
				baseline: 'OSProcess'
				with: [
					spec repository: 'github://dtlewis290/OSProcess-Tonel:master' ].
			
			spec
				package: 'FileTreeExporter' with:[
					spec requires: #('OSProcess') ];
				group: 'default' with: #('FileTreeExporter') ]
]
