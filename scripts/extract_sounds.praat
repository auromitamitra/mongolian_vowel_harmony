# Auromita
# July 19, 2021
# Create a list of words/phones from the specified tier of a textgrid

form Parse TextGrid...
  integer Tier 2
endform

file$ = chooseReadFile$: "Open a Text Grid"
Read from file: file$
intervals = Get number of intervals: tier
writeInfoLine: ""
for i to intervals
  label$ = Get label of interval: tier, i
    if label$ != ""
        appendInfoLine: label$
    endif
endfor