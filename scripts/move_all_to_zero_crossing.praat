# Auromita
# August 23 2021
# for all textgrids in a directory, move the boundaries in the specified tiers to the nearesr zero-crossing
# subroutine from http://www.u.arizona.edu/~dbrenner/Scripts/toZeroCrossingsSubroutine.praat


####################################################################################

# this Praat procedure replaces a tier in a text-grid with another tier whose boundaries are at
# closest zero-crossing equivalents to the input tier's boundaries.

procedure to0x .t
	select tg
	.tiername$ = Get tier name... .t
	.newt = .t+1
	.isIntervalTier = Is interval tier... .t
	if .isIntervalTier
		Insert interval tier... .newt '.tiername$'_0x
		.numints = Get number of intervals... .t
		for .i to .numints-1
			.intend = Get end point... .t .i
			.lab$ = Get label of interval... .t .i
			select wav
			.zxend = Get nearest zero crossing... 1 .intend
			select tg
			Insert boundary... .newt .zxend
			Set interval text... .newt .i '.lab$'
		endfor
		.lab$ = Get label of interval... .t .numints
		Set interval text... .newt .numints '.lab$'
	else
		Insert point tier... .newt '.tiername$'_0x
		.numpoints = Get number of points... .t
		for .p to .numpoints
			.ptime = Get time of point... .t .p
			.plab$ = Get label of point... .t .p
			select wav
			.ptime0x = Get nearest zero crossing 1 .ptime
			select tg
			Insert point... .newt .ptime0x
			Set point text... .newt .p
		endfor
	endif
	Remove tier... .t
endproc
###############################################################################################

@to0x: TextGrid f01_frame_rep1

writeInfoLine: "Done"

