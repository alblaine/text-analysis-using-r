# Activity 9: Quantitative Political Text Classification using wordfish scaling
# Source: http://www.wordfish.org/

install.packages("quanteda.textmodels")
install.packages("quanteda.textplots")
library(quanteda)
library(tidyverse)
library(quanteda.textmodels)
library(quanteda.textplots)

####################### Skip this setup section in class ###############################

# Set sotu-addresses folder as your working directory first

docs <- readtext("*.txt", encoding = "utf8", docvarsfrom = "filenames")
docs <- docs %>%
  mutate(year= str_sub(.$docvar1, -5)) %>% # create year column
  mutate(name= str_sub(.$docvar1, 1, -6)) # create name column

docs$year <- docs$year %>%
  str_replace_all("[-ab]", "") # remove unwanted characters from the year column

docs$year <- as.integer(docs$year)

docs$name <- docs$name %>%
  str_replace_all("-", " ") %>%
  trimws()  #trim leading and trailing whitespace from terms in name field\

docs_corp <- corpus(docs)

########################################################################################


# Goal: Classify texts according to political party affiliation based on word frequency.

# Set sotu-addresses folder as your working directory first

# 1. Create a dfm of the corpus of Presidential speeches from 1992-2020. We created this corpus in Activity 6.
docs_corp

corpus_9220 <- corpus_subset(docs_corp, year >= 1992 & year <= 2020)

# Tokenize the corpus and create a dfm

toks_9220 <- tokens(corpus_9220, remove_numbers = TRUE, remove_punct = TRUE) %>%
  tokens_remove(pattern = stopwords("english"), padding=TRUE) %>%
  tokens_wordstem() %>%
  tokens_tolower()

dfm_9220 <- dfm(toks_9220)

View(as.data.frame(dfm_9220))

# 2. Apply the wordfish model to the dfm.
?quanteda.textmodels::textmodel_wordfish #get more info about the model

tmod_wf <- textmodel_wordfish(dfm_9220)
summary(tmod_wf)
textplot_scale1d(tmod_wf)

# 3. Assign party affiliation metadata for each speech in the corpus.
docvars(corpus_9220)$party <- ifelse(docvars(corpus_9220)$name %in% c("barack obama", "william j clinton"), "DEM", "REP")
docvars(corpus_9220)

# 4. Group results by party
textplot_scale1d(tmod_wf, groups = corpus_9220$party)

# 5. Practice. Create a corpus subset of speeches from 1966-1977. 
corpus_6677 <- 

# 6. Practice. Look at the document variables (metadata) for each speech
docvars(corpus_6677)

# 7. Practice. Create tokens and a dfm of the corpus.
toks_6677 <-
dfm_6677 <- 

# 8. Practice. Apply the wordfish model to the dfm.
tmod_6677 <- 
  
summary(tmod_6677)

# 9. Practice. Create a textplot.


# 10. Practice. Create a textplot grouping results by name
