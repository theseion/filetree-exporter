action-export
exportVersion: version to: destination
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