new_formant_data <- read_excel("formants_combined.xlsx")
new_formant_data <- new_formant_data %>% mutate_if(is.character,as.factor)

attach(new_formant_data)

library(phonR)
F1 <- cbind(f1_v1_t1,	f1_v1_t2,	f1_v1_t3,	f1_v1_t4,	f1_v1_t5,	f1_v1_t6,	f1_v1_t7,	f1_v1_t8,	f1_v1_t9,	f1_v1_t10, f1_v2_t1,	f1_v2_t2,	f1_v2_t3,	f1_v2_t4,	f1_v2_t5,	f1_v2_t6,	f1_v2_t7,	f1_v2_t8,	f1_v2_t9,	f1_v2_t10)
F2 <- cbind(f2_v1_t1,	f2_v1_t2,	f2_v1_t3,	f2_v1_t4,	f2_v1_t5,	f2_v1_t6,	f2_v1_t7,	f2_v1_t8,	f2_v1_t9,	f2_v1_t10, f2_v2_t1,	f2_v2_t2,	f2_v2_t3,	f2_v2_t4,	f2_v2_t5,	f2_v2_t6,	f2_v2_t7,	f2_v2_t8,	f2_v2_t9,	f2_v2_t10)

lobanov <- with(new_formant_data, normLobanov(cbind(F1, F2)), group=speaker)

newlobanov <- data.frame(v1, v2,harmony_type,lobanov)

#Distal to the consonant plots for V1T6, and V2T5
par(mfrow = c(1, 2))
xlim=c(2.5,-2.5)
ylim=c(4,-2)
with(newlobanov, plotVowels(f1_v1_t6, f2_v1_t6, v1, 
                                   group = harmony_type, 
                                   plot.tokens = FALSE, plot.means = TRUE, 
                                   pch.means = v1, cex.means = 2, xlim=xlim, ylim=ylim,
                                   var.col.by = v1, ellipse.fill = TRUE, poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"), pretty = TRUE))

with(newlobanov, plotVowels(F1_V2_T5, F2_V2_T5, V2, 
                            #group = harmony_type, 
                            plot.tokens = FALSE, plot.means = TRUE, 
                            pch.means = V2, cex.means = 2, xlim=xlim, ylim=ylim,
                            var.col.by = V2, ellipse.fill = TRUE, poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"), pretty = TRUE))

#Proximal to the consonant plots for V1T10, and V2T10
with(newlobanov, plotVowels(F1_V1_T10, F2_V1_T10, V1, 
                            #group = harmony_type, 
                            plot.tokens = FALSE, plot.means = TRUE, 
                            pch.means = V1, cex.means = 2, xlim=xlim, ylim=ylim,
                            var.col.by = V1, ellipse.fill = TRUE, poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"), pretty = TRUE))

with(newlobanov, plotVowels(F1_V2_T1, F2_V2_T1, V2, 
                            #group = harmony_type, 
                            plot.tokens = FALSE, plot.means = TRUE, 
                            pch.means = V2, cex.means = 2, xlim=xlim, ylim=ylim,
                            var.col.by = V2, ellipse.fill = TRUE, poly.line = TRUE, poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"), pretty = TRUE))


#poly.area of distal V1 and V2
poly.area.V1T6 <- with(newlobanov, vowelMeansPolygonArea(F1_V1_T6, F2_V1_T6, V1, 
  poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),group = subject) )
poly.area.V2T5 <- with(newlobanov, vowelMeansPolygonArea(F1_V2_T5, F2_V2_T5, V2, 
  poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),group = subject) )
rbind(poly.area.V1T6, poly.area.V2T5)

#poly.area of  V1 and V2
poly.area.V1T10 <- with(newlobanov, vowelMeansPolygonArea(F1_V1_T10, F2_V1_T10, V1, 
  poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),group = subject) )
poly.area.V2T1 <- with(newlobanov, vowelMeansPolygonArea(F1_V2_T1, F2_V2_T1, V2, 
  poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"),group = subject) )
rbind(poly.area.V1T10, poly.area.V2T1)


#LMER
attach(newlobanov)
sublobanov <- data.frame(item,subject,newlobanov)
#V1 from V2
mongCoartPropen.model = lmer( F1_V1_T6 ~ F1_V2_T5 + harmony_type + (1+F1_V2_T5|subject) + (1+F1_V2_T5|item), data=sublobanov,REML=FALSE)
null.model = lmer(F1_V1_T6 ~  harmony_type + (1+F1_V2_T5|subject) + (1+F1_V2_T5|item), data=sublobanov,REML=FALSE)
summary(mongCoartPropen.model)
anova(mongCoartPropen.model,null.model)

mongCoartPropen.model = lmer( F1_V2_T5 ~ F1_V1_T6 + harmony_type + (1|subject) + (1|item), data=sublobanov,REML=FALSE)

nonharm <- sublobanov[ which(sublobanov$harmony_type=='Non-harmonic'),]

V1predF1.model = lmer(F1_V1_T6 ~ F1_V2_T1 + V2 + (1+F1_V2_T1|subject) + (1+F1_V2_T1|item), data=nonharm,REML=FALSE)
V1predF1.nullmodel = lmer(F1_V1_T6 ~  V2 + (1+F1_V2_T1|subject) + (1+F1_V2_T1|item), data=nonharm,REML=FALSE)
V2predF1.model = lmer(F1_V2_T5 ~  V1 + (1+F1_V1_T10|subject) + (1+F1_V1_T10|item), data=nonharm,REML=FALSE)
V2predF1.nullmodel = lmer(F1_V2_T5 ~ (1+F1_V1_T10|subject) + (1+F1_V1_T10|item), data=nonharm,REML=FALSE)


anova(V2predF1.model,V2predF1.nullmodel)

V1predF2.model = lmer(F2_V1_T6 ~ F2_V2_T5 + (1|subject) + (1|item), data=nonharm,REML=FALSE)
V2predF2.model = lmer(F2_V2_T5 ~ F2_V1_T6 + (1|subject) + (1|item), data=nonharm,REML=FALSE) 
#Carry over effect is greater when the V1 is u and opaque in non-H

summary(V1predF1.model)
summary(V2predF1.model)

summary(V1predF2.model)
summary(V2predF2.model)
# rbind(poly.area.V1T6, poly.area.V2T5)
# 
# poly.area <- with(newlobanov, vowelMeansPolygonArea(F1_V2_T5, F2_V2_T5, V2, 
#                             poly.order = c("i", "e", "a", "ɔ", "o", "ʊ", "u"), group = harmony_type))
# hull.area <- with(newlobanov, convexHullArea(F1_V2_T5, F2_V2_T5, group = subject))
# rbind(poly.area, hull.area)
