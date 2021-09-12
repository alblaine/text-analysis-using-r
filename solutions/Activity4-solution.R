# Activity 4: Create tidy data frames from corpus objects and visualize term frequencies
install.packages("wordcloud")
install.packages("tidytext")

library(readtext)
library(tidyverse)
library(wordcloud)
library(tidytext)

################ Setup: OK to skip in class if already stored in R

reviews <- readtext("hotelreviews.csv", text_field = "reviews.text", encoding = "utf8")
reviews_corp <- corpus(reviews)

################ 


# 1. Convert corpus to a tokens object and then a document feature matrix (dfm).

reviews_tokens <- tokens(reviews_corp, remove_numbers = TRUE,  remove_punct = TRUE, remove_symbols = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower()

reviews_dfm <- dfm(reviews_tokens)


# 2. Turn dfm into a tidy dataframe. A tidy data frame means one variable per column, one observation per row, one value per cell.

tidy_reviews <- tidy(reviews_dfm)

tidy_reviews

# 3. Filter and sort by the documents that mention breakfast most often
tidy_reviews %>%
  filter(term=="breakfast") %>% 
  arrange(desc(count))

# 4. Look up review #1053 to see what the person said about the breakfast
reviews_corp[[1053]]

# 5. Practice. Filter and sort by the documents that mention location most often. View the first review in the list.
tidy_reviews %>%
  filter(term=="location") %>% 
  arrange(desc(count))

reviews_corp[[324]]

# 6. Use tidyverse functions select(), group_by(), summarise(), arrange() to see total word counts
term_frequency <- tidy_reviews %>%
  select(-document) %>%
  group_by(term) %>%
  summarise(freq = n()) %>%
  arrange(desc(freq))

View(term_frequency)

## Visualize the word counts 

# 7. Create a word cloud
wordcloud(term_frequency$term, term_frequency$freq, max.words = 100, colors=brewer.pal(3, "Dark2"))

# 8. Practice. Re-run the word cloud with max.words = 150. 
wordcloud(term_frequency$term, term_frequency$freq, max.words = 150, colors=brewer.pal(3, "Dark2"))

# Create a bar chart

# 9. Create a bar chart using the top 20 terms by frequency

term_frequency %>%
  top_n(20) %>%
  ggplot(., aes(fct_reorder(term, freq), y=freq)) + 
  labs(x="terms", y="frequency")+
  geom_col() + 
  coord_flip() + 
  theme_classic()

# 10. Practice. Now create a bar chart showing top 10 terms. 

term_frequency %>%
  top_n(20) %>%
  ggplot(., aes(fct_reorder(term, freq), y=freq)) + 
  labs(x="terms", y="frequency")+
  geom_col() + 
  coord_flip() + 
  theme_classic()


# 11. Practice. Create tokens from the corpus of tweets created in the last activity and then create a dfm from the tokens. 
# tweets <- readtext("tweets.csv", text_field = "text", encoding = "utf8")
# tweets_corp <- corpus(tweets)
tweets_tokens <- tokens(tweets_corp, remove_numbers = TRUE,  remove_punct = TRUE, remove_symbols = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower()

tweets_dfm <- dfm(tweets_tokens)

# 12. Practice. Create a tidy data frame from the dfm.
tidy_tweets <- tidy(tweets_dfm)


# 13. Practice. Use tidyverse functions select(), group_by(), summarise(), arrange() to see total word counts as in step 6.
tweet_frequency <- tidy_tweets %>%
  select(-document) %>%
  group_by(term) %>%
  summarise(freq = n()) %>%
  arrange(desc(freq))

# 14. Practice. Create a word cloud.
wordcloud(tweet_frequency$term, term_frequency$freq, max.words = 150, colors=brewer.pal(3, "Dark2"))

# 15. Let's remove the first 6 rows of most frequent terms and re-run the wordcloud.
tf_trimmed <- tweet_frequency[-c(1:6),]
wordcloud(tf_trimmed$term, term_frequency$freq, max.words = 150, colors=brewer.pal(3, "Dark2"))


