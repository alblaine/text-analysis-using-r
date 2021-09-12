# Activity 0. Starter activity. 
# Goal: learn important terms and concepts for text analysis.

# 1. Packages are snippets of code we'll use in our R session. Install only once.
install.packages("readtext")
install.packages("quanteda")

# 2. You have to load the packages you'll be using each session using library().
library(readtext)
library(quanteda)

# 3. Read a text file. First, set your working directory to the location of the file.
rf_poem <- readtext("frost.txt")
rf_poem

# 4. Create a corpus. A corpus is a structure for text analysis that retains the position of the words.
rf_corp <- corpus(rf_poem)
rf_corp

# 5. Tokenize and clean the corpus. Tokenization splits the corpus into units, such as words, for analysis.
rf_toks <- tokens(rf_corp, remove_punct = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower() %>%
  tokens_wordstem()

# 6. Create a document feature matrix (dfm) from the tokens.
rf_dfm <- dfm(rf_toks)

View(convert(rf_dfm, to='data.frame'))

# 7. Practice. Read in the Emily Dickinson poem from "dickinson.csv" using readtext() like in step 3.
ed_poem <- 

# 8. Create a corpus like in step 4.


# 9. Tokenize and clean the corpus.

    
# 10. Create a document feature matrix (dfm) from the tokens like in step 6.

