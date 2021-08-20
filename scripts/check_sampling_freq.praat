# Auromita
# August 6 2021


writeInfoLine: ""
dir$ = "./"
###

Create Strings as file list: "files", dir$ + "*.wav"
nFiles = Get number of strings

for i from 1 to nFiles
	# read in WAV file
	selectObject: "Strings files"
	filename$ = Get string: i
	Read from file: dir$ + filename$

	sampfreq = Get sampling frequency
	appendInfoLine: filename$, tab$, sampfreq
	
	# clean up
	select all
	minusObject: "Strings files"
	Remove

endfor