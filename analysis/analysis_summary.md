# Analysis

Simplest model: f1_v1_t5 ~ v1 + (1|speaker)+(1|word)

1. Random effects structure:
- adding by-subject and by-item random slopes for the explanatory variable (F1 of other vowel) improves model: (1+f1_v2_t5|speaker) +(1+f1_v2_t5|word)

2. 
- Null model: f1_v1_t5 ~ v1 + (1+f1_v2_t5|speaker) +(1+f1_v2_t5|word)
- Full model: adding f1 of the other vowel: f1_v1_t5 ~ v1 + f1_v2_t5 + (1+f1_v2_t5|speaker) +(1+f1_v2_t5|word)

3.  Model names:
- V1 model: v1 explained by v2
- V2 model: v2 explained by v1
- Compare each to corresponding null model, then compare p-values from both ANOVAs (which is a greater improvement from the corresponding null model)

4. Adding harmony_type: 
- as fixed effect (to explain f1): no significant improvement
- as interaction term (harmony_type*f1_v2_t5): convergence warning

## F1

## Results from full dataset

- both V1 and V2 model better than corresponding null models -- coarticulation robust in both directions
- V2 model better than V1 model -- v1 explains v2 better than v2 explains v1
- so direction of coarticulation: more left-to-right -- same direction as vowel harmony


## Results from subsetting data by harmony type

1. Non-harmonic: 
- neither V1 not V2 are significantly better than corresponding null models -- coarticulation: less robust
- But: V1 model better than V2 model (V2 explains V1 better) 
- So: whatever coarticulation is there is more in the right-to-left (anticipatory) direction -- opposite to direction of VH

2. Harmonic: same as overall pattern

1. ATR: same as overall

1. Rounding
- V1 model: not significant
- V2 model: significant
- So coarticulation: left-to-right, like other harmonic sequences

---

## F2

## Results from full dataset

- same as F1
- both V1 and V2 model better than corresponding null models -- coarticulation robust in both directions
- V2 model better than V1 model -- v1 explains v2 better than v2 explains v1
- so direction of coarticulation: more left-to-right -- same direction as vowel harmony

## Results from subsetting data by harmony type

1. Non-harmonic: 
- same as F1
- neither V1 not V2 are significantly better than corresponding null models -- coarticulation: less robust
- But: V1 model better than V2 model (V2 explains V1 better) 
- So: whatever coarticulation is there is more in the right-to-left (anticipatory) direction -- opposite to direction of VH

2. Harmonic: 
- same as overall pattern
- V1 model: only marginally significant (.)
- V2 significant
- so direction: left-to-right

3. ATR: 
- same as overall pattern
- V1 model: not significant
- V2 significant
- so direction: left-to-right

4. Rounding
- same as overall pattern
- V1 model: not significant
- V2 model: significant
- So coarticulation: left-to-right, like other harmonic sequences

---

## Interaction model

Full (interaction) model: f1_v1_t5 ~ v1 + harmony_type*f1_v2_t5 + (1+f1_v2_t5|speaker) +(1+f1_v2_t5|word)

Null model: f1_v1_t5 ~ v1 + f1_v2_t5 + (1+f1_v2_t5|speaker) +(1+f1_v2_t5|word)

### F1

1. V1 model (v2 explaining v1): convergence warning. interaction marginally better (.)
2. V2 model (v1 explaining v2): interation significantly better

### F2

1. V1 model: not significant
2. V2 model: not significant
