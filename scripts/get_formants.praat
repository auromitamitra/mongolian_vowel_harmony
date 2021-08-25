############################################################
###    get_formants.praat
###
###
###    MEASURES FORMANT VALUES FOR SEGMENTS IN A TEXTGRID
############################################################

#PROMT THE USER FOR INPUT
########## CONTROL VARIABLES ##########
seg_tier = 1
word_tier = 2
context_tier = 3
directory$ = "./"
data_path$ = "./"
data_file$ = "formants.txt"
maximum_formant = 5500
number_of_formants = 5
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
#COUNT THE NUMBER OF INTERVALS IN THE PHONES TIER OF THE TEXTGRID
        select 'textgrid'
        intervals = Get number of intervals... seg_tier


#GO THROUGH THE PHONE INTERVALS ONE BY ONE
for i to intervals
    select 'textgrid'
    phone$ = Get label of interval... seg_tier i

    #SEE IF THE INTERVAL LABEL IS A PHONE : edit this
    if phone$ != ""

        #GET TIMES DURING THE PHONE
        start = Get starting point... seg_tier i
        end = Get end point... seg_tier i
        t1 = start + (end-start) * 0.05
        halfway = start + (end-start) / 2
        t3 = start + (end-start) * 0.95
			vdur = (end - start) * 1000
			

        #IDENTIFY THE WORD
        j = Get interval at time... word_tier halfway
        word$ = Get label of interval... word_tier j

        word_start = Get starting point... word_tier j
        word_end = Get end point... word_tier j
			
			#IDENTIFY THE CONTEXT
			k = Get interval at time... context_tier halfway
			context$ = Get label of interval... context_tier k


          
        #MEASURE F1 AND F2 AT THREE TIMES
        select 'formant'
        f1_t1 = Get value at time... 1 't1' Hertz Linear
        f2_t1 = Get value at time... 2 't1' Hertz Linear
        f1_mid = Get value at time... 1 'halfway' Hertz Linear
        f2_mid = Get value at time... 2 'halfway' Hertz Linear
        #f1_t3 = Get value at time... 1 't3' Hertz Linear
        #f2_t3 = Get value at time... 2 't3' Hertz Linear

        #RECORD THE FORMANT MEASUREMENTS
        printline 'fileName$''tab$''word$''tab$''context$''tab$''phone$''tab$''f1_t1:2''tab$''f2_t1:2''tab$''f1_mid:2''tab$''f2_mid:2''tab$''vdur:2'
    

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

