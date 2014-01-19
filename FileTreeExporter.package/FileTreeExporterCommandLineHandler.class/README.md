Usage: [--help] [[users|packages] --from=<URL>] [export --from=<URL> [--to=<DIR>] --user-map=<FILE>]
	
	--help    show this help message
	users     list all users of the source repository
	packages  list all packages in the source repository
	export    export the source repository to the git repository in <DIR>
	<URL>     url for a monticello source repository
	<DIR>     git repository directory to which the source repository is exported to.
	<FILE>    a line separate file wich maps the monticello users to full git users.