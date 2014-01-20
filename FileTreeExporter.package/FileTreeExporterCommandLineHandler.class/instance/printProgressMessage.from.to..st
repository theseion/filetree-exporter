accessing
printProgressMessage: message from: index to: end
	self stderr startOfLine; clearToEnd; yellow; 
		<< message; << ' [';
		print: index; << '/'; print: end; << ']';
		clear.