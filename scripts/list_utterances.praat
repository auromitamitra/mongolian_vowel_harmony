# Auromita
# July 19 2021
# Creates a list of utterances from a textgrid in the following format: UTTERANCE_ID word1 word2 word3...
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
		appendInfoLine: speaker_ID$, "_pass", i, " ", text$
	endif
endfor
