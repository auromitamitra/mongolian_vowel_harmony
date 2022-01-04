library(readxl)
library(dplyr)
library(lme4)
library(phonR)
library(effectsize)
library(lmerTest)

# read in data
df <- read_excel("formant_data/formants_combined.xlsx") %>%
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

#---------------------------------------------------------------------

## For linear mixed models models, the data was mean-centered and scaled prior to analysis, as this increases the likelihood of convergence (Bates et al. 2015a, Eager&Roy 2017)
df_lobanov.CS <- df_lobanov %>% mutate_if(is.numeric,scale)
df_har.CS <- df_har %>% mutate_if(is.numeric,scale)
df_nhar.CS <- df_nhar %>% mutate_if(is.numeric,scale)


## models for F1
attach(df_lobanov.CS)

#effect of v2 on v1
v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_lobanov.CS, REML = FALSE)
summary(v1_vh.model)


# estimating effect size (eta squared) for the main variable (F1 of v2) from F-value or t-value (package used: "effectsize")
v1_anova <- anova(v1_vh.model)
v1_F <- v1_anova$`F value`[[2]] %>% signif(digits=3)
v1_df <- v1_anova$`NumDF`[[2]] %>% signif(digits=3)
v1_dendf <- v1_anova$`DenDF`[[2]] %>% signif(digits=3)

F_to_eta2(4.5456,1,55.332) # F_to_eta2(Fvalue, NumDF, DenDF)

v1_effect <- F_to_eta2(v1_F,v1_df,v1_dendf)$Eta2_partial %>% signif(digits=3) # partial eta squared value for explanatory variable 

# parameters::model_parameters(v1_vh.model, effects = "fixed", df_method = "satterthwaite")
# t_to_eta2(2.13, df_error = 55.33)

#----

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                       data = df_lobanov.CS, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)


#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_lobanov.CS, REML = FALSE)
summary(v2_vh.model)

# estimating effect size (eta squared) for the main variable (F1 of v1) from F-value or t-value (package used: "effectsize")
anova(v2_vh.model)
F_to_eta2(19.387,1,41.412) # F_to_eta2(Fvalue, NumDF, DenDF)

# parameters::model_parameters(v2_vh.model, effects = "fixed", df_method = "satterthwaite")
# t_to_eta2(4.40, df_error = 41.41)



v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                       data = df_lobanov.CS, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_lobanov.CS)

## subset: non-harmonic
attach(df_nhar.CS)

#effect of v2 on v1

v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1|speaker) + (1|word), 
                   data = df_nhar.CS, REML = FALSE)
summary(v1_vh.model)

#warning: singularity
isSingular(v1_vh.model, tol = 1e-4)
# removed random slopes

# estimating effect size (eta squared) for the main variable (F1 of v2) from F-value or t-value (package used: "effectsize")
anova(v1_vh.model)
F_to_eta2(0.0012,1,441.98) # F_to_eta2(Fvalue, NumDF, DenDF)

#----

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_nhar.CS, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1|speaker) + (1|word), 
                   data = df_nhar.CS, REML = FALSE)
summary(v2_vh.model)
#warning: singularity
isSingular(v2_vh.model)
# removed random slopes

# # convergence error (Model failed to converge with 1 negative eigenvalue: -8.6e+02). Decreasing stoppin tolerances (from lme4 documentation):
# 
# fm1 = lmer(f1_v2_t5 ~ 
#              v2 + f1_v1_t5 + 
#              (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
#            data = df_nhar, REML = FALSE)
# 
# ## 1. decrease stopping tolerances
# strict_tol <- lmerControl(optCtrl=list(xtol_abs=1e-8, ftol_abs=1e-8))
# if (all(fm1@optinfo$optimizer=="nloptwrap")) {
#   fm1.tol <- update(fm1, control=strict_tol)
# }
# 
# ## 2. center and scale predictors:
# df_nhar.CS <- df_nhar %>% mutate_if(is.numeric,scale)
# fm1.CS <- update(fm1, data=df_nhar.CS)
# 
# 

# estimating effect size (eta squared) for the main variable (F1 of v1) from F-value or t-value (package used: "effectsize")
anova(v2_vh.model)
F_to_eta2(0.0273,1,30.9959) # F_to_eta2(Fvalue, NumDF, DenDF)


#----

v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_nhar.CS, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_nhar.CS)


## subset: harmonic
attach(df_har.CS)

#effect of v2 on v1

v1_vh.model = lmer(f1_v1_t5 ~ 
                     v1+ f1_v2_t5 + 
                     (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                   data = df_har.CS, REML = FALSE)
summary(v1_vh.model)

# estimating effect size (eta squared) for the main variable (F1 of v1) from F-value or t-value (package used: "effectsize")
anova(v2_vh.model)
F_to_eta2(0.0423,1,24.4534) # F_to_eta2(Fvalue, NumDF, DenDF)

#----

v1_null.model = lmer(f1_v1_t5 ~ 
                       v1 + 
                       (1+f1_v2_t5|speaker) + (1+f1_v2_t5|word), 
                     data = df_har.CS, REML = FALSE)
summary(v1_null.model)


anova(v1_vh.model, v1_null.model)

#effect of v1 on v2
v2_vh.model = lmer(f1_v2_t5 ~ 
                     v2 + f1_v1_t5 + 
                     (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                     data = df_har.CS, REML = FALSE)
summary(v2_vh.model)

v2_null.model = lmer(f1_v2_t5 ~
                       v2 +
                       (1+f1_v1_t5|speaker) + (1+f1_v1_t5|word), 
                       data = df_har.CS, REML = FALSE)
summary(v2_null.model)


anova(v2_vh.model, v2_null.model)


detach(df_har.CS)


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

