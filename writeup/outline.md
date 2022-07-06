### Preface
- Our presentation on **Asymmetries in V-to-V coarticulation among harmonic and non-harmonic sequences in Khalkha Mongolian**has 5 sections

### Move to Outline slide
- First we will discuss the relationship between coarticulation and vowel harmony
- Next, we will describe the vowel system of Khalkha Mongolian, which shows left-to-right ATR harmony
- The following sections will outline our research questions, materials and methods we followed, and conclude with our analyses where we propose a relationship between coarticulatory resistance and preservation of contrast.

### Slide 2
- when we speak, our articulatory geatures overlap, which results in acoustic variation 
- in VCV sequences like we see here, some features of each vowel affect the production of the other vowel, and this happens in both directions
- On the perception end, listeners compensate for this kind of variation so that these categories don't lose salience
- but if listeners fail to perceptually compensate for this variation
### Slide 3
- it gets phonologized, and leads to the development of vowel harmony-- like we see here (the feature is now perceived as being a part of V2)
- so VH is long-distance feature sharing between vowels, and is a grammatical feature of the language
- Greater left-to-right VCV coarticulation should lead to left to right vowel harmony
- We can therefore expect that the directionality of the vowel harmony patterns in a language would be the same as the direction of coarticulatory propensity that was there before vowel harmony developed

- given this relationship between these two processes, we are interested in what happens synchronically within a system that has already been through this grammaticalization. We will look at such a system, and then discuss what kinds of questions it poses about how automatic speech processes interact with what we understand as anstract grammar

### Slide 4
- this is the vowel system: there are seven monophthongs, and they can be classified as having the feature ATR, or lacking it
- the reason for this classification is that Khalkha is an ATR vowel harmony system where vowels in non-compound words must share an ATR feature. So these groups represent harmony classes.

### Slide 5

- The directionality of harmony is left-to-right-- this means that features of the initial vowels determine those of subsequent vowels
- A subset of these vowels also show rounding harmony, but we are not looking at that here
- The high front vowel, /i/ is `transparent' -- when it occurs in a non-initial position, it does not participate in VH
- This results in what we define as non-harmonic VCV sequences
- we are expecially interested in what happens within these non-harmonic sequences 

### Slide 6      
    - Given what we know about how VH systems develop, we are interested in two questions:
        - first, how does coarticulation function in a system where VH has already developed?
        - second, what explains the development of the non-harmonic sequences we talked about?
    - this relates to the broader question of how grammatical knowledge interacts with physiological processes that govern speech. We think VH systems are an exciting place to look into this
    - in this study, want to quantify patterns of coarticulation in Khalkha Mongolian, and then see how these patterns compare in harmonic vs non-harmonic sequences 
    
### Slide 7  
  
    - Data consists of read speech, recorded from 14 female native speakers and covers all vowels in both initial and non-initial positions. 
    - disyllabic words - have a VCV structure. We want to look at coarticulation between V1 and V2 (point)
    - from what we saw before — non-initial i is transparent, so words where V2 is i are non-harmonic. These are the two groups we are comparing

### Slide 8
    - To force-align and annotate the data, we manually annotated a subset, including both passage and wordlist, and trained an acoustic model using Kaldi. Then used MFA to annotate the rest
    - [figure] this is the frame sentence, we measured the FFs of each vowel at the mid-point, 
    ?? - and then to quantify coarticulation, we asked how well the FF of this vowel could be predicted by the identity of the other vowel in the word in a statistical model
        
### slide 9
        - plotting the F1XF2 vowel spaces for the initial and non-initial vowels in both groups, we see that
        - for harmonic sequences, the V2 space is clearly more diffused than V1, suggesting greater variability due to coarticulation
        - comparing between the groups, V2 doesn't tell us much because vowels in the two groups have a complementary distribution. But when we compare V1 in the harmonic vs non-harmonic sets-- a and U in the initial position of nh words-- much more diffused than the corresponding vowels in harmonic words. Suggests that the coarticulatory patterns might differ
    
### slide 10    
        - to quantify coarticulation, we used mixed effects models to ask how well the formant frequency of a vowel is predicted by the identity of the other vowel in the word
        - want to see if there are differences in this tendency between harmonic and non-harmonic subsets
        - to compare the extent of coarticulation, we calculated the effect size (eta squared) for the explanatory variable in each model
        - fixed effects and model outputs are shown in the table
        - F1: robust coarticulation in both directions, carryover coarticulation is greater for both har and nh sequences

### slide 11
        - however in F2, which is an acoustic correlate for the ATR feature, see that harmonic sequences only show carryover coarticulation
        - in contrast, nh sequences show greater coarticulation in the anticipatory (right-to-left) direction. This is opposite to the direction of vh
        - recall that nh sequences only have one category in the V2 position-- i. These patterns suggest that the category has high coarticulatory resistance
        
### slide 12
        to summarize:
        - patterns of coarticulation differ— in F2, features of V2 are enhanced in nh sequences
        - high front vowel, which doesn't participate in vowel harmony, shows high coarticulatory resistance, giving some clue as to how these words might have developed as non-harmonic sequences diachronially  
        - it’s interesting to note that coarticulation, which we generally understand to be inimical to contrast, could be possibly enhancing/preserving phonological contrast in a system where the general tendency is towards feature sharing and thus the loss of contrast
        - suggests that automatic physiological processes in speech aren’t independent of “abstract” grammatical knowledge, and vice-versa
        
### Slide 13 Future stuffw
        - Explicit measurement of coarticulatory resistance using the Locus Equation framework
        - would be exciting to look at these patterns across a range of VH systems that differ in the directionality of harmony and see if we can come up with a typology of vowel harmony systems, that shed light on how these develop and change 