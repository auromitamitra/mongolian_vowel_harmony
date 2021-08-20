# Auromita
# July 19, 2021
# Lists utterance IDs with start and end times ("segments.txt" file)
# UTTERANCE_ID = "SPEAKER-ID"_pass_"utterance no."

file$ = chooseReadFile$: "Open a Text Grid"
Read from file: file$

form speaker number
  word Speaker_ID:
  word File_name: F1_passages
  integer Utterance_tier: 3
endform
writeInfo: ""
numberOfIntervals = Get number of intervals: utterance_tier
i = 0
for intervalnumber from 1 to numberOfIntervals
	text$ = Get label of interval: utterance_tier, intervalnumber
	if text$ != ""
		start = Get start time of interval: utterance_tier, intervalnumber
		start$ = fixed$(start,2)
		end = Get end time of interval: utterance_tier, intervalnumber
		end$ = fixed$(end,2)
		i = i+1
		utterance_ID$ = speaker_ID$ + "_pass" + string$(i)
		appendInfoLine: utterance_ID$, tab$, file_name$, tab$, start$, tab$, end$
	endif
endfor
