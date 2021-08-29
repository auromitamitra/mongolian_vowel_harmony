# Move left boundary of labeled intervals later (to the right) by specified duration
# Puts final left and right boundaries at zero crossings
#
# Useful in undoing the script that moves left boundaries earlier (to the left)
#
# Ignores empty intervals and intervals containing only a space
# or new line character (line break)
# Sound and textgrid must be selected in the objects window
#
# Author: Danielle Daidone 5/9/17
#
# Modified from original script that moved
# all boundaries from a TextGrid to their nearest
# zero-crossings, keeping labels and number of intervals
# by Jose J. Atria 5/21/12
#####################################################################################

form Move left boundary later and zero cross final boundaries
	comment Specify tier to be processed:
	integer tier 1
	comment Specify directory where new textgrid will be saved:
	sentence saveDir ../temp_output
	comment Specify number of milliseconds to move left boundary by:
	positive moveDur 0.001
endform

moveDur = moveDur/1000

writeInfoLine: "Boundaries moved for the following labeled intervals:'newline$'"

soundname$ = selected$ ("Sound", 1)
textgrid$ = selected$ ("TextGrid", 1)

select TextGrid 'textgrid$'

      #check if specified tier is interval tier
      interval = Is interval tier... tier
      
      # Process intervals
      if interval 
         ni = Get number of intervals... tier
         for i to ni
          	label$[i] = Get label of interval... tier i
         endfor

             for i to ni
             select TextGrid 'textgrid$'
		  
		  #if interval is labeled
		  if label$[i] = ""
		  elsif label$[i] = " "
		  elsif label$[i] = newline$
		  else
		  appendInfoLine: label$[i]
            
			#move right boundary to closest zero crossing
			boundary = Get end point... tier i
			select Sound 'soundname$'
			zero = Get nearest zero crossing... 1 boundary
			  if boundary != zero
				select TextGrid 'textgrid$'
				Remove right boundary... tier i
				Insert boundary... tier zero
			  endif
		    
			#move left boundary earlier by specified duration
			select TextGrid 'textgrid$'
			leftbound = Get start point... tier i
			appendInfoLine: "original boundaries:'leftbound', 'boundary'"
			Insert boundary... tier leftbound + moveDur
			Remove left boundary... tier i
						
			#move left boundary to closest zero crossing
			boundary2 = Get start point... tier i
			select Sound 'soundname$'
			zero2 = Get nearest zero crossing... 1 boundary2
			  if boundary2 != zero2
				select TextGrid 'textgrid$'
				Remove left boundary... tier i
				Insert boundary... tier zero2
			  endif
			select TextGrid 'textgrid$'
			a = Get start point... tier i
			b = Get end point... tier i
			appendInfoLine: "new boundaries: 'a', 'b''newline$'"
			
		  endif
               endfor

        select TextGrid 'textgrid$'
        for i to ni
          name$ = label$[i]
          Set interval text... tier i 'name$'
        endfor

	select TextGrid 'textgrid$'
	Write to text file... 'saveDir$''textgrid$'.TextGrid

	