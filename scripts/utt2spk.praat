# July 19, 2021
# Maps each utterance to speaker: UTTERANCE_ID (tab) SPEAKER_ID
# UTTERANCE_ID = "SPEAKER-ID"_pass_"utterance no."

file$ = chooseReadFile$: "Open a Text Grid"
Read from file: file$

form speaker number
  word Speaker_ID:
  integer Utterance_tier: 3
endform
writeInfo: ""
numberOfIntervals = Get number of intervals: utterance_tier
i = 0
for intervalnumber from 1 to numberOfIntervals
	text$ = Get label of interval: utterance_tier, intervalnumber
	if text$ != ""
		i = i+1
		utterance_ID$ = speaker_ID$ + "_pass" + string$(i)
		appendInfoLine: utterance_ID$, tab$, speaker_ID$
	endif
endfor
