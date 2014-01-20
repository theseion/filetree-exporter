action-listing
printUniqueVersionInformation: extractBlock
	"Collect information from all versions in the source repository.
	Use the extractBlock to get the information string.
	The printed output is sorted and duplicates removed."
	| strings |
	
	strings := self filteredVersions collect: extractBlock as: Set.
	self printAsSortedCollection: strings.