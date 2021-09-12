## Activity 5: Read in multiple text files and do TF-IDF analysis to find distinctive words per document.

#install.packages("readtext") 
#install.packages("tidyverse")
#install.packages("quanteda")

library(readtext)
library(tidyverse)
library(quanteda)


# Section 1. Load text data from multiple text files, create a corpus, and clean the corpus

# 1. Read the sotu text files into R. 

# First, Set sotu-addresses folder as your working directory.
# Use readtext() to read the files in from the sotu-addresses folder
docs <- readtext("*.txt", encoding = "utf8", docvarsfrom = "filenames")
View(head(docs)) # see first few rows

# 2. Create new fields for name and year from the docvar1 column
docs <- docs %>%
  mutate(year= str_sub(.$docvar1, -5)) %>% # create year column
  mutate(name= str_sub(.$docvar1, 1, -6)) # create name column

View(head(docs, 50))

# 3. Clean the fields by stripping out unwanted characters and removing the filename column.
docs$year <- docs$year %>%
  str_replace_all("[-ab]", "") # remove unwanted characters from the year column

docs$year <- as.integer(docs$year)
View(head(docs, 50))

# 4. Remove unwanted characters from the name column
docs$name <- docs$name %>%
  str_replace_all("-", " ") %>%
  trimws()  #trim leading and trailing whitespace from terms in name field

View(tail(docs, 30))


# 5. Create a corpus of the texts and then tokenize the corpus.

docs_corp <- corpus(docs)

docs_tokens <- tokens(docs_corp, remove_punct = TRUE, remove_numbers = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower() %>%
  tokens_wordstem()

## Use TF-IDF to see what terms are most unique & important to a document.

# 6. Create a document feature matrix (dfm)
sotu_dfm <- dfm(docs_tokens)


# 7. Construct a tf-idf on a dfm to determine a document's most distinctive words
sotu_tf_idf <- dfm_tfidf(sotu_dfm)

# 8. See most distinctive words by president:
topfeatures(sotu_tf_idf, groups=name)

# 9. See most distinctive words by speech
topfeatures(sotu_tf_idf, group=docid(sotu_tf_idf))

## Practice: Using the ted_talks dataset, do the following:

# 10. Set working directory back to folder that contains the "ted_talks17.csv" file.

# 11. Read in ted talks dataset and create a corpus. This time we're going to analyze the transcript field.
ted_talks <- readtext("ted_talks17.csv", text_field = "transcript", encoding="utf8")
ted_corp <- corpus(ted_talks)

# 12. Create tokens from the corpus and then a dfm as in steps 5 & 6.
ted_tokens <- tokens(ted_corp, remove_punct = TRUE, remove_numbers = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower() %>%
  tokens_wordstem()
  
ted_dfm <- dfm(ted_tokens)

# 13. Construct a tf-idf for each talk as in step 7.
ted_tf_idf <- dfm_tfidf(ted_dfm)

# 14. Print out the most distinctive terms for each talk.

list_top_terms <- as.list(topfeatures(ted_tf_idf, group=docid(ted_tf_idf)))
list_top_terms

