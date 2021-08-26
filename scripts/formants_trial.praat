
#PROMPT THE USER FOR INPUT
########## CONTROL VARIABLES ##########
seg_tier = 2
word_tier = 1
directory$ = "./"
data_path$ = "./"
data_file$ = "formants.txt"
maximum_formant = 5500
number_of_formants = 5
filler_word$ = "(xɔjor|aʧ͡iɮ|atiɮ|minij|pʰaɮ|ʧ͡ʰat|ʦ͡am|xaɮ|ɮam|waːr|pi|gesen)"
vowel$ = "^(a|aː|e|eː|i|iː|o|oː|u|uː|ʊ|ʊː|ɔ|ɔː|œ|œœ)$"
# note: vowel length diacritic in annotations not colon (:), different character (ː)

###################################

select Sound f01_frame_rep1
plus TextGrid f01_frame_rep1
Scale times
sound = selected("Sound")
textgrid = selected("TextGrid")

# HEADER LINE
printline filename'tab$'word'tab$'vowel'tab$'f1_5'tab$'f2_5'tab$'f1_15'tab$'f2_15'tab$'f1_25'tab$'f2_25'tab$'f1_35'tab$'f2_32'tab$'f1_45'tab$'f2_45'tab$'f1_55'tab$'f2_55'tab$'f1_65'tab$'f2_65'tab$'f1_75'tab$'f2_75'tab$'f1_85'tab$'f2_85'tab$'f1_95'tab$'f2_95

#SELECT SOUND AND FIND THE FORMANTS
select 'sound'
formant = To Formant (burg)... 0.01 5 5500 0.025 50

#COUNT NUMBER OF INTERVALS IN THE WORD AND PHONE TIER OF THE TEXTGRID
select 'textgrid'
word_intervals = Get number of intervals: word_tier
#phone_intervals = Get number of intervals: seg_tier

# GO THROUGH WORD INTERVALS ONE BY ONE
for wi from 1 to word_intervals
    word$ = Get label of interval: word_tier, wi
    #FIND TARGET WORDS
    if (index_regex(word$,filler_word$)=0) and word$ != ""
        wstart = Get start time of interval: word_tier, wi
        wend = Get end time of interval: word_tier, wi
        # EXTRACT WORD
        phoneobject = Extract part: wstart, wend, "yes"
        # FOR EACH WORD, EXTRACT CORRESPONDING PHONES
        selectObject: phoneobject
        phone_intervals = Get number of intervals: seg_tier
    
        #GO THROUGH THE PHONE INTERVALS ONE BY ONE
        for i to phone_intervals
            selectObject: phoneobject
            phone$ = Get label of interval... seg_tier i

            #SEE IF THE INTERVAL LABEL IS A VOWEL 
            if index_regex(phone$,vowel$)

                #GET TIMES DURING THE PHONE
                start = Get starting point... seg_tier i
                end = Get end point... seg_tier i
                t1 = start + (end-start) * 0.05
                t2 = start + (end-start) * 0.15
                t3 = start + (end-start) * 0.25
                t4 = start + (end-start) * 0.35
                t5 = start + (end-start) * 0.45
                t6 = start + (end-start) * 0.55
                t7 = start + (end-start) * 0.65
                t8 = start + (end-start) * 0.75
                t9 = start + (end-start) * 0.85
                t10 = start + (end-start) * 0.95

            
                #MEASURE F1 AND F2 AT TEN TIMES
                select 'formant'
                f1_t1 = Get value at time... 1 't1' Hertz Linear
                f1_t2 = Get value at time... 1 't2' Hertz Linear
                f1_t3 = Get value at time... 1 't3' Hertz Linear
                f1_t4 = Get value at time... 1 't4' Hertz Linear
                f1_t5 = Get value at time... 1 't5' Hertz Linear
                f1_t6 = Get value at time... 1 't6' Hertz Linear
                f1_t7 = Get value at time... 1 't7' Hertz Linear
                f1_t8 = Get value at time... 1 't8' Hertz Linear
                f1_t9 = Get value at time... 1 't9' Hertz Linear
                f1_t10 = Get value at time... 1 't10' Hertz Linear

                f2_t1 = Get value at time... 2 't1' Hertz Linear
                f2_t2 = Get value at time... 2 't2' Hertz Linear
                f2_t3 = Get value at time... 2 't3' Hertz Linear
                f2_t4 = Get value at time... 2 't4' Hertz Linear
                f2_t5 = Get value at time... 2 't5' Hertz Linear
                f2_t6 = Get value at time... 2 't6' Hertz Linear
                f2_t7 = Get value at time... 2 't7' Hertz Linear
                f2_t8 = Get value at time... 2 't8' Hertz Linear
                f2_t9 = Get value at time... 2 't9' Hertz Linear
                f2_t10 = Get value at time... 2 't10' Hertz Linear
                
                #RECORD THE FORMANT MEASUREMENTS (:2 --> upto 2 decimal places)
                printline 'fileName$''tab$''word$''tab$''phone$''tab$''f1_t1:2''tab$''f2_t1:2''tab$''f1_t2:2''tab$''f2_t2:2''tab$''f1_t3:2''tab$''f2_t3:2''tab$''f1_t4:2''tab$''f2_t4:2''tab$''f1_t5:2''tab$''f2_t5:2''tab$''f1_t6:2''tab$''f2_t6:2''tab$''f1_t7:2''tab$''f2_t7:2''tab$''f1_t8:2''tab$''f2_t8:2''tab$''f1_t9:2''tab$''f2_t9:2''tab$''f1_t10:2''tab$''f2_t10:2'
        
            endif
        endfor
        removeObject: phoneobject
        select 'textgrid'

    endif
endfor

printline 'done' 