## Activity 2: Structure and Clean Text Data for Analysis
# Goal: learn how to clean raw text for analysis.

install.packages("readtext") 
install.packages("quanteda")

library(readtext)
library(quanteda)

# 1. Read in the hotel reviews dataset, tell R where the text field is.
reviews <- readtext("hotelreviews.csv", text_field = "reviews.text", encoding = "utf8")
# data source: https://data.world/datafiniti/hotel-reviews

# 2. Explore the data
names(reviews)

## Create corpus

# 3. Turn the dataset into a corpus for text analysis
reviews_corp <- corpus(reviews)

reviews_corp
docvars(reviews_corp)


# 4. See the text of the 2nd review in the dataset:
reviews_corp[[2]]

# 5. Practice. See the text of the 100th review in the dataset:
reviews_corp[[100]]


# 6. Tokenize the corpus & clean the tokens: remove stop words, punctuation, convert to lowercase, stem endings

reviews_tokens <- tokens(reviews_corp, remove_numbers = TRUE,  remove_punct = TRUE, remove_symbols = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower()

reviews_tokens

## Practice: Using the steps above, practice cleaning the ted_talks description field

# 7. Practice. Read in the data & specify the text field (we'll use the description field this time)
ted_talks <- readtext("ted_talks17.csv", text_field = "description", encoding = "utf8")


# 8. Practice. Create a corpus using corpus() like in step 3.
ted_corp <- corpus(ted_talks)


# 9. Practice. Tokenize the corpus and clean the tokens like in step 6.
ted_toks <- tokens(ted_corp, remove_numbers = TRUE,  remove_punct = TRUE, remove_symbols = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower()
