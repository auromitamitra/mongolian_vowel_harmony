
############################################################
###    get_formants.praat
###
###
###    MEASURES FORMANT VALUES FOR SEGMENTS IN A TEXTGRID
############################################################

#PROMPT THE USER FOR INPUT
########## CONTROL VARIABLES ##########
seg_tier = 2
word_tier = 1
directory$ = "./"
data_path$ = "./"
data_file$ = "formants.txt"
maximum_formant = 5500
number_of_formants = 5
filler_word$ = "xɔjor|aʧ͡iɮ|atiɮ|minij|pʰaɮ|ʧ͡ʰat|ʦ͡am|xaɮ|ɮam|waːr"
vowel$ = "a|a:|e|e:|i|i:|o|o:|u|u:|ʊ|ʊ:|ɔ|ɔ:|œ|œ:"
###################################

Create Strings as file list... list 'directory$'/*.wav
numberOfFiles = Get number of strings

clearinfo

printline FileName'tab$'Word'tab$'Context'tab$'Vowel'tab$'F1_5'tab$'F2_5'tab$'F1_mid'tab$'F2_mid'tab$'Vowel_Duration'tab$'

for ifile to numberOfFiles
    select Strings list
    fileName$ = Get string... ifile
    Read from file... 'directory$'/'fileName$'
    fileName$ = selected$("Sound")
    Read from file... 'directory$'/'fileName$'.TextGrid
    select Sound 'fileName$'
    plus TextGrid 'fileName$'
    Scale times
    sound = selected("Sound")
    textgrid = selected("TextGrid")

    #SELECT THE SOUND AND FIND THE FORMANTS
    select 'sound'
    formant = To Formant (burg)... 0.01 5 5500 0.025 50

    #COUNT NUMBER OF INTERVALS IN THE WORD and PHONE TIER OF THE TEXTGRID
    select 'textgrid'
    word_intervals = Get number of intervals: word_tier
    #phone_intervals = Get number of intervals: seg_tier

# GO THROUGH WORD INTERVALS ONE BY ONE
for wi from 1 to word_intervals
    word$ = Get label of interval: word_tier, wi
    #FIND TARGET WORDS
    if word$ != filler_word$
        wstart = Get start time of interval: word_tier, wi
        wend = Get end time of interval: word_tier, wi
        # EXTRACT WORD
        phoneobject = Extract part: wstart, wend, "no"
        # FOR EACH WORD, EXTRACT CORRESPONDING PHONES
        selectObject: phoneobject
        phone_intervals = Get number of intervals: phone_tier
    
        #GO THROUGH THE PHONE INTERVALS ONE BY ONE
        for i to phone_intervals
            select 'textgrid'
            phone$ = Get label of interval... seg_tier i

            #SEE IF THE INTERVAL LABEL IS A VOWEL 
            if phone$ = vowels$

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
            
            #RECORD THE FORMANT MEASUREMENTS
            printline 'fileName$''tab$''word$''tab$''context$''tab$''phone$''tab$''f1_t1:2''tab$''f2_t1:2''tab$''f1_mid:2''tab$''f2_mid:2''tab$''vdur:2'
            removeObject: phoneobject
            selectObject: "TextGrid F1_r1"
        endfor

    endif
endfor
    
select 'formant'
Remove
fappendinfo 'data_path$'/'data_file$'
        clearinfo

    
    select 'sound'
    plus 'textgrid'
    Remove
endfor

