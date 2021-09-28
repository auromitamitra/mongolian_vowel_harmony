library(readxl)
library(dplyr)
library(lme4)
library(phonR)

# read in data
df <- read_excel("formants_combined.xlsx") %>%
  mutate_if(is.character,as.factor)
str(df)

attach(df)

# separate objects for F1 and F2 values 
F1 <- cbind(f1_v1_t1,	f1_v1_t2,	f1_v1_t3,	f1_v1_t4,	f1_v1_t5,	f1_v1_t6,	f1_v1_t7,	f1_v1_t8,	f1_v1_t9,	f1_v1_t10, f1_v2_t1,	f1_v2_t2,	f1_v2_t3,	f1_v2_t4,	f1_v2_t5,	f1_v2_t6,	f1_v2_t7,	f1_v2_t8,	f1_v2_t9,	f1_v2_t10)
F2 <- cbind(f2_v1_t1,	f2_v1_t2,	f2_v1_t3,	f2_v1_t4,	f2_v1_t5,	f2_v1_t6,	f2_v1_t7,	f2_v1_t8,	f2_v1_t9,	f2_v1_t10, f2_v2_t1,	f2_v2_t2,	f2_v2_t3,	f2_v2_t4,	f2_v2_t5,	f2_v2_t6,	f2_v2_t7,	f2_v2_t8,	f2_v2_t9,	f2_v2_t10)

# new data frame with normalized formant values
lobanov <- with(df, normLobanov(cbind(F1, F2)), group=speaker)
df_lobanov <- data.frame(speaker, iteration,word, harmony_type, v1, v2,lobanov)
rm(F1, F2, lobanov)
detach(df)

# subsets for harmonic and non-harmonic sequences
df_nhar <- filter(df_lobanov, harmony_type == "non-harmonic")
df_har <- filter(df_lobanov, harmony_type != "non-harmonic")

df_ATR <- filter(df_lobanov, harmony_type == "ATR")
df_rounding <- filter(df_lobanov, harmony_type == "rounding")


## plots

xlim=c(2.5,-2.5)
ylim=c(4,-2)

# non-harmonic
with(df_nhar, plotVowels(f1_v1_t5, f2_v1_t5, 
                         xlim=xlim, ylim=ylim,
                         vowel = v1, #group = speaker, 
                         plot.tokens = FALSE, plot.means = TRUE, 
                         var.col.by = v1, var.sty.by = v1, pch.means = v1, 
                         ellipse.fill = F, 
                         pretty = T))

with(df_nhar, plotVowels(f1_v2_t5, f2_v2_t5, 
                         xlim=xlim, ylim=ylim,
                         vowel = v2, #group = speaker, 
                         plot.tokens = FALSE, plot.means = TRUE, 
                         var.col.by = v2, var.sty.by = v2, pch.means = v2, 
                         ellipse.fill = F, 
                         pretty = T))

# harmonic
with(df_har, plotVowels(f1_v1_t5, f2_v1_t5, 
                        xlim=xlim, ylim=ylim,
                        vowel = v1, #group = speaker,
                        plot.tokens = FALSE, plot.means = TRUE, 
                        var.col.by = v1, var.sty.by = v1, pch.means = v1, 
                        ellipse.fill = F, 
                        poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),
                        pretty = T))

with(df_har, plotVowels(f1_v2_t5, f2_v2_t5, 
                        xlim=xlim, ylim=ylim,
                        vowel = v2, #group = speaker,
                        plot.tokens = F, plot.means = T, 
                        var.col.by = v2, var.sty.by = v2, pch.means = v2, 
                        ellipse.fill = F, 
                        poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),
                        pretty = T))

# all
with(df_lobanov, plotVowels(f1_v1_t5, f2_v1_t5, 
                        xlim=xlim, ylim=ylim,
                        vowel = v1, #group = harmony_type,
                        plot.tokens = F, plot.means = T, 
                        var.col.by = v1, var.sty.by = v1, pch.means = v1, 
                        ellipse.fill = T, ellipse.line = F,
                        poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),
                        pretty = T))

with(df_lobanov, plotVowels(f1_v2_t5, f2_v2_t5, 
                        xlim=xlim, ylim=ylim,
                        vowel = v2, #group = harmony_type,
                        plot.tokens = F, plot.means = T, 
                        var.col.by = v2, var.sty.by = v2, pch.means = v2, 
                        ellipse.fill = T, ellipse.line = F,
                        poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),
                        pretty = T))

## models for F1
attach(df_lobanov)

#effect of v2 on v1
v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                       data = df_lobanov, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                       data = df_lobanov, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_lobanov)

# subset: non-harmonic
attach(df_nhar)

#effect of v2 on v1

v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                   data = df_nhar, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_nhar, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                   data = df_nhar, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_nhar, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_nhar)


## subset: harmonic
attach(df_har)

#effect of v2 on v1

v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                   data = df_har, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_har, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_har, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                       data = df_har, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_har)


## subset: ATR
attach(df_ATR)

#effect of v2 on v1

v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                   data = df_ATR, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_ATR, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_ATR, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                       data = df_ATR, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_ATR)


## subset: rounding
attach(df_rounding)

#effect of v2 on v1

v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_rounding, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                       data = df_rounding, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_rounding, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                       data = df_rounding, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)

detach(df_rounding)

#########################

## models for F2
attach(df_lobanov)

#effect of v2 on v1
v1_vh.model = lmer(f2_v1_t5 ~ 
                     v1+ f2_v2_t5 + 
                     (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                   data = df_lobanov, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f2_v1_t5 ~ 
                       v1 + 
                       (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f2_v2_t5 ~ 
                     v2 + f2_v1_t5 + 
                     (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                   data = df_lobanov, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f2_v2_t5 ~
                       v2 +
                       (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)

detach(df_lobanov)

# subset: non-harmonic
attach(df_nhar)

#effect of v2 on v1

v1_vh.model = lmer(f2_v1_t5 ~ 
                     v1+ f2_v2_t5 + 
                     (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                   data = df_nhar, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f2_v1_t5 ~ 
                       v1 + 
                       (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                     data = df_nhar, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f2_v2_t5 ~ 
                     v2 + f2_v1_t5 + 
                     (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                   data = df_nhar, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f2_v2_t5 ~
                       v2 +
                       (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                     data = df_nhar, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)

detach(df_nhar)


## subset: harmonic
attach(df_har)

#effect of v2 on v1

v1_vh.model = lmer(f2_v1_t5 ~ 
                     v1+ f2_v2_t5 + 
                     (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                   data = df_har, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f2_v1_t5 ~ 
                       v1 + 
                       (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                     data = df_har, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f2_v2_t5 ~ 
                     v2 + f2_v1_t5 + 
                     (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                   data = df_har, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f2_v2_t5 ~
                       v2 +
                       (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                     data = df_har, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)

detach(df_har)


## subset: ATR
attach(df_ATR)

#effect of v2 on v1

v1_vh.model = lmer(f2_v1_t5 ~ 
                     v1+ f2_v2_t5 + 
                     (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                   data = df_ATR, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f2_v1_t5 ~ 
                       v1 + 
                       (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                     data = df_ATR, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f2_v2_t5 ~ 
                     v2 + f2_v1_t5 + 
                     (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                   data = df_ATR, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f2_v2_t5 ~
                       v2 +
                       (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                     data = df_ATR, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)

detach(df_ATR)


## subset: rounding
attach(df_rounding)

#effect of v2 on v1

v1_vh.model = lmer(f2_v1_t5 ~ 
                     v1+ f2_v2_t5 + 
                     (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                   data = df_rounding, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f2_v1_t5 ~ 
                       v1 + 
                       (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                     data = df_rounding, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f2_v2_t5 ~ 
                     v2 + f2_v1_t5 + 
                     (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                   data = df_rounding, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f2_v2_t5 ~
                       v2 +
                       (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                     data = df_rounding, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)

detach(df_rounding)


##### Interaction model #####

## F1
attach(df_lobanov)

#effect of v2 on v1
v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1 + harmony_type*f1_v2_t5 +
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                   data = df_lobanov, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + f1_v2_t5 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + harmony_type*f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                   data = df_lobanov, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f1_v2_t5 ~
                       v2 + f1_v1_t5 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_lobanov)


## F2
attach(df_lobanov)

#effect of v2 on v1
v1_vh.model = lmer(f2_v1_t5 ~ 
                     v1+ harmony_type*f2_v2_t5 + 
                     (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                   data = df_lobanov, REML = FALSE)
summary(v1_vh.model)

v1_null.model = lmer(f2_v1_t5 ~ 
                       v1 + f2_v2_t5 +
                       (1+f2_v2_t5|speaker) + (1+f2_v2_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f2_v2_t5 ~ 
                     v2 + harmony_type*f2_v1_t5 + 
                     (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                   data = df_lobanov, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f2_v2_t5 ~
                       v2 + f2_v1_t5 + 
                       (1+f2_v1_t5|speaker) + (1+f2_v1_t5|word), 
                     data = df_lobanov, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)

detach(df_lobanov)

