# jm 2012-10-05
# save a selection of files to the hard disk
# supported object types: Sound, TextGrid, Table (other objetct types are ignored!)
# file name specification: objet name or user specified basename + index
# existing file will *not* be overridden
# Usage:
#		- select objects
#		- run script
#		- specify options
#		- choose target directory

form Settings
	boolean Use_object_names 0
	comment If you don't use object names you must specify a base name.
	comment Files will be numbered sequentially (test_1, test_2 ...);
	comment 
	sentence Base_file_name heart_01_dur
	comment If files already exist new files are time stamped.
endform

directory$ = chooseDirectory$ ("Choose a directory to save the files in")
if directory$ = ""
	exit
endif

nos = numberOfSelected ()
for i to nos
	objectIDs [i] = selected ('i')
endfor

clearinfo
num = 1
for i to nos
	num$ = fixed$ (num, 0)
	id = objectIDs [i]
	select 'id'
	name_type$ = selected$ ()
	oname$ = extractLine$ (name_type$, " ")
	type$ = extractWord$ (name_type$, "")
	if type$ = "Sound"
		call testAndSave wav
	elsif type$ = "TextGrid"
		call testAndSave TextGrid
	elsif type$ = "Table"
		call testAndSave Table
	else
		printline WARNING: 'type$' 'oname$' ('id') not saved; can't handle objects of type 'type$'.
		num = num - 1
	endif
	num = num + 1
endfor

for i to nos
	if i = 1
		select objectIDs [i]
	else
		plus objectIDs [i]
	endif
endfor


procedure testAndSave .suffix$
	if use_object_names = 0
		.pname$ = base_file_name$ + "_" + num$
	else
		.pname$ = oname$
	endif
	.filename$ = directory$ + "/" + .pname$ + "." + .suffix$
	print Trying to save '.filename$'
	if fileReadable (.filename$)
		printline
		printline 'tab$'WARNING: '.filename$' already exists; adding time stamp.
		repeat
			.date$ = date$ ()
			.filename$ = directory$ + "/" + .pname$ + " (" + .date$ + ")" + "." + .suffix$
		until !fileReadable (.filename$)
		print 'tab$'Saving instead '.filename$'
	endif
	if .suffix$ = "wav"
		Save as WAV file... '.filename$'
	elsif .suffix$ = "TextGrid" || .suffix$ = "Table"
		Save as text file... '.filename$'
	endif
	printline 'tab$'-'tab$'Done
endproc





