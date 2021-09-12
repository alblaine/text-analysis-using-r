# Using an API in R
install.packages('RCurl')
install.packages('rjson')
install.packages('jsonlite')
library(rjson)
library(RCurl)
library(jsonlite)

#Example url: https://api.nasa.gov/techport/api/projects/{id_parameter}?api_key=DEMO_KEY
#This api gets summaries of recent NASA projects. NASA has an open API that's free to use.

# 1. Build the url for calling the api. Get your api key at https://api.nasa.gov/
# General rule: do not to share your api keys with others or make them public. 
my_key <- "INSERTKEYHERE"
  
url <- paste0('https://api.nasa.gov/techtransfer/patent/?engine&api_key=', my_key)

# 2. Get the data from the api endpoint. Convert JSON data results to a data frame
data <- fromJSON(getURL(url), flatten=TRUE)
data_df <- as.data.frame(data)

# 3. Create a corpus from the data frame data_df. Specify the text_field = 'results.4'

data_corp <- corpus(data_df, text_field = 'results.4')
data_corp

# 4. Let's group the corpus documents by category. Group the corpus using corpus_group() based on the results.6 field.

data_corp_grouped <- corpus_group(data_corp, groups=data_df$results.6)
data_corp_grouped

# 5. Create tokens & a dfm of the grouped corpus.
data_dfm <-
  tokens(data_corp_grouped, remove_punct = TRUE, remove_numbers = TRUE) %>%
  tokens_remove(stopwords("en")) %>%
  tokens_tolower() %>%
  tokens_wordstem() %>%
  dfm()

# 6. Construct a tf-idf for each group of documents.
data_tf_idf <- dfm_tfidf(data_dfm)

# 7. Print the tf-idf results for each grouping.
i <- 0
for(i in 1:ndoc(data_tf_idf)) {
  print(docnames(data_tf_idf)[i]) # prints out the category for the grouped docs
  print(topfeatures(data_tf_idf[i,]))
}

# 8. Practice. Get data from the following api into R and do some text cleaning and/or analysis: 
# Subsitute your api key where it says "DEMO_KEY"
# https://api.nasa.gov/DONKI/notifications?startDate=2021-08-01&type=all&api_key=DEMO_KEY

url_d <- paste0('https://api.nasa.gov/DONKI/notifications?startDate=2021-08-01&type=all&api_key=', my_key)
data <- fromJSON(getURL(url_d), flatten=TRUE)
data_df <- as.data.frame(data)
