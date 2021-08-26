filler_word$ = "(xɔjor|aʧ͡iɮ|atiɮ|minij|pʰaɮ|ʧ͡ʰat|ʦ͡am|xaɮ|ɮam|waːr|pi|gesen)"
vowel$ = "^(a|a:|e|e:|i|i:|o|o:|u|u:|ʊ|ʊ:|ɔ|ɔ:|œ|œœ)$"
word_tier = 1
seg_tier = 2

select Sound f01_frame_rep1
plus TextGrid f01_frame_rep1
Scale times
sound = selected("Sound")
textgrid = selected("TextGrid")
clearinfo

select 'textgrid'
#word_intervals = Get number of intervals: word_tier
phone_intervals = Get number of intervals: seg_tier

# GO THROUGH WORD INTERVALS ONE BY ONE
for wi from 1 to phone_intervals
    phone$ = Get label of interval: seg_tier, wi
    #FIND TARGET WORDS
    if index_regex(phone$,vowel$)
        printline 'phone$'
    elif phone$ = ""
        printline ' '
    else
        printline 'nope'
    endif
endfor