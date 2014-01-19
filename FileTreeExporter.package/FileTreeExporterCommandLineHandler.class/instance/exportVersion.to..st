action-export
exportVersion: version to: destination
	| gitUser result commitFile |

	gitUser := self gitUserFromMCUser: version author.

	commitFile := 'filetree-export-commit.txt' asFileReference.
	commitFile ensureDelete.
	commitFile writeStream: [ :s |
		s nextPutAll: version info message ].

	"filetree export"
	destination storeVersion: version.
	"git commit"
	result := OSProcess waitForCommand: ('cd "', destination directory fullName,'" && ',
		'git add repository/* && ',
		'git commit --allow-empty-message --allow-empty --author="', gitUser, '" --file="', commitFile fullName, '"')