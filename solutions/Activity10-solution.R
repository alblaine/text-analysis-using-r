# Activity 10: Naive Bayes Classification for Texts
# Goal: to classify a text into one of two categories.
# Further reading: https://towardsdatascience.com/implementing-a-naive-bayes-classifier-for-text-categorization-in-five-steps-f9192cdd54c3

install.packages("quanteda.textmodels")
install.packages("caret", dependencies = TRUE)

library(readtext)
library(quanteda)
library(quanteda.textmodels)
library(caret)


# 1. For this activity we will use the airline tweets dataset.
# Set working directory to main folder first

tweets <- readtext("tweets.csv", text_field = "text", encoding="utf8")
tweets_corp <- corpus(tweets)
summary(tweets_corp, 5)

# 2. Get a random sample of 800 tweets from the dataset
set.seed(300)
id_train <- sample(1:1000, 800, replace = FALSE)
head(id_train, 10)

# 3. Create an id field with a unique number as an id.
tweets_corp$id_numeric <- 1:ndoc(tweets_corp)

# 4. Create a training set. Notice we're adding dfm() to our function chain, a more advanced technique.
training_dfm <- corpus_subset(tweets_corp, id_numeric %in% id_train) %>%
  tokens(remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE) %>%
  tokens_tolower() %>%
  dfm()

# 5. Create a test set (documents not in id_train).
test_dfm <- corpus_subset(tweets_corp, !id_numeric %in% id_train) %>%
  tokens(remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE) %>%
  tokens_tolower() %>%
  dfm()

# 6. Train the model.
tmod_nb <- textmodel_nb(training_dfm, training_dfm$airline_sentiment)
summary(tmod_nb)

# 7. Match features in testing dfm to those with the training set. Eliminate non-matches.
matched_dfm <- dfm_match(test_dfm, features = featnames(training_dfm))

# 8. See how model worked.
actual_class <- matched_dfm$airline_sentiment
predicted_class <- predict(tmod_nb, newdata = matched_dfm)
tab_class <- table(actual_class, predicted_class)
tab_class

# 9. Test accuracy of the model with a confusion matrix.
confusionMatrix(tab_class, mode = "everything")


# II. Practice. Try to predict political party of speeches using Naive Bayes Classifier

# Set working directory to sotu-addresses folder first

# 10. Practice. Create a corpus subset of SOTU addresses from the 20th century. starting with FDR.
corpus20 <- corpus_subset(docs_corp, year >= 1934 & year <=2000)

# 11. Practice. Assign each speech with a party affiliation.
docvars(corpus20)$party <- ifelse(docvars(corpus20)$name %in% c("william j clinton", "jimmy carter", "lyndon b johnson", "john f kennedy", "harry s truman", "franklin d roosevelt"), "DEM", "REP")
docvars(corpus20)

# 12. Practice. Generate a set of random numbers to create training and test sets.
set.seed(100)
id_train <- sample(1:109, 80, replace = FALSE)
head(id_train, 10)

# 13. Practice. Create an id field with a unique number as an id.
corpus20$id_numeric <- 1:ndoc(corpus20)

# 14. Practice. Create a training set.
training_dfm <- corpus_subset(corpus20, id_numeric %in% id_train) %>%
  tokens(remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE) %>%
  tokens_tolower() %>%
  dfm()  
  
# 15. Practice. Create a test set (documents not in id_train).
test_dfm <- corpus_subset(corpus20, !id_numeric %in% id_train) %>%
  tokens(remove_punct = TRUE, remove_symbols = TRUE, remove_numbers = TRUE) %>%
  tokens_tolower() %>%
  dfm()  

# 16. Practice. Train the model. Make sure to point to the 'party' column.
tmod_nb <- textmodel_nb(training_dfm, training_dfm$party)
summary(tmod_nb)

# 17. Practice. Match features in testing dfm to those with the training set. Eliminate non-matches.
matched_dfm <- dfm_match(test_dfm, features = featnames(training_dfm))

# 18. Practice. See how model worked.
actual_class <- matched_dfm$party
predicted_class <- predict(tmod_nb, newdata = matched_dfm)
tab_class <- table(actual_class, predicted_class)
tab_class

# 19. Practice. Test accuracy of the model with a confusion matrix.
confusionMatrix(tab_class, mode = "everything")
