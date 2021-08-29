#target_word$ = "(tœɮœœr|pœœrœœr|ʦ͡œœɮrœɮtʰ|ʦ͡œœɮruːɮ)"
target_word$ = "tœɮœœr"
word_tier = 1
phone_tier = 2

select TextGrid f01_frame_rep1
textgrid = selected("TextGrid")
clearinfo

select 'textgrid'
word_intervals = Get number of intervals: word_tier
phone_intervals = Get number of intervals: phone_tier

# GO THROUGH WORD INTERVALS ONE BY ONE
for wi from 1 to word_intervals
    word$ = Get label of interval: word_tier, wi
    #FIND TARGET WORDS
    if index_regex(word$,target_word$)
        writeInfoLine: "word is ", word$
        wstart = Get start time of interval: word_tier, wi
        wend = Get end time of interval: word_tier, wi  
        
        # EXTRACT WORD
        phoneobject = Extract part: wstart, wend, "yes"
        # FOR EACH WORD, FIND CORRESPONDING PHONES
        selectObject: phoneobject
        phone_intervals = Get number of intervals: phone_tier

        # GO THROUGH THE PHONE INTERVALS ONE BY ONE
        for i from wstart to wend
            interval = Get interval at time: phone_tier, i
            selectObject: phoneobject
            phone$ = Get label of interval... phone_tier interval
            if phone$ = "œ" 
                phone_next$ = Get label of interval... phone_tier interval+1
                appendInfoLine: "phone1: ",phone$, " phone2: ", phone_next$
                # FIND TARGET VOWEL SEQUENCE
                if (phone$ = "œ") and (phone_next$ = "œ")
                    appendInfoLine: "found ",phone$," and ",phone_next$
                    Remove right boundary... phone_tier interval
                    start = Get start time of interval: phone_tier, interval
                    end = Get end time of interval: phone_tier, interval
                    selectObject: textgrid
                    target_phone = Get interval at time: phone_tier, start
                    Remove right boundary... phone_tier target_phone
                endif
            endif
            
           
        endfor

    endif
endfor

printline done