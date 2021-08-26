# Auromita
# July 19, 2021
# Create a lexicon from a textgrid. Word and phone tier must be aligned. Format: WORD (tab) PHONE1 (space) PHONE2 (space) PHONE3...

## to fix: line 37: file name (use variable with file ID)

form Select tiers
  integer Phone_tier: 1
  integer Word_tier: 2
endform

file$ = chooseReadFile$: "Open a Text Grid"
Read from file: file$
#select TextGrid 'file$'
#textgrid = selected("TextGrid")

word_intervals = Get number of intervals: word_tier
phone_intervals = Get number of intervals: phone_tier

writeInfoLine: "<oov>", tab$ ,"<oov>"
appendInfoLine: "<sil>", tab$, "SIL"

for wi from 1 to word_intervals
  word$ = Get label of interval: word_tier, wi
  # for all non-empty and non-silence intervals:
  if (word$ != "") and (word$ != "sil") and ( word$ != "sp")
    wstart = Get start time of interval: word_tier, wi
    wend = Get end time of interval: word_tier, wi
    # extract word
    phoneobject = Extract part: wstart, wend, "no"
    # for each word, extract corresponding phones
    selectObject: phoneobject
    intervals = Get number of intervals: phone_tier
    phonestring$ = ""
    # write phone transcription for word (phones separated by space)
    for i from 1 to intervals
      phone$ = Get label of interval: phone_tier, i
      phonestring$ = phonestring$ + " " + phone$
    endfor
    appendInfoLine: word$, tab$, phonestring$
    removeObject: phoneobject
    selectObject 'f01_frame_rep1.TextGrid'
  endif
endfor 




  

