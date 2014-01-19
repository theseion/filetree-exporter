baselines
baseline10: spec
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