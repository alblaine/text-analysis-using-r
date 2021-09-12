## Activity 3: Sentiment analysis of reviews

install.packages("quanteda")
install.packages("tidyverse")
install.packages("SentimentAnalysis")

library(quanteda)
library(tidyverse)
library(SentimentAnalysis)


################ Setup: OK to skip in class if already done
# Read in the hotel reviews dataset, tell R where the text field is.
reviews <- readtext("hotelreviews.csv", text_field = "reviews.text", encoding = "utf8")

reviews_corp <- corpus(reviews)

reviews_tokens <- tokens(reviews_corp, remove_numbers = TRUE,  remove_punct = TRUE, remove_symbols = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower()

################

# I. Sentiment analysis using quanteda package functions.

# 1. Take the tokenized reviews and compare each feature with a sentiment dictionary built-in to quanteda.

reviews_lsd <- tokens_lookup(reviews_tokens, dictionary =  data_dictionary_LSD2015[1:2])

head(reviews_lsd)

# 2. Create a document feature matrix of the sentiment
dfm_reviews_lsd <- dfm(reviews_lsd)
dfm_reviews_lsd

reviews_df <- convert(dfm_reviews_lsd, to="data.frame")
reviews_df

# 3. Examine the text of the review with the most negative words.

reviews_corp[[3769]]

# 4. Practice. Examine the text of the review with the most positive words. 

reviews_corp[[1763]]

# 4B. Create a ratio of positive words/total number of tokens
reviews_df$num_tokens <- ntoken(reviews_tokens)

reviews_df$pos_ratio <- reviews_df$positive/reviews_df$num_tokens

# 4C. Practice: create a ratio of negative to total tokens
reviews_df$neg_ratio <- reviews_df$negative/reviews_df$num_tokens

# 4D. Filter out rows where num tokens is less than 3. 

reviews_filtered <- reviews_df %>%
  filter(num_tokens >= 3)

# II. Sentiment Analysis using SentimentAnalysis package functions.

# 5. Use functions from the Sentiment Analysis package to analyze sentiment for the reviews corpus

reviews_sentiment <- analyzeSentiment(reviews_corp)

# 6. Create a column with the label "positive", "negative", or "neutral" for each review
reviews_sentiment$feeling <- convertToDirection(reviews_sentiment$SentimentQDAP)

# 7. Use group_by and summarise() to count how many of each type of review there are
sentiment_summary <- reviews_sentiment %>%
  group_by(feeling) %>%
  summarise(n())

sentiment_summary

# 8. Join the sentiment data with the original reviews dataset
reviews_data_all <- cbind(reviews_sentiment[14:15], reviews)

View(reviews_data_all)

# III. Practice sentiment analysis on the airline tweets dataset, "tweets.csv"
# 9. Read in airline tweets dataset. The text field is labeled "text".

tweets <- readtext("tweets.csv", text_field = "text", encoding = "utf8")

# 10. Create a corpus.

tweets_corp <- corpus(tweets)
  
# 11. Conduct a Sentiment Analysis of the corpus as in section II. 

tweets_sentiment <- analyzeSentiment(tweets_corp)
tweets_sentiment$feeling <- convertToDirection(tweets_sentiment$SentimentQDAP)

tweets_summary <- tweets_sentiment %>%
  group_by(feeling) %>%
  summarise(n())

tweets_data_all <- cbind(tweets_sentiment, tweets)

# 12. Compare the two columns airline_sentiment (already in dataset) and feeling (column you created)

comp <- tweets_data_all[,-c(5:30)]

######### Note: How to filter out non-English language reviews from reviews dataset:

# Use the textcat function to determine the language of the reviews.
install.packages("textcat")
library(textcat)

profiles <- TC_byte_profiles[names(TC_byte_profiles)] #import pre-set dictionary that is part of the package
lang <- textcat(reviews$text, p = profiles) # compare profiles with review text to determine language

df_lang <- data.frame(lang) # turn the list into a data frame

# Create a flag to add to original reviews dataset (include scots, etc. due to common mistakes in textcat)
df_lang <- df_lang %>%
  mutate(english = ifelse(lang %in% c("english", "scots", "scots-gaelic", "welsh"), "Y", "N"))

# Add the language-specific columns onto the reviews data frame using cbind().
reviews_sentiment_lang <- cbind(reviews_data_all, df_lang)
reviews_sentiment_lang

# Filter out any row with a "N" flag in the english column
eng_reviews <- reviews_sentiment_lang %>%
  filter(english == "Y")


