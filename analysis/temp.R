library(readxl)
library(dplyr)
library(lme4)
library(phonR)

df <- read_excel("formant_data/formants_combined.xlsx") %>%
  mutate_if(is.character,as.factor)
str(df)

filter <- df %>% filter(filename == "f05_frame_rep3")
