# Auromita
# July 19, 2021
# Create a list of non-silent words from the word tier of a textgrid

form Parse TextGrid...
  #sentence File \passages\F1_passages.TextGrid
  integer Tier 2
endform

file$ = chooseReadFile$: "Open a Text Grid"
Read from file: file$
intervals = Get number of intervals: tier
writeInfoLine: ""
for i to intervals
  label$ = Get label of interval: tier, i
  if label$ = "gesen"
  # because last word same in all utterances
    appendInfo: label$, newline$
  elif (label$ != "") and (label$ != "sil") and (label$ != "sp")
    #start = Get start point: tier, i
    appendInfo: label$, " "
  endif
endfor