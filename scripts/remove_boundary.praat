# Auromita
# August 29, 2021
# Find consecutive œ s in the phone tier and remove intervening boundary



########## CONTROL VARIABLES #################
word_tier = 1
phone_tier = 2
input_dir$ = "../temp_input/"
output_dir$ = "../temp_output/"
target_word$ = "(tœɮœœr|pœœrœœr|ʦ͡œœɮrœɮtʰ|ʦ͡œœɮruːɮ)"

#############################################

Create Strings as file list... list 'input_dir$'/
nfiles = Get number of strings
clearinfo

for ifile to nfiles
    select Strings list
    filename$ = Get string... ifile
    Read from file... 'input_dir$'/'filename$'
    filename$ = selected$("TextGrid")
    select TextGrid 'filename$'
    textgrid = selected("TextGrid")
    appendInfoLine: ""
    appendInfoLine: "file = ", filename$

    word_intervals = Get number of intervals: word_tier
    phone_intervals = Get number of intervals: phone_tier

    # GO THROUGH WORD INTERVALS ONE BY ONE
    for wi from 1 to word_intervals
        selectObject: textgrid
        word$ = Get label of interval: word_tier, wi
        #FIND TARGET WORDS
        if index_regex(word$,target_word$)
            appendInfoLine: "word is ", word$
            wstart = Get start time of interval: word_tier, wi
            wend = Get end time of interval: word_tier, wi  

            # EXTRACT WORD
            phoneobject = Extract part: wstart, wend, "yes"
            # FOR EACH WORD, FIND CORRESPONDING PHONES
            selectObject: phoneobject
            phone_intervals = Get number of intervals: phone_tier
            
            # GO THROUGH THE PHONE INTERVALS ONE BY ONE
            for i from 1 to phone_intervals
                selectObject: phoneobject
                phone$ = Get label of interval... phone_tier i
                # IF THE PHONE IS œ, LOOK AT THE NEXT PHONE
                if phone$ = "œ"
                    phone_next$ = Get label of interval... phone_tier i+1
                    #appendInfoLine: phone$,tab$, phone_next$
                    # IF 2 CONSECUTIVE INTERVALS ARE œ: GO TO MAIN TEXTGRID, REMOVE BOUNDARY BETWEEN THEM
                    if phone_next$ = "œ"
                        start = Get start time of interval: phone_tier, i
                        end = Get end time of interval: phone_tier, i
                        appendInfoLine: "found ",phone$," and ",phone_next$," in ",word$," at ",start
                        selectObject: textgrid
                        target_phone = Get interval at time: phone_tier, start
                        Remove right boundary... phone_tier target_phone
                        phone_name$ = Get label of interval... phone_tier target_phone
                        appendInfoLine: "new label= ",phone_name$
                    endif
                endif
            endfor
            removeObject: phoneobject
            
        endif
    endfor
    selectObject: textgrid
    Save as text file: output_dir$+filename$+".TextGrid"
    select 'textgrid'
    Remove

endfor