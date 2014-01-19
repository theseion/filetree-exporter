versions
versionDevelopment: spec
	<version: 'dev' imports: #('1.0-baseline') >
	
	spec for: #common do: [		
		spec
			package: 'ConfigurationOfFileTreeExporter'  with: 'ConfigurationOfFileTreeExporter';
			package: 'FileTreeExporter' with: 'FileTreeExporter.173';
			project: 'OSProcess'   with: #stable ].