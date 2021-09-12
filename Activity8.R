## Activity 8: Document Feature Similarity
# Goal: Find documents similar or different from another document.

install.packages("quanteda.textstats")
library(quanteda.textstats)
library(readtext)
library(quanteda)

###### Setup -- skip if you have already done this ###
ted_talks <- readtext("ted_talks17.csv", text_field = "transcript", encoding = "utf8")
ted_corp <- corpus(ted_talks)
ted_tokens <- tokens(ted_corp, remove_punct = TRUE, remove_numbers = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower() %>%
  tokens_wordstem()  

ted_dfm <- dfm(ted_tokens)

###### End Setup

# I. Document similarity

# 1. Start with a reference document, ted talk #1 and compute cosine similarity with 
# other talks in the corpus.

sim_stats <- textstat_simil(ted_dfm, ted_dfm["ted_talks17.csv.1",], method="cosine")

# 2. Turn that output into a data frame

similarity_scores <- data.frame(sim_stats)

# 3. Sort in descending order of cosine similarity
similarity_scores[order(-similarity_scores$cosine),]

# 4. Compare tags for talks #34 and #1
ted_corp$tags[1]
ted_corp$tags[34]

# 5. Practice find documents most similar to ted_talks17.csv.10.

sim_stats10 <- textstat_simil(      )

# 6. Practice. Convert similarity scores to a data frame.
similarity_scores10 <- data.frame(     )

# 7. Practice. Sort the scores in descending order.
similarity_scores10[          ]

# 8. Practice. Examine the tags field for both documents.




