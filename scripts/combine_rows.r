# Auromita
# August 30, 2021
# formats output from formants.praat: for each word, put V1 and V2 data in one row

library(readxl)
library(tidyverse)

# read in spreadsheet
df <- read_excel("formants.xlsx")
str(df)     

# change character variables to factors
df <- df %>% mutate_if(is.character,as.factor)
str(df)

# separate odd and even numbered rows (extract every nth row starting from 1: df %>% filter(row_number() %% n == 1))
df_odd <- df %>% filter(row_number() %% 2 == 1) ## extract odd rows
df_even <- df %>% filter(row_number() %% 2 == 0) ## extract even rows

# change column names
df_odd <- df_odd %>% 
  rename(v1 = vowel) %>%
  rename_with(~ gsub("_", "_v1_", .x))

df_even <- df_even %>% 
  rename(v2 = vowel) %>%
  rename_with(~ gsub("_", "_v2_", .x))

# combine data frames
new_df <- df_odd %>%
  inner_join(df_even, by = c("filename","word")) %>%
  relocate(v2, .after = v1) %>%
  # add columns for speaker and iteration from parts of the filename (<speaker>_frame/passage_<rep>)
  mutate(temp = filename, .after = filename) %>%
  separate(temp, into = c("speaker","extra","iteration"), sep = "_") %>%
  mutate(extra = NULL) %>%
  mutate(iteration = str_replace(iteration, "rep", ""))

# write into csv file
write.csv(new_df,file = "formants_temp.csv")

## Note: this messes up the IPA characters in excel. 
## Open new excel sheet "formants_new.csv" --> data --> import --> from text --> (select file + encoding) --> save



