## Activity 7: Topic Modeling with quanteda and seededlda packages


install.packages("quanteda.corpora")
install.packages("seededlda")

library(readtext)
library(quanteda)
library(seededlda)
library(tidyverse)

## Goal: Learn topic modeling in R using Ted Talk transcripts 

# 1. Read in Ted Talks data as a data frame and indicate the transcript column as the text field.

ted_talks <- readtext("ted_talks17.csv", text_field = "transcript", encoding = "utf8")

# 2. Create a corpus and tokens from the ted_talks data

ted_corp <- corpus(ted_talks)
print(ted_corp)

ted_tokens <- tokens(ted_corp, remove_punct = TRUE, remove_numbers = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower() %>%
  tokens_wordstem()  


# 3. Create a dfm from the corpus. Use arguments in the function to clean the text as part of creating the dfm.

ted_dfm <- dfm(ted_tokens)

View(as.data.frame(ted_dfm))

# 4. Run your topic model. LDA (Latent Dirichlet Allocation)) is a probabilistic modeling approach that assumes every word in
# a document belongs to some 'unknown' topic.

tmod_lda <- textmodel_lda(ted_dfm, k = 10)

terms(tmod_lda, 10)


# 5. Practice. Now create a new Ted Talks dfm without stemming and re-run the model. What differences do you notice?

ted_tokens_ns <- tokens(ted_corp, remove_punct = TRUE, remove_numbers = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower() 

ted_dfm_ns <- dfm(ted_tokens_ns)

tmod_lda_ns <- textmodel_lda(ted_dfm_ns, k = 10)

terms(tmod_lda_ns, 10)

## Seeded LDA: Provide a set of topics to the model. Run the non-stemmed ted model.
dict_topic <- dictionary(file = "topics.yml")
print(dict_topic)


tmod_slda <- textmodel_seededlda(ted_dfm, dictionary = dict_topic)
terms(tmod_slda, 10)
