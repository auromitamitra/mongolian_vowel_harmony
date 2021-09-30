library(readxl)
library(dplyr)
library(lme4)
library(phonR)

df <- read_excel("formants_combined.xlsx") %>%
  mutate_if(is.character,as.factor)
str(df)